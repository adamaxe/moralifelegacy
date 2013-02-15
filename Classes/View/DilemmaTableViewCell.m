#import "DilemmaTableViewCell.h"
#import "UIColor+Utility.h"
#import "UIFont+Utility.h"

@implementation DilemmaTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //Setup cell text visuals
        [self.detailTextLabel setTextColor:[UIColor moraLifeBrightGreen]];
        [self.textLabel setFont:[UIFont fontForTableViewCellText]];
        [self.textLabel setNumberOfLines:1];
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
        [self.imageView setImage:dilemmaImage];
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
            [self.textLabel setTextColor:[UIColor moraLifeChoiceLightGray]];
            [self.detailTextLabel setTextColor:[UIColor moraLifeChoiceLightGreen]];
            [self.textLabel setFont:[UIFont fontForTableViewCellText]];

            self.textLabel.alpha = 0.6f;
            self.detailTextLabel.alpha = 0.6f;
            self.imageView.alpha = 0.2f;

        } break;
        case DilemmaTableViewCellStateAvailable: {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.selectionStyle = UITableViewCellSelectionStyleGray;
            [self.textLabel setFont:[UIFont fontForTableViewCellTextLarge]];

            [self.textLabel setTextColor:[UIColor moraLifeChoiceRed]];
            [self.detailTextLabel setTextColor:[UIColor moraLifeChoiceBlue]];
            self.textLabel.alpha = 1.0f;
            self.detailTextLabel.alpha = 1.0f;
            self.imageView.alpha = 1.0f;

        } break;
        case DilemmaTableViewCellStateUnavailable: {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            [self.textLabel setFont:[UIFont fontForTableViewCellText]];

            [self.textLabel setTextColor:[UIColor moraLifeChoiceLightGreen]];
            [self.detailTextLabel setTextColor:[UIColor moraLifeChoiceLightGray]];
            self.textLabel.alpha = 1.0f;
            self.detailTextLabel.alpha = 1.0f;
            self.imageView.alpha = 1.0f;

        } break;

        default:
            break;
    }

}

@end
