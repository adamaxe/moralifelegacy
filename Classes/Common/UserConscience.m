#import "UserConscience.h"
#import "ConscienceBody.h"
#import "ConscienceAccessories.h"
#import "ConscienceView.h"
#import "ConscienceAsset.h"
#import "ConscienceBuilder.h"
#import "UserCharacterDAO.h"
#import "ConscienceMind.h"

@interface UserConscience ()
/**
 Create base Monitor before personalization re-instatement
 */
- (void)createConscience;
/**
 Apply User's changes to base Monitor
 */
- (void)configureConscience;

@end

@implementation UserConscience

-(id)init {
    self = [super init];

    if (self) {
        [self createConscience];
    }

    return self;
}

/**
 Implementation: Call all constructors for default Conscience features if they do not already exist.  These setups will be overridden by the configuration task.
 */
- (void) createConscience{

    if (!_userConscienceBody) {
        _userConscienceBody = [[ConscienceBody alloc] init];

    }

    if (!_userConscienceAccessories) {
        _userConscienceAccessories = [[ConscienceAccessories alloc] init];

    }

    if (!_userConscienceMind) {
        _userConscienceMind = [[ConscienceMind alloc] init];

    }

	//Apply User customizations to Conscience and User Data
    [self configureConscience];

	//Create physcial, viewable Conscience from constructs
    if (!_userConscienceView) {
        _userConscienceView = [[ConscienceView alloc] initWithFrame:CGRectMake(20, 130, 200, 200) withBody:_userConscienceBody withAccessories:_userConscienceAccessories withMind:_userConscienceMind];

        _userConscienceView.tag = MLConscienceViewTag;
        _userConscienceView.multipleTouchEnabled = TRUE;
    }

}

/**
 Implementation: Retrieve User-customizations to Monitor from Core Data.  Then build physical traits (eyes/mouth/face/mind).
 */
- (void)configureConscience{
    UserCharacterDAO *currentUserCharacterDAO = [[UserCharacterDAO alloc] init];
    UserCharacter *currentUserCharacter = [currentUserCharacterDAO read:@""];

    //Populate User Conscience
    _userConscienceBody.eyeName = [currentUserCharacter characterEye];
    _userConscienceBody.mouthName = [currentUserCharacter characterMouth];
    _userConscienceBody.symbolName = [currentUserCharacter characterFace];

    _userConscienceBody.eyeColor = [currentUserCharacter characterEyeColor];
    _userConscienceBody.browColor = [currentUserCharacter characterBrowColor];
    _userConscienceBody.bubbleColor = [currentUserCharacter characterBubbleColor];
    _userConscienceBody.bubbleType = [[currentUserCharacter characterBubbleType] intValue];

    _userConscienceBody.age = [[currentUserCharacter characterAge] intValue];
    _userConscienceBody.size = [[currentUserCharacter characterSize] floatValue];

    _userConscienceAccessories.primaryAccessory = [currentUserCharacter characterAccessoryPrimary];
    _userConscienceAccessories.secondaryAccessory = [currentUserCharacter characterAccessorySecondary];
    _userConscienceAccessories.topAccessory = [currentUserCharacter characterAccessoryTop];
    _userConscienceAccessories.bottomAccessory = [currentUserCharacter characterAccessoryBottom];

    _userConscienceMind.mood = [[currentUserCharacter characterMood] floatValue];
    _userConscienceMind.enthusiasm = [[currentUserCharacter characterEnthusiasm] floatValue];


	//Call utility class to parse svg data for feature building
	[ConscienceBuilder buildConscience:_userConscienceBody];
}


@end
