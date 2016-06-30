/**
Implementation:  Facial Features Gradient Data.  Object to be populated with the gradient data from XML.
 locationsCount, componentsCount and pointsCount left for future implementation.

@class ConscienceGradient ConscienceGradient.h
 */

#import "ConscienceGradient.h"

@implementation ConscienceGradient

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        //In case of first time run, or User does not supply configuration, default gradient
        _gradientID = @"";
        _locationsCount = 2;
        _componentsCount = _locationsCount * 4;
        _pointsCount = 2;
		_gradientPoints = [[NSMutableArray alloc] init];

    }
    return self;
}


@end
