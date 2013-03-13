#import "UserCollectableDAO.h"

NSString* const MLCollectableEthicals = @"ethical";

@implementation UserCollectableDAO

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {

    self = [super initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadWrite];

    if (self) {
        [self.predicateDefaultName setString:@"collectableKey"];
        [self.sortDefaultName setString:@"collectableName"];
        [self.managedObjectClassName setString:@"UserCollectable"];
    }

    return self;

}

- (UserCollectable *)create {
    return (UserCollectable *)[self createObject];
}

- (UserCollectable *)read:(NSString *)key {
    return (UserCollectable *)[self readObject:key];
}


@end
