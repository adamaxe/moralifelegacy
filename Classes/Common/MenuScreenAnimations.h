/**
 UIViewController Menu Screen Protocol.  Used for providing animated buttons on menus.
 
 Copyright 2010 Team Axe, LLC. All rights reserved.
 
 @class MenuScreenAnimations.h
 @author Team Axe, LLC. http://www.teamaxe.org
 @date 07/20/2010
 */
@protocol MenuScreenAnimations <NSObject>

/**
 Randomly select which of buttons to animate
 */
- (void) refreshButtons;

/**
 Animate the button's icon
 @param buttonNumber NSNumber which requested button
 */
- (void) buttonAnimate:(NSNumber *) buttonNumber;

/**
 Return the buttons icon to default after animation finishes
 @param buttonNumber NSNumber which requested button
 */
- (void) buttonAnimationDone:(NSNumber *) buttonNumber;

@end
