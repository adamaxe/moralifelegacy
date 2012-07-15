#import "BaseDAO.h"
#import "Dilemma.h"

@interface DilemmaDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (Dilemma *)read:(NSString *)key;

@end
