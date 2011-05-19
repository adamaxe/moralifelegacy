/**
Implementation:  ConscienceAccessories holds the image name of each currently adorned asset.  
It can be utilizied for both the User ConscienceView and the Antagonist ConscienceView.

@class ConscienceAccessories ConscienceAccessories.h
*/

#import "ConscienceAccessories.h"

@implementation ConscienceAccessories

@synthesize primaryAccessory, secondaryAccessory, topAccessory, bottomAccessory;

- (id)init
{
    self = [super init];
    if (self) {
		
        //In case of first time run, or User does not supply configuration, default Conscience
        [self setPrimaryAccessory:kPrimaryAccessoryFileNameResource];
        [self setSecondaryAccessory:kSecondaryAccessoryFileNameResource];
        [self setTopAccessory:kTopAccessoryFileNameResource];
        [self setBottomAccessory:kBottomAccessoryFileNameResource];

    }

    return self;
}

- (void) dealloc {

	[primaryAccessory release];
	[secondaryAccessory release];
	[topAccessory release];
	[bottomAccessory release];
	[super dealloc];
}

@end