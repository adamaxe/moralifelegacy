#import "UserCharacterDAO.h"

@implementation UserCharacterDAO 

- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager andClassType:(NSString *)classType{
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:classType];
    
    if (self) {
        [self.predicateDefaultName setString:@"characterName"];
        [self.sortDefaultName setString:@"characterName"];
        [self.managedObjectClassName setString:@"UserCharacter"];
    }
    
    return self;
    
}

-(instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    return [self initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadWrite];
}


- (UserCharacter *)create {
    return (UserCharacter *)[self createObject];
}

- (UserCharacter *)read:(NSString *)key {
    return (UserCharacter *)[self readObject:key];
}


@end
