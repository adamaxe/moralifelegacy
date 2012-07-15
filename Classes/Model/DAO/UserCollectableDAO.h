#import "BaseDAO.h"
#import "UserCollectable.h"

@interface UserCollectableDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (UserCollectable *)create;
- (UserCollectable *)read:(NSString *)key;

@end
