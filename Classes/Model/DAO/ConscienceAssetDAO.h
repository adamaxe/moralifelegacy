#import "BaseDAO.h"
#import "ConscienceAsset.h"

@interface ConscienceAssetDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ConscienceAsset *)read:(NSString *)key;

@end
