#import "UIFont+Utility.h"

@implementation UIFont (Utility)

/**
 Implementation: Setup the correct font family name
 */

+ (UIFont *) fontForNavigationBarTitle {

    return [UIFont boldSystemFontOfSize:22];
}

+ (UIFont *) fontForTableViewCellText {

    return [UIFont fontWithName:@"Cochin-Bold" size:16.0];
}

+ (UIFont *) fontForTableViewCellTextLarge {

    return [UIFont fontWithName:@"Cochin-Bold" size:18.0];
}

+ (UIFont *) fontForTextLabels {

    return [UIFont fontWithName:@"Cochin-Bold" size:18.0];
}

+ (UIFont *) fontForHomeScreenButtons {

    return [UIFont fontWithName:@"Cochin-Bold" size:18.0];
}

+ (UIFont *) fontForScreenButtons {

    return [UIFont fontWithName:@"Cochin-Bold" size:20.0];
}

+ (UIFont *) fontForConscienceHeader {

    return [UIFont fontWithName:@"Cochin-Bold" size:24.0];
}

+ (UIFont *) fontForTableViewCellDetailText {
    return [UIFont systemFontOfSize:14.0];

}

@end
