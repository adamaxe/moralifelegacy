#import "UserChoiceDAO.h"

@implementation UserChoiceDAO 

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
