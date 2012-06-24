@class ConscienceAsset;

@interface ConscienceAssetDAO : NSObject

- (id)initWithKey:(NSString *)key;

- (NSString *)readLongDescription:(NSString *)key;
- (NSString *)readDisplayName:(NSString *)key;
- (NSString *)readImageName:(NSString *)key;

- (NSArray *)readAllNames;
- (NSArray *)readAllDisplayNames;
- (NSArray *)readAllImageNames;
- (NSArray *)readAllDetails;

@end
