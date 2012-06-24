#import "ConscienceAssetDAO.h"
#import "ModelManager.h"
#import "ConscienceAsset.h"

@interface ConscienceAssetDAO () {
	NSManagedObjectContext *context;		/**< Core Data context */	
}

- (ConscienceAsset *)findPersistedObject:(NSString *)moralName;
- (NSArray *)listMorals;

@property (nonatomic, retain) NSString *currentKey;
@property (nonatomic, retain) NSArray *persistedObjects;
@property (nonatomic, retain) NSMutableArray *returnedNames;
@property (nonatomic, retain) NSMutableArray *returnedImageNames;
@property (nonatomic, retain) NSMutableArray *returnedDetails;
@property (nonatomic, retain) NSMutableArray *returnedDisplayNames;

- (NSArray *)retrievePersistedObjects;
- (void)processObjects;

@end

@implementation ConscienceAssetDAO 

@synthesize currentKey;
@synthesize persistedObjects;
@synthesize returnedNames, returnedImageNames, returnedDetails, returnedDisplayNames;

- (id) init {
    return [self initWithKey:nil];
}



- (id)initWithKey:(NSString *)key {
    return [self initWithKey:key andInMemory:NO];
}

- (id)initWithKey:(NSString *)key andInMemory:(BOOL)isTransient {
    
    self = [super init];
    
    if (self) {
        ModelManager *moralModelManager = [[ModelManager alloc] initWithInMemoryStore:isTransient];
        context = [moralModelManager managedObjectContext];
        [moralModelManager release];
        
        NSString *requestedKey;
        
        if (key) {
            requestedKey = [[NSString alloc] initWithFormat:key];
        } else {
            requestedKey = [[NSString alloc] initWithFormat:@""];
        }
        
        self.currentKey = requestedKey;
        [requestedKey release];
        
        NSMutableArray *names = [[NSMutableArray alloc] init];
        self.returnedNames = names;
        [names release];
        
        NSMutableArray *imageNames = [[NSMutableArray alloc] init];
        self.returnedImageNames = imageNames;
        [imageNames release];
        
        NSMutableArray *displayNames = [[NSMutableArray alloc] init];
        self.returnedDisplayNames = displayNames;
        [displayNames release];
        
        NSMutableArray *details = [[NSMutableArray alloc] init];        
        self.returnedDetails = details;
        [details release];
        
        NSArray *objects = [[NSArray alloc] initWithArray:[self retrievePersistedObjects]];        
        self.persistedObjects = objects;
        [objects release];
        
        [self processObjects];

    }
    
    return self;
    
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

- (NSArray *)readAllNames {
    return self.returnedNames;
}

- (NSArray *)readAllDisplayNames {    
    return self.returnedDisplayNames;
}

- (NSArray *)readAllImageNames {    
    return self.returnedImageNames;
}

- (NSArray *)readAllDetails {
    return self.returnedDetails;
}

#pragma mark -
- (Moral *)findPersistedObject:(NSString *)key {
#pragma mark Private API
    if (self.persistedObjects.count == 0) {
        [self processObjects];
    }
    
    NSPredicate *findPred = [NSPredicate predicateWithFormat:@"SELF.nameMoral == %@", key];
    
    NSArray *objects = [self.persistedObjects filteredArrayUsingPredicate:findPred];
    
    return [objects objectAtIndex:0];
    
}

- (NSArray *)listMorals {
    return [self retrievePersistedObjects];
}

- (void)processObjects {
        
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
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"ConscienceAsset" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"nameReference == %@", currentKey];
    [request setPredicate:pred];
	
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameReference" ascending:YES];
	NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	NSArray *objects = [context executeFetchRequest:request error:&outError];
    	
	[request release];
    
    return objects;

}

@end
