#import "BaseDAO.h"
#import "ReferenceAsset.h"

@interface ReferenceAssetDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ReferenceAsset *)read:(NSString *)key;

@end
