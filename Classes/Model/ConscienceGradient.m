/**
Implementation:  Facial Features Gradient Data.  Object to be populated with the gradient data from XML.

@class ConscienceGradient ConscienceGradient.h
 */

#import "ConscienceGradient.h"

@implementation ConscienceGradient

@synthesize gradientID;
@synthesize locationsCount, componentsCount;
@synthesize gradientPoints;
@synthesize pointsCount;

- (id)init
{
    self = [super init];
    if (self) {
        [self setGradientID:@""];
        [self setLocationsCount:2];    
        [self setComponentsCount:locationsCount * 4];
        [self setPointsCount:2];
		gradientPoints = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void) dealloc {
	[gradientID release];
	[gradientPoints release];
	[super dealloc];
}

@end