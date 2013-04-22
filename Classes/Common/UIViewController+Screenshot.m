/**
 Implementation: Do up some CG magic

 @class UIViewController+Screenshot UIViewController+Screenshot.h
 */
#import "UIViewController+Screenshot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIViewController (Screenshot)

- (UIImage *) takeScreenshot {

    CGSize imageSize = [[UIScreen mainScreen] bounds].size;

    if (NULL != UIGraphicsBeginImageContextWithOptions) {

        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    } else {
        UIGraphicsBeginImageContext(imageSize);
    }

    CGContextRef context = UIGraphicsGetCurrentContext();

    //iOS applications may have more than one window, key window, keyboard's window, etc.
    //Iterate through windows even if keyboard is up
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            //Account for layer being offset by status bar, rotations, etc.
            CGContextSaveGState(context);

            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);

            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);

            // Offset by the portion of the bounds left of and above the anchor point
            CGFloat transformX = -[window bounds].size.width * [[window layer] anchorPoint].x;
            CGFloat transformY = -[window bounds].size.height * [[window layer] anchorPoint].y;
            CGContextTranslateCTM(context, transformX, transformY);

            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];

            // Restore the context
            CGContextRestoreGState(context);
        }
    }

    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return image;

}

@end
