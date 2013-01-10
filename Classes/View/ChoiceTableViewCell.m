#import "ChoiceTableViewCell.h"

@implementation ChoiceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.isVirtue = FALSE;
        [self.textLabel setMinimumFontSize:12.0];

        //Set cell content wrapping
        [self.textLabel setFont:[UIFont systemFontOfSize:18.0]];
        [self.textLabel setNumberOfLines:1];
        [self.textLabel setAdjustsFontSizeToFitWidth:TRUE];

    }
    return self;
}

- (void)prepareForReuse {
    _isVirtue = FALSE;
}

- (void)setIsVirtue:(BOOL)isVirtue {
    if (isVirtue) {
        [self.detailTextLabel setTextColor:[UIColor colorWithRed:0.0/255.0 green:176.0/255.0 blue:0.0/255.0 alpha:1]];
    } else {
        [self.detailTextLabel setTextColor:[UIColor colorWithRed:200.0/255.0 green:25.0/255.0 blue:2.0/255.0 alpha:1]];
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
