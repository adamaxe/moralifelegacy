#import "ReferenceAsset.h"

@class ModelManager;

@interface ReferenceAssetDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ReferenceAsset *)read:(NSString *)key;
- (NSString *)readShortDescription:(NSString *)key;
- (NSString *)readLongDescription:(NSString *)key;
- (NSString *)readDisplayName:(NSString *)key;
- (NSString *)readImageName:(NSString *)key;
- (NSString *)readLink:(NSString *)key;
- (NSNumber *)readOriginYear:(NSString *)key;
- (NSString *)readMoralImageName:(NSString *)key;
- (NSString *)readOriginLocation:(NSString *)key;
- (NSString *)readMoralKey:(NSString *)key;

- (NSArray *)readAllNames;
- (NSArray *)readAllDisplayNames;
- (NSArray *)readAllImageNames;
- (NSArray *)readAllLongDescriptions;
- (NSArray *)readAllShortDescriptions;
- (NSArray *)readAllLinks;
- (NSArray *)readAllOriginYears;
- (NSArray *)readAllOriginLocations;
- (NSArray *)readAllMoralKeys;
- (NSArray *)readAll;

@end
