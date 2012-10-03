#import "UserCharacterDAO.h"
#import "MoraLifeAppDelegate.h"

@implementation UserCharacterDAO 

- (id) init {
    return [self initWithKey:nil];
}

- (id)initWithKey:(NSString *)key {
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [self initWithKey:key andModelManager:[appDelegate moralModelManager]];
}

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:kContextReadWrite];
    
    if (self) {
        [self.predicateDefaultName setString:@"characterName"];
        [self.sortDefaultName setString:@"characterName"];
        [self.managedObjectClassName setString:@"UserCharacter"];
    }
    
    return self;
    
}

- (UserCharacter *)create {
    return (UserCharacter *)[self createObject];
}

- (UserCharacter *)read:(NSString *)key {
    return (UserCharacter *)[self readObject:key];
}


@end
