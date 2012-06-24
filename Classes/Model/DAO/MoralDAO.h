@class Moral, ModelManager;

@interface MoralDAO : NSObject

- (id)initWithModelManager:(ModelManager *) moralModelManager;
- (id)initWithModelManager:(ModelManager *) moralModelManager andType:(NSString *)type;

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
