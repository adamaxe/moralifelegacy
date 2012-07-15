#import "Dilemma.h"
#import "Moral.h"
#import "Character.h"

@class ModelManager;

@interface DilemmaDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (Dilemma *)read:(NSString *)key;
- (NSArray *)readAll;

- (int)count;

@end
