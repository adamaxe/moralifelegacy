#import "ReferenceBeliefDAO.h"

@implementation ReferenceBeliefDAO 

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadOnly];
    
    if (self) {
        [self.predicateDefaultName setString:@"nameReference"];
        [self.sortDefaultName setString:@"nameReference"];
        [self.managedObjectClassName setString:@"ReferenceBelief"];
    }
    
    return self;
    
}

- (ReferenceBelief *)read:(NSString *)key {
    return (ReferenceBelief *)[self readObject:key];
}


@end