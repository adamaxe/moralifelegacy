/**
Implementation: Conscience Object draws a set of drawing instructions which are pulled from SVG documents.
SVG Documents are parsed into arrays of instructions and points.
ConscienceObjectView draws via Core Graphics these points when provided the drawing instructions.
 
@class ConscienceObjectView ConscienceObjectView.h
 */

#import "ConscienceObjectView.h"
#import "MoralifeAppDelegate.h"
#import "ConscienceLayer.h"
#import "ConsciencePath.h"
#import "ConscienceGradient.h"
#import "UIColor+Utility.h"

int const MLEyeWidth = 32;
int const MLEyeHeight = 32;

@implementation ConscienceObjectView

#pragma mark -
#pragma mark View lifecycle

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		//By default, each ConscienceObject must be transparent
		_conscienceBackgroundColor = [UIColor clearColor];
		self.backgroundColor = _conscienceBackgroundColor;
		self.multipleTouchEnabled = TRUE;
		_totalLayers = [[NSMutableDictionary alloc] init];
		_totalGradients = [[NSMutableDictionary alloc] init];
		
	}
    return self;
}


/**
Must override drawRect because custom drawing from a vector source is required
@param rect frame to be drawn within
*/
-(void) drawRect:(CGRect)rect{

	NSString *fillColor;
	bool isReoriented = FALSE;
	
	if (_conscienceBackgroundColor != nil){
		self.backgroundColor = [UIColor clearColor];
	}else {
		self.backgroundColor = _conscienceBackgroundColor;
	}

	//Determine draw order
	//Layers prefixed with int to ease draw order
	//e.g. Iris must draw before lid to be obscured by lid
	NSArray *layerKeys = [_totalLayers allKeys];
	NSArray *sortedKeys = [layerKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	//Iterate through layers, drawing each.
	ConscienceLayer *currentLayer;
	
	for (int i=0; i<[sortedKeys count]; i++) {
		currentLayer = (ConscienceLayer *)_totalLayers[sortedKeys[i]];

		if (currentLayer != nil) {
			CGContextRef context = UIGraphicsGetCurrentContext();

			CGContextSaveGState(context);

			//Parse pathInstructions to determine number of paths required
			//pathInstructions is array of instruction arrays
			//pathPoints is array of point arrays	
			for (ConsciencePath *currentPath in currentLayer.consciencePaths) {
                _dynamicPath = CGPathCreateMutable();

				//Determine if image from path should be reoriented
				//Set bool after first iteration to prevent cummulative translations
				if (!isReoriented && (currentLayer.offsetX != 0 || currentLayer.offsetY != 0)) {
					CGContextTranslateCTM(context, currentLayer.offsetX, currentLayer.offsetY);
					isReoriented = TRUE;
				}
				
                //array of int drawing instructions
				NSMutableArray *pathInstructions = [[NSMutableArray alloc] initWithArray:currentPath.pathInstructions];
                //array of CGFloats representing coordinates
				NSMutableArray *pathPoints = [[NSMutableArray alloc] initWithArray:currentPath.pathPoints];
				
				//Create the path
				[self createPathFromPoints:pathPoints WithInstructions:pathInstructions ForPath:_dynamicPath];

                
				//Color the path
				//Convert hex from data to CGPathColor format
				CGContextAddPath(context, _dynamicPath);
				
				//Check to see if fill color is a reference to gradient
				//If true, do not fill the path, shade it instead
				if([currentPath.pathFillColor rangeOfString:@"url"].location == NSNotFound){
					if (![currentLayer.currentFillColor isEqualToString:@""]) {
						fillColor = [NSString stringWithString:currentLayer.currentFillColor];
					}else{
						fillColor = [NSString stringWithString:currentPath.pathFillColor];
					}
				}else {
					NSString *gradientSubstring = (NSString *)[currentPath.pathFillColor substringFromIndex:5];
					gradientSubstring = [gradientSubstring substringToIndex:[gradientSubstring length]-1];
					
					ConscienceGradient *gradientElement = _totalGradients[gradientSubstring];
					CGContextClip(context);
					CGColorSpaceRef conscienceColorSpace = CGColorSpaceCreateDeviceRGB();
					
					CGFloat gradientLocations[2] = {0.0, 1.0};
					CGFloat gradientComponents[8] = {0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0};
					CGGradientRef conscienceGradient = CGGradientCreateWithColorComponents (conscienceColorSpace, gradientComponents,  gradientLocations, 2);
					
					CGPoint startPoint = [(gradientElement.gradientPoints)[0] CGPointValue];
					CGPoint endPoint = [(gradientElement.gradientPoints)[1] CGPointValue];

					CGContextDrawLinearGradient (context, conscienceGradient, startPoint, endPoint, 0);
					//CFRelease(conscienceGradient);
					CGColorSpaceRelease(conscienceColorSpace);
					CGGradientRelease(conscienceGradient);
                    fillColor = @"000000";
				}

                UIColor *fillColorUIColor = [UIColor colorWithHexString:fillColor alpha:currentPath.pathFillOpacity];
                CGContextSetFillColorWithColor(context, fillColorUIColor.CGColor);


				CGContextFillPath(context);

				//Stroke the path
				CGContextAddPath(context, _dynamicPath);

                UIColor *strokeColorUIColor = [UIColor colorWithHexString:currentPath.pathStrokeColor alpha:currentPath.pathStrokeOpacity];

				CGContextSetLineWidth(context, currentPath.pathStrokeWidth);
                CGContextSetStrokeColorWithColor(context, strokeColorUIColor.CGColor);

				CGContextStrokePath(context);

                //Close path
                CGPathCloseSubpath(_dynamicPath);
				CGPathRelease(_dynamicPath);

			}

			CGContextRestoreGState(context);

		}else {
			NSLog(@"no layer");
		}
	}

}

/**
Implementation:  To determine which CGPathOperation to perform, each instructions element contains an single instruction.  
Depending upon the instruction, a number of points are pulled from points and then added to the path.
Path is returned when instructionsArray is empty.
Points must be absolute.
 */
- (void) createPathFromPoints:(NSArray *) points WithInstructions:(NSArray *) instructions ForPath:(CGMutablePathRef) path{

	//Cursors to traverse the arrays
	int pointPosition = 0;

	//Parse instructions to determine number of operations
	for (int i = 0; i < [instructions count]; i++) {

		//For each element, perform requested CGPath operation.
		//Pass the appropriate number of CGFloats to operation.
		//Must typecast NSNumber Object back to CGFloat typedef
		//Increment Operators cannot be used due to subsequent utilizations inline
		switch ([instructions[i] integerValue]){
			case 0:CGPathMoveToPoint(path, NULL, [points[pointPosition] floatValue], 
									[points[pointPosition+1] floatValue]);
									pointPosition+=2;break;
			case 1:CGPathAddLineToPoint(path, NULL, [points[pointPosition] floatValue], 
									[points[pointPosition+1] floatValue]);
									pointPosition+=2;break;
			case 2:CGPathAddCurveToPoint(path, NULL, [points[pointPosition] floatValue], 
									[points[pointPosition+1] floatValue],
									[points[pointPosition+2] floatValue],
									[points[pointPosition+3] floatValue],
									[points[pointPosition+4] floatValue],
									[points[pointPosition+5] floatValue]);
									pointPosition+=6;break;
			case 3:CGPathAddQuadCurveToPoint(path, NULL, [points[pointPosition] floatValue], 
									[points[pointPosition+1] floatValue],
									[points[pointPosition+2] floatValue],
									[points[pointPosition+3] floatValue]);
									pointPosition+=4;break;
			case 4:CGPathAddArcToPoint(path, NULL, [points[pointPosition] floatValue], 
									[points[pointPosition+1] floatValue],
									[points[pointPosition+2] floatValue],
									[points[pointPosition+3] floatValue],
									[points[pointPosition+4] floatValue]);
									pointPosition+=5;break;
			default:break;
		}
	}

}

#pragma mark -
#pragma mark Memory management



@end
