#import "MoralDAO.h"

@implementation MoralDAO 

- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager andClassType:(NSString *)classType{
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:classType];
    
    if (self) {
        [self.predicateDefaultName setString:@"nameMoral"];
        [self.sortDefaultName setString:@"displayNameMoral"];
        [self.managedObjectClassName setString:@"Moral"];
    }
    
    return self;
    
}

-(instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    return [self initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadOnly];
}

- (Moral *)read:(NSString *)key {
    return (Moral *)[self readObject:key];
}


@end
