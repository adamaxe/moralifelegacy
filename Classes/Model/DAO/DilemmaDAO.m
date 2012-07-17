#import "DilemmaDAO.h"
#import "MoraLifeAppDelegate.h"

@implementation DilemmaDAO 

- (id) init {
    return [self initWithKey:nil];
}

- (id)initWithKey:(NSString *)key {
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [self initWithKey:key andModelManager:[appDelegate moralModelManager]];
}

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    
    self = [super initWithKey:key andModelManager:moralModelManager andClassType:kContextReadOnly];
    
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

-(void)dealloc {
    [super dealloc];
}

@end