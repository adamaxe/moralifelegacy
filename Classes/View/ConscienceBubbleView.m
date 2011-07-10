/**
Implementation:  ConcienceView can display the User's or Antagonist's Bubble.
Bubble Color is customizable by the User and populated by userConscienceBody
Bubble Animation speed is determined by Conscience's mood and enthusiasm

@class ConscienceBubbleView ConscienceBubbleView.h
 */

#import "ConscienceBubbleView.h"
#import <CoreGraphics/CoreGraphics.h>
//QuarzCore necessary for CABasicAnimation
#import <QuartzCore/QuartzCore.h>

@implementation ConscienceBubbleView
@synthesize bubbleType;
@synthesize bubbleGlowWidth, bubbleGlowDuration;
@synthesize bubbleColor;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

		//Set background to transparent, enable multi-touch for User manipulation
		self.backgroundColor = [UIColor clearColor];
		self.multipleTouchEnabled = YES;

		//Set default pulse, line width and black glow
		[self setBubbleGlowDuration:kBubbleDuration];
		[self setBubbleGlowWidth:kBubbleWidth];
		[self setBubbleColor:kBubbleColor];
		[self setBubbleType:kBubbleType];
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
	NSScanner *fillColorScanner = [NSScanner scannerWithString:bubbleColor];

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
	CGContextSetLineWidth(context, bubbleGlowWidth);
	
	//Outline black, slightly transparent
	CGContextSetRGBStrokeColor(context, 0,0,0,0.6);

	//Background white, totally opaque
	CGContextSetRGBFillColor (context, 1, 1, 1, 1);

	/** @todo convert hard coded values to constants */
	//Draw 165px circle 15px off center
    
//	CGContextFillEllipseInRect(context, CGRectMake(12, 12, 165, 165));
	
	//Reset shadow for overall bubble black dropshadow
	float shadowColorValues[] = {0, 0, 0, .6};// 3
	shadowColor = CGColorCreate(colorSpace, shadowColorValues);
	shadowOffset = CGSizeMake (5,  5);
	CGContextSetShadowWithColor(context, shadowOffset, 6, shadowColor);	
	CGColorRelease(shadowColor);
	CGContextFillEllipseInRect(context, CGRectMake(12, 12, 165, 165));

	//Reset shadow for outer glow of bubble
	shadowOffset = CGSizeMake (0,  0);
	CGContextSetShadowWithColor(context, shadowOffset, 6, bubbleColorCG);	
    
    /** @todo Determine if other bubble types are worthwhile */
//    CGMutablePathRef outerPath = CGPathCreateMutable();    
//    CGAffineTransform outerTransform = CGAffineTransformMakeTranslation(-5.0, -5.0);
//    
//    CGPathMoveToPoint(outerPath, &outerTransform, 96.403054,15.795842);
//	CGPathAddCurveToPoint(outerPath, &outerTransform, 144.55939,34.57146, 161.2552,54.787642, 177.35025,96.743029);
//    CGPathAddCurveToPoint(outerPath, &outerTransform, 161.86524,146.02377, 134.29839,164.22041, 97.353851,177.55153);
//    CGPathAddCurveToPoint(outerPath, &outerTransform, 75.599212,147.67056, 39.313875,118.90137, 14.574729,97.624169);    
//    CGPathAddCurveToPoint(outerPath, &outerTransform, 48.142838,71.729871, 67.738924,43.521176, 94.571123,16.815672);
//    CGPathAddCurveToPoint(outerPath, &outerTransform, 95.148571,16.548563, 95.648168,15.666187, 96.403054,15.795842);    
//	
//	CGPathCloseSubpath(outerPath);
//	
//	CGContextAddPath(context, outerPath);
//	CGContextFillPath(context);
//    CGContextStrokePath(context);
//    
//	CGPathRelease(outerPath);
    
    CGContextStrokeEllipseInRect(context, CGRectMake(12, 12, 165, 165));
	
	/** @todo convert to function */
	//Draw bubble surface
	//Generate path to mimic shimmer in upper-right corner of sphere
	shadowOffset = CGSizeMake (0,  0);
	CGContextSetRGBFillColor (context, 1, 1, 1, 0.4);
	CGContextSetShadowWithColor(context, shadowOffset, 10, bubbleColorCG);	

	CGAffineTransform transform = CGAffineTransformMakeTranslation(-5.0, -5.0);

	//Create path to draw
	CGMutablePathRef dynamicPath = CGPathCreateMutable();    

	CGPathMoveToPoint(dynamicPath, &transform, 100.56817,30.166705);
	CGPathAddCurveToPoint(dynamicPath, &transform, 66.791491, 37.335987, 36.124184, 69.452376, 33.144898, 112.51362);
	CGPathAddCurveToPoint(dynamicPath, &transform, 25.42531, 72.733457,  64.4555, 27.727181, 100.56817, 30.166705);
	
	CGPathCloseSubpath(dynamicPath);
	
	CGContextAddPath(context, dynamicPath);
	CGContextFillPath(context);
		
	CGPathRelease(dynamicPath);
	
	//Release objects
	CGColorRelease (bubbleColorCG);
	CGColorSpaceRelease (colorSpace);
	
	//Restore context before animation
	CGContextRestoreGState(context);

	/** @todo convert to function */
	//Create bubble glow animation
	CALayer *bubbleAnimationLayer = [CALayer layer];
	/** @todo convert hard coded values to constants */
	bubbleAnimationLayer.frame = CGRectMake(5, 5, 178, 178);
    
    CGFloat radius = 83.0;
    [bubbleAnimationLayer setMasksToBounds:YES];
    [bubbleAnimationLayer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [bubbleAnimationLayer setCornerRadius:radius];
    [bubbleAnimationLayer setBounds:CGRectMake(0.0f, 0.0f, radius *2, radius *2)];    
    [bubbleAnimationLayer setOpacity:0.6];
		
	/** @todo provide opaque border to white circle */
	CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacityAnimation.duration = bubbleGlowDuration;
	opacityAnimation.fromValue = [NSNumber numberWithFloat:0.8];
	opacityAnimation.toValue = [NSNumber numberWithFloat:0.2];
	opacityAnimation.autoreverses = YES;
	opacityAnimation.delegate = self;
	opacityAnimation.repeatCount = INFINITY;

	//Must remove previous animations each time
	//Animation will be drawn multiple times on each setNeedsDisplay otherwise		
	[bubbleAnimationLayer removeAllAnimations];
	[bubbleAnimationLayer addAnimation:opacityAnimation forKey:@"animateOpacity"];	
	self.layer.sublayers = nil;
    
    //Determine which bubbleType to display
    switch (bubbleType) {
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
    [bubbleColor release];
    [super dealloc];
}

@end