#import "BaseDAO.h"
#import "ReferenceBelief.h"

@interface ReferenceBeliefDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ReferenceBelief *)read:(NSString *)key;

@end
