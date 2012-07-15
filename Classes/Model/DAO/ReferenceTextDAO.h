#import "BaseDAO.h"
#import "ReferenceText.h"

@interface ReferenceTextDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ReferenceText *)read:(NSString *)key;

@end
