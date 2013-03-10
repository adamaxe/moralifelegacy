#import "ConscienceView.h"
#import "ConscienceMind.h"

@class ConscienceBody, ConscienceAccessories, ConscienceView, ConscienceMind;
@interface UserConscience : NSObject

@property (nonatomic, strong) ConscienceBody *userConscienceBody;   /**< Representation of User's Conscience */
@property (nonatomic, strong) ConscienceAccessories *userConscienceAccessories;     /**< Representation of User's Accessories */
@property (nonatomic, strong) ConscienceView *userConscienceView;   /**< Visual representation of User's Conscience+Accessories */
@property (nonatomic, strong) ConscienceMind *userConscienceMind;   /**< Representation of User's Mental State */

@end
