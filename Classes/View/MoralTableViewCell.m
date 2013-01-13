#import "MoralTableViewCell.h"

CGFloat const MoralTableViewCellDefaultHeight = 44;

int const MoralTableViewCellMaximumLineNumber = 5;
int const MoralTableViewCellRowTextWidth = 200;
int const MoralTableViewCellRowTextPaddingHorizontal = 10;
int const MoralTableViewCellRowTextPaddingVertical = 3;
CGFloat const MoralTableViewCellRowTextHeight = 32.0;
CGFloat const MoralTableViewCellRowImageDimension = 40.0;
CGFloat const MoralTableViewCellTextLabelFontSize = 18.0;
CGFloat const MoralTableViewCellDetailTextLabelFontSize = 14.0;

@implementation MoralTableViewCell

+ (CGFloat)heightForTextLabels:(NSString *)text {

    UIFont *textFont = [UIFont systemFontOfSize:MoralTableViewCellTextLabelFontSize];
    UIFont *detailTextFont = [UIFont systemFontOfSize:MoralTableViewCellDetailTextLabelFontSize];
    CGSize constraintSize = CGSizeMake(MoralTableViewCellRowTextWidth, CGFLOAT_MAX);
    CGFloat textHeight = [text sizeWithFont:textFont constrainedToSize:constraintSize].height + [text sizeWithFont:detailTextFont constrainedToSize:constraintSize].height;
    return MIN(textHeight, (detailTextFont.pointSize * MoralTableViewCellMaximumLineNumber) + 1);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self.textLabel setShadowColor:[UIColor lightGrayColor]];
        [self.textLabel setShadowOffset:CGSizeMake(1, 1)];

        [self.textLabel setFont:[UIFont systemFontOfSize:MoralTableViewCellTextLabelFontSize]];
        [self.textLabel setNumberOfLines:1];
        [self.textLabel setAdjustsFontSizeToFitWidth:TRUE];

        [self.detailTextLabel setFont:[UIFont systemFontOfSize:MoralTableViewCellDetailTextLabelFontSize]];
        [self.detailTextLabel setNumberOfLines:0];

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    }
    return self;
}

-(void)prepareForReuse {
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.backgroundColor = [UIColor greenColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];

    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.size.width = MoralTableViewCellRowImageDimension;
    imageViewFrame.size.height = MoralTableViewCellRowImageDimension;
    self.imageView.frame = imageViewFrame;

    CGRect textLabelFrame = self.detailTextLabel.frame;
    textLabelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + MoralTableViewCellRowTextPaddingHorizontal;
    textLabelFrame.origin.y = self.imageView.frame.origin.y;
    textLabelFrame.size.width = MoralTableViewCellRowTextWidth;
    textLabelFrame.size.height = MoralTableViewCellRowTextHeight;
    self.textLabel.frame = textLabelFrame;

    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    CGFloat moralSynonymHeight = [MoralTableViewCell heightForTextLabels:self.moralSynonyms];
    detailTextLabelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + MoralTableViewCellRowTextPaddingHorizontal;
    detailTextLabelFrame.origin.y = CGRectGetMaxY(self.textLabel.frame);
    detailTextLabelFrame.size.width = MoralTableViewCellRowTextWidth;
    detailTextLabelFrame.size.height = moralSynonymHeight;

    self.detailTextLabel.frame = detailTextLabelFrame;
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
