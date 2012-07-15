#import "BaseDAO.h"
#import "ReferencePerson.h"

@interface ReferencePersonDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ReferencePerson *)read:(NSString *)key;

@end
