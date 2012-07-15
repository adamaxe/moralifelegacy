#import "UserChoice.h"

@class ModelManager;

@interface UserChoiceDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (UserChoice *)create;
- (UserChoice *)read:(NSString *)key;
- (NSArray *)readAll;
- (BOOL)update;
- (BOOL)delete:(UserChoice *)dilemma;

- (int)count;

@end
