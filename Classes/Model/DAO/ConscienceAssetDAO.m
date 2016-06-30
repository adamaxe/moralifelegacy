#import "ConscienceAssetDAO.h"

@implementation ConscienceAssetDAO 

- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadOnly];
    
    if (self) {
        [self.predicateDefaultName setString:@"nameReference"];
        [self.sortDefaultName setString:@"nameReference"];
        [self.managedObjectClassName setString:@"ConscienceAsset"];
    }
    
    return self;
    
}

- (ConscienceAsset *)read:(NSString *)key {
    return (ConscienceAsset *)[self readObject:key];
}


@end
