/**
 Implementation:  Read only interface to Character(s)

 @class CharacterDAO CharacterDAO.h
 */

#import "CharacterDAO.h"
#import "MoraLifeAppDelegate.h"

@implementation CharacterDAO 

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