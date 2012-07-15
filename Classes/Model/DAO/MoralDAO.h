#import "BaseDAO.h"
#import "Moral.h"

@interface MoralDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (Moral *)read:(NSString *)key;

@end
