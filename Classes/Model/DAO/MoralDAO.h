@class Moral, ModelManager;

@interface MoralDAO : NSObject

- (id)initWithType:(NSString *)type;
- (id)initWithType:(NSString *)type andModelManager:(ModelManager *)moralModelManager;

- (NSString *)readColor:(NSString *)key;
- (NSString *)readDefinition:(NSString *)key;
- (NSString *)readLongDescription:(NSString *)key;
- (NSString *)readDisplayName:(NSString *)key;
- (NSString *)readImageName:(NSString *)key;

- (NSArray *)readAllNames;
- (NSArray *)readAllDisplayNames;
- (NSArray *)readAllImageNames;
- (NSArray *)readAllDetails;

@end
