#import "ReferenceTableViewCell.h"

@implementation ReferenceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self.textLabel setFont:[UIFont systemFontOfSize:18.0]];
        [self.textLabel setNumberOfLines:1];
        [self.textLabel setAdjustsFontSizeToFitWidth:TRUE];

    }
    return self;
}

- (void)setReferenceImage:(UIImage *)referenceImage {
    if (![_referenceImage isEqual:referenceImage]) {
        [self.imageView setImage:referenceImage];
        _referenceImage = referenceImage;
    }
}

@end
