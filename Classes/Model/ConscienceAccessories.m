/**
Implementation:  ConscienceAccessories holds the image name of each currently adorned asset.  
It can be utilizied for both the User ConscienceView and the Antagonist ConscienceView.

@class ConscienceAccessories ConscienceAccessories.h
*/

#import "ConscienceAccessories.h"

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

- (void) dealloc {

	[_primaryAccessory release];
	[_secondaryAccessory release];
	[_topAccessory release];
	[_bottomAccessory release];
	[super dealloc];
}

@end