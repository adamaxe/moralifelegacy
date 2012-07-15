#import "BaseDAO.h"
#import "UserCharacter.h"

@interface UserCharacterDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (UserCharacter *)create;
- (UserCharacter *)read:(NSString *)key;

@end
