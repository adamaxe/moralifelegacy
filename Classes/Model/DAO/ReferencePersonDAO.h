#import "ReferencePerson.h"

@class ModelManager;

@interface ReferencePersonDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ReferencePerson *)read:(NSString *)key;
- (NSArray *)readAll;

@end
