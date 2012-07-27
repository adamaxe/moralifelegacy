/**
Implementation:  ConcienceView can display the User's or Antagonist's Bubble.
Bubble Color is customizable by the User and populated by userConscienceBody
Bubble Animation speed is determined by Conscience's mood and enthusiasm

@class ConscienceBubbleView ConscienceBubbleView.h
 */

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "ConscienceBubbleView.h"
#import "ConscienceBubbleFactory.h"

@implementation ConscienceBubbleView

#pragma mark -
#pragma mark View lifecycle

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

		//Set background to transparent, enable multi-touch for User manipulation
		self.backgroundColor = [UIColor clearColor];
		self.multipleTouchEnabled = YES;

		//Set default pulse, line width and black glow
		_bubbleGlowDuration = kBubbleDuration;
		_bubbleGlowWidth = kBubbleWidth;
		_bubbleColor = kBubbleColor;
		_bubbleType = kBubbleType;
	}

	return self;
}

- (void)drawRect:(CGRect)rect {
	//Create graphics context
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	/** @todo convert to function */
	//Convert hex color to CG compatible values
	//i.e. #RRGGBBAA = R, G, B, A
	//e.g. #FFFFFFFF = 1,1,1,1

	//Convert String to Hex values
	NSScanner *fillColorScanner = [NSScanner scannerWithString:_bubbleColor];

	unsigned fillColorInt;

	[fillColorScanner scanHexInt:&fillColorInt]; 

	//Bitshift each position to get 1-255 value
	//Divide value by 255 to get CGColorRef compatible value
	CGFloat red   = ((fillColorInt & 0xFF0000) >> 16) / 255.0f;
	CGFloat green = ((fillColorInt & 0x00FF00) >>  8) / 255.0f;
	CGFloat blue  =  (fillColorInt & 0x0000FF) / 255.0f;

	//Shadow offset set to 0,0 to mimic a glow around Conscience
	CGSize shadowOffset = CGSizeMake (0,  0);

	//Create shadow witout offset
	CGFloat colorValues[4] = {red,green,blue,1}; 	
	CGColorRef bubbleColorCG;
	CGColorRef shadowColor;	
	CGColorSpaceRef colorSpace;
	
	colorSpace = CGColorSpaceCreateDeviceRGB ();
	bubbleColorCG = CGColorCreate (colorSpace, colorValues);
	CGContextSetShadowWithColor (context, shadowOffset, 5, bubbleColorCG);
	
	CGContextSaveGState(context);
	
	//Set black outline and white background
	CGContextSetLineWidth(context, _bubbleGlowWidth);
	
	//Outline black, slightly transparent
	CGContextSetRGBStrokeColor(context, 0,0,0,0.6);

	//Background white, totally opaque
	CGContextSetRGBFillColor (context, 1, 1, 1, 1);
	
	//Reset shadow for overall bubble black dropshadow
	float shadowColorValues[] = {0, 0, 0, .6};// 3
	shadowColor = CGColorCreate(colorSpace, shadowColorValues);
	shadowOffset = CGSizeMake (7,  7);
	CGContextSetShadowWithColor(context, shadowOffset, 6, shadowColor);	
	CGColorRelease(shadowColor);

    //outerpath is shape enclosing Conscience
    //dynamicPath is the accent promoting 3d nature of Conscience
    CGMutablePathRef outerPath = [ConscienceBubbleFactory bubbleSurfaceWithType:_bubbleType];
    CGMutablePathRef dynamicPath = [ConscienceBubbleFactory bubbleAccentWithType:_bubbleType];
        
	CGContextAddPath(context, outerPath);
	CGContextFillPath(context);    
    
    //Reset shadow for outer glow of bubble
	shadowOffset = CGSizeMake (0,  0);
	CGContextSetShadowWithColor(context, shadowOffset, 6, bubbleColorCG);	

    CGContextAddPath(context, outerPath);
	CGContextFillPath(context);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 3.0);
    CGContextSetStrokeColor(context, shadowColorValues);
    CGContextAddPath(context, outerPath);
    CGContextStrokePath(context);
        
	//Draw bubble surface
	//Generate path to mimic shimmer in upper-right corner of shape
	shadowOffset = CGSizeMake (0,  0);
	CGContextSetRGBFillColor (context, 1, 1, 1, 0.4);
	CGContextSetShadowWithColor(context, shadowOffset, 10, bubbleColorCG);	
	
	CGContextAddPath(context, dynamicPath);
	CGContextFillPath(context);
    	
	//Release objects
	CGColorRelease (bubbleColorCG);
	CGColorSpaceRelease (colorSpace);
	
	//Restore context before animation
	CGContextRestoreGState(context);

	//Create bubble glow animation
    //Opaque Layer is drawn in the shape of the outer path and pulses
    CAShapeLayer *bubbleAnimationLayer = [CAShapeLayer layer];
    CGRect shapeRect = CGRectMake(5.0f, 5.0f, 178.0f, 178.0f);
    [bubbleAnimationLayer setBounds:shapeRect];
    [bubbleAnimationLayer setPosition:CGPointMake(94.0f, 94.0f)];
    [bubbleAnimationLayer setFillColor:[[UIColor whiteColor] CGColor]];
    [bubbleAnimationLayer setOpacity:0.6];
    [bubbleAnimationLayer setPath:outerPath];
        
	CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacityAnimation.duration = _bubbleGlowDuration;
	opacityAnimation.fromValue = @0.8f;
	opacityAnimation.toValue = @0.2f;
	opacityAnimation.autoreverses = YES;
	opacityAnimation.delegate = self;
	opacityAnimation.repeatCount = INFINITY;

	//Must remove previous animations each time
	//Animation will be drawn multiple times on each setNeedsDisplay otherwise		
	[bubbleAnimationLayer removeAllAnimations];
	[bubbleAnimationLayer addAnimation:opacityAnimation forKey:@"animateOpacity"];	
	self.layer.sublayers = nil;

    //Determine which bubbleType to display
    switch (_bubbleType%3) {
        case 0: self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);break;
        case 1: self.transform = CGAffineTransformMakeScale(0.9f, 1.05f);break;
        case 2: self.transform = CGAffineTransformMakeScale(1.05f, 0.9f);break;
        default: break;
    }

	[self.layer addSublayer:bubbleAnimationLayer];
    
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [_bubbleColor release];
    [super dealloc];
}

@end