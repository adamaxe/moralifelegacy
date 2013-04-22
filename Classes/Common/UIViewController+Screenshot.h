/**
 UIViewController utility category.  Allow creation of a screenshot from the current ViewController

 @class UIViewController+Screenshot

 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 02/14/2013
 */
@interface UIViewController (Screenshot)

/**
Return a screenshot for use in backgrounds
 @return UIImage screenshot image for background use
 */
- (UIImage *) takeScreenshot;

@end