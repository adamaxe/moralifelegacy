#import "ChoiceTableViewCell.h"
#import "UIColor+Utility.h"
#import "UIFont+Utility.h"

@implementation ChoiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.isVirtue = FALSE;
        
        self.textLabel.minimumScaleFactor = 12.0/self.detailTextLabel.font.pointSize;

        //Set cell content wrapping
         self.textLabel.textColor = [UIColor moraLifeChoiceBlue];
        self.textLabel.font = [UIFont fontForTableViewCellTextLarge];
        self.textLabel.numberOfLines = 1;
        self.textLabel.adjustsFontSizeToFitWidth = TRUE;
        [self.textLabel sizeToFit];

    }
    return self;
}

- (void)prepareForReuse {
    self.isVirtue = FALSE;
}

- (void)setIsVirtue:(BOOL)isVirtue {
    if (isVirtue) {
        self.detailTextLabel.textColor = [UIColor moraLifeChoiceGreen];
    } else {
        self.detailTextLabel.textColor = [UIColor moraLifeChoiceRed];
    }

    _isVirtue = isVirtue;
        
}

- (void)setMoralImage:(UIImage *)moralImage {
    if (![_moralImage isEqual:moralImage]) {
        self.imageView.image = moralImage;
        _moralImage = moralImage;
    }
}

@end
