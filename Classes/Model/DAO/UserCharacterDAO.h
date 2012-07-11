#import "UserCharacter.h"

@class ModelManager;

@interface UserCharacterDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (UserCharacter *)read:(NSString *)key;
- (NSArray *)readAll;
- (BOOL) update;

@end
