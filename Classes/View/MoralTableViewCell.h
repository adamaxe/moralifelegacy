/**
 Custom TableViewCell for Moral Cell.  Allows for setting of image and setting of pre-defined row colors dependent upon Moral type.

 @class MoralTableViewCell

 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 01/12/2013
 */

@interface MoralTableViewCell : UITableViewCell

extern int const MoralTableViewCellRowTextPaddingVertical;
extern CGFloat const MoralTableViewCellDefaultHeight;
extern CGFloat const MoralTableViewCellRowTextHeight;

@property (nonatomic) NSString *moralName;  /**< name of Moral */
@property (nonatomic) NSString *moralSynonyms; /**< other names of Moral */
@property (nonatomic) UIColor *moralColor;  /**< color to match image icon */
@property (nonatomic) UIImage *moralImage;  /**< moral icon */

/**
Static method to return what the detailTextLabel's height will be based upon font and cell width

 @param text NSString to fill the detailTextLabel
 @return height CGFloat of the height of the text
 */
+ (CGFloat)heightForDetailTextLabel:(NSString *)text;

@end
