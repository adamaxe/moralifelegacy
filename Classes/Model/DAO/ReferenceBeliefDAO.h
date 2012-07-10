#import "ReferenceBelief.h"
#import "ReferencePerson.h"

@class ModelManager;

@interface ReferenceBeliefDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ReferenceBelief *)read:(NSString *)key;
- (NSArray *)readAll;

@end
