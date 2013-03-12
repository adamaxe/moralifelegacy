#import "ChoiceHistoryModel.h"
#import "ModelManager.h"
#import "UserChoiceDAO.h"
#import "MoralDAO.h"

NSString* const MLChoiceHistoryModelTypeAll = @"Virtue";
NSString* const MLChoiceHistoryModelTypeIsGood = @"Vice";
NSString* const MLChoiceHistoryModelTypeIsBad = @"All";

NSString* const MLChoiceListSortDate = @"entryModificationDate";
NSString* const MLChoiceListSortWeight = @"choiceWeight";
NSString* const MLChoiceListSortSeverity = @"entrySeverity";
NSString* const MLChoiceListSortName = @"entryShortDescription";

@interface ChoiceHistoryModel () {
    NSUserDefaults *preferences;                  /**< User defaults to write to file system */
    UserChoiceDAO *currentUserChoiceDAO;    /**< current User Choices*/
    MoralDAO *currentMoralDAO;              /**< retrieve morals User has utilized */

}

@property (nonatomic, readwrite, strong) NSArray *choices;			/**< Array of User-entered choice titles */
@property (nonatomic, readwrite, strong) NSArray *choicesAreGood;     	/**< Array of whether choices are good/bad */
@property (nonatomic, readwrite, strong) NSArray *choiceKeys;			/**< Array of User-entered choice titles */
@property (nonatomic, readwrite, strong) NSArray *details;			/**< Array of User-entered details */
@property (nonatomic, readwrite, strong) NSArray *icons;				/**< Array of associated images */

/**
 Retrieve all User entered Choices
 */
- (void) retrieveAllChoices;

@end

@implementation ChoiceHistoryModel

- (id)initWithModelManager:(ModelManager *) modelManager andDefaults:(NSUserDefaults *) prefs{

    self = [super init];
    if (self) {

        _choiceType = @"";
        _isAscending = FALSE;
        _sortKey = MLChoiceListSortDate;

        _choices = [[NSArray alloc] init];
        _choicesAreGood = [[NSArray alloc] init];
        _choiceKeys = [[NSArray alloc] init];
        _details = [[NSArray alloc] init];
        _icons = [[NSArray alloc] init];
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
    _sortKey = sortKey;
    [self retrieveAllChoices];
}


/**
 Implementation: Retrieve all User entered Choices, and then populate a working set of data containers upon which to filter.
 */
- (void) retrieveAllChoices {

    NSMutableArray *derivedChoices = [[NSMutableArray alloc] init];
	NSMutableArray *derivedChoiceKeys = [[NSMutableArray alloc] init];
	NSMutableArray *derivedChoicesAreGood = [[NSMutableArray alloc] init];
	NSMutableArray *derivedIcons = [[NSMutableArray alloc] init];
	NSMutableArray *derivedDetails = [[NSMutableArray alloc] init];

    NSString *predicateParam = @"dile-";

	//Ensure that Choices created during Morathology sessions are not displayed here
	//All Dilemma/Action Choice entryKeys are prefixed with string "dile-"
	//@see DilemmaViewController
	NSPredicate *pred;

    if ([self.choiceType isEqualToString:MLChoiceHistoryModelTypeAll]) {
        pred = [NSPredicate predicateWithFormat:@"NOT entryKey contains[cd] %@", predicateParam];
    } else if ([self.choiceType isEqualToString:MLChoiceHistoryModelTypeIsGood]) {
        pred = [NSPredicate predicateWithFormat:@"entryIsGood == TRUE AND NOT entryKey contains[cd] %@", predicateParam];
    } else {
        pred = [NSPredicate predicateWithFormat:@"entryIsGood == FALSE AND NOT entryKey contains[cd] %@", predicateParam];
    }

	currentUserChoiceDAO.predicates = @[pred];

	//choiceSortDescriptor and isAscending are set throughout class
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:self.sortKey ascending:self.isAscending];

    NSArray* sortDescriptors = @[sortDescriptor];
	currentUserChoiceDAO.sorts = sortDescriptors;

	NSArray *objects = [currentUserChoiceDAO readAll];

	if ([objects count] > 0) {

		//Build raw data list to be filtered by second data container set
		for (UserChoice *matches in objects){

			[derivedChoices addObject:[matches entryShortDescription]];
		 	[derivedChoiceKeys addObject:[matches entryKey]];
			[derivedChoicesAreGood addObject:@([[matches entryIsGood] boolValue])];

			//Detailed text is name of Moral, Weight, Date, Long Description
			NSMutableString *detailText = [[NSMutableString alloc] init];

			[detailText appendFormat:@"%.1f ", [[matches choiceWeight] floatValue]];
			NSString *value = [matches choiceMoral];

			Moral *currentMoral = [currentMoralDAO read:value];

            //Display image and moral name
            [derivedIcons addObject:[currentMoral imageNameMoral]];
            [detailText appendString:[currentMoral displayNameMoral]];

			//Display date last modified for sorting
            NSDate *modificationDate = [matches entryModificationDate];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM-dd"];

            [detailText appendFormat:@" %@", [dateFormat stringFromDate:modificationDate]];


			//If longDescription is empty, do not show colon separating
            if (![[matches entryLongDescription] isEqualToString:@""]) {
                [detailText appendFormat:@": %@", [matches entryLongDescription]];
            }

			//Populate details array with constructed detail
            [derivedDetails addObject:detailText];

		}
	}

	self.choices = [NSArray arrayWithArray:derivedChoices];
	self.choiceKeys = [NSArray arrayWithArray:derivedChoiceKeys];
	self.choicesAreGood = [NSArray arrayWithArray:derivedChoicesAreGood];
	self.icons = [NSArray arrayWithArray:derivedIcons];
	self.details = [NSArray arrayWithArray:derivedDetails];

}

/**
 Implementation: Retrieve a requested Choice and set NSUserDefaults for ChoiceViewController to read
 */
- (void) retrieveChoice:(NSString *) choiceKey forEditing:(BOOL)isEditing{

    UserChoice *userChoiceMatch = [currentUserChoiceDAO read:choiceKey];

    if (userChoiceMatch) {

        //Set state retention for eventual call to ChoiceViewController to pick up
        if(isEditing){
            [preferences setObject:[userChoiceMatch entryKey] forKey:@"entryKey"];
        }
        [preferences setFloat:[[userChoiceMatch entrySeverity] floatValue]forKey:@"entrySeverity"];
        [preferences setObject:[userChoiceMatch entryShortDescription] forKey:@"entryShortDescription"];
        [preferences setObject:[userChoiceMatch entryLongDescription] forKey:@"entryLongDescription"];
        [preferences setObject:[userChoiceMatch choiceJustification] forKey:@"choiceJustification"];
        [preferences setObject:[userChoiceMatch choiceConsequences] forKey:@"choiceConsequence"];
        [preferences setFloat:[[userChoiceMatch choiceInfluence] floatValue] forKey:@"choiceInfluence"];
        [preferences setObject:[userChoiceMatch choiceMoral] forKey:@"moralKey"];
        [preferences setBool:[[userChoiceMatch entryIsGood] boolValue] forKey:@"entryIsGood"];

        Moral *currentMoral = [currentMoralDAO read:[userChoiceMatch choiceMoral]];

        [preferences setObject:[currentMoral displayNameMoral] forKey:@"moralName"];
        [preferences setObject:[currentMoral imageNameMoral] forKey:@"moralImage"];
        [preferences synchronize];
    }

}



@end
