#import "DilemmaTableViewCell.h"
#import "UIColor+Utility.h"
#import "UIFont+Utility.h"

@implementation DilemmaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //Setup cell text visuals
        (self.detailTextLabel).textColor = [UIColor moraLifeBrightGreen];
        (self.textLabel).font = [UIFont fontForTableViewCellText];
        (self.textLabel).numberOfLines = 1;
        [self.textLabel setAdjustsFontSizeToFitWidth:TRUE];
        [self.detailTextLabel setAdjustsFontSizeToFitWidth:TRUE];
        self.textLabel.alpha = 1.0f;
        self.detailTextLabel.alpha = 1.0f;
        self.imageView.alpha = 1.0f;
    }
    return self;
}

- (void)setCurrentCellState:(DilemmaTableViewCellState)currentCellState {
    _currentCellState = currentCellState;

    [self styleCellForState:currentCellState];

}

- (void)setDilemmaImage:(UIImage *)dilemmaImage {
    if (![_dilemmaImage isEqual:dilemmaImage]) {
        (self.imageView).image = dilemmaImage;
        _dilemmaImage = dilemmaImage;
    }
}

-(void)prepareForReuse {
    [super prepareForReuse];
    [self styleCellForState:DilemmaTableViewCellStateUnavailable];
}

#pragma mark - Cell Configuration
- (void)setupDefaultCellState {

}

- (void)styleCellForState:(DilemmaTableViewCellState)cellState {
    switch (cellState) {
        case DilemmaTableViewCellStateFinished: {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            (self.textLabel).textColor = [UIColor moraLifeChoiceLightGray];
            (self.detailTextLabel).textColor = [UIColor moraLifeChoiceLightGreen];
            (self.textLabel).font = [UIFont fontForTableViewCellText];

            self.textLabel.alpha = 0.6f;
            self.detailTextLabel.alpha = 0.6f;
            self.imageView.alpha = 0.2f;

        } break;
        case DilemmaTableViewCellStateAvailable: {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.selectionStyle = UITableViewCellSelectionStyleGray;
            (self.textLabel).font = [UIFont fontForTableViewCellTextLarge];

            (self.textLabel).textColor = [UIColor moraLifeChoiceRed];
            (self.detailTextLabel).textColor = [UIColor moraLifeChoiceBlue];
            self.textLabel.alpha = 1.0f;
            self.detailTextLabel.alpha = 1.0f;
            self.imageView.alpha = 1.0f;

        } break;
        case DilemmaTableViewCellStateUnavailable: {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            (self.textLabel).font = [UIFont fontForTableViewCellText];

            (self.textLabel).textColor = [UIColor moraLifeChoiceLightGreen];
            (self.detailTextLabel).textColor = [UIColor moraLifeChoiceLightGray];
            self.textLabel.alpha = 1.0f;
            self.detailTextLabel.alpha = 1.0f;
            self.imageView.alpha = 1.0f;

        } break;

        default:
            break;
    }

}

@end
