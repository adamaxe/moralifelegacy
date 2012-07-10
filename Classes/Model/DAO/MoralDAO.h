#import "Moral.h"

@class ModelManager;

@interface MoralDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (Moral *)read:(NSString *)key;
- (NSArray *)readAll;

@end
