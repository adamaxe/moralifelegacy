/**
Implementation:  Facial Features Gradient Data.  Object to be populated with the gradient data from XML.
 locationsCount, componentsCount and pointsCount left for future implementation.

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
        
        //In case of first time run, or User does not supply configuration, default gradient
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