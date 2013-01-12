@interface ReferenceTableViewCell : UITableViewCell

typedef enum {
    ReferenceTableViewCellTypeAsset,
    ReferenceTableViewCellTypeFigure,
    ReferenceTableViewCellTypeMoral
} ReferenceTableViewCellType;

@property (nonatomic) UIImage *referenceImage;
@property (nonatomic, assign) ReferenceTableViewCellType referenceType;
@property (nonatomic, assign, readonly) CGFloat tableCellHeight;

@end
