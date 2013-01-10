@interface DilemmaTableViewCell : UITableViewCell

typedef enum {
    DilemmaTableViewCellStateAvailable,
    DilemmaTableViewCellStateUnavailable,
    DilemmaTableViewCellStateFinished
} DilemmaTableViewCellState;

@property (nonatomic, assign) DilemmaTableViewCellState currentCellState;
@property (nonatomic) UIImage *dilemmaImage;

@end
