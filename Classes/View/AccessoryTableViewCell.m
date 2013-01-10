#import "AccessoryTableViewCell.h"

@implementation AccessoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.isAffordable = FALSE;
        //Configure cell text
        [self.textLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.textLabel setNumberOfLines:1];
        [self.textLabel setAdjustsFontSizeToFitWidth:TRUE];
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
		self.detailTextLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:176.0/255.0 blue:0.0/255.0 alpha:1];
    } else {
		self.accessoryType = UITableViewCellAccessoryNone;
		self.detailTextLabel.textColor = [UIColor colorWithRed:200.0/255.0 green:25.0/255.0 blue:2.0/255.0 alpha:1];
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
