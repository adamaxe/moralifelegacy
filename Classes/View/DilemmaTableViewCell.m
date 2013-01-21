#import "DilemmaTableViewCell.h"
#import "UIColor+Utility.h"

@implementation DilemmaTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //Setup cell text visuals
        [self.detailTextLabel setTextColor:[UIColor moraLifeBrightGreen]];
        [self.textLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self.textLabel setNumberOfLines:1];
        [self.textLabel setAdjustsFontSizeToFitWidth:TRUE];
        [self.detailTextLabel setAdjustsFontSizeToFitWidth:TRUE];
        

    }
    return self;
}

- (void)setCurrentCellState:(DilemmaTableViewCellState)currentCellState {
    if (_currentCellState != currentCellState) {
        [self styleCellForState:currentCellState];
    }

    _currentCellState = currentCellState;
        
}

- (void)setDilemmaImage:(UIImage *)dilemmaImage {
    if (![_dilemmaImage isEqual:dilemmaImage]) {
        [self.imageView setImage:dilemmaImage];
        _dilemmaImage = dilemmaImage;
    }
}

- (void)styleCellForState:(DilemmaTableViewCellState)cellState {
    switch (cellState) {
        case DilemmaTableViewCellStateFinished: {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            [self.textLabel setTextColor:[UIColor moraLifeChoiceLightGray]];
            [self.detailTextLabel setTextColor:[UIColor moraLifeChoiceLightGreen]];
            [self.textLabel setFont:[UIFont systemFontOfSize:12.0]];

        } break;
        case DilemmaTableViewCellStateAvailable: {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.selectionStyle = UITableViewCellSelectionStyleGray;
            [self.textLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
            [self.textLabel setTextColor:[UIColor moraLifeChoiceRed]];
            [self.detailTextLabel setTextColor:[UIColor moraLifeChoiceBlue]];

        } break;
        case DilemmaTableViewCellStateUnavailable: {
            [self.textLabel setTextColor:[UIColor moraLifeChoiceLightGreen]];
            [self.detailTextLabel setTextColor:[UIColor moraLifeChoiceLightGray]];

            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleNone;

        } break;

        default:
            break;
    }

}

@end
