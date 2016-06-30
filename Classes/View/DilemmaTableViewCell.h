/**
 Custom TableViewCell for Dilemmas.  Changes styling of text to communicate selectability.

 @class DilemmaTableViewCell

 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 01/12/2013
 */

@interface DilemmaTableViewCell : UITableViewCell

/**
 Cell type to differentiate user state of dilemma
 */
typedef NS_ENUM(unsigned int, DilemmaTableViewCellState) {
    DilemmaTableViewCellStateAvailable,
    DilemmaTableViewCellStateUnavailable,
    DilemmaTableViewCellStateFinished
};

@property (nonatomic, assign) DilemmaTableViewCellState currentCellState;   /**< whether cell is available, unfinished, etc. */
@property (nonatomic) UIImage *dilemmaImage;    /**< image for Dilemma */

@end
