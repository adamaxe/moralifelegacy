#import "UserCharacter.h"

@class ModelManager;

@interface UserCharacterDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (UserCharacter *)create;
- (UserCharacter *)read:(NSString *)key;
- (NSArray *)readAll;
- (BOOL) update;
- (BOOL)delete:(UserCharacter *)character;

@end
