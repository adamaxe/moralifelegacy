/**
Custom TableViewCell for Reference Assets.  Changes styling of text and allows for differing heights and a cell type.  Also adds frame around Figures if that cell type is is figure.

@class ReferenceTableViewCell

@author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 01/12/2013
 */

@interface ReferenceTableViewCell : UITableViewCell

/**
 Cell type to differentiate image border, height
 */
typedef enum {
    ReferenceTableViewCellTypeAsset,
    ReferenceTableViewCellTypeFigure,
    ReferenceTableViewCellTypeMoral
} ReferenceTableViewCellType;

@property (nonatomic) UIImage *referenceImage;  /**< image for Reference */
@property (nonatomic, assign) ReferenceTableViewCellType referenceType; /**< moralife cell type */
@property (nonatomic, assign, readonly) CGFloat tableCellHeight;    /**< custom cell height to account for image border */

@end
