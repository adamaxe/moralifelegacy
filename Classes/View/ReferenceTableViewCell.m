#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ReferenceTableViewCell.h"
#import "UIColor+Utility.h"
#import "UIFont+Utility.h"

CGFloat const ReferenceTableViewCellImageBorderMargin = 1.1;
int const ReferenceTableViewCellTextMargin = 5;
int const ReferenceTableViewCellHeightDefault = 44;
int const ReferenceTableViewCellHeightFigure = 88;

@interface ReferenceTableViewCell ()

@property (nonatomic, assign, readwrite) CGFloat tableCellHeight;
@property (nonatomic) UIView *figureImageFrame;

@end

@implementation ReferenceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self.textLabel setTextColor:[UIColor moraLifeChoiceBlue]];
        [self.textLabel setFont:[UIFont fontForTableViewCellTextLarge]];
        [self.textLabel setNumberOfLines:1];
        [self.textLabel setAdjustsFontSizeToFitWidth:TRUE];

        UIView *figureImageFrame = [[UIView alloc] initWithFrame:self.imageView.frame];
        figureImageFrame.backgroundColor = [UIColor clearColor];
        figureImageFrame.layer.borderColor = [[UIColor moraLifeBrown] CGColor];
        figureImageFrame.layer.borderWidth = 2.0;
        figureImageFrame.layer.backgroundColor = [[UIColor clearColor] CGColor];
        figureImageFrame.layer.cornerRadius = 4.0;

        figureImageFrame.hidden = YES;
        [self addSubview:figureImageFrame];
        self.figureImageFrame = figureImageFrame;

    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    if (self.referenceType == ReferenceTableViewCellTypeFigure) {
        CGRect cellImageViewFrame = self.imageView.frame;
        self.figureImageFrame.frame = CGRectMake(cellImageViewFrame.origin.x, cellImageViewFrame.origin.y, cellImageViewFrame.size.width * ReferenceTableViewCellImageBorderMargin, cellImageViewFrame.size.height * ReferenceTableViewCellImageBorderMargin);
        self.figureImageFrame.center = self.imageView.center;

        CGRect textLabelFrame = self.textLabel.frame;
        textLabelFrame.origin.x += ReferenceTableViewCellTextMargin;
        self.textLabel.frame = textLabelFrame;

        CGRect detailTextLabelFrame = self.detailTextLabel.frame;
        detailTextLabelFrame.origin.x += ReferenceTableViewCellTextMargin;
        self.detailTextLabel.frame = detailTextLabelFrame;
        [self bringSubviewToFront:self.imageView];
    }

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
        self.figureImageFrame.hidden = !(referenceType == ReferenceTableViewCellTypeFigure);
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
