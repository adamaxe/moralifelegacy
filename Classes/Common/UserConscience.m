#import "UserConscience.h"
#import "ModelManager.h"
#import <QuartzCore/QuartzCore.h>
#import "ConscienceBody.h"
#import "ConscienceAccessories.h"
#import "ConscienceAsset.h"
#import "ConscienceBuilder.h"
#import "UserCharacterDAO.h"
#import "UserCollectableDAO.h"

float const MLTransientInterval = 7;

@interface UserConscience ()

@property (nonatomic) ModelManager *modelManager;
@property (nonatomic) NSTimer *shakeTimer;				/**< limits Conscience shake response */

/**
 User choices affect UserConscience immediately, must return Conscience to regular state
 @param originalMood float representing overall Conscience mood
 @param originalEnthusiasm float representing overall Conscience enthusiasm
 */
-(void) resetMood:(float) originalMood andEnthusiasm:(float) originalEnthusiasm;

/**
 Create base Monitor before personalization re-instatement
 */
- (void)createConscience;
/**
 Apply User's changes to base Monitor
 */
- (void)configureConscience;
/**
 Stop the Conscience from shaking
 */
- (void)shakeEnd;

@end

@implementation UserConscience

-(id)initWithModelManager:(ModelManager *)modelManager {

    self = [super init];

    if (self) {
        self.modelManager = modelManager;
        [self createConscience];

        if (!self.conscienceCollection) {
            self.conscienceCollection = [[NSMutableArray alloc] init];

        }
        
        [self configureCollection];
    }

    return self;
}

#pragma mark -
#pragma mark overloaded setters

- (void)setTransientMood:(float)transientMood {
    if(_transientMood != transientMood) {

        //store previous mood
        float restoreMood = self.userConscienceMind.mood;
        float restoreEnthusiasm = self.userConscienceMind.enthusiasm;

        //set new mood
        self.userConscienceMind.mood = transientMood;
        self.userConscienceMind.enthusiasm = 100.0;
        [self.userConscienceMind setIsExpressionForced:TRUE];

        //Setup invocation for delayed mood reset
        SEL selector = @selector(resetMood:andEnthusiasm:);

        NSMethodSignature *signature = [UserConscience instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:selector];

        //Set the arguments
        [invocation setTarget:self];
        [invocation setArgument:&restoreMood atIndex:2];
        [invocation setArgument:&restoreEnthusiasm atIndex:3];

        [self.userConscienceView setNeedsDisplay];

        [NSTimer scheduledTimerWithTimeInterval:MLTransientInterval invocation:invocation repeats:NO];
        
    }
}

#pragma mark -
#pragma mark Conscience Setup

/**
 Implementation: Retrieve User-entries such as questions/responses.
 */
- (void)configureCollection{

    //Retrieve  assets already earned by user
    UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:@"" andModelManager:self.modelManager];

    NSArray *objects = [currentUserCollectableDAO readAll];
    //Populate dictionary with dilemmaName (key) and moral that was chosen
    for (UserCollectable *match in objects) {

        [self.conscienceCollection addObject:[match collectableName]];
    }

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
    UserCharacterDAO *currentUserCharacterDAO = [[UserCharacterDAO alloc] initWithKey:@"" andModelManager:self.modelManager];
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

/**
 Implementation: Return UserConscience's Mood to previous state.  Eliminate transient mood/enthusiasm.  Fade results since glow change would be jarring, visually.
 */
- (void) resetMood:(float) originalMood andEnthusiasm:(float) originalEnthusiasm{

    [UIView beginAnimations:@"conscienceFade" context:nil];
    [UIView setAnimationDuration:0.25];

    [UIView setAnimationBeginsFromCurrentState:YES];

    self.userConscienceView.alpha = 0;
    self.userConscienceMind.mood = originalMood;
    self.userConscienceMind.enthusiasm = originalEnthusiasm;
    [self.userConscienceView setNeedsDisplay];

    [UIView setAnimationDelegate:self.userConscienceView];
    [UIView setAnimationDidStopSelector:@selector(makeConscienceVisible)];

    [UIView commitAnimations];
    
}

#pragma mark -
#pragma mark Shake Handling

/**
 Implementation: Randomize the position of the conscience and the eye positions for a time.  Stop the actual consciencePosition randomization, but continue the eye randomization for a time.
 */
- (void)shakeConscience {
    SEL shakeSelector = @selector(changeEyeDirection);
	SEL shakeEndSelector = @selector(shakeEnd);

	// create a singature from the selector
	NSMethodSignature *shakeSignature = [[ConscienceView class] instanceMethodSignatureForSelector:shakeSelector];
	NSMethodSignature *shakeEndSignature = [[self class] instanceMethodSignatureForSelector:shakeEndSelector];

	NSInvocation *shakeInvocation = [NSInvocation invocationWithMethodSignature:shakeSignature];
	NSInvocation *shakeEndInvocation = [NSInvocation invocationWithMethodSignature:shakeEndSignature];

	[shakeInvocation setTarget:self.userConscienceView];
	[shakeInvocation setSelector:shakeSelector];
	[shakeEndInvocation setTarget:self];
	[shakeEndInvocation setSelector:shakeEndSelector];

    //Stop the conscience from moving
    if(self.shakeTimer != nil){
        [self.shakeTimer invalidate];
        self.shakeTimer = nil;
    }else {
        self.shakeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 invocation:shakeInvocation repeats:YES];
        [NSTimer scheduledTimerWithTimeInterval:1.5 invocation:shakeEndInvocation repeats:NO];

    }

    CAAnimation *shakeAnimation = (CAAnimation *)[self.userConscienceView shakeAnimation];
    [self.userConscienceView.layer addAnimation:shakeAnimation forKey:@"position"];

}

- (void) shakeEnd {
	[self.shakeTimer invalidate];
	self.shakeTimer = nil;

}

@end
