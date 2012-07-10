#import "ReferenceAsset.h"

@class ModelManager;

@interface ReferenceAssetDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ReferenceAsset *)read:(NSString *)key;
- (NSArray *)readAll;

@end
