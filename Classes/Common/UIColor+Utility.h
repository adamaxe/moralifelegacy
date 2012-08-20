/**
 UIColor utility category.  Allow creation of a UIColor using standard hex format strings

 @class UIColor+Utility

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 08/18/2012
 */

@interface UIColor (Utility)

/**
Class method for creating a UIColor from a hex formatted string
 @param NSString hex representation to be converted i.e. FF00FF or #FF00FF
 @return UIColor UIColor from the hexValue
 */
+ (UIColor *) colorWithHexString:(NSString *) hexValue;

/**
 Class method for creating a UIColor from a hex formatted string and alpha value
 @param NSString hex representation to be converted i.e. FF00FF or #FF00FF
 @param CGFloat float value from 0.0 to 1.0 for alpha channel
 @return UIColor UIColor from the hexValue and alpha
 */
+ (UIColor *) colorWithHexString:(NSString *) hexValue alpha:(CGFloat) alpha;


@end
