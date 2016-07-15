#import "ReferenceBeliefDAO.h"

@implementation ReferenceBeliefDAO 

- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager andClassType:(NSString *)classType {
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:classType];
    
    if (self) {
        [self.predicateDefaultName setString:@"nameReference"];
        [self.sortDefaultName setString:@"nameReference"];
        [self.managedObjectClassName setString:@"ReferenceBelief"];
    }
    
    return self;
    
}

-(instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    return [self initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadOnly];
}


- (ReferenceBelief *)read:(NSString *)key {
    return (ReferenceBelief *)[self readObject:key];
}


@end
