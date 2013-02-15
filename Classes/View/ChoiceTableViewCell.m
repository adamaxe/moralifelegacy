#import "ChoiceTableViewCell.h"
#import "UIColor+Utility.h"
#import "UIFont+Utility.h"

@implementation ChoiceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.isVirtue = FALSE;
        [self.textLabel setMinimumFontSize:12.0];

        //Set cell content wrapping
        [self.textLabel setTextColor:[UIColor moraLifeChoiceBlue]];
        [self.textLabel setFont:[UIFont fontForTableViewCellTextLarge]];
        [self.textLabel setNumberOfLines:1];
        [self.textLabel setAdjustsFontSizeToFitWidth:TRUE];
        [self.textLabel sizeToFit];

    }
    return self;
}

- (void)prepareForReuse {
    self.isVirtue = FALSE;
}

- (void)setIsVirtue:(BOOL)isVirtue {
    if (isVirtue) {
        [self.detailTextLabel setTextColor:[UIColor moraLifeChoiceGreen]];
    } else {
        [self.detailTextLabel setTextColor:[UIColor moraLifeChoiceRed]];
    }

    _isVirtue = isVirtue;
        
}

- (void)setMoralImage:(UIImage *)moralImage {
    if (![_moralImage isEqual:moralImage]) {
        [self.imageView setImage:moralImage];
        _moralImage = moralImage;
    }
}

@end
