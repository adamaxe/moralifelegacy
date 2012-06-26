#import "MoralDAO.h"
#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "Moral.h"

@interface MoralDAO ()

- (Moral *)findPersistedObject:(NSString *)key;

@property (nonatomic, retain) NSString *currentType;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSMutableArray *persistedObjects;
@property (nonatomic, retain) NSMutableArray *returnedNames;
@property (nonatomic, retain) NSMutableArray *returnedImageNames;
@property (nonatomic, retain) NSMutableArray *returnedDetails;
@property (nonatomic, retain) NSMutableArray *returnedDisplayNames;

- (NSArray *)retrievePersistedObjects;
- (void)processObjects;

@end

@implementation MoralDAO 

@synthesize sorts = _sorts;
@synthesize predicates = _predicates;

@synthesize currentType = _currentType;
@synthesize context = _context;
@synthesize persistedObjects = _persistedObjects;
@synthesize returnedNames = _returnedNames;
@synthesize returnedImageNames = _returnedImageNames;
@synthesize returnedDetails = _returnedDetails;
@synthesize returnedDisplayNames = _returnedDisplayNames;

- (id)init {    
    return [self initWithType:@"all"];
}

- (id)initWithType:(NSString *)type {
    
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [self initWithType:type andModelManager: [appDelegate moralModelManager]];
}

- (id)initWithType:(NSString *)type andModelManager:(ModelManager *)moralModelManager {

    self = [super init];

    if (self) {
        _context = [[moralModelManager managedObjectContext] retain];
        
        _sorts = [[NSArray alloc] init];
        _predicates = [[NSSet alloc] init];

        if (type) {
            _currentType = [[NSString alloc] initWithFormat:type];
        } else {
            _currentType = [[NSString alloc] initWithFormat:@"all"];
        }
        
        _returnedNames =  [[NSMutableArray alloc] init];
        
        _returnedImageNames = [[NSMutableArray alloc] init];

        _returnedDisplayNames = [[NSMutableArray alloc] init];
        
        _returnedDetails = [[NSMutableArray alloc] init];
        
        _persistedObjects = [[NSMutableArray alloc] initWithArray:[self retrievePersistedObjects]];
        
        [self processObjects];
    }
    
    return self;
}

- (NSString *)readColor:(NSString *)key {
    return [self findPersistedObject:key].colorMoral;
}

- (NSString *)readDefinition:(NSString *)key {
    return [self findPersistedObject:key].definitionMoral;
}

- (NSString *)readLongDescription:(NSString *)key {
    return [self findPersistedObject:key].longDescriptionMoral;
}

- (NSString *)readDisplayName:(NSString *)key {
    return [self findPersistedObject:key].displayNameMoral;
}

- (NSString *)readImageName:(NSString *)key {
    return [self findPersistedObject:key].imageNameMoral;    
}

- (NSArray *)readAllNames {
    [self refreshData];
    return self.returnedNames;
}

- (NSArray *)readAllDisplayNames {    
    [self refreshData];
    return self.returnedDisplayNames;
}

- (NSArray *)readAllImageNames {    
    [self refreshData];
    return self.returnedImageNames;
}

- (NSArray *)readAllDetails {
    [self refreshData];
    return self.returnedDetails;
}

#pragma mark -
#pragma mark Private API
- (Moral *)findPersistedObject:(NSString *)key {  
        
    [self refreshData];
    
    NSPredicate *findPred = [NSPredicate predicateWithFormat:@"SELF.nameMoral == %@", key];
    
    NSArray *objects = [self.persistedObjects filteredArrayUsingPredicate:findPred];
    if (objects.count > 0) {
        return [objects objectAtIndex:0];
    } else {
        return nil;
    }
    
}

- (void)refreshData {
    [self.persistedObjects removeAllObjects];
    [self.persistedObjects addObjectsFromArray:[self retrievePersistedObjects]];
    
    [self processObjects];
}

- (void)processObjects {
        
    [self.returnedNames removeAllObjects];
    [self.returnedImageNames removeAllObjects];
    [self.returnedDisplayNames removeAllObjects];
    [self.returnedDetails removeAllObjects];
    
    for (Moral *match in self.persistedObjects){
        [self.returnedNames addObject:[match nameMoral]];
        [self.returnedImageNames addObject:[match imageNameMoral]];
        [self.returnedDisplayNames addObject:[match displayNameMoral]];
        [self.returnedDetails addObject:[match longDescriptionMoral]];			
    }
    
}

- (NSArray *)retrievePersistedObjects {	
	NSError *outError;
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"Moral" inManagedObjectContext:self.context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];

    if (![self.currentType isEqualToString:@"all"]) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"shortDescriptionMoral == %@", self.currentType];
        [request setPredicate:pred];
    }
	
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameMoral" ascending:YES];
	NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	NSArray *objects = [self.context executeFetchRequest:request error:&outError];
    	
	[request release];
    
    return objects;

}

-(void)dealloc {
    [_predicates release];
    [_sorts release];
    [_currentType release];
    [_context release];
    [_returnedDetails release];
    [_returnedDisplayNames release];
    [_returnedImageNames release];
    [_returnedNames release];
    [_persistedObjects release];
    [super dealloc];
}

@end
