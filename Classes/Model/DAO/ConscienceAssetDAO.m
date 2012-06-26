#import "ConscienceAssetDAO.h"
#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "ConscienceAsset.h"
#import "Moral.h"

@interface ConscienceAssetDAO () 

- (ConscienceAsset *)findPersistedObject:(NSString *)key;

@property (nonatomic, retain) NSString *currentKey;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSMutableArray *persistedObjects;
@property (nonatomic, retain) NSMutableArray *returnedNames;
@property (nonatomic, retain) NSMutableArray *returnedImageNames;
@property (nonatomic, retain) NSMutableArray *returnedDetails;
@property (nonatomic, retain) NSMutableArray *returnedDisplayNames;

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
@synthesize returnedDetails = _returnedDetails;
@synthesize returnedDisplayNames = _returnedDisplayNames;

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
        _predicates = [[NSSet alloc] init];
                
        if (key) {
            _currentKey = [[NSString alloc] initWithFormat:key];
        } else {
            _currentKey = [[NSString alloc] initWithFormat:@""];
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

- (int)readCost:(NSString *)key {
    return [[self findPersistedObject:key].costAsset intValue];
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
    [self.returnedDetails removeAllObjects];    
        
    for (ConscienceAsset *match in self.persistedObjects){
        [self.returnedNames addObject:[match nameReference]];
        [self.returnedImageNames addObject:[match imageNameReference]];
        [self.returnedDisplayNames addObject:[match displayNameReference]];
        [self.returnedDetails addObject:[match longDescriptionReference]];			
    }
    
}

- (NSArray *)retrievePersistedObjects {
    //Begin CoreData Retrieval			
	NSError *outError;
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"ConscienceAsset" inManagedObjectContext:self.context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];

    if (![self.currentKey isEqualToString:@""]) {

        NSPredicate *pred = [NSPredicate predicateWithFormat:@"nameReference == %@", self.currentKey];
        [request setPredicate:pred];
    }
	
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameReference" ascending:YES];
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
    [_currentKey release];
    [_context release];
    [_returnedDetails release];
    [_returnedDisplayNames release];
    [_returnedImageNames release];
    [_returnedNames release];
    [_persistedObjects release];
    [super dealloc];
}

@end
