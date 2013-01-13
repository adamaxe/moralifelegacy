#import "MoralTableViewCell.h"

@implementation MoralTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self.textLabel setShadowColor:[UIColor lightGrayColor]];
        [self.textLabel setShadowOffset:CGSizeMake(1, 1)];

        [self.textLabel setFont:[UIFont systemFontOfSize:18.0]];
        [self.textLabel setNumberOfLines:1];
        [self.textLabel setAdjustsFontSizeToFitWidth:TRUE];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];


    }
    return self;
}

- (void)setMoralName:(NSString *)moralName {
    if (![_moralName isEqualToString:moralName]) {
        _moralName = moralName;
        [self.textLabel setText: [_moralName capitalizedString]];
    }

}

- (void)setMoralSynonyms:(NSString *)moralSynonyms {
    if(![_moralSynonyms isEqualToString:moralSynonyms]) {
        _moralSynonyms = moralSynonyms;
        [self.detailTextLabel setText:_moralSynonyms];
    }
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
