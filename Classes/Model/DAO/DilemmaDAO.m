#import "DilemmaDAO.h"

@implementation DilemmaDAO 

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadOnly];
    
    if (self) {
        [self.predicateDefaultName setString:@"nameDilemma"];
        [self.sortDefaultName setString:@"displayNameDilemma"];
        [self.managedObjectClassName setString:@"Dilemma"];
    }
    
    return self;
    
}

- (Dilemma *)read:(NSString *)key {
    return (Dilemma *)[self readObject:key];
}


@end