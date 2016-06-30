#import "UIColor+Utility.h"

@implementation UIColor (Utility)

+ (UIColor *) moraLifeChoiceRed {

    return [UIColor colorWithRed:200.0/255.0 green:25.0/255.0 blue:2.0/255.0 alpha:1];
}

+ (UIColor *) moraLifeChoiceGreen {

    return [UIColor colorWithRed:44.0/255.0 green:103.0/255.0 blue:44.0/255.0 alpha:1];
}

+ (UIColor *) moraLifeBrightGreen {

    return [UIColor colorWithRed:0.0/255.0 green:176.0/255.0 blue:0.0/255.0 alpha:1];
}

+ (UIColor *) moraLifeChoiceLightGreen {

    return [UIColor colorWithRed:100.0/255.0 green:150.00/255.0 blue:100.0/255.0 alpha:1];
}

+ (UIColor *) moraLifeChoiceBlue {

    return [UIColor colorWithRed:50.0/255.0 green:79.0/255.0 blue:133.0/255.0 alpha:1];
}

+ (UIColor *) moraLifeBrown {

    return [UIColor colorWithRed:153.0/255.0 green:74.0/255.0 blue:49.0/255.0 alpha:1];
}


+ (UIColor *) moraLifeChoiceGray {

    return [UIColor colorWithRed:115.0/255.0 green:118.0/255.0 blue:102.0/255.0 alpha:1];
}

+ (UIColor *) moraLifeChoiceLightGray {

    return [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
}

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
    scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@"#"];

    [scanner scanHexInt: &rgbval];

    //Bitshift to get the 00 - FF range of each component
    CGFloat red = (((rgbval & 0xFF0000) >> 16))/255.0;
    CGFloat green = (((rgbval & 0xFF00) >> 8))/255.0;
    CGFloat blue = (rgbval & 0xFF)/255.0;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
