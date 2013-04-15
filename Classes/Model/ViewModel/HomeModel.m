/** Implementation: Utilize the UserCollectableDAO and UserChoiceDAO in order to retrieve User information for HomeViewController */

#import "HomeModel.h"
#import "ModelManager.h"
#import "UserChoiceDAO.h"
#import "MoralDAO.h"
#import "UserCollectableDAO.h"
#import "ConscienceAssetDAO.h"

static int thoughtVersion = 0;
int const MLThoughtIterations = 5;

@interface HomeModel () {
    NSUserDefaults *preferences;                    /**< User defaults to write to file system */
    UserChoiceDAO *currentUserChoiceDAO;            /**< current User Choice DAO*/
    UserCollectableDAO *currentUserCollectableDAO;  /**< current User Collectable DAO*/
    ConscienceAssetDAO *currentConscienceAssetDAO;  /**< current Conscience Asset DAO*/
    MoralDAO *currentMoralDAO;                      /**< retrieve morals User has utilized */

}

@property (nonatomic, strong) ModelManager *modelManager;

@property (nonatomic, strong, readwrite) NSString *greatestVirtue;
@property (nonatomic, strong, readwrite) NSString *worstVice;
@property (nonatomic, strong, readwrite) NSString *highestRank;

@property (nonatomic, strong, readwrite) UIImage *greatestVirtueImage;
@property (nonatomic, strong, readwrite) UIImage *worstViceImage;
@property (nonatomic, strong, readwrite) UIImage *highestRankImage;

@end

@implementation HomeModel

- (id)initWithModelManager:(ModelManager *) modelManager {

    self = [super init];
    if (self) {

        currentUserChoiceDAO = [[UserChoiceDAO alloc] initWithKey:@"" andModelManager:modelManager];
        
        currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:@"" andModelManager:modelManager];

        currentConscienceAssetDAO = [[ConscienceAssetDAO alloc] initWithKey:@"" andModelManager:modelManager];
        currentMoralDAO = [[MoralDAO alloc] initWithKey:@"" andModelManager:modelManager];
        
        self.modelManager = modelManager;

    }

    return self;
    
}

#pragma mark -
#pragma mark Overridden getters

-(NSString *)greatestVirtue {
    [self retrieveBiggestChoiceAsVirtue:YES];
    return _greatestVirtue;
}

-(NSString *)worstVice {
    [self retrieveBiggestChoiceAsVirtue:NO];
    return _worstVice;
}

-(NSString *)highestRank {
    [self retrieveHighestRank];
    return _highestRank;
}

-(UIImage *)greatestVirtueImage {
    [self retrieveBiggestChoiceAsVirtue:YES];
    return _greatestVirtueImage;
}

-(UIImage *)worstViceImage {
    [self retrieveBiggestChoiceAsVirtue:NO];
    return _worstViceImage;
}

-(UIImage *)highestRankImage {
    [self retrieveHighestRank];
    return _highestRankImage;
}


/**
 Implementation:  Determine time of day, and which thought should be displayed.  Cycle through available dilemmas,  current mood, etc.
 */
- (NSString *)generateWelomeMessageWithTimeOfDay:(NSDate *)now andMood:(CGFloat)mood andEnthusiasm:(CGFloat)enthusiasm {

    /** @todo localize everything */
    NSString *timeOfDay = @"Morning";

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
    NSInteger hour = [components hour];

    NSArray *conscienceEnthusiasm = @[@"Stuporous", @"Unresponsive", @"Apathetic", @"Lethargic", @"Indifferent", @"Calm", @"Focused", @"Animated", @"Excited", @"Passionate", @"Unbridled"];
    NSArray *conscienceMood = @[@"Livid", @"Angry", @"Depressed", @"Sad", @"Discontent", @"Normal", @"Content", @"Pleasant", @"Happy", @"Ecstatic", @"Jubilant"];

    if (hour < 4) {
        timeOfDay = @"Night";
    } else if (hour < 12) {
        timeOfDay = @"Morning";
    } else if (hour < 17) {
        timeOfDay = @"Afternoon";
    } else if (hour <= 24) {
        timeOfDay = @"Night";
    }

    NSString *currentConscienceMood = @"Good";

    if ((enthusiasm < 50) || (mood < 50)) {
        currentConscienceMood = @"Bad";
    }

    currentUserCollectableDAO.predicates = @[[NSPredicate predicateWithFormat:@"collectableName == %@", MLCollectableEthicals]];

    UserCollectable *currentUserCollectable = [currentUserCollectableDAO read:@""];

    int ethicals = 0;
    //Increase the moral's value
    ethicals = [[currentUserCollectable collectableValue] intValue];

    NSString *welcomeTextName =[[NSString alloc] initWithFormat:@"%@Welcome%@%@",NSStringFromClass([self class]), timeOfDay, currentConscienceMood];
    NSString *welcomeText = [[NSString alloc] initWithString:NSLocalizedString(welcomeTextName,nil)];
    NSMutableString *thoughtSpecialized = [[NSMutableString alloc] init];

    /** @todo localize Conscience responses */
    switch (thoughtVersion) {
        case 0:{
            [thoughtSpecialized appendString:@"Have you read your Moral Report lately? Tap the Rank Button to review it!"];
            break;
        }
        case 1:{

            if (ethicals == 0) {
                [thoughtSpecialized appendString:@"You have no ethicals left.\n\nEarn some in Morathology by tapping the Rank Button!"];
            } else {
                [thoughtSpecialized appendFormat:@"You have %dε in the bank.\n\nTap the Rank Button to spend them in the Commissary!", ethicals];
            }
            break;
        }
        case 2:{

            int moodIndex = [@(mood) intValue];
            int enthusiasmIndex = [@(enthusiasm) intValue];

            [thoughtSpecialized appendFormat:@"I'm feeling %@ and %@.", conscienceMood[moodIndex/10], conscienceEnthusiasm[enthusiasmIndex/10]];

            break;
        }
        case 3:{
            [thoughtSpecialized appendFormat:@"Your current rank is %@.", self.highestRank];
            break;
        }
        default:
            [thoughtSpecialized setString:welcomeText];
            break;

    }

    if (thoughtVersion < MLThoughtIterations-1) {
        thoughtVersion++;
    } else {
        thoughtVersion = 0;
    }

    return (NSString *)thoughtSpecialized;

}

/**
 Implementation:  Must iterate through every UserChoice entered and sum each like entry to determine most prominent/troublesome virtue/vice
 */
- (void) retrieveBiggestChoiceAsVirtue:(BOOL) isVirtue{

    NSPredicate *pred;

    if (isVirtue) {
        pred = [NSPredicate predicateWithFormat:@"choiceWeight > %d", 0];
    } else {
        pred = [NSPredicate predicateWithFormat:@"choiceWeight < %d", 0];
    }

	currentUserChoiceDAO.predicates = @[pred];

    NSMutableString *moralDisplayName = [NSMutableString stringWithString:@"unknown"];
    NSMutableString *moralImageName = [NSMutableString stringWithString:@"card-doubt"];

	NSArray *objects = [currentUserChoiceDAO readAll];
    NSMutableDictionary *reportValues = [[NSMutableDictionary alloc] initWithCapacity:[objects count]];

	if ([objects count] == 0) {
		NSLog(@"No matches");

        if (isVirtue) {
            self.greatestVirtueImage = [UIImage imageNamed:@"card-doubt.png"];
        } else {
            self.worstViceImage = [UIImage imageNamed:@"card-doubt.png"];
        }

	} else {

        float currentValue = 0.0;


        for (UserChoice *match in objects){

            NSNumber *choiceWeightTemp = reportValues[[match choiceMoral]];

            if (choiceWeightTemp != nil) {
                currentValue = [choiceWeightTemp floatValue];
            } else {
                currentValue = 0.0;
            }

            currentValue += fabsf([[match choiceWeight] floatValue]);

            [reportValues setValue:@(currentValue) forKey:[match choiceMoral]];
        }

        NSArray *sortedPercentages = [reportValues keysSortedByValueUsingSelector:@selector(compare:)];
        NSArray* reversedPercentages = [[sortedPercentages reverseObjectEnumerator] allObjects];

        NSString *value = reversedPercentages[0];

        Moral *currentMoral = [currentMoralDAO read:value];

        if (currentMoral) {
            [moralDisplayName setString:currentMoral.displayNameMoral];
            [moralImageName setString:currentMoral.imageNameMoral];
        }

        if (isVirtue) {
            self.greatestVirtueImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", moralImageName]];

            self.greatestVirtue = moralDisplayName;
        } else {
            self.worstViceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", moralImageName]];

            self.worstVice = moralDisplayName;
        }

	}


}

/**
 Implementation:  Must iterate through every UserCollectable to find all ranks given.  Sort by collectableName as ranks increase alphabetically.
 Change the Rank picture and description.
 */
- (void) retrieveHighestRank {

    //Begin CoreData Retrieval to find all Ranks in possession.
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"collectableName contains[cd] %@", @"asse-rank"];
	currentUserCollectableDAO.predicates = @[pred];

	NSSortDescriptor* sortDescriptor;

	//sort by collectablename as all ranks are alphabetically/numerically sorted by collectableName
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"collectableName" ascending:FALSE];

	NSArray* sortDescriptors = @[sortDescriptor];
	currentUserCollectableDAO.sorts = sortDescriptors;


	NSArray *objects = [currentUserCollectableDAO readAll];

	//In case of no granted Ranks, setup the default User
	self.highestRankImage = [UIImage imageNamed:@"card-doubt.png"];
	self.highestRank = @"Neophyte";

	//Ensure that at least one rank is present
	if ([objects count] > 0) {

        NSString *value = [objects[0] collectableName];
        ConscienceAsset *currentAsset = [currentConscienceAssetDAO read:value];

        if (currentAsset) {
            self.highestRankImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-sm.png", currentAsset.imageNameReference]];
            self.highestRank = currentAsset.displayNameReference;
        }

	}

}

@end
