#import "CharacterDAO.h"

@implementation CharacterDAO 

- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager andClassType:(NSString *)classType{
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:classType];
    
    if (self) {
        [self.predicateDefaultName setString:@"nameCharacter"];
        [self.sortDefaultName setString:@"nameCharacter"];
        [self.managedObjectClassName setString:@"Character"];
    }
    
    return self;
    
}

-(instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    return [self initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadOnly];
}

- (Character *)read:(NSString *)key {
    return (Character *)[self readObject:key];
}


@end
