#import "MoralDAO.h"
#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "Moral.h"

@interface MoralDAO ()

- (Moral *)findPersistedObject:(NSString *)key;

@property (nonatomic, retain) NSString *currentKey;
@property (nonatomic, retain) NSString *currentType;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSMutableArray *persistedObjects;
@property (nonatomic, retain) NSMutableArray *returnedNames;
@property (nonatomic, retain) NSMutableArray *returnedImageNames;
@property (nonatomic, retain) NSMutableArray *returnedShortDescriptions;
@property (nonatomic, retain) NSMutableArray *returnedLongDescriptions;
@property (nonatomic, retain) NSMutableArray *returnedDisplayNames;
@property (nonatomic, retain) NSMutableArray *returnedDefinitions;
@property (nonatomic, retain) NSMutableArray *returnedSubtitles;
@property (nonatomic, retain) NSMutableArray *returnedLinks;

- (NSArray *)retrievePersistedObjects;
- (void)processObjects;

@end

@implementation MoralDAO 

@synthesize sorts = _sorts;
@synthesize predicates = _predicates;

@synthesize currentKey = _currentKey;
@synthesize currentType = _currentType;
@synthesize context = _context;
@synthesize persistedObjects = _persistedObjects;
@synthesize returnedNames = _returnedNames;
@synthesize returnedImageNames = _returnedImageNames;
@synthesize returnedShortDescriptions = _returnedShortDescriptions;
@synthesize returnedLongDescriptions = _returnedLongDescriptions;
@synthesize returnedDisplayNames = _returnedDisplayNames;
@synthesize returnedDefinitions = _returnedDefinitions;
@synthesize returnedSubtitles = _returnedSubtitles;
@synthesize returnedLinks = _returnedLinks;

- (id)init {    
    return [self initWithKey:nil];
}

- (id)initWithKey:(NSString *)key {
    
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [self initWithKey:key andModelManager: [appDelegate moralModelManager]];
}

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager {
    
    self = [super init];
    
    if (self) {
        _context = [[moralModelManager managedObjectContext] retain];
        
        _sorts = [[NSArray alloc] init];
        _predicates = [[NSArray alloc] init];
        
        if (key) {
            _currentKey = [[NSString alloc] initWithFormat:key];
        } else {
            _currentKey = [[NSString alloc] initWithFormat:@""];
        }
        
        _returnedNames =  [[NSMutableArray alloc] init];
        _returnedImageNames = [[NSMutableArray alloc] init];
        _returnedDefinitions = [[NSMutableArray alloc] init];        
        _returnedDisplayNames = [[NSMutableArray alloc] init];
        _returnedShortDescriptions = [[NSMutableArray alloc] init];        
        _returnedLongDescriptions = [[NSMutableArray alloc] init];
        _returnedSubtitles = [[NSMutableArray alloc] init];
        _returnedLinks = [[NSMutableArray alloc] init];
        _persistedObjects = [[NSMutableArray alloc] initWithArray:[self retrievePersistedObjects]];
        
        [self processObjects];
    }
    
    return self;
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
        _predicates = [[NSArray alloc] init];

        if (type) {
            _currentType = [[NSString alloc] initWithFormat:type];
        } else {
            _currentType = [[NSString alloc] initWithFormat:@"all"];
        }
        
        _returnedNames =  [[NSMutableArray alloc] init];
        _returnedImageNames = [[NSMutableArray alloc] init];
        _returnedDefinitions = [[NSMutableArray alloc] init];        
        _returnedDisplayNames = [[NSMutableArray alloc] init];
        _returnedShortDescriptions = [[NSMutableArray alloc] init];        
        _returnedLongDescriptions = [[NSMutableArray alloc] init];
        _returnedSubtitles = [[NSMutableArray alloc] init];
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

- (NSString *)readShortDescription:(NSString *)key {
    return [self findPersistedObject:key].shortDescriptionMoral;
}

- (NSString *)readSubtitle:(NSString *)key {    
    NSString *combinedShortDescription = [[[NSString alloc] initWithFormat:@"%@: %@", [self findPersistedObject:key].shortDescriptionMoral, [self findPersistedObject:key].longDescriptionMoral] autorelease];
    
    return combinedShortDescription;
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

- (NSString *)readLink:(NSString *)key {
    return [self findPersistedObject:key].linkMoral;    
}


- (NSArray *)readAllNames {
    [self refreshData];
    return self.returnedNames;
}

- (NSArray *)readAllDefinitions {    
    [self refreshData];
    return self.returnedDefinitions;
}

- (NSArray *)readAllDisplayNames {    
    [self refreshData];
    return self.returnedDisplayNames;
}

- (NSArray *)readAllImageNames {    
    [self refreshData];
    return self.returnedImageNames;
}

- (NSArray *)readAllShortDescriptions {
    [self refreshData];
    return self.returnedLongDescriptions;
}

- (NSArray *)readAllSubtitles {
    [self refreshData];
    return self.returnedSubtitles;
}

- (NSArray *)readAllLongDescriptions {
    [self refreshData];
    return self.returnedLongDescriptions;
}

- (NSArray *)readAllLinks {
    [self refreshData];
    return self.returnedLongDescriptions;
}

#pragma mark -
#pragma mark Private API
- (Moral *)findPersistedObject:(NSString *)key {  
        
    [self refreshData];
    
    NSPredicate *findPred;
    NSArray *objects;
    
    if (![key isEqualToString:@""]) {
        findPred = [NSPredicate predicateWithFormat:@"nameMoral == %@", key];
        objects = [self.persistedObjects filteredArrayUsingPredicate:findPred];
    } else {
        objects = self.persistedObjects;
    }

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
    [self.returnedShortDescriptions removeAllObjects];
    [self.returnedLongDescriptions removeAllObjects];
    [self.returnedDefinitions removeAllObjects];
    [self.returnedSubtitles removeAllObjects];
    [self.returnedLinks removeAllObjects];
    
    for (Moral *match in self.persistedObjects){
        [self.returnedNames addObject:[match nameMoral]];
        [self.returnedImageNames addObject:[match imageNameMoral]];
        [self.returnedDisplayNames addObject:[match displayNameMoral]];
        [self.returnedShortDescriptions addObject:[match shortDescriptionMoral]];
        [self.returnedLongDescriptions addObject:[match longDescriptionMoral]];	
        [self.returnedDefinitions addObject:[match definitionMoral]];	
        [self.returnedLinks addObject:[match linkMoral]];	
        
        NSString *combinedShortDescription = [[NSString alloc] initWithFormat:@"%@: %@", [match shortDescriptionMoral], [match longDescriptionMoral]];
        
        [self.returnedSubtitles addObject:combinedShortDescription];
        [combinedShortDescription release];
        
    }
    
}

- (NSArray *)retrievePersistedObjects {	
	NSError *outError;
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"Moral" inManagedObjectContext:self.context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
    
    NSMutableArray *currentPredicates = [[NSMutableArray alloc] initWithArray:self.predicates];
    
    if (![self.currentKey isEqualToString:@""]) {
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"nameMoral == %@", self.currentKey];
        [currentPredicates addObject:pred];
    }
    
    NSPredicate *currentPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:currentPredicates];
    [request setPredicate:currentPredicate];
    
    [currentPredicates release];    
    
	if (self.sorts.count > 0) {
        [request setSortDescriptors:self.sorts];
    } else {
        NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayNameMoral" ascending:YES];
        NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptor release];
        [sortDescriptors release];
    }    
    	
	NSArray *objects = [self.context executeFetchRequest:request error:&outError];
    	
	[request release];
    
    return objects;

}

-(void)dealloc {
    [_predicates release];
    [_sorts release];
    [_currentType release];
    [_context release];
    [_returnedDefinitions release];
    [_returnedSubtitles release];
    [_returnedShortDescriptions release];
    [_returnedLongDescriptions release];
    [_returnedDisplayNames release];
    [_returnedImageNames release];
    [_returnedLinks release];
    [_returnedNames release];
    [_persistedObjects release];
    [super dealloc];
}

@end
