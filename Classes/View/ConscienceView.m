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

int const kDirectionFacingLeft = 0;
int const kDirectionFacingRight = 1;
int const kConscienceLowerLeftX = 55;
int const kConscienceLowerLeftY = 440;
int const kConscienceHomeX = 105;
int const kConscienceHomeY = 225;
int const kConscienceOffscreenBottomX = 70;
int const kConscienceOffscreenBottomY = 605;
int const kConscienceAntagonistX = 90;
int const kConscienceAntagonistY = 45;
int const kConscienceAntagonistWidth = 165;
int const kConscienceAntagonistHeight = 165;
int const kConscienceViewTag = 3017;
int const kConscienceAntagonistViewTag = 3020;
float const kConscienceLargeSizeX = 1.25;
float const kConscienceLargeSizeY = 1.25;
float const kConscienceLargestSize = 2.25;

int const kMouthHeight = 32;
int const kMouthWidth = 50;
int const kSymbolHeight = 200;
int const kSymbolWidth = 200;
int const kTopBottomAccessoryHeight = 50;
int const kTopBottomAccessoryWidth = 162;
int const kEyeLeftIndex = 0;
int const kEyeRightIndex = 1;
int const kEyeBothIndex = 2;
int const kEyeRandomIndex = 3;
int const kEyeCloseIndex = 0;
int const kEyeOpenIndex = 1;
int const kExpressionInterval = 3;
float const kBlinkInterval = 2;

/**
 Tag Numbers for webViews in order to reference them
 */
typedef enum bodyViewTags{
	kEyeRightViewTag = 3000,
	kEyeLeftViewTag = 3001,
	kMouthWebViewTag = 3002,
	kSymbolWebViewTag = 3003,
	kBubbleImageViewTag = 3004,
	kPrimaryAccessoryViewTag = 3005,
	kSecondaryAccessoryViewTag = 3006,
	kTopAccessoryViewTag = 3007,
	kBottomAccessoryViewTag = 3008,
	kEyeLeftSleepImageViewTag = 3009,
	kEyeLeftBrowViewTag = 3010,
	kEyeRightBrowViewTag = 3011,
	kBubbleViewTag = 3012,
	kEyeLeftBagViewTag = 3013,
	kEyeRightBagViewTag = 3014,
	kSymbolViewTag = 3015,
	kMouthViewTag = 3016,
	kConscienceCustomizeViewTag = 3018,
	kAnimatedBubbleViewTag = 3019,
	kConscienceProtagonistViewTag = 3021,
	kChoiceCancelButtonTag = 3022,
	kChoiceMoralButtonTag = 3023
} bodyViewTags;

/**
 Possible expression states of Lips
 */
typedef enum expressionLipsEnum{
	kExpressionLipsSadShock,
	kExpressionLipsSadOpenAlt1,
	kExpressionLipsSadOpen,
	kExpressionLipsSadAlt1,
	kExpressionLipsSad,
	kExpressionLipsSadSmirk,
	kExpressionLipsSadSilly,
	kExpressionLipsNormal,
	kExpressionLipsHappySmirk,
	kExpressionLipsHappy,
	kExpressionLipsHappyAlt1,
	kExpressionLipsHappySilly,
	kExpressionLipsHappyOpen,
	kExpressionLipsHappyOpenAlt1,
	kExpressionLipsHappyShock
}expressionLipsEnum;

/**
 Possible expression states of Dimples
 */
typedef enum expressionDimplesEnum{
	kExpressionDimplesSad,
	kExpressionDimplesNormal,
	kExpressionDimplesHappy
}expressionDimplesEnum;

/**
 Possible expression states of Teeth
 */
typedef enum expressionTeethEnum{
	kExpressionTeethSadOpenAlt1,
	kExpressionTeethSadOpen,
	kExpressionTeethHappyOpen,
	kExpressionTeethHappyOpenAlt1
}expressionTeethEnum;

/**
 Possible expression states of Tongue
 */
typedef enum expressionTongueEnum{
	kExpressionTongueSadCenter,
	kExpressionTongueSadLeft,
	kExpressionTongueSadRight,
	kExpressionTongueHappyCenter,
	kExpressionTongueHappyLeft,
	kExpressionTongueHappyRight
}expressionTongueEnum;

/**
 Possible expression states of Brow
 */
typedef enum expressionBrowEnum{
	kExpressionBrowAngry,
	kExpressionBrowNormal,
	kExpressionBrowConfused,
	kExpressionBrowExcited
}expressionBrowEnum;

/**
 Possible expression states of Lashes
 */
typedef enum expressionLashesEnum{
	kExpressionLashesUp,
	kExpressionLashesDown
}expressionLashesEnum;

/**
 Possible expression states of Lid
 */
typedef enum expressionLidEnum{
	kExpressionLidAngry,
	kExpressionLidSleepy,
	kExpressionLidNormal,
	kExpressionLidUnder
}expressionLidEnum;


/**
 Possible look direction of Eye
 */
typedef enum expressionLookEnum{
	kExpressionLookCenter,
	kExpressionLookDown,
	kExpressionLookUp,
	kExpressionLookLeft,
	kExpressionLookRight,
	kExpressionLookCross,
	kExpressionLookCrazy
}expressionLookEnum;

/**
 Possible expression states of Bags
 */
typedef enum expressionBagsEnum{
	kExpressionBagsNormal,
	kExpressionBagsOld,
	kExpressionBagsOlder,
	kExpressionBagsOldest
}expressionBagsEnum;

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
		_directionFacing = kDirectionFacingLeft;
		self.contentMode = UIViewContentModeScaleAspectFit;
		self.multipleTouchEnabled = TRUE;
		self.backgroundColor = [UIColor clearColor];
        
		/** @todo change hardcoded x/y coordinates to constants */
		//Allocate actual Conscience features
		//set tag number for each view so they can be changed with reinitialization
		//configuration is done in setNeedsDisplay		
		_conscienceBubbleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
		_conscienceBubbleView.tag = kBubbleViewTag;
		_conscienceBubbleView.multipleTouchEnabled = TRUE;
        
		animatedBubbleView = [[ConscienceBubbleView alloc] initWithFrame:CGRectMake(0, 0, kSymbolWidth, kSymbolHeight)];
		animatedBubbleView.tag = kAnimatedBubbleViewTag;
		[_conscienceBubbleView insertSubview:animatedBubbleView atIndex:0];
		
		accessoryPrimaryView = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(160, 25, kSideAccessoryWidth, kSideAccessoryHeight)]; 
		accessoryPrimaryView.tag = kPrimaryAccessoryViewTag;
		
		[_conscienceBubbleView addSubview:accessoryPrimaryView];
		
		accessorySecondaryView = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(-20, 25, kSideAccessoryWidth, kSideAccessoryHeight)]; 
		accessorySecondaryView.tag = kSecondaryAccessoryViewTag;
		[_conscienceBubbleView addSubview:accessorySecondaryView];
		
		accessoryTopView = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(12, -10, kTopBottomAccessoryWidth, kTopBottomAccessoryHeight)]; 
		accessoryTopView.tag = kTopAccessoryViewTag;		
		[_conscienceBubbleView addSubview:accessoryTopView];
		
		accessoryBottomView = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(20, 165, kTopBottomAccessoryWidth, kTopBottomAccessoryHeight)]; 
		accessoryBottomView.tag = kBottomAccessoryViewTag;		
		[_conscienceBubbleView addSubview:accessoryBottomView];
		
		conscienceEyeRightView = [[ConscienceObjectView alloc] initWithFrame:CGRectMake(0, 0, kEyeWidth, kEyeHeight)];
		conscienceEyeRightView.tag = kEyeRightViewTag;
		[_conscienceBubbleView addSubview:conscienceEyeRightView];
		
		conscienceEyeLeftView = [[ConscienceObjectView alloc] initWithFrame:CGRectMake(kEyeWidth, 0, kEyeWidth, kEyeHeight)];
		conscienceEyeLeftView.tag = kEyeLeftViewTag;
		conscienceEyeLeftView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
		[_conscienceBubbleView addSubview:conscienceEyeLeftView];
        
		conscienceMouthView = [[ConscienceObjectView alloc] initWithFrame:CGRectMake(kEyeWidth, 0, kMouthWidth, kMouthHeight)];
		conscienceMouthView.tag = kMouthViewTag;
		[_conscienceBubbleView addSubview:conscienceMouthView];
		
		conscienceSymbolView = [[ConscienceObjectView alloc] initWithFrame:CGRectMake(0, 0, kSymbolWidth, kSymbolHeight)];
		conscienceSymbolView.tag = kSymbolViewTag;
        
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
	accessoryPrimaryView = (AccessoryObjectView *)[_conscienceBubbleView viewWithTag:kPrimaryAccessoryViewTag];
	accessoryPrimaryView.accessoryFilename = _currentConscienceAccessories.primaryAccessory;
    
	[accessoryPrimaryView setNeedsDisplay];
	
	accessorySecondaryView = (AccessoryObjectView *)[_conscienceBubbleView viewWithTag:kSecondaryAccessoryViewTag];
	accessorySecondaryView.accessoryFilename = _currentConscienceAccessories.secondaryAccessory;
	[accessorySecondaryView setNeedsDisplay];
	
	accessoryTopView = (AccessoryObjectView *)[_conscienceBubbleView viewWithTag:kTopAccessoryViewTag];
	accessoryTopView.accessoryFilename = _currentConscienceAccessories.topAccessory;
	[accessoryTopView setNeedsDisplay];
	
	accessoryBottomView = (AccessoryObjectView *)[_conscienceBubbleView viewWithTag:kBottomAccessoryViewTag];
	accessoryBottomView.accessoryFilename = _currentConscienceAccessories.bottomAccessory;
	[accessoryBottomView setNeedsDisplay];
	
	animatedBubbleView = (ConscienceBubbleView *) [_conscienceBubbleView viewWithTag:kAnimatedBubbleViewTag];
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
- (void) changeEyeState:(int) eyeState forEye:(int) eyeNumber{

	//determine a random eye if random eye is requested
	int randomSwitch = arc4random() % 2;
	//boolean to mark if change is requested for both eyes
	bool isRecursive = NO;

	ConscienceObjectView *conscienceEyeView;

	//Select the Eye to respond
	if (eyeNumber == kEyeLeftIndex) {
		conscienceEyeView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:kEyeLeftViewTag];
	
	} else if (eyeNumber == kEyeRightIndex ) {
		conscienceEyeView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:kEyeRightViewTag];

	} else if (eyeNumber == kEyeBothIndex) {
		//Both eyes have been requested.  Call left/right, cancel rest of function
		[self changeEyeState:eyeState forEye:kEyeLeftIndex];
		[self changeEyeState:eyeState forEye:kEyeRightIndex];
		isRecursive = YES;

	}else {
		//Random eye requested
		if (randomSwitch < 1) {
			[self changeEyeState:eyeState forEye:kEyeLeftIndex];
		}else {
			[self changeEyeState:eyeState forEye:kEyeRightIndex];
		}
		isRecursive = YES;
	}
	
	//IF both/random eyes have been requested, recursion is active, cancel work
	//Otherwise close/open the requested eye
	if (!isRecursive) {
		
		//Change the eyeState
		if (eyeState == kEyeOpenIndex) {

			//Ensure correct eye color is passed
			ConscienceLayer *currentLayer;
            
            if (eyeNumber == kEyeLeftIndex) {
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

- (void) changeEyeDirection:(int)expressionIndex forEye:(int) eyeNumber{

    //Ensure valid expression Index
    if ((expressionIndex > 6) || (expressionIndex < 0)) {
        expressionIndex = 0;
    }
    
	//determine a random eye if random eye is requested
	int randomSwitch = arc4random() % 6;

	NSString *layerID = @"4layerEyeball";
	NSValue *val;
	//boolean to mark if change is requested for both eyes
	bool isRecursive = NO;

	ConscienceObjectView *conscienceEyeView;
	
	//Select the Eye to respond
	if (eyeNumber == kEyeLeftIndex) {
		conscienceEyeView = conscienceEyeLeftView;
		val = eyeLeftPositions[expressionIndex];
	}else if (eyeNumber == kEyeRightIndex ) {
		conscienceEyeView = conscienceEyeRightView;
		val = eyeRightPositions[expressionIndex];
	}else if (eyeNumber == kEyeBothIndex) {
		//Both eyes have been requested.  Call left/right, cancel rest of function
		[self changeEyeDirection:expressionIndex forEye:kEyeLeftIndex];
		[self changeEyeDirection:expressionIndex forEye:kEyeRightIndex];
		isRecursive = YES;
		
	}else {
		//Random eye requested
		if (randomSwitch < 1) {
			[self changeEyeDirection:expressionIndex forEye:kEyeLeftIndex];
		}else {
			[self changeEyeDirection:expressionIndex forEye:kEyeRightIndex];
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
- (void) changeBrowExpressions:(NSString *) expression forEye:(int) eyeNumber{

	//determine a random eye if random eye is requested
	int randomSwitch = arc4random() % 2;
	//boolean to mark if change is requested for both eyes
	bool isRecursive = NO;
	
	ConscienceObjectView *conscienceEyeView;
	
	//Select the Eye to respond
	if (eyeNumber == kEyeLeftIndex) {
		conscienceEyeView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:kEyeLeftViewTag];
		
	}else if (eyeNumber == kEyeRightIndex ) {
		conscienceEyeView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:kEyeRightViewTag];
		
	}else if (eyeNumber == kEyeBothIndex) {
		//Both eyes have been requested.  Call left/right, cancel rest of function
		[self changeBrowExpressions:expression forEye:kEyeLeftIndex];
		[self changeBrowExpressions:expression forEye:kEyeRightIndex];
		isRecursive = YES;
		
	}else {
		//Random eye requested
		if (randomSwitch < 1) {
			[self changeBrowExpressions:expression forEye:kEyeLeftIndex];
		}else {
			[self changeBrowExpressions:expression forEye:kEyeRightIndex];
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
- (void) changeLidExpressions:(NSString *) expression forEye:(int) eyeNumber{
	//determine a random eye if random eye is requested
	int randomSwitch = arc4random() % 2;
	//boolean to mark if change is requested for both eyes
	bool isRecursive = NO;
	
	ConscienceObjectView *conscienceEyeView;
	
	//Select the Eye to respond
	if (eyeNumber == kEyeLeftIndex) {
		conscienceEyeView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:kEyeLeftViewTag];
		
	}else if (eyeNumber == kEyeRightIndex ) {
		conscienceEyeView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:kEyeRightViewTag];
		
	}else if (eyeNumber == kEyeBothIndex) {
		//Both eyes have been requested.  Call left/right, cancel rest of function
		[self changeLidExpressions:expression forEye:kEyeLeftIndex];
		[self changeLidExpressions:expression forEye:kEyeRightIndex];
		isRecursive = YES;
		
	}else {
		//Random eye requested
		if (randomSwitch < 1) {
			[self changeLidExpressions:expression forEye:kEyeLeftIndex];
		}else {
			[self changeLidExpressions:expression forEye:kEyeRightIndex];
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
	conscienceNewMouthView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:kMouthViewTag];

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
	conscienceNewMouthView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:kMouthViewTag];

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
	conscienceNewMouthView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:kMouthViewTag];
	
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
	conscienceNewMouthView = (ConscienceObjectView *)[_conscienceBubbleView viewWithTag:kMouthViewTag];

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
	animatedBubbleView = (ConscienceBubbleView *)[_conscienceBubbleView viewWithTag:kAnimatedBubbleViewTag];
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
	if (_directionFacing == kDirectionFacingLeft) {
		_directionFacing = kDirectionFacingRight;
		self.transform = CGAffineTransformIdentity;
		self.transform = CGAffineTransformMakeScale(1.0, 1.0);		
	}else{
		_directionFacing = kDirectionFacingLeft;
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
            mouthTimer = [NSTimer scheduledTimerWithTimeInterval:kExpressionInterval target:self selector:@selector(timedMouthExpressionChanges) userInfo:nil repeats:YES];
        }
        if(![eyeTimer isValid]){
            eyeTimer = [NSTimer scheduledTimerWithTimeInterval:kBlinkInterval target:self selector:@selector(timedEyeChanges) userInfo:nil repeats:YES];
        }
        
    } else {
        [self changeEyeState:kEyeCloseIndex forEye:kEyeBothIndex];
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
	
	int eyeState = kEyeOpenIndex;
    int eyeNumber = kEyeBothIndex;
    
    /** @bug fix winking */
//    //If Conscience is in a good mood, allow for winking
//    if (conscienceMood > 70) {
//        if ((arc4random() % 4) > 2) {
//            eyeNumber = kEyeRandomIndex;
//            blinkDuration = 0.3;
//            randomDirection = 0;
//        }
//            
//    }	
    
    [eyeTimerInvocation setArgument:&eyeState atIndex:2];
	[eyeTimerInvocation setArgument:&eyeNumber atIndex:3];
	
	if (randomSwitch < 2)  {
		[self changeEyeState:kEyeCloseIndex forEye:eyeNumber];
		blinkTimer = [NSTimer scheduledTimerWithTimeInterval:blinkDuration invocation:eyeTimerInvocation repeats:NO];
	}
    
    /** @todo lessen confused frequency */
    eyeNumber = kEyeBothIndex;
	
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
            eyeNumber = kEyeRandomIndex;
        }
		
		[self changeBrowExpressions:browExpressions[randomBrow] forEye:eyeNumber]; 
		
	} else {
        [self changeBrowExpressions:browExpressions[0] forEye:eyeNumber]; 

    }
    
    eyeNumber = kEyeBothIndex;
        
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

                eyeNumber = kEyeRandomIndex;
            }
			
		}

		[self changeLidExpressions:lidExpressions[randomLid] forEye:eyeNumber];
		
	} else {
        [self changeLidExpressions:lidExpressions[0] forEye:eyeNumber];

    }
        	
	_isExpressionForced = FALSE;
	[self changeEyeDirection:randomDirection forEye:kEyeBothIndex];
	
}

- (void) changeEyeDirection{
	
	static int expressionIndex = 0;
	//int eyeIndex = kEyeBothIndex;
	
	if (expressionIndex > 6) {
		expressionIndex = 0;
	}		
	
	
	[self changeEyeDirection:expressionIndex forEye:kEyeLeftIndex];
	[self changeEyeDirection:expressionIndex forEye:kEyeRightIndex];
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