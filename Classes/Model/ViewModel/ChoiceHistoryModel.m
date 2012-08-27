#import "MoraLifeAppDelegate.h"
#import "ChoiceHistoryModel.h"
#import "ModelManager.h"
#import "UserChoiceDAO.h"
#import "MoralDAO.h"

NSString* const kChoiceHistoryModelTypeAll = @"Virtue";
NSString* const kChoiceHistoryModelTypeIsGood = @"Vice";
NSString* const kChoiceHistoryModelTypeIsBad = @"All";

@interface ChoiceHistoryModel () {
    NSUserDefaults *preferences;                  /**< User defaults to write to file system */
    UserChoiceDAO *currentUserChoiceDAO;    /**< current User Choices*/
    MoralDAO *currentMoralDAO;              /**< retrieve morals User has utilized */

}

@property (nonatomic, readwrite, retain) NSMutableArray *choices;			/**< Array of User-entered choice titles */
@property (nonatomic, readwrite, retain) NSMutableArray *choicesAreGood;     	/**< Array of whether choices are good/bad */
@property (nonatomic, readwrite, retain) NSMutableArray *choiceKeys;			/**< Array of User-entered choice titles */
@property (nonatomic, readwrite, retain) NSMutableArray *details;			/**< Array of User-entered details */
@property (nonatomic, readwrite, retain) NSMutableArray *icons;				/**< Array of associated images */

/**
 Retrieve all User entered Choices
 */
- (void) retrieveAllChoices;

@end

@implementation ChoiceHistoryModel

- (id)init {
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];

    return [self initWithModelManager:[appDelegate moralModelManager] andDefaults:[NSUserDefaults standardUserDefaults]];
}

- (id)initWithModelManager:(ModelManager *) modelManager andDefaults:(NSUserDefaults *) prefs{

    self = [super init];
    if (self) {

        _choiceType = @"";
        _isAscending = FALSE;

        _choices = [[NSMutableArray alloc] init];
        _choicesAreGood = [[NSMutableArray alloc] init];
        _choiceKeys = [[NSMutableArray alloc] init];
        _details = [[NSMutableArray alloc] init];
        _sortKey = [[NSString alloc] initWithString:kChoiceListSortDate];
        _icons = [[NSMutableArray alloc] init];
        preferences = prefs;

        currentUserChoiceDAO = [[UserChoiceDAO alloc] initWithKey:@"" andModelManager:modelManager];
        currentMoralDAO = [[MoralDAO alloc] initWithKey:@"" andModelManager:modelManager];

    }

    [self retrieveAllChoices];

    return self;
    
}

#pragma mark -
#pragma mark Overloaded Setters

/* Whenever sGood is changed from ViewController, model is refreshed */
- (void) setChoiceType:(NSString *)choiceType {
    if (_choiceType != choiceType) {
        _choiceType = choiceType;
        [self retrieveAllChoices];
    }
}

/* Whenever isAscending is changed from ViewController, model is refreshed */
- (void) setIsAscending:(BOOL)isAscending {
    if (_isAscending != isAscending) {
        _isAscending = isAscending;
        [self retrieveAllChoices];
    }
}

/* Whenever sortDescriptor is changed from ViewController, model is refreshed */
- (void) setSortKey:(NSString *)sortKey {
    if (![_sortKey isEqualToString:sortKey]) {
        _sortKey = sortKey;
        [self retrieveAllChoices];
    }
}


/**
 Implementation: Retrieve all User entered Choices, and then populate a working set of data containers upon which to filter.
 */
- (void) retrieveAllChoices {

	//Clear all datasets
	[self.choices removeAllObjects];
	[self.choiceKeys removeAllObjects];
	[self.choicesAreGood removeAllObjects];
	[self.icons removeAllObjects];
	[self.details removeAllObjects];

    NSString *predicateParam = [[NSString alloc] initWithString:@"dile-"];

	//Ensure that Choices created during Morathology sessions are not displayed here
	//All Dilemma/Action Choice entryKeys are prefixed with string "dile-"
	//@see DilemmaViewController
	NSPredicate *pred;

    if ([self.choiceType isEqualToString:kChoiceHistoryModelTypeAll]) {
        pred = [NSPredicate predicateWithFormat:@"NOT entryKey contains[cd] %@", predicateParam];
    } else if ([self.choiceType isEqualToString:kChoiceHistoryModelTypeIsGood]) {
        pred = [NSPredicate predicateWithFormat:@"entryIsGood == TRUE AND NOT entryKey contains[cd] %@", predicateParam];
    } else {
        pred = [NSPredicate predicateWithFormat:@"entryIsGood == FALSE AND NOT entryKey contains[cd] %@", predicateParam];
    }

	currentUserChoiceDAO.predicates = @[pred];
	[predicateParam release];

	//choiceSortDescriptor and isAscending are set throughout class
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:self.sortKey ascending:self.isAscending];

    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
	currentUserChoiceDAO.sorts = sortDescriptors;
	[sortDescriptor release];
    [sortDescriptors release];

	NSArray *objects = [currentUserChoiceDAO readAll];

	if ([objects count] > 0) {

		//Build raw data list to be filtered by second data container set
		for (UserChoice *matches in objects){

			[self.choices addObject:[matches entryShortDescription]];
		 	[self.choiceKeys addObject:[matches entryKey]];
			[self.choicesAreGood addObject:@([[matches entryIsGood] boolValue])];

			//Detailed text is name of Moral, Weight, Date, Long Description
			NSMutableString *detailText = [[NSMutableString alloc] init];

			[detailText appendFormat:@"%.1f ", [[matches choiceWeight] floatValue]];
			NSString *value = [matches choiceMoral];

			Moral *currentMoral = [currentMoralDAO read:value];

            //Display image and moral name
            [self.icons addObject:[currentMoral imageNameMoral]];
            [detailText appendString:[currentMoral displayNameMoral]];

			//Display date last modified for sorting
            NSDate *modificationDate = [matches entryModificationDate];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM-dd"];

            [detailText appendFormat:@" %@", [dateFormat stringFromDate:modificationDate]];

            [dateFormat release];

			//If longDescription is empty, do not show colon separating
            if (![[matches entryLongDescription] isEqualToString:@""]) {
                [detailText appendFormat:@": %@", [matches entryLongDescription]];
            }

			//Populate details array with constructed detail
            [self.details addObject:detailText];
			[detailText release];

		}
	}
}

/**
 Implementation: Retrieve a requested Choice and set NSUserDefaults for ChoiceViewController to read
 */
- (void) retrieveChoice:(NSString *) choiceKey {

    UserChoice *match = [currentUserChoiceDAO read:choiceKey];

    if (match) {

        //Set state retention for eventual call to ChoiceViewController to pick up
    //		[prefs setObject:[match entryKey] forKey:@"entryKey"];
        [preferences setFloat:[[match entrySeverity] floatValue]forKey:@"entrySeverity"];
        [preferences setObject:[match entryShortDescription] forKey:@"entryShortDescription"];
        [preferences setObject:[match entryLongDescription] forKey:@"entryLongDescription"];
        [preferences setObject:[match choiceJustification] forKey:@"choiceJustification"];
        [preferences setObject:[match choiceConsequences] forKey:@"choiceConsequence"];
        [preferences setFloat:[[match choiceInfluence] floatValue] forKey:@"choiceInfluence"];
        [preferences setObject:[match choiceMoral] forKey:@"moralKey"];
        [preferences setBool:[[match entryIsGood] boolValue] forKey:@"entryIsGood"];

        Moral *currentMoral = [currentMoralDAO read:[match choiceMoral]];

        [preferences setObject:[currentMoral displayNameMoral] forKey:@"moralName"];
        [preferences setObject:[currentMoral imageNameMoral] forKey:@"moralImage"];
        [preferences synchronize];
    }

}

-(void)dealloc {

    [_choices release];
    [_choicesAreGood release];
    [_choiceKeys release];
    [_details release];
    [_icons release];
    [currentUserChoiceDAO release];
    [currentMoralDAO release];

    [super dealloc];
}


@end
