#import "UserDilemma.h"

@class ModelManager;

@interface UserDilemmaDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (UserDilemma *)create;
- (UserDilemma *)read:(NSString *)key;
- (NSArray *)readAll;
- (BOOL)update;
- (BOOL)delete:(UserDilemma *)dilemma;

@end
