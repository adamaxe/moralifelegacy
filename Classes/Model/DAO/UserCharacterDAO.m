#import "UserCharacterDAO.h"

@implementation UserCharacterDAO 

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadWrite];
    
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
