/**
Transparent UINavigationBar subclass.  Prevent default UINavigationbar background from displaying.

@see UINavigationBar
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 05/19/2010
@file
 */

@interface UINavigationBar (CustomTexture)

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;

@end
