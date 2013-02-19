/**
Implementation:  ConcienceView can display the User's Conscience or a Antagonist's Conscience.
User's Conscience is customizable by the User and populated by userConscienceBody and userConscienceMind.  
Antagonist Conscience is determined by System and assigned to currentConscienceBody and currentConscienceMind.  
Actual facial changes are requested by ViewController.  
@todo finish documentation
@class ConscienceView ConscienceView.h
 */

#import <QuartzCore/QuartzCore.h>
#import "ConscienceView.h"
#import "MoraLifeAppDelegate.h"
#import "ConscienceBody.h"
#import "ConscienceGradient.h"
#import "ConscienceLayer.h"
#import "ConscienceObjectView.h"
#import "ConscienceBubbleView.h"
#import "ConscienceAccessories.h"
#import "AccessoryObjectView.h"
#import "ConscienceAsset.h"
#import "ConscienceMind.h"
#import "ConsciencePath.h"

int const MLDirectionFacingLeft = 0;
int const MLDirectionFacingRight = 1;
int const MLConscienceLowerLeftX = 55;
int const MLConscienceLowerLeftY = 440;
int const MLConscienceHomeX = 105;
int const MLConscienceHomeY = 225;
int const MLConscienceOffscreenBottomX = 70;
int const MLConscienceOffscreenBottomY = 605;
int const MLConscienceAntagonistX = 90;
int const MLConscienceAntagonistY = 45;
int const MLConscienceAntagonistWidth = 165;
int const MLConscienceAntagonistHeight = 165;
int const MLConscienceViewTag = 3017;
int const MLConscienceAntagonistViewTag = 3020;
float const MLConscienceLargeSizeX = 1.25;
float const MLConscienceLargeSizeY = 1.25;
float const MLConscienceLargestSize = 2.25;

int const MLMouthHeight = 32;
int const MLMouthWidth = 50;
int const MLSymbolHeight = 200;
int const MLSymbolWidth = 200;
int const MLTopBottomAccessoryHeight = 50;
int const MLTopBottomAccessoryWidth = 162;
int const MLExpressionInterval = 3;
float const MLBlinkInterval = 2;

/**
 Tag Numbers for webViews in order to reference them
 */
typedef enum {
	MLConscienceViewEyeRightViewTag = 3000,
	MLConscienceViewEyeLeftViewTag = 3001,
	MLConscienceViewMouthWebViewTag = 3002,
	MLConscienceViewSymbolWebViewTag = 3003,
	MLConscienceViewBubbleImageViewTag = 3004,
	MLConscienceViewPrimaryAccessoryViewTag = 3005,
	MLConscienceViewSecondaryAccessoryViewTag = 3006,
	MLConscienceViewTopAccessoryViewTag = 3007,
	MLConscienceViewBottomAccessoryViewTag = 3008,
	MLConscienceViewEyeLeftSleepImageViewTag = 3009,
	MLConscienceViewEyeLeftBrowViewTag = 3010,
	MLConscienceViewEyeRightBrowViewTag = 3011,
	MLConscienceViewBubbleViewTag = 3012,
	MLConscienceViewEyeLeftBagViewTag = 3013,
	MLConscienceViewEyeRightBagViewTag = 3014,
	MLConscienceViewSymbolViewTag = 3015,
	MLConscienceViewMouthViewTag = 3016,
	MLConscienceViewConscienceCustomizeViewTag = 3018,
	MLConscienceViewAnimatedBubbleViewTag = 3019,
	MLConscienceViewConscienceProtagonistViewTag = 3021,
	MLConscienceViewChoiceCancelButtonTag = 3022,
	MLConscienceViewChoiceMoralButtonTag = 3023
} MLConscienceViewTags;

/** Eyes
 */

typedef enum {
    MLEyePlacementLeft,
    MLEyePlacementRight,
    MLEyePlacementBoth,
    MLEyePlacementRandom

} MLEyePlacement;

typedef enum {
    MLEyeStateClose,
    MLEyeStateOpen

} MLEyeState;

/**
 Possible expression states of Lips
 */
typedef enum {
	MLExpressionLipsSadShock,
	MLExpressionLipsSadOpenAlt1,
	MLExpressionLipsSadOpen,
	MLExpressionLipsSadAlt1,
	MLExpressionLipsSad,
	MLExpressionLipsSadSmirk,
	MLExpressionLipsSadSilly,
	MLExpressionLipsNormal,
	MLExpressionLipsHappySmirk,
	MLExpressionLipsHappy,
	MLExpressionLipsHappyAlt1,
	MLExpressionLipsHappySilly,
	MLExpressionLipsHappyOpen,
	MLExpressionLipsHappyOpenAlt1,
	MLExpressionLipsHappyShock
} MLExpressionLips;

/**
 Possible expression states of Dimples
 */
typedef enum {
	MLExpressionDimplesSad,
	MLExpressionDimplesNormal,
	MLExpressionDimplesHappy
} MLExpressionDimples;

/**
 Possible expression states of Teeth
 */
typedef enum {
	MLExpressionTeethSadOpenAlt1,
	MLExpressionTeethSadOpen,
	MLExpressionTeethHappyOpen,
	MLExpressionTeethHappyOpenAlt1
} MLexpressionTeeth;

/**
 Possible expression states of Tongue
 */
typedef enum {
	MLExpressionTongueSadCenter,
	MLExpressionTongueSadLeft,
	MLExpressionTongueSadRight,
	MLExpressionTongueHappyCenter,
	MLExpressionTongueHappyLeft,
	MLExpressionTongueHappyRight
} MLExpressionTongue;

/**
 Possible expression states of Brow
 */
typedef enum {
	MLExpressionBrowAngry,
	MLExpressionBrowNormal,
	MLExpressionBrowConfused,
	MLExpressionBrowExcited
} MLExpressionBrow;

/**
 Possible expression states of Lashes
 */
typedef enum {
	MLExpressionLashesUp,
	MLExpressionLashesDown
} MLExpressionLashes;

/**
 Possible expression states of Lid
 */
typedef enum {
	MLExpressionLidAngry,
	MLExpressionLidSleepy,
	MLExpressionLidNormal,
	MLExpressionLidUnder
} MLExpressionLid;


/**
 Possible look direction of Eye
 */
typedef enum {
	MLExpressionLookCenter,
	MLExpressionLookDown,
	MLExpressionLookUp,
	MLExpressionLookLeft,
	MLExpressionLookRight,
	MLExpressionLookCross,
	MLExpressionLookCrazy
} MLExpressionLook;

/**
 Possible expression states of Bags
 */
typedef enum {
	MLExpressionBagsNormal,
	MLExpressionBagsOld,
	MLExpressionBagsOlder,
	MLExpressionBagsOldest
} MLExpressionBags;

@interface ConscienceView () {
    
	MoraLifeAppDelegate *appDelegate;               /**< delegate for application level callbacks */
    
    //Conscience visual display
	ConscienceBubbleView *animatedBubbleView;		/**< External animated bubble */
	ConscienceObjectView *conscienceEyeLeftView;	/**< Conscience left eye (right-most eye on screen) */
	ConscienceObjectView *conscienceEyeRightView;   /**< Conscience right eye (left-most eye on screen) */
	ConscienceObjectView *conscienceSymbolView;     /**< Conscience symbol */
	ConscienceObjectView *conscienceMouthView;      /**< Conscience mouth */
    
	//Conscience possession visual display
	AccessoryObjectView *accessoryPrimaryView;      /**< Conscience left hand (right-most on screen) */
	AccessoryObjectView *accessorySecondaryView;	/**< Conscience right hand/back (left-most on screen) */
	AccessoryObjectView *accessoryTopView;          /**< Conscience head */
	AccessoryObjectView *accessoryBottomView;		/**< Conscience neck/chest */
	
    NSArray *browExpressions;
    NSArray *lidExpressions;    
    NSArray *lipsExpressions;
    NSArray *tongueExpressions;
    NSArray *teethExpressions;
    NSArray *dimplesExpressions;
    NSArray *eyeLeftPositions;
    NSArray *eyeRightPositions;    
    
	NSTimer *mouthTimer;		/**< controls expression interval */
	NSTimer *eyeTimer;          /**< controls eye state interval */
	NSTimer *blinkTimer;		/**< controls blink/wink interval */
	
}

/**
 Change eye state to imitate winking/blinking
 Values are open and closed
 @param eyeState int whether eye is open or closed
 @param eyeNumber int eye designation to affect (left, right, both, random)
 */
- (void) changeEyeState:(MLEyeState) eyeState forEye:(MLEyePlacement) eyeNumber;

/**
 Change direction Conscience is looking by moving iris
 Values are center, down, up, left, right, cross, crazy
 @param expressionIndex int direction eye can look
 @param eyeNumber int eye designation to affect (left, right, both, random)
 @see expressionLookEnum
 */
- (void) changeEyeDirection:(MLExpressionLook)expressionIndex forEye:(MLEyePlacement) eyeNumber;

/**
 Change brow expression
 Values are angry, confused, excited, normal
 @param expression NSString layerName of brow ConscienceLayer to be selected
 @param eyeNumber int eye designation to affect (left, right, both, random)
 */
- (void) changeBrowExpressions:(NSString *) expression forEye:(MLEyePlacement) eyeNumber;

/**
 Change lid expression
 Values are angry, normal, sleepy, under
 @param expression NSString layerName of lid ConscienceLayer to be selected
 @param eyeNumber int eye designation to affect (left, right, both, random)
 */
- (void) changeLidExpressions:(NSString *) expression forEye:(MLEyePlacement) eyeNumber;


@end

@implementation ConscienceView

static int numberOfShakes = 8;
static float durationOfShake = 0.5f;
static float vigourOfShake = 0.05f;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithFrame:(CGRect)frame withBody:(ConscienceBody *) argBody withAccessories:(ConscienceAccessories *) argAccessories
withMind: (ConscienceMind *) argMind{

    if ((self = [super initWithFrame:frame])) {

        [self setCurrentConscienceBody:argBody];
        [self setCurrentConscienceAccessories:argAccessories];
        [self setCurrentConscienceMind:argMind];

        //Conscience Look direction determined by layeroffset
        //Array of pixel offsets by X/Y coordinates utilized for every eyetype
        //Values are look: center, up, down, left, right, cross, crazy
        eyeLeftPositions = @[[NSValue valueWithCGPoint:CGPointMake(0, 0)],
                                     [NSValue valueWithCGPoint:CGPointMake(0, -2)], 
                                     [NSValue valueWithCGPoint:CGPointMake(0, 3)],
                                     [NSValue valueWithCGPoint:CGPointMake(-2, 1)],	
                                     [NSValue valueWithCGPoint:CGPointMake(3, 0)],
                                     [NSValue valueWithCGPoint:CGPointMake(4, 1)],
                                     [NSValue valueWithCGPoint:CGPointMake(4, -2)]];
        
        eyeRightPositions = @[[NSValue valueWithCGPoint:CGPointMake(0, 0)],
                                      [NSValue valueWithCGPoint:CGPointMake(0, -2)], 
                                      [NSValue valueWithCGPoint:CGPointMake(0, 3)],
                                      [NSValue valueWithCGPoint:CGPointMake(3, 1)],
                                      [NSValue valueWithCGPoint:CGPointMake(-3, -1)],
                                      [NSValue valueWithCGPoint:CGPointMake(4, 1)],
                                      [NSValue valueWithCGPoint:CGPointMake(-1, 4)]];

        lipsExpressions = @[@"layerLipsSadShock", @"layerLipsSadOpenAlt1", @"layerLipsSadOpen", @"layerLipsSadAlt1", @"layerLipsSad", @"layerLipsSadSmirk", @"layerLipsSadSilly", @"layerLipsNormalSad", @"layerLipsNormal", @"layerLipsNormalHappy", @"layerLipsHappySmirk", @"layerLipsHappy", @"layerLipsHappySilly", @"layerLipsHappyAlt1", @"layerLipsHappyOpen", @"layerLipsHappyOpenAlt1", @"layerLipsHappyShock"];
        dimplesExpressions = @[@"layerDimplesSad", @"layerDimplesNormal", @"layerDimplesHappy"];        
        teethExpressions = @[@"layerTeethSadOpenAlt1", @"layerTeethSadOpen", @"layerTeethNormal", @"layerTeethHappyOpen", @"layerTeethHappyOpenAlt1"];
        tongueExpressions = @[@"layerTongueSadCenter", @"layerTongueSadLeft", @"layerTongueSadRight", @"layerTongueNormal", @"layerTongueHappyCenter", @"layerTongueHappyLeft", @"layerTongueHappyRight"];
        browExpressions = @[@"layerBrowNormal",@"layerBrowAngry", @"layerBrowConfused", @"layerBrowExcited"];
        lidExpressions = @[@"layerLidNormal", @"layerLidAngry", @"layerLidSquint", @"layerLidSleepy", @"layerLidUnder"];

        
        appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
        
		//Setup initial views
		_directionFacing = MLDirectionFacingLeft;
		self.contentMode = UIViewContentModeScaleAspectFit;
		self.multipleTouchEnabled = TRUE;
		self.backgroundColor = [UIColor clearColor];
        
		/** @todo change hardcoded x/y coordinates to constants */
		//Allocate actual Conscience features
		//set tag number for each view so they can be changed with reinitialization
		//configuration is done in setNeedsDisplay		
		_conscienceBubbleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
		_conscienceBubbleView.tag = MLConscienceViewBubbleViewTag;
		_conscienceBubbleView.multipleTouchEnabled = TRUE;
        
		animatedBubbleView = [[ConscienceBubbleView alloc] initWithFrame:CGRectMake(0, 0, MLSymbolWidth, MLSymbolHeight)];
		animatedBubbleView.tag = MLConscienceViewAnimatedBubbleViewTag;
		[_conscienceBubbleView insertSubview:animatedBubbleView atIndex:0];
		
		accessoryPrimaryView = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(160, 25, MLSideAccessoryWidth, MLSideAccessoryHeight)]; 
		accessoryPrimaryView.tag = MLConscienceViewPrimaryAccessoryViewTag;
		
		[_conscienceBubbleView addSubview:accessoryPrimaryView];
		
		accessorySecondaryView = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(-20, 25, MLSideAccessoryWidth, MLSideAccessoryHeight)]; 
		accessorySecondaryView.tag = MLConscienceViewSecondaryAccessoryViewTag;
		[_conscienceBubbleView addSubview:accessorySecondaryView];
		
		accessoryTopView = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(12, -10, MLTopBottomAccessoryWidth, MLTopBottomAccessoryHeight)];
		accessoryTopView.tag = MLConscienceViewTopAccessoryViewTag;		
		[_conscienceBubbleView addSubview:accessoryTopView];
		
		accessoryBottomView = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(20, 165, MLTopBottomAccessoryWidth, MLTopBottomAccessoryHeight)];
		accessoryBottomView.tag = MLConscienceViewBottomAccessoryViewTag;		
		[_conscienceBubbleView addSubview:accessoryBottomView];
		
		conscienceEyeRightView = [[ConscienceObjectView alloc] initWithFrame:CGRectMake(0, 0, MLEyeWidth, MLEyeHeight)];
		conscienceEyeRightView.tag = MLConscienceViewEyeRightViewTag;
		[_conscienceBubbleView addSubview:conscienceEyeRightView];
		
		conscienceEyeLeftView = [[ConscienceObjectView alloc] initWithFrame:CGRectMake(MLEyeWidth, 0, MLEyeWidth, MLEyeHeight)];
		conscienceEyeLeftView.tag = MLConscienceViewEyeLeftViewTag;
		conscienceEyeLeftView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
		[_conscienceBubbleView addSubview:conscienceEyeLeftView];
        
		conscienceMouthView = [[ConscienceObjectView alloc] initWithFrame:CGRectMake(MLEyeWidth, 0, MLMouthWidth, MLMouthHeight)];
		conscienceMouthView.tag = MLConscienceViewMouthViewTag;
		[_conscienceBubbleView addSubview:conscienceMouthView];
		
		conscienceSymbolView = [[ConscienceObjectView alloc] initWithFrame:CGRectMake(0, 0, MLSymbolWidth, MLSymbolHeight)];
		conscienceSymbolView.tag = MLConscienceViewSymbolViewTag;
        
		[_conscienceBubbleView addSubview:conscienceSymbolView];
        
		
		[self addSubview: _conscienceBubbleView];
        
    }
	
	return self;
	
}

/**
Implementation: Must override setNeedsDisplay because Conscience can be altered by User at any time.
Views are called by tags which are set in initWithFrame by constants
@see ConscienceView::initWithFrame
*/
-(void) setNeedsDisplay{
    [super setNeedsDisplay];

	//Ensure correct bubble color/animation is set	
	[self changeBubble];	

    //Display accessories chosen by User or System for Antagonists
	accessoryPrimaryView = (AccessoryObjectView *)[_conscienceBubbleView viewWithTag:MLConscienceViewPrimaryAccessoryViewTag];
	accessoryPrimaryView.accessoryFilename = _currentConscienceAccessories.primaryAccessory;
    
	[accessoryPrimaryView setNeedsDisplay];
	
	accessorySecondaryView = (AccessoryObjectView *)[_conscienceBubbleView viewWithTag:MLConscienceViewSecondaryAccessoryViewTag];
	accessorySecondaryView.accessoryFilename = _currentConscienceAccessories.secondaryAccessory;
	[accessorySecondaryView setNeedsDisplay];
	
	accessoryTopView = (AccessoryObjectView *)[_conscienceBubbleView viewWithTag:MLConscienceViewTopAccessoryViewTag];
	accessoryTopView.accessoryFilename = _currentConscienceAccessories.topAccessory;
	[accessoryTopView setNeedsDisplay];
	
	accessoryBottomView = (AccessoryObjectView *)[_conscienceBubbleView viewWithTag:MLConscienceViewBottomAccessoryViewTag];
	accessoryBottomView.accessoryFilename = _currentConscienceAccessories.bottomAccessory;
	[accessoryBottomView setNeedsDisplay];
	
	animatedBubbleView = (ConscienceBubbleView *) [_conscienceBubbleView viewWithTag:MLConscienceViewAnimatedBubbleViewTag];
	[animatedBubbleView setNeedsDisplay];	

    
	[self setTimers];
	

}

/**
 Implementation: Symbol/Eye/Mouth/Accessories choices/color determined by User's symbol/eye/mouth/accessories color/choice.
 currentConscienceBody is either userConscienceBody, or antagonistConscienceBody set by ViewController
 @see ConscienceView::initWithFrame
 */
-(void)layoutSubviews {
    //Set Eye layer, Eye is actually composed of separate layers to allow for animation
	//insertLayer is needed to modify iris/brow colors
	//currentConscienceBody layers are pulled for each eye feature
	//then set into view in specific order to account for layer draw order
	//order is determined by leading number in setObject:forKey:
	ConscienceLayer *insertLayer = (_currentConscienceBody.eyeLayers)[@"layerEyeballIrisLeft"];
	insertLayer.currentFillColor = _currentConscienceBody.eyeColor;
    
	(conscienceEyeLeftView.totalLayers)[@"4layerEyeball"] = insertLayer;
	insertLayer = (_currentConscienceBody.browLayers)[@"layerBrowNormal"];
	insertLayer.currentFillColor = _currentConscienceBody.browColor;
    
	(conscienceEyeLeftView.totalLayers)[@"2layerBrow"] = insertLayer;
	
	//Rest of Eye layers are without color
	(conscienceEyeLeftView.totalLayers)[@"6layerLid"] = (_currentConscienceBody.lidLayers)[@"layerLidNormal"];
	(conscienceEyeLeftView.totalLayers)[@"5layerSocketBottom"] = (_currentConscienceBody.socketLayers)[@"layerSocketBottom"];
	(conscienceEyeLeftView.totalLayers)[@"7layerSocketTop"] = (_currentConscienceBody.socketLayers)[@"layerSocketTop"];
	(conscienceEyeLeftView.totalLayers)[@"9layerLashes"] = (_currentConscienceBody.lashesLayers)[@"layerLashesUp"];
    
	NSMutableString *ageLayer = [[NSMutableString alloc] initWithString:@"layerBags"];
    
	switch (_currentConscienceBody.age) {
		case 0: [ageLayer appendString:@"Normal"]; break;
		case 1: [ageLayer appendString:@"Old"]; break;            
		case 2: [ageLayer appendString:@"Older"]; break;            
		case 3: [ageLayer appendString:@"Oldest"]; break;            
		default: [ageLayer appendString:@"Normal"]; break;
	}
    
	(conscienceEyeLeftView.totalLayers)[@"3layerBags"] = (_currentConscienceBody.bagsLayers)[ageLayer];
	[conscienceEyeLeftView.totalGradients addEntriesFromDictionary:_currentConscienceBody.gradientLayers];
	
	//Request ConscienceObject view update
	[conscienceEyeLeftView setNeedsDisplay];
	
	//Repeat work for right eye
	//Both cannot be done simultaneously to account for expression differences between eyes
	//such as wink/blink, raise eyebrow, one lid, etc.
	insertLayer = (_currentConscienceBody.eyeLayers)[@"layerEyeballIrisRight"];
	insertLayer.currentFillColor = _currentConscienceBody.eyeColor;
	(conscienceEyeRightView.totalLayers)[@"4layerEyeball"] = insertLayer;
	insertLayer = (_currentConscienceBody.browLayers)[@"layerBrowNormal"];
	insertLayer.currentFillColor = _currentConscienceBody.browColor;
    
	(conscienceEyeRightView.totalLayers)[@"2layerBrow"] = insertLayer;
    
	(conscienceEyeRightView.totalLayers)[@"6layerLid"] = (_currentConscienceBody.lidLayers)[@"layerLidNormal"];
	(conscienceEyeRightView.totalLayers)[@"5layerSocketBottom"] = (_currentConscienceBody.socketLayers)[@"layerSocketBottom"];
	(conscienceEyeRightView.totalLayers)[@"7layerSocketTop"] = (_currentConscienceBody.socketLayers)[@"layerSocketTop"];
	(conscienceEyeRightView.totalLayers)[@"9layerLashes"] = (_currentConscienceBody.lashesLayers)[@"layerLashesUp"];
	(conscienceEyeRightView.totalLayers)[@"3layerBags"] = (_currentConscienceBody.bagsLayers)[ageLayer];
    
	[conscienceEyeRightView.totalGradients addEntriesFromDictionary:_currentConscienceBody.gradientLayers];
	[conscienceEyeRightView setNeedsDisplay];	
	
	//Set Symbol layer, Symbol is actually composed of a single layer for the graphic
	//Position layer is included to set the positioning of the eyes/mouth for each symbol
	(conscienceSymbolView.totalLayers)[@"layerSymbol"] = (_currentConscienceBody.symbolLayers)[@"layerSymbol"];
	[conscienceSymbolView setNeedsDisplay];
    
	//Set Mouth layer, Mouth is actually composed of separate layers to allow for animation
	(conscienceMouthView.totalLayers)[@"layerDimples"] = (_currentConscienceBody.dimplesLayers)[@"layerDimplesHappy"];
	(conscienceMouthView.totalLayers)[@"layerLips"] = (_currentConscienceBody.lipsLayers)[@"layerLipsNormal"];
	(conscienceMouthView.totalLayers)[@"layerTeeth"] = (_currentConscienceBody.teethLayers)[@"layerTeethNormal"];
	(conscienceMouthView.totalLayers)[@"layerTongue"] = (_currentConscienceBody.tongueLayers)[@"layerTongueNormal"];
	[conscienceMouthView.totalGradients addEntriesFromDictionary:_currentConscienceBody.gradientLayers];
    
	//Positioning of Eyes/Mouth/Symbol actually housed in symbol SVG file
	//Position is a single path in SVG where each point represents a facial feature location		
	ConscienceLayer *positionLayer = (ConscienceLayer *)(_currentConscienceBody.symbolLayers)[@"layerPosition"];
	ConsciencePath *positionPath = (ConsciencePath *)[positionLayer consciencePaths][0];
	
	CGPoint p = CGPointMake([(positionPath.pathPoints)[0] floatValue], [(positionPath.pathPoints)[1] floatValue]);
	conscienceEyeRightView.center = p;
	p = CGPointMake([(positionPath.pathPoints)[2] floatValue], [(positionPath.pathPoints)[3] floatValue]);
	conscienceEyeLeftView.center = p;		
	p = CGPointMake([(positionPath.pathPoints)[4] floatValue], [(positionPath.pathPoints)[5] floatValue]);
	conscienceMouthView.center = p;
        
	_isExpressionForced = FALSE;
    
}

#pragma mark -
#pragma mark Eye expression control

/** 
Implementation: Change Eye state for winking/blinking, function is recursive to account for left,right,both or random eye changes
Eye choices/color determined by User's eye/color choice
eyeState determined by ViewController
 */
- (void) changeEyeState:(MLEyeState) eyeState forEye:(MLEyePlacement) eyeNumber{

	//determine a random eye if random eye is requested
	int randomSwitch = arc4random() % 2;
	//boolean to mark if change is requested for both eyes
	bool isRecursive = NO;

	ConscienceObjectView *conscienceEyeView;

	//Select the Eye to respond
	if (eyeNumber == MLEyePlacementLeft) {
		conscienceEyeView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:MLConscienceViewEyeLeftViewTag];
	
	} else if (eyeNumber == MLEyePlacementRight ) {
		conscienceEyeView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:MLConscienceViewEyeRightViewTag];

	} else if (eyeNumber == MLEyePlacementBoth) {
		//Both eyes have been requested.  Call left/right, cancel rest of function
		[self changeEyeState:eyeState forEye:MLEyePlacementLeft];
		[self changeEyeState:eyeState forEye:MLEyePlacementRight];
		isRecursive = YES;

	}else {
		//Random eye requested
		if (randomSwitch < 1) {
			[self changeEyeState:eyeState forEye:MLEyePlacementLeft];
		}else {
			[self changeEyeState:eyeState forEye:MLEyePlacementRight];
		}
		isRecursive = YES;
	}
	
	//IF both/random eyes have been requested, recursion is active, cancel work
	//Otherwise close/open the requested eye
	if (!isRecursive) {
		
		//Change the eyeState
		if (eyeState == MLEyeStateOpen) {

			//Ensure correct eye color is passed
			ConscienceLayer *currentLayer;
            
            if (eyeNumber == MLEyePlacementLeft) {
                currentLayer = (_currentConscienceBody.eyeLayers)[@"layerEyeballIrisLeft"];
			}else {
                currentLayer = (_currentConscienceBody.eyeLayers)[@"layerEyeballIrisRight"];
			}
            
			currentLayer.currentFillColor = _currentConscienceBody.eyeColor;
			
			(conscienceEyeView.totalLayers)[@"4layerEyeball"] = currentLayer;
			[conscienceEyeView setNeedsDisplay];
			
			(conscienceEyeView.totalLayers)[@"9layerLashes"] = (_currentConscienceBody.lashesLayers)[@"layerLashesUp"];
			[conscienceEyeView setNeedsDisplay];
		
		}else {
			//Close the eye
			(conscienceEyeView.totalLayers)[@"9layerLashes"] = (_currentConscienceBody.lashesLayers)[@"layerLashesDown"];
			[conscienceEyeView setNeedsDisplay];

		}
	}
		
}

/**
Implementation: Change Conscience look direction, function is recursive to account for left,right,both or random eye changes
Eye choices/color determined by User's eye/color choice
expressionIndex determined by ViewController
*/

- (void) changeEyeDirection:(MLExpressionLook)expressionIndex forEye:(MLEyePlacement) eyeNumber{

	//determine a random eye if random eye is requested
	int randomSwitch = arc4random() % 6;

	NSString *layerID = @"4layerEyeball";
	NSValue *val;
	//boolean to mark if change is requested for both eyes
	bool isRecursive = NO;

	ConscienceObjectView *conscienceEyeView;
	
	//Select the Eye to respond
	if (eyeNumber == MLEyePlacementLeft) {
		conscienceEyeView = conscienceEyeLeftView;
		val = eyeLeftPositions[expressionIndex];
	}else if (eyeNumber == MLEyePlacementRight ) {
		conscienceEyeView = conscienceEyeRightView;
		val = eyeRightPositions[expressionIndex];
	}else if (eyeNumber == MLEyePlacementBoth) {
		//Both eyes have been requested.  Call left/right, cancel rest of function
		[self changeEyeDirection:expressionIndex forEye:MLEyePlacementLeft];
		[self changeEyeDirection:expressionIndex forEye:MLEyePlacementRight];
		isRecursive = YES;
		
	}else {
		//Random eye requested
		if (randomSwitch < 1) {
			[self changeEyeDirection:expressionIndex forEye:MLEyePlacementLeft];
		}else {
			[self changeEyeDirection:expressionIndex forEye:MLEyePlacementRight];
		}
		isRecursive = YES;
	}
	
	//IF both/random eyes have been requested, recursion is active, cancel work
	//Otherwise change currentEyeball position
	if (!isRecursive) {
        
		CGPoint p = [val CGPointValue];
        ConscienceLayer *currentEyeball = (ConscienceLayer *)(conscienceEyeView.totalLayers)[layerID];
		[currentEyeball setOffsetX:p.x];
		[currentEyeball setOffsetY:p.y];
        
		[conscienceEyeView setNeedsDisplay];

	}
	
}

/**
Implementation: Display brows, function is recursive to account for left,right,both or random eye changes
Brow choices/color determined by User's eye/color choice
expression determined by Conscience Mood/Enthusiasm
*/
- (void) changeBrowExpressions:(NSString *) expression forEye:(MLEyePlacement) eyeNumber{

	//determine a random eye if random eye is requested
	int randomSwitch = arc4random() % 2;
	//boolean to mark if change is requested for both eyes
	bool isRecursive = NO;
	
	ConscienceObjectView *conscienceEyeView;
	
	//Select the Eye to respond
	if (eyeNumber == MLEyePlacementLeft) {
		conscienceEyeView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:MLConscienceViewEyeLeftViewTag];
		
	}else if (eyeNumber == MLEyePlacementRight ) {
		conscienceEyeView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:MLConscienceViewEyeRightViewTag];
		
	}else if (eyeNumber == MLEyePlacementBoth) {
		//Both eyes have been requested.  Call left/right, cancel rest of function
		[self changeBrowExpressions:expression forEye:MLEyePlacementLeft];
		[self changeBrowExpressions:expression forEye:MLEyePlacementRight];
		isRecursive = YES;
		
	}else {
		//Random eye requested
		if (randomSwitch < 1) {
			[self changeBrowExpressions:expression forEye:MLEyePlacementLeft];
		}else {
			[self changeBrowExpressions:expression forEye:MLEyePlacementRight];
		}
		isRecursive = YES;
	}
	
	//If both/random eyes have been requested, recursion is active, cancel work
	//Otherwise change lid layer
	if (!isRecursive) {
		//Ensure correct brow color is passed
		ConscienceLayer *currentLayer = (_currentConscienceBody.browLayers)[expression];
		currentLayer.currentFillColor = _currentConscienceBody.browColor;
		(conscienceEyeView.totalLayers)[@"2layerBrow"] = currentLayer;
		[conscienceEyeView setNeedsDisplay];
			
	}

}

/**
Implementation: Display eyelids, function is recursive to account for left,right,both or random eye changes
Lid choices determined by User's eye choice
expression determined by Conscience Mood/Enthusiasm
*/
- (void) changeLidExpressions:(NSString *) expression forEye:(MLEyePlacement) eyeNumber{
	//determine a random eye if random eye is requested
	int randomSwitch = arc4random() % 2;
	//boolean to mark if change is requested for both eyes
	bool isRecursive = NO;
	
	ConscienceObjectView *conscienceEyeView;
	
	//Select the Eye to respond
	if (eyeNumber == MLEyePlacementLeft) {
		conscienceEyeView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:MLConscienceViewEyeLeftViewTag];
		
	}else if (eyeNumber == MLEyePlacementRight ) {
		conscienceEyeView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:MLConscienceViewEyeRightViewTag];
		
	}else if (eyeNumber == MLEyePlacementBoth) {
		//Both eyes have been requested.  Call left/right, cancel rest of function
		[self changeLidExpressions:expression forEye:MLEyePlacementLeft];
		[self changeLidExpressions:expression forEye:MLEyePlacementRight];
		isRecursive = YES;
		
	}else {
		//Random eye requested
		if (randomSwitch < 1) {
			[self changeLidExpressions:expression forEye:MLEyePlacementLeft];
		}else {
			[self changeLidExpressions:expression forEye:MLEyePlacementRight];
		}
		isRecursive = YES;
	}
	
	
	//If both/random eyes have been requested, recursion is active, cancel work
	//Otherwise change lid layer
	if (!isRecursive) {
		(conscienceEyeView.totalLayers)[@"6layerLid"] = (_currentConscienceBody.lidLayers)[expression];
		[conscienceEyeView setNeedsDisplay];

	}
	
}

#pragma mark -
#pragma mark Mouth expression control


/**
Implementation: Display dimples.  Dimple choices determined by User's mouth choice
expression determined by Conscience Mood/Enthusiasm
*/
- (void) changeDimplesExpressions:(NSString *) expression{

	/** @todo determine proper memory management */	
	//Retrieve current Mouth
	ConscienceObjectView *conscienceNewMouthView;
	conscienceNewMouthView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:MLConscienceViewMouthViewTag];

	//Change Dimples Layer	
	(conscienceNewMouthView.totalLayers)[@"layerDimples"] = (_currentConscienceBody.dimplesLayers)[expression];
	
	//Request mouth update
	[conscienceNewMouthView setNeedsDisplay];
}

/**
Implementation: Display lips.  Lip choices determined by User's mouth choice
expression determined by Conscience Mood/Enthusiasm
*/
- (void) changeLipsExpressions:(NSString *) expression{
		
	/** @todo determine proper memory management */	
	//Retrieve current Mouth
	ConscienceObjectView *conscienceNewMouthView;
	conscienceNewMouthView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:MLConscienceViewMouthViewTag];

	//Change lips Layer	
	(conscienceNewMouthView.totalLayers)[@"layerLips"] = (_currentConscienceBody.lipsLayers)[expression];

	//Request mouth update
	[conscienceNewMouthView setNeedsDisplay];
}

/**
Implementation: Display teeth. Teeth choices determined by User's mouth choice
expression determined by Conscience Mood/Enthusiasm
*/

- (void) changeTeethExpressions:(NSString *) expression{

	/** @todo determine proper memory management */	
	//Retrieve current Mouth
	ConscienceObjectView *conscienceNewMouthView;
	conscienceNewMouthView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:MLConscienceViewMouthViewTag];
	
	//Change teeth Layer
	(conscienceNewMouthView.totalLayers)[@"layerTeeth"] = (_currentConscienceBody.teethLayers)[expression];
	
	//Request mouth update
	[conscienceNewMouthView setNeedsDisplay];
}

/**
Implementation: Display tongue.  Tongue choices determined by User's mouth choice
expression determined by Conscience Mood/Enthusiasm
*/

- (void) changeTongueExpressions:(NSString *) expression{
		
	/** @todo determine proper memory management */
	//Retrieve current Mouth
	ConscienceObjectView *conscienceNewMouthView;
	conscienceNewMouthView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:MLConscienceViewMouthViewTag];

	//Set Tongue Layer	
	(conscienceNewMouthView.totalLayers)[@"layerTongue"] = (_currentConscienceBody.tongueLayers)[expression];
	
	//Request mouth update
	[conscienceNewMouthView setNeedsDisplay];
}


/**
Implementation: Actual values to set for the bubble are populated in currentConscienceBody, currentConscienceMind
Color determined by User.  Animation determined by Conscience Mood/Enthusiasm
*/
- (void) changeBubble{

	//User is allowed selection of colors for Bubble
	animatedBubbleView = (ConscienceBubbleView *)[_conscienceBubbleView viewWithTag:MLConscienceViewAnimatedBubbleViewTag];
	animatedBubbleView.bubbleColor = _currentConscienceBody.bubbleColor;
	animatedBubbleView.bubbleType = _currentConscienceBody.bubbleType;

    //Glow duration is inverse of Conscience enthusiasm, enthusiastic = shorter duration
    CGFloat glowDuration = 1/(((_currentConscienceMind.enthusiasm*2)/100) + 1);
    animatedBubbleView.bubbleGlowDuration = glowDuration;

	//Request bubble update
	[animatedBubbleView setNeedsDisplay];
		
}

#pragma mark -
#pragma mark Conscience Changes

/**
Implementation: Determine Conscience direction facing.  Reverse Conscience if necessary.  Call function to make Conscience visisble.
 */
- (void)removeConscienceInvisibility{
	
	//Determine which way Conscience is facing
	if (_directionFacing == MLDirectionFacingLeft) {
		_directionFacing = MLDirectionFacingRight;
		self.transform = CGAffineTransformIdentity;
		self.transform = CGAffineTransformMakeScale(1.0, 1.0);		
	}else{
		_directionFacing = MLDirectionFacingLeft;
		self.transform = CGAffineTransformIdentity;
		self.transform = CGAffineTransformMakeScale(-1.0, 1.0);		
	}
	
	[self makeConscienceVisible];
}

/**
Implementation: Reset Conscience alpha.
 */
- (void)makeConscienceVisible{
	
	[UIView beginAnimations:@"visible" context:nil];
	[UIView setAnimationDuration:0.25];
	
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	self.alpha = 1;
	
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Timed Changes

/**
Implementation: Determine if Conscience is awake.  Set timers to change eye and lip expresssions.
 */
- (void) setTimers{
	
    //Put Conscience to sleep if enthusiasm is 0
    if (_currentConscienceMind.enthusiasm > 0) {

        //Restart Conscience movement after User has moved it
        [self timedEyeChanges];
        [self timedMouthExpressionChanges];        
        
        if(![mouthTimer isValid]){
            mouthTimer = [NSTimer scheduledTimerWithTimeInterval:MLExpressionInterval target:self selector:@selector(timedMouthExpressionChanges) userInfo:nil repeats:YES];
        }
        if(![eyeTimer isValid]){
            eyeTimer = [NSTimer scheduledTimerWithTimeInterval:MLBlinkInterval target:self selector:@selector(timedEyeChanges) userInfo:nil repeats:YES];
        }
        
    } else {
        [self changeEyeState:MLEyeStateClose forEye:MLEyePlacementBoth];
    }
	
}

/**
Implementation: Cancel timers handling mouth/eye expressions and any transient blinks.
 */
- (void) stopTimers {

    if(mouthTimer != nil){
        
        [mouthTimer invalidate];
        mouthTimer = nil;
    }
    
    if(blinkTimer != nil){
        
        [blinkTimer invalidate];
        blinkTimer = nil;
    }
    
    if(eyeTimer != nil){
        
        [eyeTimer invalidate];
        eyeTimer = nil;
    }
    
}

/**
Implementation: Determine which mouth expression to enable along with teeth, dimple and tongue selection
 */
- (void) timedMouthExpressionChanges{
	
    CGFloat conscienceMood = _currentConscienceMind.mood;
    CGFloat conscienceEnthusiasm = _currentConscienceMind.enthusiasm;

    int randomIndex = 16 * (conscienceMood/100);
    
    
    if (conscienceEnthusiasm > 50) {
        randomIndex += 1;
    } else {
        randomIndex -= 1;
    }
    
    randomIndex += arc4random() %2;
    
    if (randomIndex > 16) {
        randomIndex = 16;
    }
    
    if (randomIndex < 0) {
        randomIndex = 0;
    }
    
	int randomSwitch = arc4random() % 2;
	int randomTongueHappy = 3 + arc4random() % 3;
	int randomTongueSad = arc4random() % 3;
	int dimpleIndex = 1;
	int teethIndex = 2;
	int tongueIndex = 3;	
	
	if ((randomSwitch < 1) || _isExpressionForced) {

		[self changeLipsExpressions:lipsExpressions[randomIndex]];
	}

	_isExpressionForced = FALSE;
	
	if(randomSwitch < 1){
        
        switch(randomIndex){
			case 0:dimpleIndex = 0;teethIndex = 2;tongueIndex = 3;break;				
			case 1:dimpleIndex = 0;teethIndex = 0;tongueIndex = 3;break;
			case 2:dimpleIndex = 0;teethIndex = 1;tongueIndex = 3;break;                
			case 3:dimpleIndex = 0;teethIndex = 2;tongueIndex = 3;break;
			case 4:dimpleIndex = 0;teethIndex = 2;tongueIndex = randomTongueSad;break;
			case 5:dimpleIndex = 0;teethIndex = 2;tongueIndex = 3;break;
			case 6:dimpleIndex = 0;teethIndex = 2;tongueIndex = randomTongueSad;break;
			case 7:dimpleIndex = 1;teethIndex = 2;tongueIndex = 3;break;
			case 8:dimpleIndex = 1;teethIndex = 2;tongueIndex = 3;break;
			case 9:dimpleIndex = 1;teethIndex = 2;tongueIndex = 3;break;
			case 10:dimpleIndex = 2;teethIndex = 2;tongueIndex = 3;break;
			case 11:dimpleIndex = 2;teethIndex = 2;tongueIndex = randomTongueHappy;break;
			case 12:dimpleIndex = 2;teethIndex = 2;tongueIndex = randomTongueHappy;break;
            case 13:dimpleIndex = 2;teethIndex = 2;tongueIndex = 3;break;		  
			case 14:dimpleIndex = 2;teethIndex = 3;tongueIndex = 3;break;
			case 15:dimpleIndex = 2;teethIndex = 4;tongueIndex = 3;break;
            case 16:dimpleIndex = 2;teethIndex = 2;tongueIndex = 3;break;
			default:dimpleIndex = 1;teethIndex = 2;tongueIndex = 3;
                
        }
        
	}else{
		dimpleIndex = 1;
		teethIndex = 2;
		tongueIndex = 3;
		
	}
	
	[self changeDimplesExpressions:dimplesExpressions[dimpleIndex]];
	
    if (conscienceEnthusiasm > 40) {

        [self changeTeethExpressions:teethExpressions[teethIndex]];        
        [self changeTongueExpressions:tongueExpressions[tongueIndex]];
    
    }
    
}

- (void) timedEyeChanges{
	
	//Randomize blinks
	int randomSwitch = arc4random() % 3;
	//Random direction
	//5 removes cross-eyed and crazy
	int randomDirection = arc4random() % 6;

	//Generate int between 0 - 240;
	int randomInterval = arc4random() %100;
	//Generate random float range between 0.1 and 
	float blinkDuration = 0.1 + (float)randomInterval/100;
		    
    CGFloat conscienceEnthusiasm = _currentConscienceMind.enthusiasm;
    CGFloat conscienceMood = _currentConscienceMind.mood;

	if(conscienceMood < 0) {
	
		if(randomSwitch == 0) {
			randomDirection = 5;	
		} else if (randomSwitch ==1) {
			randomDirection = 6;	
		}
	}
    
	//Create Invocation in order to re-open eyes after random interval
	// get an Objective-C selector variable for the method
	SEL eyeTimerSelector = @selector(changeEyeState:forEye:);
	
	// create a singature from the selector
	NSMethodSignature *eyeTimerSignature = [[self class] instanceMethodSignatureForSelector:eyeTimerSelector];
	
	NSInvocation *eyeTimerInvocation = [NSInvocation invocationWithMethodSignature:eyeTimerSignature];
	[eyeTimerInvocation setTarget:self];
	[eyeTimerInvocation setSelector:eyeTimerSelector];
	
	int eyeState = MLEyeStateOpen;
    int eyeNumber = MLEyePlacementBoth;
    
    /** @bug fix winking */
//    //If Conscience is in a good mood, allow for winking
//    if (conscienceMood > 70) {
//        if ((arc4random() % 4) > 2) {
//            eyeNumber = MLEyeRandomIndex;
//            blinkDuration = 0.3;
//            randomDirection = 0;
//        }
//            
//    }	
    
    [eyeTimerInvocation setArgument:&eyeState atIndex:2];
	[eyeTimerInvocation setArgument:&eyeNumber atIndex:3];
	
	if (randomSwitch < 2)  {
		[self changeEyeState:MLEyeStateClose forEye:eyeNumber];
		blinkTimer = [NSTimer scheduledTimerWithTimeInterval:blinkDuration invocation:eyeTimerInvocation repeats:NO];
	}
    
    /** @todo lessen confused frequency */
    eyeNumber = MLEyePlacementBoth;
	
    if ((randomSwitch < 1) || _isExpressionForced){
        int randomBrow = 0; 

        if (conscienceEnthusiasm > 60) {
            if (conscienceMood > 50) {
                randomBrow = 3;
            }else {
                randomBrow = 1;
            }

        } else {
            randomBrow = 2;
            eyeNumber = MLEyePlacementRandom;
        }
		
		[self changeBrowExpressions:browExpressions[randomBrow] forEye:eyeNumber]; 
		
	} else {
        [self changeBrowExpressions:browExpressions[0] forEye:eyeNumber]; 

    }
    
    eyeNumber = MLEyePlacementBoth;
        
	if ((randomSwitch == 2) || _isExpressionForced) {
            
        int randomLid = 0;
        
        if (conscienceEnthusiasm > 70) {

            if ((arc4random() %3) > 1) {
                randomLid = 4;
            } else {
            
                if (conscienceMood <= 15) {
                    randomLid = 2;
                }
            }
            
        } else if (conscienceEnthusiasm > 30) {
            
            if (conscienceMood > 50) {
                randomLid = 0;
            }else {
                randomLid = 1;
            }
            
        } else {
            randomLid = 3;
        }
        		
        if (randomLid > 2) {
			
            if ((arc4random() %3) > 2) {

                eyeNumber = MLEyePlacementRandom;
            }
			
		}

		[self changeLidExpressions:lidExpressions[randomLid] forEye:eyeNumber];
		
	} else {
        [self changeLidExpressions:lidExpressions[0] forEye:eyeNumber];

    }
        	
	_isExpressionForced = FALSE;
	[self changeEyeDirection:randomDirection forEye:MLEyePlacementBoth];
	
}

- (void) changeEyeDirection{
	
	static int expressionIndex = 0;
	//int eyeIndex = MLEyeBothIndex;
	
	if (expressionIndex > 6) {
		expressionIndex = 0;
	}		
	
	
	[self changeEyeDirection:expressionIndex forEye:MLEyePlacementLeft];
	[self changeEyeDirection:expressionIndex forEye:MLEyePlacementRight];
	expressionIndex++;		
}

-(CAKeyframeAnimation *) shakeAnimation {
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];
	
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, CGRectGetMinX([self frame]), CGRectGetMinY([self frame]));
	int index;
	for (index = 0; index < numberOfShakes; ++index)
	{
		
		CGPathAddLineToPoint(shakePath, NULL, CGRectGetMidX([self frame]) - [self frame].size.width * vigourOfShake, CGRectGetMidY([self frame]) - [self frame].size.height * vigourOfShake);
		CGPathAddLineToPoint(shakePath, NULL, CGRectGetMidX([self frame]) + [self frame].size.width * vigourOfShake, CGRectGetMidY([self frame]) + [self frame].size.height * vigourOfShake);
		
	}
    
    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = durationOfShake;
    
    CGPathRelease(shakePath);
    return shakeAnimation;
}

#pragma mark -
#pragma mark Memory management

/**
Release init'ed objects, deallocate super.
*/
- (void)dealloc {
    
	[self stopTimers];

}


@end