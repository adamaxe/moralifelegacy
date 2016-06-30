#import "ReportMoralTableViewCell.h"
#import "UIFont+Utility.h"

@implementation ReportMoralTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        (self.textLabel).shadowColor = [UIColor lightGrayColor];
        (self.textLabel).shadowOffset = CGSizeMake(1, 1);

        (self.textLabel).numberOfLines = 1;
        [self.textLabel setAdjustsFontSizeToFitWidth:TRUE];
        self.selectionStyle = UITableViewCellSelectionStyleNone;


    }
    return self;
}

- (void)setMoralImage:(UIImage *)moralImage {
    if (![_moralImage isEqual:moralImage]) {
        (self.imageView).image = moralImage;
        _moralImage = moralImage;
    }
}

- (void)setMoralColor:(UIColor *)moralColor {
    if (![_moralColor isEqual:moralColor]) {
        (self.textLabel).textColor = moralColor;
        _moralColor = moralColor;
    }

}

@end
