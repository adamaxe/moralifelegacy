#import "CharacterDAO.h"

@implementation CharacterDAO 

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadOnly];
    
    if (self) {
        [self.predicateDefaultName setString:@"nameCharacter"];
        [self.sortDefaultName setString:@"nameCharacter"];
        [self.managedObjectClassName setString:@"Character"];
    }
    
    return self;
    
}

- (Character *)read:(NSString *)key {
    return (Character *)[self readObject:key];
}


@end