#import "ReferenceTextDAO.h"

@implementation ReferenceTextDAO 

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadOnly];
    
    if (self) {
        [self.predicateDefaultName setString:@"nameReference"];
        [self.sortDefaultName setString:@"nameReference"];
        [self.managedObjectClassName setString:@"ReferenceText"];
    }
    
    return self;
    
}

- (ReferenceText *)read:(NSString *)key {
    return (ReferenceText *)[self readObject:key];
}


@end