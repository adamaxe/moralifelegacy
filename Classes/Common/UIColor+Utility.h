/**
 UIColor utility category.  Allow creation of a UIColor using standard hex format strings

 @class UIColor+Utility

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 08/18/2012
 */

@interface UIColor (Utility)

/**
 Common MoraLife Interface Color Red
 @return UIColor for negative UI choices
 */
+ (UIColor *) moraLifeChoiceRed;

/**
 Common MoraLife Interface Color Green
 @return UIColor for positive UI choices
 */
+ (UIColor *) moraLifeChoiceGreen;

/**
 Common MoraLife Interface Color Bright Green
 @return UIColor for high-contrast titles
 */
+ (UIColor *) moraLifeBrightGreen;

/**
 Common MoraLife Interface Color Light Green
 @return UIColor for pending UI choices
 */
+ (UIColor *) moraLifeChoiceLightGreen;

/**
 Common MoraLife Interface Color Blue
 @return UIColor for neutral UI choices
 */
+ (UIColor *) moraLifeChoiceBlue;

/**
 Common MoraLife Interface Color Brown
 @return UIColor for innert UI choices
 */
+ (UIColor *) moraLifeBrown;

/**
 Common MoraLife Interface Color Gray
 @return UIColor for unimportant UI Choices
 */
+ (UIColor *) moraLifeChoiceGray;

/**
 Common MoraLife Interface Color Light Gray
 @return UIColor for unavailable UI choices
 */
+ (UIColor *) moraLifeChoiceLightGray;

/**
Class method for creating a UIColor from a hex formatted string
 @param hexValue NSString hex representation to be converted i.e. FF00FF or #FF00FF
 @return UIColor UIColor from the hexValue
 */
+ (UIColor *) colorWithHexString:(NSString *) hexValue;

/**
 Class method for creating a UIColor from a hex formatted string and alpha value
 @param hexValue NSString hex representation to be converted i.e. FF00FF or #FF00FF
 @param alpha CGFloat value from 0.0 to 1.0 for alpha channel
 @return UIColor UIColor from the hexValue and alpha
 */
+ (UIColor *) colorWithHexString:(NSString *) hexValue alpha:(CGFloat) alpha;


@end
