#import "AccessoryTableViewCell.h"
#import "UIColor+Utility.h"

@implementation AccessoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.isAffordable = FALSE;
        //Configure cell text
        [self.textLabel setFont:[UIFont fontWithName:@"Cochin-Bold" size:16.0]];
        [self.textLabel setNumberOfLines:1];
        [self.textLabel setAdjustsFontSizeToFitWidth:TRUE];
        [self.textLabel setTextColor:[UIColor moraLifeChoiceBlue]];
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        //Configure cell subtitle text
        [self.detailTextLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.detailTextLabel setNumberOfLines:1];
        [self.detailTextLabel setAdjustsFontSizeToFitWidth:TRUE];
        [self.detailTextLabel setMinimumFontSize:8.0];

    }
    return self;
}

- (void)setIsAffordable:(BOOL)isAffordable {
    if (isAffordable) {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.selectionStyle = UITableViewCellSelectionStyleGray;
		self.detailTextLabel.textColor = [UIColor moraLifeChoiceGreen];
    } else {
		self.accessoryType = UITableViewCellAccessoryNone;
		self.detailTextLabel.textColor = [UIColor moraLifeChoiceRed];
    }

    _isAffordable = isAffordable;
        
}

- (void)setAccessoryImage:(UIImage *)accessoryImage {
    if (![_accessoryImage isEqual:accessoryImage]) {
        [self.imageView setImage:accessoryImage];
        _accessoryImage = accessoryImage;
    }
}

@end
