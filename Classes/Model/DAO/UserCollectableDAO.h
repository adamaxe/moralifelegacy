#import "UserCollectable.h"

@class ModelManager;

@interface UserCollectableDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (UserCollectable *)create;
- (UserCollectable *)read:(NSString *)key;
- (NSArray *)readAll;
- (BOOL)update;
- (BOOL)delete:(UserCollectable *)dilemma;

- (int)count;

@end
