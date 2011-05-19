/**
Implementation:  ConcienceView can display the User's Conscience or a Antagonist's Conscience.
User's Conscience is customizable by the User and populated by userConscienceBody and userConscienceMind.  
Antagonist Conscience is determined by System and assigned to currentConscienceBody and currentConscienceMind.  
Actual facial changes are requested by ViewController.  

@class ConscienceView ConscienceView.h
 */

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

@implementation ConscienceView

@synthesize currentConscienceBody;
@synthesize currentConscienceAccessories;
@synthesize currentConscienceMind;
@synthesize conscienceBubbleView;
@synthesize directionFacing;
@synthesize isExpressionForced;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithFrame:(CGRect)frame withBody:(ConscienceBody *) argBody withAccessories:(ConscienceAccessories *) argAccessories
withMind: (ConscienceMind *) argMind{

	[self setCurrentConscienceBody:argBody];
	[self setCurrentConscienceAccessories:argAccessories];
	[self setCurrentConscienceMind:argMind];

	[self initWithFrame:frame];
	
	return self;
	
}

/**
Implementation: Actual values to set for the Conscience are populated in currentConscienceBody, currentConscienceMind
Color is chosen by User
Animation is dictated by Conscience Mood/Enthusiasm
@see ConscienceView::setNeedsDisplay
*/
- (id)initWithFrame:(CGRect)frame {

    if ((self = [super initWithFrame:frame])) {

		appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
        
		//Setup initial views
		directionFacing = kDirectionFacingLeft;
		self.contentMode = UIViewContentModeScaleAspectFit;
		self.multipleTouchEnabled = TRUE;
		self.backgroundColor = [UIColor clearColor];

		/** @todo change hardcoded x/y coordinates to constants */
		//Allocate actual Conscience features
		//set tag number for each view so they can be changed with reinitialization
		//configuration is done in setNeedsDisplay		
		conscienceBubbleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
		conscienceBubbleView.tag = kBubbleViewTag;
		conscienceBubbleView.multipleTouchEnabled = TRUE;

		animatedBubbleView = [[ConscienceBubbleView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
		animatedBubbleView.tag = kAnimatedBubbleViewTag;
		[conscienceBubbleView insertSubview:animatedBubbleView atIndex:0];
		[animatedBubbleView release];		
		
		accessoryPrimaryView = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(160, 25, kSideAccessoryWidth, kSideAccessoryHeight)]; 
		accessoryPrimaryView.tag = kPrimaryAccessoryViewTag;
		
		[conscienceBubbleView addSubview:accessoryPrimaryView];
		[accessoryPrimaryView release];
		
		accessorySecondaryView = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(-20, 25, kSideAccessoryWidth, kSideAccessoryHeight)]; 
		accessorySecondaryView.tag = kSecondaryAccessoryViewTag;
		[conscienceBubbleView addSubview:accessorySecondaryView];
		[accessorySecondaryView release];
		
		accessoryTopView = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(12, -10, kTopBottomAccessoryWidth, kTopBottomAccessoryHeight)]; 
		accessoryTopView.tag = kTopAccessoryViewTag;		
		[conscienceBubbleView addSubview:accessoryTopView];
		[accessoryTopView release];
		
		accessoryBottomView = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(20, 165, kTopBottomAccessoryWidth, kTopBottomAccessoryHeight)]; 
		accessoryBottomView.tag = kBottomAccessoryViewTag;		
		[conscienceBubbleView addSubview:accessoryBottomView];
		[accessoryBottomView release];		
		
		conscienceEyeRightView = [[ConscienceObjectView alloc] initWithFrame:CGRectMake(0, 0, kEyeWidth, kEyeHeight)];
		conscienceEyeRightView.tag = kEyeRightViewTag;
		[conscienceBubbleView addSubview:conscienceEyeRightView];
		[conscienceEyeRightView release];
		
		conscienceEyeLeftView = [[ConscienceObjectView alloc] initWithFrame:CGRectMake(kEyeWidth, 0, kEyeWidth, kEyeHeight)];
		conscienceEyeLeftView.tag = kEyeLeftViewTag;
		conscienceEyeLeftView.transform = CGAffineTransformIdentity;
		conscienceEyeLeftView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
		[conscienceBubbleView addSubview:conscienceEyeLeftView];
		[conscienceEyeLeftView release];		
	
		conscienceMouthView = [[ConscienceObjectView alloc] initWithFrame:CGRectMake(kEyeWidth, 0, kMouthWidth, kMouthHeight)];
		conscienceMouthView.tag = kMouthViewTag;
		[conscienceBubbleView addSubview:conscienceMouthView];
		[conscienceMouthView release];	
		
		conscienceSymbolView = [[ConscienceObjectView alloc] initWithFrame:CGRectMake(0, 0, kSymbolWidth, kSymbolHeight)];
		conscienceSymbolView.tag = kSymbolViewTag;

		[conscienceBubbleView addSubview:conscienceSymbolView];
		[conscienceSymbolView release];

		
		[self addSubview: conscienceBubbleView];
		
		[conscienceBubbleView release];
		

	}
    return self;
}

/**
Must override setNeedsDisplay because Conscience can be altered by User at any time.
Views are called by tags which are set in initWithFrame by constants
Symbol/Eye/Mouth/Accessories choices/color determined by User's symbol/eye/mouth/accessories color/choice.
currentConscienceBody is either userConscienceBody, or antagonistConscienceBody set by ViewController
@see ConscienceView#initWithFrame
*/
-(void) setNeedsDisplay{

	//Ensure correct bubble color/animation is set	
	[self changeBubble];	

	//Set Eye layer, Eye is actually composed of separate layers to allow for animation
	//insertLayer is needed to modify iris/brow colors
	//currentConscienceBody layers are pulled for each eye feature
	//then set into view in specific order to account for layer draw order
	//order is determined by leading number in setObject:forKey:
	ConscienceLayer *insertLayer = [currentConscienceBody.eyeLayers objectForKey:@"layerEyeballIrisLeft"];
	insertLayer.currentFillColor = currentConscienceBody.eyeColor;

	[conscienceEyeLeftView.totalLayers setObject:insertLayer forKey:@"4layerEyeball"];
	insertLayer = [currentConscienceBody.browLayers objectForKey:@"layerBrowNormal"];
	insertLayer.currentFillColor = currentConscienceBody.browColor;

	[conscienceEyeLeftView.totalLayers setObject:insertLayer forKey:@"2layerBrow"];
	
	//Rest of Eye layers are without color
	[conscienceEyeLeftView.totalLayers setObject:[currentConscienceBody.lidLayers objectForKey:@"layerLidNormal"] forKey:@"6layerLid"];
	[conscienceEyeLeftView.totalLayers setObject:[currentConscienceBody.socketLayers objectForKey:@"layerSocketBottom"] forKey:@"5layerSocketBottom"];
	[conscienceEyeLeftView.totalLayers setObject:[currentConscienceBody.socketLayers objectForKey:@"layerSocketTop"] forKey:@"7layerSocketTop"];
	[conscienceEyeLeftView.totalLayers setObject:[currentConscienceBody.lashesLayers objectForKey:@"layerLashesUp"] forKey:@"9layerLashes"];
    
	NSMutableString *ageLayer = [[NSMutableString alloc] initWithString:@"layerBags"];
    
	switch (currentConscienceBody.age) {
		case 0: [ageLayer appendString:@"Normal"]; break;
		case 1: [ageLayer appendString:@"Old"]; break;            
		case 2: [ageLayer appendString:@"Older"]; break;            
		case 3: [ageLayer appendString:@"Oldest"]; break;            
		default: [ageLayer appendString:@"Normal"]; break;
	}
    
	[conscienceEyeLeftView.totalLayers setObject:[currentConscienceBody.bagsLayers objectForKey:ageLayer] forKey:@"3layerBags"];
	[conscienceEyeLeftView.totalGradients addEntriesFromDictionary:currentConscienceBody.gradientLayers];
	
	//Request ConscienceObject view update
	[conscienceEyeLeftView setNeedsDisplay];
	
	//Repeat work for right eye
	//Both cannot be done simultaneously to account for expression differences between eyes
	//such as wink/blink, raise eyebrow, one lid, etc.
	insertLayer = [currentConscienceBody.eyeLayers objectForKey:@"layerEyeballIrisRight"];
	insertLayer.currentFillColor = currentConscienceBody.eyeColor;
	[conscienceEyeRightView.totalLayers setObject:insertLayer forKey:@"4layerEyeball"];
	insertLayer = [currentConscienceBody.browLayers objectForKey:@"layerBrowNormal"];
	insertLayer.currentFillColor = currentConscienceBody.browColor;

	[conscienceEyeRightView.totalLayers setObject:insertLayer forKey:@"2layerBrow"];
    
	[conscienceEyeRightView.totalLayers setObject:[currentConscienceBody.lidLayers objectForKey:@"layerLidNormal"] forKey:@"6layerLid"];	
	[conscienceEyeRightView.totalLayers setObject:[currentConscienceBody.socketLayers objectForKey:@"layerSocketBottom"] forKey:@"5layerSocketBottom"];
	[conscienceEyeRightView.totalLayers setObject:[currentConscienceBody.socketLayers objectForKey:@"layerSocketTop"] forKey:@"7layerSocketTop"];
	[conscienceEyeRightView.totalLayers setObject:[currentConscienceBody.lashesLayers objectForKey:@"layerLashesUp"] forKey:@"9layerLashes"];
	[conscienceEyeRightView.totalLayers setObject:[currentConscienceBody.bagsLayers objectForKey:ageLayer] forKey:@"3layerBags"];
	[ageLayer release];

	[conscienceEyeRightView.totalGradients addEntriesFromDictionary:currentConscienceBody.gradientLayers];
	[conscienceEyeRightView setNeedsDisplay];	
	
	//Set Symbol layer, Symbol is actually composed of a single layer for the graphic
	//Position layer is included to set the positioning of the eyes/mouth for each symbol
	[conscienceSymbolView.totalLayers setObject:[currentConscienceBody.symbolLayers objectForKey:@"layerSymbol"] forKey:@"layerSymbol"];
	[conscienceSymbolView setNeedsDisplay];

	//Set Mouth layer, Mouth is actually composed of separate layers to allow for animation
	[conscienceMouthView.totalLayers setObject:[currentConscienceBody.dimplesLayers objectForKey:@"layerDimplesHappy"] forKey:@"layerDimples"];
	[conscienceMouthView.totalLayers setObject:[currentConscienceBody.lipsLayers objectForKey:@"layerLipsNormal"] forKey:@"layerLips"];				
	[conscienceMouthView.totalLayers setObject:[currentConscienceBody.teethLayers objectForKey:@"layerTeethNormal"] forKey:@"layerTeeth"];
	[conscienceMouthView.totalLayers setObject:[currentConscienceBody.tongueLayers objectForKey:@"layerTongueNormal"] forKey:@"layerTongue"];
	[conscienceMouthView.totalGradients addEntriesFromDictionary:currentConscienceBody.gradientLayers];

	//Positioning of Eyes/Mouth/Symbol actually housed in symbol SVG file
	//Position is a single path in SVG where each point represents a facial feature location		
	ConscienceLayer *positionLayer = (ConscienceLayer *)[currentConscienceBody.symbolLayers objectForKey:@"layerPosition"];
	ConsciencePath *positionPath = (ConsciencePath *)[[positionLayer consciencePaths] objectAtIndex:0];
	
	CGPoint p = CGPointMake([[positionPath.pathPoints objectAtIndex:0] floatValue], [[positionPath.pathPoints objectAtIndex:1] floatValue]);
	conscienceEyeRightView.center = p;
	p = CGPointMake([[positionPath.pathPoints objectAtIndex:2] floatValue], [[positionPath.pathPoints objectAtIndex:3] floatValue]);
	conscienceEyeLeftView.center = p;		
	p = CGPointMake([[positionPath.pathPoints objectAtIndex:4] floatValue], [[positionPath.pathPoints objectAtIndex:5] floatValue]);
	conscienceMouthView.center = p;
		
	//Display accessories chosen by User or System for Antagonists
	accessoryPrimaryView = (AccessoryObjectView *)[conscienceBubbleView viewWithTag:kPrimaryAccessoryViewTag];
	accessoryPrimaryView.accessoryFilename = currentConscienceAccessories.primaryAccessory;

	[accessoryPrimaryView setNeedsDisplay];
	
	accessorySecondaryView = (AccessoryObjectView *)[conscienceBubbleView viewWithTag:kSecondaryAccessoryViewTag];
	accessorySecondaryView.accessoryFilename = currentConscienceAccessories.secondaryAccessory;
	[accessorySecondaryView setNeedsDisplay];
	
	accessoryTopView = (AccessoryObjectView *)[conscienceBubbleView viewWithTag:kTopAccessoryViewTag];
	accessoryTopView.accessoryFilename = currentConscienceAccessories.topAccessory;
	[accessoryTopView setNeedsDisplay];
	
	accessoryBottomView = (AccessoryObjectView *)[conscienceBubbleView viewWithTag:kBottomAccessoryViewTag];
	accessoryBottomView.accessoryFilename = currentConscienceAccessories.bottomAccessory;
	[accessoryBottomView setNeedsDisplay];
	
	animatedBubbleView = (ConscienceBubbleView *) [conscienceBubbleView viewWithTag:kAnimatedBubbleViewTag];
	[animatedBubbleView setNeedsDisplay];	

	isExpressionForced = FALSE;

	[self setTimers];
	
	[super setNeedsDisplay];

}


#pragma mark -
#pragma mark Eye expression control

/** 
Change Eye state for winking/blinking, function is recursive to account for left,right,both or random eye changes
Eye choices/color determined by User's eye/color choice
eyeState determined by ViewController
 
@see ConscienceBody
*/
- (void) changeEyeState:(int) eyeState forEye:(int) eyeNumber{

	//determine a random eye if random eye is requested
	int randomSwitch = arc4random() % 2;
	//boolean to mark if change is requested for both eyes
	bool isRecursive = NO;

	ConscienceObjectView *conscienceEyeView;

	//Select the Eye to respond
	if (eyeNumber == kEyeLeftIndex) {
		conscienceEyeView = (ConscienceObjectView *)[conscienceBubbleView viewWithTag:kEyeLeftViewTag];
	
	} else if (eyeNumber == kEyeRightIndex ) {
		conscienceEyeView = (ConscienceObjectView *)[conscienceBubbleView viewWithTag:kEyeRightViewTag];

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
                currentLayer = [currentConscienceBody.eyeLayers objectForKey:@"layerEyeballIrisLeft"];
			}else {
                currentLayer = [currentConscienceBody.eyeLayers objectForKey:@"layerEyeballIrisRight"];
			}
            
			currentLayer.currentFillColor = currentConscienceBody.eyeColor;
			
			[conscienceEyeView.totalLayers setObject:currentLayer forKey:@"4layerEyeball"];
			[conscienceEyeView setNeedsDisplay];
			
			[conscienceEyeView.totalLayers setObject:[currentConscienceBody.lashesLayers objectForKey:@"layerLashesUp"] forKey:@"9layerLashes"];
			[conscienceEyeView setNeedsDisplay];
		
		}else {
			//Close the eye
			[conscienceEyeView.totalLayers setObject:[currentConscienceBody.lashesLayers objectForKey:@"layerLashesDown"] forKey:@"9layerLashes"];
			[conscienceEyeView setNeedsDisplay];

		}
	}
		
}

/**
Change Conscience look direction, function is recursive to account for left,right,both or random eye changes
Eye choices/color determined by User's eye/color choice
expressionIndex determined by ViewController
@see ConscienceBody
*/

- (void) changeEyeDirection:(int)expressionIndex forEye:(int) eyeNumber{

    //Ensure valid expression Index
    if ((expressionIndex > 6) || (expressionIndex < 0)) {
        expressionIndex = 0;
    }
    
	//determine a random eye if random eye is requested
	int randomSwitch = arc4random() % 6;

	NSString *layerID = [NSString stringWithString:@"4layerEyeball"];
	NSValue *val;
	//boolean to mark if change is requested for both eyes
	bool isRecursive = NO;

	ConscienceObjectView *conscienceEyeView;

	//Conscience Look direction determined by layeroffset
	//Array of pixel offsets by X/Y coordinates utilized for every eyetype
	//Values are look: center, up, down, left, right, cross, crazy
	NSArray *eyeLeftPositions = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0, 0)],
									 [NSValue valueWithCGPoint:CGPointMake(0, -2)], 
									 [NSValue valueWithCGPoint:CGPointMake(0, 3)],
									 [NSValue valueWithCGPoint:CGPointMake(-2, 1)],	
									 [NSValue valueWithCGPoint:CGPointMake(3, 0)],
									 [NSValue valueWithCGPoint:CGPointMake(4, 1)],
									 [NSValue valueWithCGPoint:CGPointMake(4, -2)], nil];

	NSArray *eyeRightPositions = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0, 0)],
									  [NSValue valueWithCGPoint:CGPointMake(0, -2)], 
									  [NSValue valueWithCGPoint:CGPointMake(0, 3)],
									  [NSValue valueWithCGPoint:CGPointMake(3, 1)],
									  [NSValue valueWithCGPoint:CGPointMake(-3, -1)],
									  [NSValue valueWithCGPoint:CGPointMake(4, 1)],
								  [NSValue valueWithCGPoint:CGPointMake(-1, 4)], nil];
	
	//Select the Eye to respond
	if (eyeNumber == kEyeLeftIndex) {
		conscienceEyeView = conscienceEyeLeftView;
		val = [eyeLeftPositions objectAtIndex:expressionIndex];
	}else if (eyeNumber == kEyeRightIndex ) {
		conscienceEyeView = conscienceEyeRightView;
		val = [eyeRightPositions objectAtIndex:expressionIndex];
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
        ConscienceLayer *currentEyeball = (ConscienceLayer *)[conscienceEyeView.totalLayers objectForKey:layerID];
		[currentEyeball setOffsetX:p.x];
		[currentEyeball setOffsetY:p.y];
        
		[conscienceEyeView setNeedsDisplay];

	}
	
}

/**
Display brows, function is recursive to account for left,right,both or random eye changes
Brow choices/color determined by User's eye/color choice
expression determined by Conscience Mood/Enthusiasm
@see ConscienceBody
@see ConscienceMind
*/
- (void) changeBrowExpressions:(NSString *) expression forEye:(int) eyeNumber{

	//determine a random eye if random eye is requested
	int randomSwitch = arc4random() % 2;
	//boolean to mark if change is requested for both eyes
	bool isRecursive = NO;
	
	ConscienceObjectView *conscienceEyeView;
	
	//Select the Eye to respond
	if (eyeNumber == kEyeLeftIndex) {
		conscienceEyeView = (ConscienceObjectView *)[conscienceBubbleView viewWithTag:kEyeLeftViewTag];
		
	}else if (eyeNumber == kEyeRightIndex ) {
		conscienceEyeView = (ConscienceObjectView *)[conscienceBubbleView viewWithTag:kEyeRightViewTag];
		
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
		ConscienceLayer *currentLayer = [currentConscienceBody.browLayers objectForKey:expression];
		currentLayer.currentFillColor = currentConscienceBody.browColor;			
		[conscienceEyeView.totalLayers setObject:currentLayer forKey:@"2layerBrow"];
		[conscienceEyeView setNeedsDisplay];
			
	}

}

/**
Display eyelids, function is recursive to account for left,right,both or random eye changes
Lid choices determined by User's eye choice
expression determined by Conscience Mood/Enthusiasm
@see ConscienceBody
@see ConscienceMind
*/
- (void) changeLidExpressions:(NSString *) expression forEye:(int) eyeNumber{
	//determine a random eye if random eye is requested
	int randomSwitch = arc4random() % 2;
	//boolean to mark if change is requested for both eyes
	bool isRecursive = NO;
	
	ConscienceObjectView *conscienceEyeView;
	
	//Select the Eye to respond
	if (eyeNumber == kEyeLeftIndex) {
		conscienceEyeView = (ConscienceObjectView *)[conscienceBubbleView viewWithTag:kEyeLeftViewTag];
		
	}else if (eyeNumber == kEyeRightIndex ) {
		conscienceEyeView = (ConscienceObjectView *)[conscienceBubbleView viewWithTag:kEyeRightViewTag];
		
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
		[conscienceEyeView.totalLayers setObject:[currentConscienceBody.lidLayers objectForKey:expression] forKey:@"6layerLid"];
		[conscienceEyeView setNeedsDisplay];

	}
	
}

#pragma mark -
#pragma mark Mouth expression control


/**
Display dimples
Dimple choices determined by User's mouth choice
expression determined by Conscience Mood/Enthusiasm
@see ConscienceBody
@see ConscienceMind
*/

- (void) changeDimplesExpressions:(NSString *) expression{

	/** @todo determine proper memory management */	
	//Retrieve current Mouth
	ConscienceObjectView *conscienceNewMouthView;
	conscienceNewMouthView = (ConscienceObjectView *)[conscienceBubbleView viewWithTag:kMouthViewTag];

	//Change Dimples Layer	
	[conscienceNewMouthView.totalLayers setObject:[currentConscienceBody.dimplesLayers objectForKey:expression] forKey:@"layerDimples"];		
	
	//Request mouth update
	[conscienceNewMouthView setNeedsDisplay];
}

/**
Display lips
Teeth choices determined by User's mouth choice
expression determined by Conscience Mood/Enthusiasm
@see ConscienceBody
@see ConscienceMind
*/

- (void) changeLipsExpressions:(NSString *) expression{
		
	/** @todo determine proper memory management */	
	//Retrieve current Mouth
	ConscienceObjectView *conscienceNewMouthView;
	conscienceNewMouthView = (ConscienceObjectView *)[conscienceBubbleView viewWithTag:kMouthViewTag];

	//Change lips Layer	
	[conscienceNewMouthView.totalLayers setObject:[currentConscienceBody.lipsLayers objectForKey:expression] forKey:@"layerLips"];		

	//Request mouth update
	[conscienceNewMouthView setNeedsDisplay];
}

/**
Display teeth
Teeth choices determined by User's mouth choice
expression determined by Conscience Mood/Enthusiasm
@see ConscienceBody
@see ConscienceMind
*/

- (void) changeTeethExpressions:(NSString *) expression{

	/** @todo determine proper memory management */	
	//Retrieve current Mouth
	ConscienceObjectView *conscienceNewMouthView;
	conscienceNewMouthView = (ConscienceObjectView *)[conscienceBubbleView viewWithTag:kMouthViewTag];
	
	//Change teeth Layer
	[conscienceNewMouthView.totalLayers setObject:[currentConscienceBody.teethLayers objectForKey:expression] forKey:@"layerTeeth"];		
	
	//Request mouth update
	[conscienceNewMouthView setNeedsDisplay];
}

/**
Display tongue
Tongue choices determined by User's mouth choice
expression determined by Conscience Mood/Enthusiasm
@see ConscienceBody
@see ConscienceMind
*/

- (void) changeTongueExpressions:(NSString *) expression{
		
	/** @todo determine proper memory management */
	//Retrieve current Mouth
	ConscienceObjectView *conscienceNewMouthView;
	conscienceNewMouthView = (ConscienceObjectView *)[conscienceBubbleView viewWithTag:kMouthViewTag];

	//Set Tongue Layer	
	[conscienceNewMouthView.totalLayers setObject:[currentConscienceBody.tongueLayers objectForKey:expression] forKey:@"layerTongue"];
	
	//Request mouth update
	[conscienceNewMouthView setNeedsDisplay];
}


/**
Actual values to set for the bubble are populated in currentConscienceBody, currentConscienceMind
Color determined by User
Animation determined by Conscience Mood/Enthusiasm
@see ConscienceBody
@see ConscienceMind
*/
- (void) changeBubble{

	//User is allowed selection of colors for Bubble
	animatedBubbleView = (ConscienceBubbleView *)[conscienceBubbleView viewWithTag:kAnimatedBubbleViewTag];
	animatedBubbleView.bubbleColor = currentConscienceBody.bubbleColor;
	animatedBubbleView.bubbleType = currentConscienceBody.bubbleType;    

    //Glow duration is inverse of Conscience enthusiasm, enthusiastic = shorter duration
    CGFloat glowDuration = 1/(((currentConscienceMind.enthusiasm*2)/100) + 1);
    animatedBubbleView.bubbleGlowDuration = glowDuration;

	//Request bubble update
	[animatedBubbleView setNeedsDisplay];
		
}

#pragma mark -
#pragma mark Conscience Changes

- (void)removeConscienceInvisibility{
	
	//Determine which way Conscience is facing
	if (directionFacing == kDirectionFacingLeft) {
		directionFacing = kDirectionFacingRight;
		self.transform = CGAffineTransformIdentity;
		self.transform = CGAffineTransformMakeScale(1.0, 1.0);		
	}else{
		directionFacing = kDirectionFacingLeft;
		self.transform = CGAffineTransformIdentity;
		self.transform = CGAffineTransformMakeScale(-1.0, 1.0);		
	}
	
	[self makeConscienceVisible];
}

- (void)makeConscienceVisible{
	
	[UIView beginAnimations:@"visible" context:nil];
	[UIView setAnimationDuration:0.25];
	
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	self.alpha = 1;
	
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Timed Changes

- (void) setTimers{
	
    //Put Conscience to sleep if enthusiasm is 0
    if (currentConscienceMind.enthusiasm > 0) {

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

- (void) timedMouthExpressionChanges{
	
	
	NSArray *expressions;
    	
    expressions = [NSArray arrayWithObjects: @"layerLipsSadShock", @"layerLipsSadOpenAlt1", @"layerLipsSadOpen", @"layerLipsSadAlt1", @"layerLipsSad", @"layerLipsSadSmirk", @"layerLipsSadSilly", @"layerLipsNormalSad", @"layerLipsNormal", @"layerLipsNormalHappy", @"layerLipsHappySmirk", @"layerLipsHappy", @"layerLipsHappySilly", @"layerLipsHappyAlt1", @"layerLipsHappyOpen", @"layerLipsHappyOpenAlt1", @"layerLipsHappyShock", nil];
    
    CGFloat conscienceMood = currentConscienceMind.mood;
    CGFloat conscienceEnthusiasm = currentConscienceMind.enthusiasm;

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
	
	if ((randomSwitch < 1) || isExpressionForced) {

		[self changeLipsExpressions:[expressions objectAtIndex:randomIndex]];
	}

	isExpressionForced = FALSE;
	
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
	
	expressions = [NSArray arrayWithObjects:@"layerDimplesSad", @"layerDimplesNormal", @"layerDimplesHappy", nil];
	[self changeDimplesExpressions:[expressions objectAtIndex:dimpleIndex]];
	
    if (conscienceEnthusiasm > 40) {
        
        expressions = [NSArray arrayWithObjects:@"layerTeethSadOpenAlt1", @"layerTeethSadOpen", @"layerTeethNormal", @"layerTeethHappyOpen", @"layerTeethHappyOpenAlt1", nil];
        [self changeTeethExpressions:[expressions objectAtIndex:teethIndex]];
        
        expressions = [NSArray arrayWithObjects:@"layerTongueSadCenter", @"layerTongueSadLeft", @"layerTongueSadRight", @"layerTongueNormal", @"layerTongueHappyCenter", @"layerTongueHappyLeft", @"layerTongueHappyRight", nil];
        [self changeTongueExpressions:[expressions objectAtIndex:tongueIndex]];
    
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
	
	NSArray * expressions;
	    
    CGFloat conscienceEnthusiasm = currentConscienceMind.enthusiasm;
    CGFloat conscienceMood = currentConscienceMind.mood;

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
    expressions = [NSArray arrayWithObjects:@"layerBrowNormal",@"layerBrowAngry", @"layerBrowConfused", @"layerBrowExcited", nil];
	
    if ((randomSwitch < 1) || isExpressionForced){	
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
		
		[self changeBrowExpressions:[expressions objectAtIndex:randomBrow] forEye:eyeNumber]; 
		
	} else {
        [self changeBrowExpressions:[expressions objectAtIndex:0] forEye:eyeNumber]; 

    }
    
    eyeNumber = kEyeBothIndex;
    expressions = [NSArray arrayWithObjects:@"layerLidNormal", @"layerLidAngry", @"layerLidSquint", @"layerLidSleepy", @"layerLidUnder", nil];
    
	if ((randomSwitch == 2) || isExpressionForced) {
            
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

		[self changeLidExpressions:[expressions objectAtIndex:randomLid] forEye:eyeNumber];
		
	} else {
        [self changeLidExpressions:[expressions objectAtIndex:0] forEye:eyeNumber];

    }
        	
	isExpressionForced = FALSE;
	[self changeEyeDirection:randomDirection forEye:kEyeBothIndex];
	
}

- (IBAction) changeEyeDirection{
	
	static int expressionIndex = 0;
	//int eyeIndex = kEyeBothIndex;
	
	if (expressionIndex > 6) {
		expressionIndex = 0;
	}		
	
	
	[self changeEyeDirection:expressionIndex forEye:kEyeLeftIndex];
	[self changeEyeDirection:expressionIndex forEye:kEyeRightIndex];
	expressionIndex++;		
}

#pragma mark -
#pragma mark Memory management

/**
Release init'ed objects, deallocate super.
*/
- (void)dealloc {
    
	[self stopTimers];
	
	[conscienceBubbleView release];
	[currentConscienceBody release];
	[currentConscienceAccessories release];
	[currentConscienceMind release];   
    
    [super dealloc];
    

}


@end