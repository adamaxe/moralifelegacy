@class Moral;

@interface MoralDAO : NSObject

- (id)initWithMoralType:(NSString *)moralType;

- (NSString *)findMoralDisplayName:(NSString *)moralName;
- (NSString *)findMoralImageName:(NSString *)moralName;

- (NSArray *)listAllMoralNames;
- (NSArray *)listAllMoralDisplayNames;
- (NSArray *)listAllMoralImages;
- (NSArray *)listAllMoralDetails;

@end
