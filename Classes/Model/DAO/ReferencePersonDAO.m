#import "ReferencePersonDAO.h"

@implementation ReferencePersonDAO 

- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadOnly];
    
    if (self) {
        [self.predicateDefaultName setString:@"nameReference"];
        [self.sortDefaultName setString:@"nameReference"];
        [self.managedObjectClassName setString:@"ReferencePerson"];
    }
    
    return self;
    
}

- (ReferencePerson *)read:(NSString *)key {
    return (ReferencePerson *)[self readObject:key];
}


@end
