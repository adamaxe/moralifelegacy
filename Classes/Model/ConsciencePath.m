/**
Implementation: Construct from SVG files NSArrays of points, gradients and drawing instructions.  
Data will represent images that will be drawn via CoreGraphics on Conscience

@class ConsciencePath ConsciencePath.h
 */

#import "ConsciencePath.h"

NSString* const kPathColor = @"";
float const kDefault0Float = 0.0;

@implementation ConsciencePath

- (id)init
{
    self = [super init];
	if (self) {
		//In case of first time run, or User does not supply configuration, default gradient
		_pathFillColor = kPathColor;
		_pathStrokeColor = kPathColor;
		_pathID = @"none";
		_pathGradient = @"";
		_pathStrokeWidth = kDefault0Float;
        _pathFillOpacity = kDefault0Float;
		_pathStrokeMiterLimit = kDefault0Float;
		_pathStrokeOpacity = kDefault0Float;

		_pathPoints = [[NSMutableArray alloc] init];
		_pathInstructions = [[NSMutableArray alloc] init];		
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {         
        
		self.pathInstructions = [decoder decodeObjectForKey:@"pathInstructions"];
		self.pathPoints = [decoder decodeObjectForKey:@"pathPoints"];
		self.pathFillColor = [decoder decodeObjectForKey:@"pathFillColor"];
		self.pathStrokeColor = [decoder decodeObjectForKey:@"pathStrokeColor"];
		self.pathID = [decoder decodeObjectForKey:@"pathID"];
		self.pathGradient = [decoder decodeObjectForKey:@"pathGradient"];
		
        self.pathStrokeWidth = [decoder decodeFloatForKey:@"pathStrokeWidth"];
        self.pathFillOpacity = [decoder decodeFloatForKey:@"pathFillOpacity"];
        self.pathStrokeOpacity = [decoder decodeFloatForKey:@"pathStrokeOpacity"];
        self.pathStrokeMiterLimit = [decoder decodeFloatForKey:@"pathStrokeMiterLimit"];
        
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
	[encoder encodeObject:_pathInstructions forKey:@"pathInstructions"];
	[encoder encodeObject:_pathPoints forKey:@"pathPoints"];
	[encoder encodeObject:_pathFillColor forKey:@"pathFillColor"];
	[encoder encodeObject:_pathStrokeColor forKey:@"pathStrokeColor"];
	[encoder encodeObject:_pathID forKey:@"pathID"];
	[encoder encodeObject:_pathGradient forKey:@"pathGradient"];
	[encoder encodeFloat:_pathStrokeWidth forKey:@"pathStrokeWidth"];
    [encoder encodeFloat:_pathFillOpacity forKey:@"pathFillOpacity"];
	[encoder encodeFloat:_pathStrokeOpacity forKey:@"pathStrokeOpacity"];
    [encoder encodeFloat:_pathStrokeMiterLimit forKey:@"pathStrokeMiterLimit"];
    
}

/**
Implementation: Using the SVG spec, separate draw instructions from draw points and correlate for future 
 CoreGraphics interpretation.
 */
- (void) convertToConsciencePath:(NSString *) pathData WithStyle:(NSString *) styleData{
	
    //SVG possesses path simplification such that repeated instructions are omitted
	//in various scenarios, and these repeated instructions do not even need to be contiguous.
	//We must preserve the previous instruction in this case, so that we can add it
	//in the event of a repeated instruction
	int pointCount = 0;
	int currentPointLimit = 0;
	bool addInstruction = FALSE;

	@autoreleasepool {
		NSMutableString *previousInstruction = [[NSMutableString alloc] initWithString:@""];
		
    /**
		Tokenize path data.
		Path must be tokenized twice.  Once for instructions/coordinates.  Twice for X/Y components.
		 */
		for (NSString *element in [pathData componentsSeparatedByString:@" "]) {        
    
        NSCharacterSet *characterSet = [NSCharacterSet letterCharacterSet];
        NSRange characterRange = [element rangeOfCharacterFromSet:characterSet];

			//Check for instruction or point
			if(characterRange.location == NSNotFound ){			
				/** @todo account for non-CGPoint instances like Arc */
				//If point found, tokenize to get x, y
                
            NSArray *points = [element componentsSeparatedByString: @","];
            
            for (int i = 0; i < [points count]; i++) {
                [self.pathPoints addObject:points[i]];
                pointCount++;
            }
            
				//Determine if an SVG instruction has been omitted
				if (pointCount == currentPointLimit) {
					addInstruction = TRUE;
					
				}
            
			}else {		
				//Determine SVG path "simplification"
				//M=0, L=1, C=2, Q=3, A=4
				if ([element isEqualToString:@"M"]) {
					currentPointLimit = 2;
                [previousInstruction setString:@"0"];
				}else if ([element isEqualToString:@"L"]) {
                [previousInstruction setString:@"1"];                
					currentPointLimit = 2;
				}else if ([element isEqualToString:@"C"]) {
                [previousInstruction setString:@"2"];                
					currentPointLimit = 6;
				}else if ([element isEqualToString:@"Q"]) {
                [previousInstruction setString:@"3"];                
					currentPointLimit = 4;
				}else if([element isEqualToString:@"A"]){
                [previousInstruction setString:@"4"];                
					currentPointLimit = 5;
				}else if([element isEqualToString:@"z"]){
					
					if (pointCount == currentPointLimit){
						addInstruction = TRUE;
						
					}
				}	
				pointCount = 0;
				
			}
			
			//Determine if an SVG instruction has been omitted
			if (addInstruction) {
				addInstruction = FALSE;
				//Explicitly add "simplified" SVG instruction
				//M=0, L=1, C=2, Q=3, A=4

            NSString *finalInstruction = [[NSString alloc] initWithString:previousInstruction];
				[self.pathInstructions addObject:finalInstruction];
					
				//Reset counter for next instruction
				pointCount = 0;
				
			}

		}


    }
	
	//Tokenizing style element.  CSS format utilized so ';' is first delimiter, ':' is second
	//name:valuepair1;name:valuepair2;etc.
	NSArray *styleComponent;
	NSArray *styleTokens = [styleData componentsSeparatedByString: @";"];
	
	NSMutableDictionary *styleNameValuePairs = [NSMutableDictionary dictionaryWithCapacity:[styleTokens count]];

	for (NSString *element in styleTokens) {
		styleComponent = [element componentsSeparatedByString: @":"];
		//Insert name value pairs into dictionary for easy retrieval.
		//Name:Value
		styleNameValuePairs[styleComponent[0]] = styleComponent[1];
	}
	
	NSString *pathColorPre = (NSString *)styleNameValuePairs[@"fill"];
	
	//Determine if fill color is null, an RGB hex color or a gradient
	if ((pathColorPre == NULL) || [pathColorPre isEqualToString:@"none"]) {
		//fill color is empty, should default to black
		[self setPathFillColor:@"000000"];
	}else if([pathColorPre rangeOfString:@"url"].location == NSNotFound){
		//fill color is not a gradient reference
        //remove leading #
        NSString *substringColor = [pathColorPre substringFromIndex:1];
		[self setPathFillColor: [substringColor substringToIndex:[substringColor length]]];

	}else {
		//Substring off "URL(#)" from gradientName
		NSString *substringTemp = [pathColorPre substringFromIndex:5];
        
		[self setPathGradient: [substringTemp substringToIndex:[substringTemp length]-1]];
		
		//populate fillColor with full gradient link
		//prevent view from painting path
		[self setPathFillColor:pathColorPre];
	
		[self setPathFillOpacity: 0];
	}

	pathColorPre = (NSString *)styleNameValuePairs[@"stroke"];
	
	if (pathColorPre != NULL && ![pathColorPre isEqualToString:@"none"]) {

		[self setPathStrokeColor:pathColorPre];

	}else {
		[self setPathStrokeColor:@"000000"];
		
	}	

	[self setPathStrokeWidth: [(NSNumber*)styleNameValuePairs[@"stroke-width"] floatValue]];
	[self setPathFillOpacity: [(NSNumber*)styleNameValuePairs[@"fill-opacity"] floatValue]];
	[self setPathStrokeMiterLimit: [(NSNumber*)styleNameValuePairs[@"stroke-miterlimit"] floatValue]];
	[self setPathStrokeOpacity: [(NSNumber*)styleNameValuePairs[@"stroke-opacity"] floatValue]];
	
}



@end