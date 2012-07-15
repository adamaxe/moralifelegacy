#import "UserDilemmaDAO.h"
#import "MoraLifeAppDelegate.h"

@implementation UserDilemmaDAO

- (id) init {
    return [self initWithKey:nil];
}

- (id)initWithKey:(NSString *)key {
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];

    return [self initWithKey:key andModelManager:[appDelegate moralModelManager]];
}

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {

    self = [super initWithKey:key andModelManager:moralModelManager andClassType:kContextReadWrite];

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

-(void)dealloc {
    [super dealloc];
}

@end