#import "MoralDAO.h"

@implementation MoralDAO 

- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadOnly];
    
    if (self) {
        [self.predicateDefaultName setString:@"nameMoral"];
        [self.sortDefaultName setString:@"displayNameMoral"];
        [self.managedObjectClassName setString:@"Moral"];
    }
    
    return self;
    
}

- (Moral *)read:(NSString *)key {
    return (Moral *)[self readObject:key];
}


@end
