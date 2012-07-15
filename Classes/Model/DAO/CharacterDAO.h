#import "Character.h"
#import "Dilemma.h"

@class ModelManager;

@interface CharacterDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (Character *)read:(NSString *)key;
- (NSArray *)readAll;

- (int)count;

@end
