/**
 Custom TableViewCell for Choices.  Changes styling of text on virtue or vice.

 @class ChoiceTableViewCell

 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 01/12/2013
 */

@interface ChoiceTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isVirtue;    /**< whether Choice is Virtue or Vice */
@property (nonatomic) UIImage *moralImage;      /**< image for Choice's moral */

@end
