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

        [self setCurrentFillColor:@""];
        [self setCurrentStrokeColor:@""];
        [self setLayerID:@""];   
    }
    
	return self;
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