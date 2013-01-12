#import "ReferenceTableViewCell.h"

#define ReferenceTableViewCellHeightDefault 44
#define ReferenceTableViewCellHeightFigure 60

@interface ReferenceTableViewCell ()

@property (nonatomic, assign, readwrite) CGFloat tableCellHeight;

@end

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

-(void)layoutSubviews {
    [super layoutSubviews];

}


#pragma mark - Overridden getters

- (CGFloat)tableCellHeight {
    return (self.referenceType == ReferenceTableViewCellTypeFigure) ?ReferenceTableViewCellHeightFigure : ReferenceTableViewCellHeightDefault;
}

#pragma mark - 
#pragma mark Overridden setters

- (void)setReferenceType:(ReferenceTableViewCellType)referenceType {
    if (_referenceType != referenceType) {
        _referenceType = referenceType;
        [self setNeedsDisplay];
    }
}

- (void)setReferenceImage:(UIImage *)referenceImage {
    if (![_referenceImage isEqual:referenceImage]) {
        [self.imageView setImage:referenceImage];
        _referenceImage = referenceImage;
    }
}

@end
