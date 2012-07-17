#import "ConscienceAssetDAO.h"
#import "MoraLifeAppDelegate.h"

@implementation ConscienceAssetDAO 

- (id) init {
    return [self initWithKey:nil];
}

- (id)initWithKey:(NSString *)key {
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [self initWithKey:key andModelManager:[appDelegate moralModelManager]];
}

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:kContextReadOnly];
    
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

-(void)dealloc {
    [super dealloc];
}

@end