/**
Transparent UINavigationBar subclass.  Prevent default UINavigationbar background from displaying.

@see UINavigationBar
@author Copyright 2020 Adam Axe. All rights reserved. http://www.adamaxe.com
@date 05/19/2010
@file
 */

@interface UINavigationBar (CustomTexture)

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;

@end
