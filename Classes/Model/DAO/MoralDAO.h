#import "Moral.h"

@class ModelManager;

@interface MoralDAO : NSObject

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (id)initWithType:(NSString *)type;
- (id)initWithType:(NSString *)type andModelManager:(ModelManager *)moralModelManager;

- (Moral *)read:(NSString *)key;
- (NSString *)readColor:(NSString *)key;
- (NSString *)readDefinition:(NSString *)key;
- (NSString *)readDisplayName:(NSString *)key;
- (NSString *)readSubtitle:(NSString *)key;
- (NSString *)readShortDescription:(NSString *)key;
- (NSString *)readLongDescription:(NSString *)key;
- (NSString *)readImageName:(NSString *)key;
- (NSString *)readLink:(NSString *)key;

- (NSArray *)readAll;
- (NSArray *)readAllNames;
- (NSArray *)readAllDefinitions;
- (NSArray *)readAllDisplayNames;
- (NSArray *)readAllSubtitles;
- (NSArray *)readAllShortDescriptions;
- (NSArray *)readAllLongDescriptions;
- (NSArray *)readAllImageNames;
- (NSArray *)readAllLinks;

@end
