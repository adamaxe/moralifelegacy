#import "DilemmaTableViewCell.h"

@implementation DilemmaTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //Setup cell text visuals
        [self.detailTextLabel setTextColor:[UIColor colorWithRed:0.0/255.0 green:176.0/255.0 blue:0.0/255.0 alpha:1]];
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
            [self.textLabel setTextColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1]];
            [self.detailTextLabel setTextColor:[UIColor colorWithRed:200.0/255.0 green:25.0/255.0 blue:2.0/255.0 alpha:1]];
            [self.textLabel setFont:[UIFont systemFontOfSize:12.0]];

        } break;
        case DilemmaTableViewCellStateAvailable: {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.selectionStyle = UITableViewCellSelectionStyleGray;
            [self.textLabel setTextColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1]];
            [self.detailTextLabel setTextColor:[UIColor colorWithRed:0.0/255.0 green:176.0/255.0 blue:0.0/255.0 alpha:1]];

        } break;
        case DilemmaTableViewCellStateUnavailable: {
            [self.textLabel setTextColor:[UIColor colorWithRed:100.0/255.0 green:150.00/255.0 blue:100.0/255.0 alpha:1]];
            [self.detailTextLabel setTextColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1]];

            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleNone;

        } break;

        default:
            break;
    }

}

@end
