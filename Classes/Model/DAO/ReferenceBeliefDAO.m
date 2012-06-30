#import "ReferenceBeliefDAO.h"
#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "ReferenceBelief.h"
#import "ReferencePerson.h"
#import "ReferencePersonDAO.h"

@interface ReferenceBeliefDAO () 

- (ReferenceBelief *)findPersistedObject:(NSString *)key;

@property (nonatomic, retain) NSString *currentKey;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSMutableArray *persistedObjects;
@property (nonatomic, retain) NSMutableArray *returnedNames;
@property (nonatomic, retain) NSMutableArray *returnedImageNames;
@property (nonatomic, retain) NSMutableArray *returnedShortDescriptions;
@property (nonatomic, retain) NSMutableArray *returnedLongDescriptions;
@property (nonatomic, retain) NSMutableArray *returnedDisplayNames;
@property (nonatomic, retain) NSMutableArray *returnedLinks;
@property (nonatomic, retain) NSMutableArray *returnedPeople;


- (NSArray *)retrievePersistedObjects;
- (void)processObjects;

@end

@implementation ReferenceBeliefDAO 

@synthesize sorts = _sorts;
@synthesize predicates = _predicates;

@synthesize currentKey = _currentKey;
@synthesize context = _context;
@synthesize persistedObjects = _persistedObjects;
@synthesize returnedNames = _returnedNames;
@synthesize returnedImageNames = _returnedImageNames;
@synthesize returnedShortDescriptions = _returnedShortDescriptions;
@synthesize returnedLongDescriptions = _returnedLongDescriptions;
@synthesize returnedDisplayNames = _returnedDisplayNames;
@synthesize returnedLinks = _returnedLinks;
@synthesize returnedPeople = _returnedPeople;


- (id) init {
    return [self initWithKey:nil];
}

- (id)initWithKey:(NSString *)key {
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [self initWithKey:key andModelManager:[appDelegate moralModelManager]];
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
        _returnedDisplayNames = [[NSMutableArray alloc] init];
        _returnedLongDescriptions = [[NSMutableArray alloc] init];
        _returnedShortDescriptions = [[NSMutableArray alloc] init];
        _returnedLinks = [[NSMutableArray alloc] init];
        _returnedPeople = [[NSMutableArray alloc] init];
        
        _persistedObjects = [[NSMutableArray alloc] initWithArray:[self retrievePersistedObjects]];
        
        [self processObjects];

    }
    
    return self;
    
}

- (NSString *)readShortDescription:(NSString *)key {
    return [self findPersistedObject:key].shortDescriptionReference;
}

- (NSString *)readLongDescription:(NSString *)key {
    return [self findPersistedObject:key].longDescriptionReference;
}

- (NSString *)readDisplayName:(NSString *)key {
    return [self findPersistedObject:key].displayNameReference;
}

- (NSString *)readImageName:(NSString *)key {
    return [self findPersistedObject:key].imageNameReference;    
}

- (NSString *)readLink:(NSString *)key {
    return [[self findPersistedObject:key] linkReference];    
}

- (ReferencePersonDAO *)readPerson:(NSString *)key {
    
    ReferencePersonDAO *currentPersonDAO = [[[ReferencePersonDAO alloc] initWithKey:[[[self findPersistedObject:key] figurehead] nameReference]] autorelease];
        
    return currentPersonDAO;    
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

- (NSArray *)readAllShortDescriptions {
    [self refreshData];    
    return self.returnedShortDescriptions;
}

- (NSArray *)readAllLongDescriptions {
    [self refreshData];    
    return self.returnedLongDescriptions;
}

- (NSArray *)readAllLinks {
    [self refreshData];    
    return self.returnedLinks;
}

- (NSArray *)readAllPeople {
    [self refreshData];    
    return self.returnedPeople;
}


#pragma mark -
#pragma mark Private API
- (ReferenceBelief *)findPersistedObject:(NSString *)key {
    
    [self refreshData];
    
    NSPredicate *findPred;
    NSArray *objects;
    
    if (![key isEqualToString:@""]) {
        findPred = [NSPredicate predicateWithFormat:@"nameReference == %@", key];
    
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
    [self.returnedLinks removeAllObjects];  
    [self.returnedPeople removeAllObjects];  
    
    for (ReferenceBelief *match in self.persistedObjects){
        [self.returnedNames addObject:[match nameReference]];
        [self.returnedImageNames addObject:[match imageNameReference]];
        [self.returnedDisplayNames addObject:[match displayNameReference]];
        [self.returnedLinks addObject:[match linkReference]];
		[self.returnedShortDescriptions addObject:[match shortDescriptionReference]];
        [self.returnedLongDescriptions addObject:[match longDescriptionReference]];

        ReferencePersonDAO *currentPersonDAO = [[ReferencePersonDAO alloc] initWithKey:[[match figurehead] nameReference]];

        [self.returnedPeople addObject:currentPersonDAO];
        [currentPersonDAO release];
    }
    
}

- (NSArray *)retrievePersistedObjects {
    //Begin CoreData Retrieval			
	NSError *outError;
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"ReferenceBelief" inManagedObjectContext:self.context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
    
    NSMutableArray *currentPredicates = [[NSMutableArray alloc] initWithArray:self.predicates];
    
    if (![self.currentKey isEqualToString:@""]) {

        NSPredicate *pred = [NSPredicate predicateWithFormat:@"nameReference == %@", self.currentKey];
        [currentPredicates addObject:pred];
    }
    
    NSPredicate *currentPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:currentPredicates];
    [request setPredicate:currentPredicate];

    [currentPredicates release];

	if (self.sorts.count > 0) {
        [request setSortDescriptors:self.sorts];
    } else {
        NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameReference" ascending:YES];
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
    [_currentKey release];
    [_context release];
    [_returnedShortDescriptions release];
    [_returnedLongDescriptions release];
    [_returnedDisplayNames release];
    [_returnedImageNames release];
    [_returnedNames release];
    [_returnedLinks release];
    [_persistedObjects release];
    [super dealloc];
}

@end
