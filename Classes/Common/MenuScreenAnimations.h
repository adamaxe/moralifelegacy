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
