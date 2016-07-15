#import "UserCollectableDAO.h"

NSString* const MLCollectableEthicals = @"ethical";

@implementation UserCollectableDAO

- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager andClassType:(NSString *)classType{

    self = [super initWithKey:key andModelManager:moralModelManager andClassType:classType];

    if (self) {
        [self.predicateDefaultName setString:@"collectableKey"];
        [self.sortDefaultName setString:@"collectableName"];
        [self.managedObjectClassName setString:@"UserCollectable"];
    }

    return self;

}

-(instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    return [self initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadWrite];
}


- (UserCollectable *)create {
    return (UserCollectable *)[self createObject];
}

- (UserCollectable *)read:(NSString *)key {
    return (UserCollectable *)[self readObject:key];
}


@end
