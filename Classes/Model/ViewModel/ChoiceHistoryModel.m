#import "MoraLifeAppDelegate.h"
#import "ChoiceHistoryModel.h"
#import "ModelManager.h"
#import "UserChoiceDAO.h"
#import "MoralDAO.h"

@interface ChoiceHistoryModel ()

@property (nonatomic, readwrite, retain) NSMutableArray *choices;			/**< Array of User-entered choice titles */
@property (nonatomic, readwrite, retain) NSMutableArray *choicesAreGood;     	/**< Array of whether choices are good/bad */
@property (nonatomic, readwrite, retain) NSMutableArray *choiceKeys;			/**< Array of User-entered choice titles */
@property (nonatomic, readwrite, retain) NSMutableArray *details;			/**< Array of User-entered details */
@property (nonatomic, readwrite, retain) NSMutableArray *icons;				/**< Array of associated images */

@end

@implementation ChoiceHistoryModel

- (id)init {
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];

    return [self initWithModelManager:[appDelegate moralModelManager]];
}

- (id)initWithModelManager:(ModelManager *) modelManager {

    self = [super init];
    if (self) {

        _isGood = TRUE;
        _isAscending = FALSE;

        _choices = [[NSMutableArray alloc] init];
        _choicesAreGood = [[NSMutableArray alloc] init];
        _choiceKeys = [[NSMutableArray alloc] init];
        _details = [[NSMutableArray alloc] init];
        _icons = [[NSMutableArray alloc] init];

    }

    [self retrieveAllChoices];

    return self;
    
}

#pragma mark -
#pragma mark Overloaded Setters

/* Whenever this isGood is changed from ViewController, model is refreshed */
- (void) setIsGood:(BOOL) isGood {
    if (_isGood != isGood) {
        _isGood = isGood;
        [self retrieveAllChoices];
    }
}

/* Whenever this isAscending is changed from ViewController, model is refreshed */
- (void) setIsAscending:(BOOL)isAscending {
    if (_isAscending != isAscending) {
        _isAscending = isAscending;
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

    UserChoiceDAO *currentUserChoiceDAO = [[UserChoiceDAO alloc] initWithKey:@""];

    NSString *predicateParam = [[NSString alloc] initWithString:@"dile-"];

	//Ensure that Choices created during Morathology sessions are not displayed here
	//All Dilemma/Action Choice entryKeys are prefixed with string "dile-"
	//@see DilemmaViewController
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"entryIsGood == %@ AND NOT entryKey contains[cd] %@", @(self.isGood), predicateParam];
	currentUserChoiceDAO.predicates = @[pred];
	[predicateParam release];

	NSSortDescriptor* sortDescriptor;

	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kChoiceListSortDate ascending:self.isAscending];

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

            MoralDAO *currentMoralDAO = [[MoralDAO alloc] init];

			Moral *currentMoral = [currentMoralDAO read:value];

            //Display image and moral name
            [self.icons addObject:[currentMoral imageNameMoral]];
            [detailText appendString:[currentMoral displayNameMoral]];

            [currentMoralDAO release];

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

	[currentUserChoiceDAO release];
}

-(void)dealloc {

    [_choices release];
    [_choicesAreGood release];
    [_choiceKeys release];
    [_details release];
    [_icons release];

    [super dealloc];
}


@end
