#import "BaseDAO.h"
#import "UserChoice.h"

@interface UserChoiceDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (UserChoice *)create;
- (UserChoice *)read:(NSString *)key;

@end
