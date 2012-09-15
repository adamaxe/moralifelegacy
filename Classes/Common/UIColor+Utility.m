#import "UIColor+Utility.h"

@implementation UIColor (Utility)

/**
 Implementation: If alpha is omitted, then assume 1.0 and call other class method
 */
+ (UIColor *) colorWithHexString:(NSString *) hexValue {

    return [UIColor colorWithHexString:hexValue alpha:1.0];
}

/**
 Implementation: Split the string into its RGB int components, bitshift each component and divide by 255 to get the 0.0 - 1.0 range required by UIColor.
 */
+ (UIColor *) colorWithHexString:(NSString *) hexValue alpha:(CGFloat) alpha {

    NSScanner *scanner;
    unsigned int rgbval;

    scanner = [NSScanner scannerWithString: hexValue];

    //Optionally allow the leading #symbol in many web-safe color generators
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];

    [scanner scanHexInt: &rgbval];

    //Bitshift to get the 00 - FF range of each component
    CGFloat red = (((rgbval & 0xFF0000) >> 16))/255.0;
    CGFloat green = (((rgbval & 0xFF00) >> 8))/255.0;
    CGFloat blue = (rgbval & 0xFF)/255.0;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end