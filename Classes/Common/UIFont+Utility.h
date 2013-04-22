/**
 UIFont utility category.  Allow creation of a UIFont using standard Font Family Name

 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 02/14/2013
 */

@interface UIFont (Utility)

/**
 Class method for creating a UIFont for UINavigationBar title
 @return UIFont tableCellFont
 */
+ (UIFont *) fontForNavigationBarTitle;

/**
 Class method for creating a UIFont for UITableViewCell text
 @return UIFont tableCellFont
 */
+ (UIFont *) fontForTableViewCellText;

/**
 Class method for creating a UIFont for major UITableViewCell text
 @return UIFont tableCellFont
 */
+ (UIFont *) fontForTableViewCellTextLarge;

/**
 Class method for creating a UIFont for UITableViewCell detailText
 @return UIFont tableCellFont
 */
+ (UIFont *) fontForTableViewCellDetailText;

/**
 Class method for creating a UIFont for Text Entry labels
 @return UIFont tableCellFont
 */
+ (UIFont *) fontForTextLabels;

/**
 Class method for creating a UIFont for Home Screen Button Labels
 @return UIFont tableCellFont
 */
+ (UIFont *) fontForHomeScreenButtons;

/**
 Class method for creating a UIFont for Screen Button Labels
 @return UIFont tableCellFont
 */
+ (UIFont *) fontForScreenButtons;

/**
 Class method for creating a UIFont for Conscience Modal views
 @return UIFont tableCellFont
 */
+ (UIFont *) fontForConscienceHeader;

@end
