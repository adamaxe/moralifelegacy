/**
Implementation:  Override draw layer of UINavigation bar to prevent drawing of black/gray graphic
 */

#import "UINavigationBar-Transparent.h"

@implementation UINavigationBar (CustomTexture)

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {

	//Prevent drawing of channel by overriding the drawLayer method and eliminating any instructions
}

@end
