/**
 Custom TableViewCell for Report Rows Assets.  Allows for setting of image and custom row color.

 @class ReportMoralTableViewCell

 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 01/12/2013
 */

@interface ReportMoralTableViewCell : UITableViewCell

@property (nonatomic) UIColor *moralColor;  /**< color to match image icon */
@property (nonatomic) UIImage *moralImage;  /**< moral icon */

@end
