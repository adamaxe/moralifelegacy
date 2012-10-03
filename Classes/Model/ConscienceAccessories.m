/**
Implementation:  ConscienceAccessories holds the image name of each currently adorned asset.  
It can be utilizied for both the User ConscienceView and the Antagonist ConscienceView.

@class ConscienceAccessories ConscienceAccessories.h
*/

#import "ConscienceAccessories.h"

NSString* const kPrimaryAccessoryFileNameResource = @"acc-nothing";
NSString* const kSecondaryAccessoryFileNameResource = @"acc-nothing";
NSString* const kTopAccessoryFileNameResource = @"acc-nothing";
NSString* const kBottomAccessoryFileNameResource = @"acc-nothing";

@implementation ConscienceAccessories

- (id)init
{
    self = [super init];
    if (self) {
		
        //In case of first time run, or User does not supply configuration, default Conscience
        _primaryAccessory = kPrimaryAccessoryFileNameResource ;
        _secondaryAccessory = kSecondaryAccessoryFileNameResource;
        _topAccessory = kTopAccessoryFileNameResource;
        _bottomAccessory = kBottomAccessoryFileNameResource;

    }

    return self;
}


@end