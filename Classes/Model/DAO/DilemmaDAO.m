#import "DilemmaDAO.h"

@implementation DilemmaDAO 

- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager andClassType:(NSString *)classType{
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:classType];
    
    if (self) {
        [self.predicateDefaultName setString:@"nameDilemma"];
        [self.sortDefaultName setString:@"displayNameDilemma"];
        [self.managedObjectClassName setString:@"Dilemma"];
    }
    
    return self;
    
}

-(instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    return [self initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadOnly];
}


- (Dilemma *)read:(NSString *)key {
    return (Dilemma *)[self readObject:key];
}


@end
