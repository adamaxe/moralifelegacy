/**
Implementation:  ConscienceAccessories holds the image name of each currently adorned asset.  
It can be utilizied for both the User ConscienceView and the Antagonist ConscienceView.

@class ConscienceAccessories ConscienceAccessories.h
*/

#import "ConscienceAccessories.h"

NSString* const MLPrimaryAccessoryFileNameResourceDefault = @"acc-nothing";
NSString* const MLSecondaryAccessoryFileNameResourceDefault = @"acc-nothing";
NSString* const MLTopAccessoryFileNameResourceDefault = @"acc-nothing";
NSString* const MLBottomAccessoryFileNameResourceDefault = @"acc-nothing";

@implementation ConscienceAccessories

- (instancetype)init
{
    self = [super init];
    if (self) {
		
        //In case of first time run, or User does not supply configuration, default Conscience
        _primaryAccessory = MLPrimaryAccessoryFileNameResourceDefault ;
        _secondaryAccessory = MLSecondaryAccessoryFileNameResourceDefault;
        _topAccessory = MLTopAccessoryFileNameResourceDefault;
        _bottomAccessory = MLBottomAccessoryFileNameResourceDefault;

    }

    return self;
}


@end
