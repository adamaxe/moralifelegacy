@interface MoralDAO : NSObject

- (id)initWithMoralType:(NSString *)moralType;

- (NSArray *)getAllMoralNames;
- (NSArray *)getAllMoralDisplayNames;
- (NSArray *)getAllMoralImages;
- (NSArray *)getAllMoralDetails;

@end
