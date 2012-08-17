/**
 Implementation:  Generate the data to be used in the ReportPieViewController.  Aggregate all virtue/vice user entries and dilemmas, calculate percentages and populate appropriate view necessities (color, icon, display name, etc.)

 @class ReportPieModel ReportPieModel.h
 */

#import "ReportPieModel.h"
#import "UserChoiceDAO.h"
#import "MoralDAO.h"
#import "ModelManager.h"

@interface ReportPieModel () {

	NSMutableDictionary *reportValues;		/**< Each moral assignment calculation to be aggregated*/
	NSMutableDictionary *moralDisplayNames;	/**< display names from SystemData to be displayed on list */
	NSMutableDictionary *moralColors;		/**< text color associated with Moral */

	float runningTotal;				/**< total of Moral Weight for calculation purposes */

}

@property (nonatomic, readwrite, retain) NSMutableArray *reportNames;
@property (nonatomic, readwrite, retain) NSMutableArray *moralNames;
@property (nonatomic, readwrite, retain) NSMutableArray *pieValues;
@property (nonatomic, readwrite, retain) NSMutableArray *pieColors;
@property (nonatomic, readwrite, retain) NSMutableDictionary *moralImageNames;

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
    self = [super init];
    if (self) {
        _isGood = TRUE;
        _isAlphabetical = FALSE;
        _isAscending = FALSE;

        _reportNames = [[NSMutableArray alloc] init];
        _pieValues = [[NSMutableArray alloc] init];
        _pieColors = [[NSMutableArray alloc] init];
        _moralNames = [[NSMutableArray alloc] init];
        _moralImageNames = [[NSMutableDictionary alloc] init];
        reportValues = [[NSMutableDictionary alloc] init];
        moralDisplayNames = [[NSMutableDictionary alloc] init];
        moralColors = [[NSMutableDictionary alloc] init];
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
	[self.moralImageNames removeAllObjects];
	[self.pieColors removeAllObjects];
	[self.pieValues removeAllObjects];
	[self.reportNames removeAllObjects];
	[self.moralNames removeAllObjects];

    UserChoiceDAO *currentUserChoiceDAO = [[UserChoiceDAO alloc] initWithKey:@""];

	//Retrieve virtue or vice
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"entryIsGood == %@", @(self.isGood)];
	currentUserChoiceDAO.predicates = @[pred];

	NSArray *objects = [currentUserChoiceDAO readAll];

	if ([objects count] > 0) {

		float currentValue = 0.0;

		//Iterate through every UserChoice combining each entry
		for (UserChoice *userChoiceMatch in objects){

			NSNumber *choiceWeightTemp = [reportValues objectForKey:[userChoiceMatch choiceMoral]];

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
            MoralDAO *currentMoralDAO = [[MoralDAO alloc] initWithKey:moralName];
            Moral *currentMoral = [currentMoralDAO read:@""];

            [moralDisplayNames setValue:currentMoral.displayNameMoral forKey:moralName];
            [self.moralImageNames setValue:currentMoral.imageNameMoral forKey:moralName];

            NSString *moralColor = [[NSString alloc] initWithString:currentMoral.colorMoral];

            //Moral color stored as hex, must convert to CGColorRef
            NSScanner *fillColorScanner = [[NSScanner alloc] initWithString:moralColor];

            unsigned fillColorInt;

            [fillColorScanner scanHexInt:&fillColorInt];

            //Bitshift each position to get 1-255 value
            //Divide value by 255 to get CGColorRef compatible value
            CGFloat red   = ((fillColorInt & 0xFF0000) >> 16) / 255.0f;
            CGFloat green = ((fillColorInt & 0x00FF00) >>  8) / 255.0f;
            CGFloat blue  =  (fillColorInt & 0x0000FF) / 255.0f;

            UIColor *moralColorTemp = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0];

            [moralColors setValue:moralColorTemp forKey:moralName];

            [currentMoralDAO release];
            [moralColorTemp release];
            [fillColorScanner release];

            [moralColor release];

        }

	}

	[currentUserChoiceDAO release];

}

/**
 Implementation:  Transform UserData entries of all Virtues/Vices into summation of weights for each Moral.
 Sum each summation of Moral into total of Virtue/Vice, then calculate percentage of each entry as percentage of whole
 Convert percentage to degrees out of 360.  Send values and colors to GraphView
 @todo needs to be optimized.  Don't generate sorted and reversed keys without need.  Check for empty first.
 */
- (void) generateGraphData {
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

	//Iterate through every User selection
	for (NSString *moralInstance in iteratorArray) {

		//Determine percentage of each entry in regards to every entry
      	moralPercentage = ([[reportValues valueForKey:moralInstance] floatValue]/runningTotal);

		//Convert percentage to degrees
		[self.pieValues addObject:@(moralPercentage * 360)];

		//Add report names for relation to table
		[self.reportNames addObject:[NSString stringWithFormat:@"%@: %.2f%%", [moralDisplayNames objectForKey:moralInstance], moralPercentage * 100]];

		[self.pieColors addObject:[moralColors objectForKey:moralInstance]];

		//Don't add Moral if it already exists in the display list
		if (![self.moralNames containsObject:moralInstance]) {
			[self.moralNames addObject:moralInstance];
		}

	}

	//Account for no User entries
	if ([iteratorArray count] == 0) {

		if (self.isGood) {
			[self.reportNames addObject:@"No Moral Entries!"];
		} else {
			[self.reportNames addObject:@"No Immoral Entries!"];
		}

		[self.pieColors addObject:[UIColor redColor]];
	}
    
}

- (void)dealloc {

    [_reportNames release];
    [_moralNames release];
    [_pieColors release];
    [_pieValues release];
    [_moralImageNames release];
    [reportValues release];
    [moralDisplayNames release];
    [moralColors release];

    [super dealloc];
}

@end
