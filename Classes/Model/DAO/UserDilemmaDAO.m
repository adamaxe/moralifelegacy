#import "UserDilemmaDAO.h"

@implementation UserDilemmaDAO

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {

    self = [super initWithKey:key andModelManager:moralModelManager andClassType:MLContextReadWrite];

    if (self) {
        [self.predicateDefaultName setString:@"entryKey"];
        [self.sortDefaultName setString:@"entryKey"];
        [self.managedObjectClassName setString:@"UserDilemma"];
    }

    return self;

}

- (UserDilemma *)create {
    return (UserDilemma *)[self createObject];
}

- (UserDilemma *)read:(NSString *)key {
    return (UserDilemma *)[self readObject:key];
}


@end