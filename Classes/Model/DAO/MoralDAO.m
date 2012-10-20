#import "MoralDAO.h"
#import "MoraLifeAppDelegate.h"

@implementation MoralDAO 

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
        [self.predicateDefaultName setString:@"nameMoral"];
        [self.sortDefaultName setString:@"displayNameMoral"];
        [self.managedObjectClassName setString:@"Moral"];
    }
    
    return self;
    
}

- (Moral *)read:(NSString *)key {
    return (Moral *)[self readObject:key];
}


@end