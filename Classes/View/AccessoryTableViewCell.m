#import "AccessoryTableViewCell.h"
#import "UIColor+Utility.h"
#import "UIFont+Utility.h"

@implementation AccessoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.isAffordable = FALSE;
        //Configure cell text
        self.textLabel.font = [UIFont fontForTableViewCellText];
        self.textLabel.numberOfLines = 1;
        self.textLabel.adjustsFontSizeToFitWidth = TRUE;
        self.textLabel.textColor = [UIColor moraLifeChoiceBlue];
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        //Configure cell subtitle text
        self.detailTextLabel.font = [UIFont fontForTableViewCellDetailText];
        self.detailTextLabel.numberOfLines = 1;
        self.detailTextLabel.adjustsFontSizeToFitWidth = TRUE;
        
        self.detailTextLabel.minimumScaleFactor = 8.0/self.detailTextLabel.font.pointSize;
        
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
        self.imageView.image = accessoryImage;
        _accessoryImage = accessoryImage;
    }
}

@end
