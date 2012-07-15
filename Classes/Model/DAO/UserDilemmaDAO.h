#import "BaseDAO.h"
#import "UserDilemma.h"

@interface UserDilemmaDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (UserDilemma *)create;
- (UserDilemma *)read:(NSString *)key;

@end