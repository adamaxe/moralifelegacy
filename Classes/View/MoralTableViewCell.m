#import "MoralTableViewCell.h"
#import "UIColor+Utility.h"
#import "UIFont+Utility.h"

//Externalized constants
int const MoralTableViewCellRowTextPaddingVertical = 3;
CGFloat const MoralTableViewCellDefaultHeight = 44;
CGFloat const MoralTableViewCellRowTextHeight = 32.0;

int const MoralTableViewCellMaximumLineNumber = 5;
int const MoralTableViewCellRowTextWidth = 200;
int const MoralTableViewCellRowTextPaddingHorizontal = 10;
CGFloat const MoralTableViewCellRowImageDimension = 40.0;

@implementation MoralTableViewCell

+ (CGFloat)heightForDetailTextLabel:(NSString *)text {

    UIFont *detailTextFont = [UIFont fontForTableViewCellDetailText];
    CGSize constraintSize = CGSizeMake(MoralTableViewCellRowTextWidth, CGFLOAT_MAX);
        
    CGFloat textHeight = [text sizeWithFont:detailTextFont constrainedToSize:constraintSize].height;
    return MIN(textHeight, (detailTextFont.pointSize * MoralTableViewCellMaximumLineNumber) + MoralTableViewCellRowTextPaddingVertical);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.textLabel.textColor = [UIColor moraLifeChoiceBlue];

        self.textLabel.font = [UIFont fontForTableViewCellTextLarge];
        self.textLabel.numberOfLines = 1;
        self.textLabel.adjustsFontSizeToFitWidth = TRUE;
        [self.textLabel sizeToFit];

        self.detailTextLabel.font = [UIFont fontForTableViewCellDetailText];
        self.detailTextLabel.numberOfLines = 0;
        [self.detailTextLabel sizeToFit];

        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    //Since the cell's height can grow, we need to adjust the cell's contents accordingly
    //Prevent the imageview from scaling
    CGRect imageViewFrame = self.imageView.frame;
    imageViewFrame.size.width = MoralTableViewCellRowImageDimension;
    imageViewFrame.size.height = MoralTableViewCellRowImageDimension;
    self.imageView.frame = imageViewFrame;

    //Align the text label with the top of the imageView
    CGRect textLabelFrame = self.detailTextLabel.frame;
    textLabelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + MoralTableViewCellRowTextPaddingHorizontal;
    textLabelFrame.origin.y = self.imageView.frame.origin.y;
    textLabelFrame.size.width = MoralTableViewCellRowTextWidth;
    textLabelFrame.size.height = MoralTableViewCellRowTextHeight;
    self.textLabel.frame = textLabelFrame;

    //Generate a dynamic height based upon the current contents
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    CGFloat moralSynonymHeight = [MoralTableViewCell heightForDetailTextLabel:self.moralSynonyms];
    detailTextLabelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + MoralTableViewCellRowTextPaddingHorizontal;
    detailTextLabelFrame.origin.y = CGRectGetMaxY(self.textLabel.frame);
    detailTextLabelFrame.size.width = MoralTableViewCellRowTextWidth;
    detailTextLabelFrame.size.height = moralSynonymHeight;

    self.detailTextLabel.frame = detailTextLabelFrame;
}

- (void)setMoralName:(NSString *)moralName {
    if (![_moralName isEqualToString:moralName]) {
        _moralName = moralName;
        self.textLabel.text = _moralName.capitalizedString;
    }

}

- (void)setMoralSynonyms:(NSString *)moralSynonyms {
    if(![_moralSynonyms isEqualToString:moralSynonyms]) {
        _moralSynonyms = moralSynonyms;
        self.detailTextLabel.text = _moralSynonyms;
    }
}

- (void)setMoralImage:(UIImage *)moralImage {
    if (![_moralImage isEqual:moralImage]) {
        self.imageView.image = moralImage;
        _moralImage = moralImage;
    }
}

- (void)setMoralColor:(UIColor *)moralColor {
    if (![_moralColor isEqual:moralColor]) {
        self.textLabel.textColor = moralColor;
        _moralColor = moralColor;
    }

}

@end
