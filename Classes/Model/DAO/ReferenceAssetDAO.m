#import "MoraLifeAppDelegate.h"
#import "ReferenceAssetDAO.h"

@implementation ReferenceAssetDAO 

- (id) init {
    return [self initWithKey:nil];
}

- (id)initWithKey:(NSString *)key {
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [self initWithKey:key andModelManager:[appDelegate moralModelManager]];
}

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadOnly];
    
    if (self) {
        [self.predicateDefaultName setString:@"nameReference"];
        [self.sortDefaultName setString:@"nameReference"];
        [self.managedObjectClassName setString:@"ReferenceAsset"];
    }
    
    return self;
    
}

- (ReferenceAsset *)read:(NSString *)key {
    return (ReferenceAsset *)[self readObject:key];
}


@end