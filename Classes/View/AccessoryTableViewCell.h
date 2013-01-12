/**
 Custom TableViewCell for Accessories.  Changes styling of text to communicate affordability of accessory.

 @class AccessoryTableViewCell

 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 01/12/2013
 */

@interface AccessoryTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isAffordable;    /**< whether user can afford accessory */
@property (nonatomic) UIImage *accessoryImage;  /**< image for Accessory */

@end
