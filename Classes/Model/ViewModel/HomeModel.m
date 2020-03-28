/** Implementation: Utilize the UserCollectableDAO and UserChoiceDAO in order to retrieve User information for HomeViewController */

#import "HomeModel.h"
#import "ModelManager.h"
#import "UserChoiceDAO.h"
#import "MoralDAO.h"
#import "UserCollectableDAO.h"
#import "ConscienceAssetDAO.h"

static int thoughtVersion = 0;
int const EMOTIONAL_STATE_COUNT = 11;
int const HOME_MODEL_THOUGHT_ITERATIONS = 5;
int const HOME_MODEL_REACTION_COUNT = 6;
NSString * const HOME_MODEL_BEGINNER_RANK = @"Neophyte";

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

        self.greatestVirtue = @"";
        self.worstVice = @"";
        self.highestRank = @"";
        self.greatestVirtueImage = [[UIImage alloc] init];
        self.worstViceImage = [[UIImage alloc] init];
        self.highestRankImage = [[UIImage alloc] init];

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

    NSString *welcomeTemp;

    NSString *timeOfDay = @"Morning";

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
    NSInteger hour = [components hour];


    NSMutableArray *conscienceEnthusiasm = [[NSMutableArray alloc] initWithCapacity:EMOTIONAL_STATE_COUNT];
    NSMutableArray *conscienceMood = [[NSMutableArray alloc] initWithCapacity:EMOTIONAL_STATE_COUNT];

    for (int i = 0; i < EMOTIONAL_STATE_COUNT; i++) {

        welcomeTemp = [[NSString alloc] initWithFormat:@"%@Mood%d",NSStringFromClass([self class]), i];

        conscienceMood[i] = NSLocalizedString(welcomeTemp, nil);

        welcomeTemp =[[NSString alloc] initWithFormat:@"%@Enthusiasm%d",NSStringFromClass([self class]), i];

        conscienceEnthusiasm[i] = NSLocalizedString(welcomeTemp, nil);

    }

    if (hour < 4) {
        timeOfDay = @"Night";
    } else if (hour < 12) {
        timeOfDay = @"Morning";
    } else if (hour < 17) {
        timeOfDay = @"Afternoon";
    } else if (hour <= 24) {
        timeOfDay = @"Night";
    }

    NSString *currentConscienceMood = ((enthusiasm < 50) || (mood < 50)) ? @"Bad" : @"Good";

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

            welcomeTemp = [[NSString alloc] initWithFormat:@"%@Thought0",NSStringFromClass([self class])];

            [thoughtSpecialized appendString:NSLocalizedString(welcomeTemp,nil)];
            break;
        }
        case 1:{

            if (ethicals == 0) {
                welcomeTemp = [[NSString alloc] initWithFormat:@"%@Thought1",NSStringFromClass([self class])];
                [thoughtSpecialized appendString:NSLocalizedString(welcomeTemp,nil)];
            } else {
                welcomeTemp = [[NSString alloc] initWithFormat:@"%@Thought2",NSStringFromClass([self class])];
                NSString *welcomeTemp2 = [[NSString alloc] initWithFormat:@"%@Thought3",NSStringFromClass([self class])];
                [thoughtSpecialized appendFormat:@"%@%d%@", NSLocalizedString(welcomeTemp,nil), ethicals, NSLocalizedString(welcomeTemp2,nil)];
            }
            break;
        }
        case 2:{

            int moodIndex = [@(mood) intValue];
            int enthusiasmIndex = [@(enthusiasm) intValue];

            welcomeTemp = [[NSString alloc] initWithFormat:@"%@Thought4",NSStringFromClass([self class])];
            NSString *welcomeTemp2 = [[NSString alloc] initWithFormat:@"%@Thought5",NSStringFromClass([self class])];

            [thoughtSpecialized appendFormat:@"%@%@%@%@.", NSLocalizedString(welcomeTemp,nil), conscienceMood[moodIndex/10], NSLocalizedString(welcomeTemp2,nil), conscienceEnthusiasm[enthusiasmIndex/10]];

            break;
        }
        case 3:{
            welcomeTemp = [[NSString alloc] initWithFormat:@"%@Thought6",NSStringFromClass([self class])];

            [thoughtSpecialized appendFormat:@"%@%@.", NSLocalizedString(welcomeTemp,nil), self.highestRank];
            break;
        }
        default:
            [thoughtSpecialized setString:welcomeText];
            break;

    }

    if (thoughtVersion < HOME_MODEL_THOUGHT_ITERATIONS-1) {
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
	self.highestRank = [NSString stringWithString:HOME_MODEL_BEGINNER_RANK];

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

- (NSString *)generateReactionWithMood:(CGFloat)mood andEnthusiasm:(CGFloat)enthusiasm {
    int randomResponse = arc4random()%HOME_MODEL_REACTION_COUNT;

    NSString *reactionMood = ((enthusiasm > 35) && (mood > 45)) ? @"Good" : @"Bad";
    NSString *reactionTemp = [[NSString alloc] initWithFormat:@"%@Reaction%d%@",NSStringFromClass([self class]), randomResponse, reactionMood];

    return NSLocalizedString(reactionTemp, @"localizedReaction");

}

@end
