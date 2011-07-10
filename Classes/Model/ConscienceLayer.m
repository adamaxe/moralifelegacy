/**
Implementation:  NSMutableArray of ConsciencePaths.

@class ConscienceLayer ConscienceLayer.h
 */

#import "ConscienceLayer.h"

@implementation ConscienceLayer

@synthesize consciencePaths, layerID;
@synthesize currentFillColor, currentStrokeColor;
@synthesize offsetX, offsetY;

- (id)init{
    self = [super init];
    if (self) {    
        //In case of first time run, or User does not supply configuration, default gradient
        consciencePaths = [[NSMutableArray alloc] init];

        [self setCurrentFillColor:kPathColor];
        [self setCurrentStrokeColor:kPathColor];
        [self setLayerID:@""];
        offsetX = kDefault0Float;
        offsetY = kDefault0Float;
    }
    
	return self;
}


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {         
        
		self.consciencePaths = [decoder decodeObjectForKey:@"consciencePaths"];
		self.layerID = [decoder decodeObjectForKey:@"layerID"];
		self.currentFillColor = [decoder decodeObjectForKey:@"currentFillColor"];
		self.currentStrokeColor = [decoder decodeObjectForKey:@"currentStrokeColor"];
		
        self.offsetX = [decoder decodeFloatForKey:@"offsetX"];
        self.offsetY = [decoder decodeFloatForKey:@"offsetX"];

	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
	[encoder encodeObject:consciencePaths forKey:@"consciencePaths"];
	[encoder encodeObject:layerID forKey:@"layerID"];
	[encoder encodeObject:currentFillColor forKey:@"currentFillColor"];
	[encoder encodeObject:currentStrokeColor forKey:@"currentStrokeColor"];    
	[encoder encodeFloat:offsetX forKey:@"offsetX"];
    [encoder encodeFloat:offsetY forKey:@"offsetY"];

}

- (void) dealloc {

    [consciencePaths removeAllObjects];
	[consciencePaths release];consciencePaths = nil;
	[layerID release];
	[currentFillColor release];
	[currentStrokeColor release];

    [super dealloc];

}

@end