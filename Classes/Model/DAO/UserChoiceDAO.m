#import "UserChoiceDAO.h"

@implementation UserChoiceDAO 

- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager andClassType:(NSString *)classType{
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:classType];
    
    if (self) {
        [self.predicateDefaultName setString:@"entryKey"];
        [self.sortDefaultName setString:@"entryKey"];
        [self.managedObjectClassName setString:@"UserChoice"];
    }
        
    return self;
    
}

-(instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    return [self initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadWrite];
}


- (UserChoice *)create {
    return (UserChoice *)[self createObject];
}

- (UserChoice *)read:(NSString *)key {
    return (UserChoice *)[self readObject:key];
}


@end
