#import "BaseDAO.h"
#import "Character.h"

@interface CharacterDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (Character *)read:(NSString *)key;

@end
