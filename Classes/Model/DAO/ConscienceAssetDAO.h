@class ConscienceAsset, ModelManager;

@interface ConscienceAssetDAO : NSObject

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (int)readCost:(NSString *)key;
- (NSString *)readShortDescription:(NSString *)key;
- (NSString *)readLongDescription:(NSString *)key;
- (NSString *)readDisplayName:(NSString *)key;
- (NSString *)readImageName:(NSString *)key;
- (NSString *)readMoralImageName:(NSString *)key;

- (NSArray *)readAllNames;
- (NSArray *)readAllDisplayNames;
- (NSArray *)readAllImageNames;
- (NSArray *)readAllDetails;

@end
