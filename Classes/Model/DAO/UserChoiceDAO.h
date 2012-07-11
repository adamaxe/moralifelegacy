#import "UserChoice.h"

@class ModelManager;

@interface UserChoiceDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (UserChoice *)read:(NSString *)key;
- (NSArray *)readAll;

@end
