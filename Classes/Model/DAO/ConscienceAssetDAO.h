#import "ConscienceAsset.h"
#import "Moral.h"
@class ModelManager;

@interface ConscienceAssetDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ConscienceAsset *)read:(NSString *)key;
- (NSArray *)readAll;

- (int)count;

@end
