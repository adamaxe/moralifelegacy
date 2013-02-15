#import "ReportMoralTableViewCell.h"
#import "UIFont+Utility.h"

@implementation ReportMoralTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self.textLabel setShadowColor:[UIColor lightGrayColor]];
        [self.textLabel setShadowOffset:CGSizeMake(1, 1)];

        [self.textLabel setFont:[UIFont fontForTableViewCellTextLarge]];
        [self.textLabel setNumberOfLines:1];
        [self.textLabel setAdjustsFontSizeToFitWidth:TRUE];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];


    }
    return self;
}

- (void)setMoralImage:(UIImage *)moralImage {
    if (![_moralImage isEqual:moralImage]) {
        [self.imageView setImage:moralImage];
        _moralImage = moralImage;
    }
}

- (void)setMoralColor:(UIColor *)moralColor {
    if (![_moralColor isEqual:moralColor]) {
        [self.textLabel setTextColor:moralColor];
        _moralColor = moralColor;
    }

}

@end
