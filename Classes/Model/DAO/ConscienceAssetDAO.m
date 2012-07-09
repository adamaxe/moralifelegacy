#import "ConscienceAssetDAO.h"
#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"

@interface ConscienceAssetDAO () 

- (ConscienceAsset *)findPersistedObject:(NSString *)key;

@property (nonatomic, retain) NSString *currentKey;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSMutableArray *persistedObjects;
@property (nonatomic, retain) NSMutableArray *returnedNames;
@property (nonatomic, retain) NSMutableArray *returnedImageNames;
@property (nonatomic, retain) NSMutableArray *returnedShortDescriptions;
@property (nonatomic, retain) NSMutableArray *returnedLongDescriptions;
@property (nonatomic, retain) NSMutableArray *returnedDisplayNames;
@property (nonatomic, retain) NSMutableArray *returnedCosts;
@property (nonatomic, retain) NSMutableArray *returnedOrientations;
@property (nonatomic, retain) NSMutableArray *returnedMoralValues;
@property (nonatomic, retain) NSMutableArray *returnedSubtitles;

- (NSArray *)retrievePersistedObjects;
- (void)processObjects;

@end

@implementation ConscienceAssetDAO 

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
@synthesize returnedCosts = _returnedCosts;
@synthesize returnedOrientations = _returnedOrientations;
@synthesize returnedMoralValues = _returnedMoralValues;
@synthesize returnedSubtitles = _returnedSubtitles;

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
        _returnedCosts = [[NSMutableArray alloc] init];
        _returnedOrientations = [[NSMutableArray alloc] init];
        _returnedMoralValues = [[NSMutableArray alloc] init];        
        _returnedSubtitles = [[NSMutableArray alloc] init];

        _persistedObjects = [[NSMutableArray alloc] initWithArray:[self retrievePersistedObjects]];
        
        [self processObjects];

    }
    
    return self;
    
}

- (ConscienceAsset *)read:(NSString *)key {
    return [self findPersistedObject:key];
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

- (NSString *)readMoralImageName:(NSString *)key {
    return [[[self findPersistedObject:key] relatedMoral] imageNameMoral];    
}

- (NSNumber *)readCost:(NSString *)key {
    return [[self findPersistedObject:key] costAsset];    
}

- (NSNumber *)readMoralValue:(NSString *)key {
    return [[self findPersistedObject:key] moralValueAsset];    
}

- (NSString *)readOrientation:(NSString *)key {
    return [[self findPersistedObject:key] orientationAsset];    
}

- (NSString *)readMoralKey:(NSString *)key {
    
    return [[[self findPersistedObject:key] relatedMoral] nameMoral];    
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

- (NSArray *)readAllCosts {
    [self refreshData];    
    return self.returnedCosts;
}

- (NSArray *)readAllOrientations {
    [self refreshData];    
    return self.returnedOrientations;
}

- (NSArray *)readAllMoralValues {
    [self refreshData];    
    return self.returnedMoralValues;
}

- (NSArray *)readAllSubtitles {
    [self refreshData];    
    return self.returnedSubtitles;
}

- (NSArray *)readAll {
    [self refreshData];    
    return self.persistedObjects;
}

#pragma mark -
#pragma mark Private API
- (ConscienceAsset *)findPersistedObject:(NSString *)key {
    
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
    [self.returnedCosts removeAllObjects];  
    [self.returnedOrientations removeAllObjects];  
    [self.returnedMoralValues removeAllObjects];  
    [self.returnedSubtitles removeAllObjects];    
    
    for (ConscienceAsset *match in self.persistedObjects){
        [self.returnedNames addObject:[match nameReference]];
        [self.returnedImageNames addObject:[match imageNameReference]];
        [self.returnedDisplayNames addObject:[match displayNameReference]];
        [self.returnedCosts addObject:[match costAsset]];
		[self.returnedShortDescriptions addObject:[match shortDescriptionReference]];
        [self.returnedLongDescriptions addObject:[match longDescriptionReference]];
        [self.returnedOrientations addObject:[match orientationAsset]];
        [self.returnedMoralValues addObject:[match moralValueAsset]];
        
        MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if ([appDelegate.userCollection containsObject:[match nameReference]]){
            [self.returnedSubtitles addObject:[NSString stringWithFormat:@"Owned! - %@", [match shortDescriptionReference]]];
        } else {
            [self.returnedSubtitles addObject:[NSString stringWithFormat:@"%dε - %@", [[match costAsset] intValue], [match shortDescriptionReference]]];
        }

    }
    
}

- (NSArray *)retrievePersistedObjects {
    //Begin CoreData Retrieval			
	NSError *outError;
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"ConscienceAsset" inManagedObjectContext:self.context];
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
    [_returnedSubtitles release];
    [_returnedDisplayNames release];
    [_returnedImageNames release];
    [_returnedNames release];
    [_returnedCosts release];
    [_returnedOrientations release];
    [_returnedMoralValues release];
    [_persistedObjects release];
    [super dealloc];
}

@end
