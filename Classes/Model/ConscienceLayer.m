/**
Implementation:  NSArray of ConsciencePaths.

@class ConscienceLayer ConscienceLayer.h
 */

#import "ConscienceLayer.h"

@implementation ConscienceLayer

@synthesize consciencePaths, layerID;
@synthesize currentFillColor, currentStrokeColor;
@synthesize offsetX, offsetY;

//- (ConscienceLayer *) init {
- (id)init{
	[super init];

	consciencePaths = [[NSMutableArray alloc] init];

    [self setCurrentFillColor:@""];
    [self setCurrentStrokeColor:@""];
    [self setLayerID:@""];   
    
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