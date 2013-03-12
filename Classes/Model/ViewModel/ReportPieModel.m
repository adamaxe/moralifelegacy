/**
 Implementation:  Generate the data to be used in the ReportPieViewController.  Aggregate all virtue/vice user entries and dilemmas, calculate percentages and populate appropriate view necessities (color, icon, display name, etc.)

 @class ReportPieModel ReportPieModel.h
 */

#import "ReportPieModel.h"
#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "UserChoiceDAO.h"
#import "MoralDAO.h"
#import "UIColor+Utility.h"

@interface ReportPieModel () {

    UserChoiceDAO *currentUserChoiceDAO;    /**< current User Choices*/
    MoralDAO *currentMoralDAO;              /**< retrieve morals User has utilized */

	NSMutableDictionary *reportValues;		/**< Each moral assignment calculation to be aggregated*/
	NSMutableDictionary *moralDisplayNames;	/**< display names from SystemData to be displayed on list */
	NSMutableDictionary *moralColors;		/**< text color associated with Moral */

	float runningTotal;				/**< total of Moral Weight for calculation purposes */

}

@property (nonatomic, readwrite, strong) NSArray *reportNames;
@property (nonatomic, readwrite, strong) NSArray *moralNames;
@property (nonatomic, readwrite, strong) NSArray *pieValues;
@property (nonatomic, readwrite, strong) NSArray *pieColors;
@property (nonatomic, readwrite, strong) NSDictionary *moralImageNames;

/**
 Retrieve all User entered Morals from persisted User Data
 */
- (void) retrieveChoices;

/**
 Convert UserData into graphable data
 */
- (void) generateGraphData;

@end

@implementation ReportPieModel

- (id)init {
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];

    return [self initWithModelManager:[appDelegate moralModelManager]];
}

- (id)initWithModelManager:(ModelManager *) modelManager {

    self = [super init];
    if (self) {
        _isGood = TRUE;
        _isAlphabetical = FALSE;
        _isAscending = FALSE;

        _reportNames = [[NSArray alloc] init];
        _pieValues = [[NSArray alloc] init];
        _pieColors = [[NSArray alloc] init];
        _moralNames = [[NSArray alloc] init];
        _moralImageNames = [[NSDictionary alloc] init];
        reportValues = [[NSMutableDictionary alloc] init];
        moralDisplayNames = [[NSMutableDictionary alloc] init];
        moralColors = [[NSMutableDictionary alloc] init];

        currentUserChoiceDAO = [[UserChoiceDAO alloc] initWithKey:@"" andModelManager:modelManager];
        currentMoralDAO = [[MoralDAO alloc] initWithKey:@"" andModelManager:modelManager];

    }

    [self generateGraphData];
    return self;

}

#pragma mark -
#pragma mark Overloaded Setters

/* Whenever this isGood is changed from UI, model is informed of change */
- (void) setIsGood:(BOOL) isGood {
    if (_isGood != isGood) {
        _isGood = isGood;
        [self generateGraphData];
    }
}

/* Whenever this isAlphabetical is changed from UI, model is informed of change */
- (void) setIsAlphabetical:(BOOL) isAlphabetical {
    if (_isAlphabetical != isAlphabetical) {
        _isAlphabetical = isAlphabetical;
        [self generateGraphData];
    }
}

/* Whenever this isAscending is changed from UI, model is informed of change */
- (void) setIsAscending:(BOOL)isAscending {
    if (_isAscending != isAscending) {
        _isAscending = isAscending;
        [self generateGraphData];
    }
}


#pragma mark -
#pragma mark Data Manipulation

/**
 Implementation: Retrieve all UserChoice entries, retrieve Morals for each, build color for each Moral
 */
- (void) retrieveChoices{

	//Reset data
 	[reportValues removeAllObjects];
	[moralDisplayNames removeAllObjects];

    NSMutableDictionary *derivedMoralImageNames = [[NSMutableDictionary alloc] init];

	//Retrieve virtue or vice
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"entryIsGood == %@", @(self.isGood)];
	currentUserChoiceDAO.predicates = @[pred];

	NSArray *objects = [currentUserChoiceDAO readAll];

	if ([objects count] > 0) {

		float currentValue = 0.0;

		//Iterate through every UserChoice combining each entry
		for (UserChoice *userChoiceMatch in objects){

			NSNumber *choiceWeightTemp = reportValues[[userChoiceMatch choiceMoral]];

			//See if a Choice has already been entered for particular Moral
            if (choiceWeightTemp != nil) {
                currentValue = [choiceWeightTemp floatValue];
            } else {
                currentValue = 0.0;
            }

			//Keep running of absolute value of Morals for percentage calculation
			//Vices are stored as negative
            runningTotal += fabsf([[userChoiceMatch choiceWeight] floatValue]);
            currentValue += fabsf([[userChoiceMatch choiceWeight] floatValue]);

            [reportValues setValue:@(currentValue) forKey:[userChoiceMatch choiceMoral]];

            NSString *moralName = [userChoiceMatch choiceMoral];
            Moral *currentMoral = [currentMoralDAO read:moralName];

            [moralDisplayNames setValue:currentMoral.displayNameMoral forKey:moralName];
            [derivedMoralImageNames setValue:currentMoral.imageNameMoral forKey:moralName];

            NSString *moralColor = [[NSString alloc] initWithString:currentMoral.colorMoral];

            [moralColors setValue:[UIColor colorWithHexString:moralColor] forKey:moralName];


        }

	}

    self.moralImageNames = derivedMoralImageNames;
}

/**
 Implementation:  Transform UserData entries of all Virtues/Vices into summation of weights for each Moral.
 Sum each summation of Moral into total of Virtue/Vice, then calculate percentage of each entry as percentage of whole
 Convert percentage to degrees out of 360.  Send values and colors to GraphView
 @todo needs to be optimized.  Don't generate sorted and reversed keys without need.  Check for empty first.
 */
- (void) generateGraphData {
	NSMutableArray *derivedPieColors = [[NSMutableArray alloc] init];
	NSMutableArray *derivedPieValues = [[NSMutableArray alloc] init];
	NSMutableArray *derivedReportNames = [[NSMutableArray alloc] init];
	NSMutableArray *derivedMoralNames = [[NSMutableArray alloc] init];

	//Reset running total before getting Choices
	runningTotal = 0.0;

	//Get all choices
	[self retrieveChoices];

	float moralPercentage = 0.0;

	//Create raw, sorted and reversed versions of the keys for sorting/ordering options
	NSArray *reportKeys = [reportValues allKeys];
	NSArray *sortedPercentages = [reportValues keysSortedByValueUsingSelector:@selector(compare:)];
	NSArray* reversedPercentages = [[sortedPercentages reverseObjectEnumerator] allObjects];

	NSArray *sortedKeys = [reportKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	NSArray *reversedKeys = [[sortedKeys reverseObjectEnumerator] allObjects];

	NSArray *iteratorArray;

	//Determine sorting and ordering
	if (self.isAlphabetical) {

		if (self.isAscending) {
            iteratorArray = reversedKeys;
      	} else {
			iteratorArray = sortedKeys;
		}
	} else {
		if (self.isAscending) {
            iteratorArray = sortedPercentages;
      	} else {
            iteratorArray = reversedPercentages;
		}
	}

    //Account for no User entries
    if ([iteratorArray count] == 0) {

        if (self.isGood) {
            [derivedReportNames addObject:@"No Moral Entries!"];
        } else {
            [derivedReportNames addObject:@"No Immoral Entries!"];
        }

        [derivedPieColors addObject:[UIColor moraLifeChoiceRed]];
    } else {

        //Iterate through every User selection
        for (NSString *moralInstance in iteratorArray) {

            //Determine percentage of each entry in regards to every entry
            moralPercentage = ([[reportValues valueForKey:moralInstance] floatValue]/runningTotal);

            //Convert percentage to degrees
            [derivedPieValues addObject:@(moralPercentage * 360)];

            //Add report names for relation to table
            [derivedReportNames addObject:[NSString stringWithFormat:@"%@: %.2f%%", moralDisplayNames[moralInstance], moralPercentage * 100]];

            [derivedPieColors addObject:moralColors[moralInstance]];

            //Don't add Moral if it already exists in the display list
            if (![derivedMoralNames containsObject:moralInstance]) {
                [derivedMoralNames addObject:moralInstance];
            }
            
        }
    }

    self.pieColors = [NSArray arrayWithArray:derivedPieColors];
	self.pieValues = [NSArray arrayWithArray:derivedPieValues];
	self.reportNames = [NSArray arrayWithArray:derivedReportNames];
	self.moralNames = [NSArray arrayWithArray:derivedMoralNames];

}


@end
