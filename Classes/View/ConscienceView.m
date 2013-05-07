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

@interface ConscienceView () <ConscienceExpressionDelegate> {

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
	
    NSArray *eyeLeftPositions;
    NSArray *eyeRightPositions;    

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
        self.currentConscienceMind.delegate = self;

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

@end