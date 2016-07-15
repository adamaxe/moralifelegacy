#import "UserDilemmaDAO.h"

@implementation UserDilemmaDAO

- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager andClassType:(NSString *)classType{

    self = [super initWithKey:key andModelManager:moralModelManager andClassType:classType];

    if (self) {
        [self.predicateDefaultName setString:@"entryKey"];
        [self.sortDefaultName setString:@"entryKey"];
        [self.managedObjectClassName setString:@"UserDilemma"];
    }

    return self;

}

-(instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    return [self initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadWrite];
}


- (UserDilemma *)create {
    return (UserDilemma *)[self createObject];
}

- (UserDilemma *)read:(NSString *)key {
    return (UserDilemma *)[self readObject:key];
}


@end
