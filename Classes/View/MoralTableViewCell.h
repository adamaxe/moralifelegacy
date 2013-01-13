/**
 Custom TableViewCell for Moral Cell.  Allows for setting of image and setting of pre-defined row colors dependent upon Moral type.

 @class MoralTableViewCell

 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 01/12/2013
 */

@interface MoralTableViewCell : UITableViewCell

extern CGFloat const MoralTableViewCellDefaultHeight;

@property (nonatomic) NSString *moralName;  /**< name of Moral */
@property (nonatomic) NSString *moralSynonyms; /**< other names of Moral */
@property (nonatomic) UIColor *moralColor;  /**< color to match image icon */
@property (nonatomic) UIImage *moralImage;  /**< moral icon */

+ (CGFloat)heightForTextLabels:(NSString *)text;

@end
