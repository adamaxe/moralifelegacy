#import "UserChoiceDAO.h"
#import "MoraLifeAppDelegate.h"

@implementation UserChoiceDAO 

- (id) init {
    return [self initWithKey:nil];
}

- (id)initWithKey:(NSString *)key {
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [self initWithKey:key andModelManager:[appDelegate moralModelManager]];
}

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadWrite];
    
    if (self) {
        [self.predicateDefaultName setString:@"entryKey"];
        [self.sortDefaultName setString:@"entryKey"];
        [self.managedObjectClassName setString:@"UserChoice"];
    }
        
    return self;
    
}

- (UserChoice *)create {
    return (UserChoice *)[self createObject];
}

- (UserChoice *)read:(NSString *)key {
    return (UserChoice *)[self readObject:key];
}


@end
