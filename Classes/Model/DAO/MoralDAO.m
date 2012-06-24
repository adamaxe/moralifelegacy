#import "MoralDAO.h"
#import "ModelManager.h"
#import "Moral.h"

@interface MoralDAO () {
	NSManagedObjectContext *context;		/**< Core Data context */	
}

- (Moral *)findPersistedObject:(NSString *)key;
- (NSArray *)listPersistedObjects;

@property (nonatomic, retain) NSString *currentKey;
@property (nonatomic, retain) NSString *currentType;
@property (nonatomic, retain) NSArray *persistedObjects;
@property (nonatomic, retain) NSMutableArray *returnedNames;
@property (nonatomic, retain) NSMutableArray *returnedImageNames;
@property (nonatomic, retain) NSMutableArray *returnedDetails;
@property (nonatomic, retain) NSMutableArray *returnedDisplayNames;

- (NSArray *)retrievePersistedObjects;
- (void)processObjects;

@end

@implementation MoralDAO 

@synthesize currentKey, currentType;
@synthesize persistedObjects;
@synthesize returnedNames, returnedImageNames, returnedDetails, returnedDisplayNames;

- (id)init {    
    return [self initWithType:@"all"];
}

- (id)initWithType:(NSString *)type {
    
    return [self initWithType:type andInMemory:NO];
}

- (id)initWithType:(NSString *)type andInMemory:(BOOL)isTransient {


    self = [super init];

    if (self) {
        ModelManager *moralModelManager = [[ModelManager alloc] initWithInMemoryStore:isTransient];
        context = [moralModelManager managedObjectContext];
        [moralModelManager release];

        NSString *requestedType;
        
        if (type) {
            requestedType = [[NSString alloc] initWithFormat:type];
        } else {
            requestedType = [[NSString alloc] initWithFormat:@"all"];
        }
        
        self.currentType = requestedType;
        [requestedType release];

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
#pragma mark Private API
- (Moral *)findPersistedObject:(NSString *)key {    
    NSPredicate *findPred = [NSPredicate predicateWithFormat:@"SELF.nameMoral == %@", key];
    
    NSArray *objects = [self.persistedObjects filteredArrayUsingPredicate:findPred];
    
    return [objects objectAtIndex:0];
    
}

- (NSArray *)listPersistedObjects {
    
    return self.persistedObjects;
}

- (void)processObjects {
        
    for (Moral *match in self.persistedObjects){
        [self.returnedNames addObject:[match nameMoral]];
        [self.returnedImageNames addObject:[match imageNameMoral]];
        [self.returnedDisplayNames addObject:[match displayNameMoral]];
        [self.returnedDetails addObject:[match longDescriptionMoral]];			
    }
    
}

- (NSArray *)retrievePersistedObjects {
    //Begin CoreData Retrieval			
	NSError *outError;
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"Moral" inManagedObjectContext:context];
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
	
	NSArray *objects = [context executeFetchRequest:request error:&outError];
    	
	[request release];
    
    return objects;

}

@end
