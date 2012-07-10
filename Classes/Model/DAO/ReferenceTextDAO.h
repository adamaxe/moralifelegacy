#import "ReferenceText.h"

@class ModelManager;

@interface ReferenceTextDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ReferenceText *)read:(NSString *)key;
- (NSArray *)readAll;

@end
