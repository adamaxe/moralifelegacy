#import "BaseDAO.h"
#import "MoraLifeAppDelegate.h"

@interface BaseDAO () 

@property (nonatomic, retain) NSString *currentKey;
@property (nonatomic, retain) NSString *classType;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSMutableArray *persistedObjects;

- (NSManagedObject *)findPersistedObject:(NSString *)key;
- (NSArray *)retrievePersistedObjects;

@end

@implementation BaseDAO 

NSString* const kContextReadOnly = @"readOnly";
NSString* const kContextReadWrite = @"readWrite";

@synthesize sorts = _sorts;
@synthesize predicates = _predicates;

@synthesize currentKey = _currentKey;
@synthesize classType = _classType;
@synthesize predicateDefaultName = _predicateDefaultName;
@synthesize sortDefaultName = _sortDefaultName;
@synthesize managedObjectClassName = _managedObjectClassName;
@synthesize context = _context;
@synthesize persistedObjects = _persistedObjects;

- (id) init {
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [self initWithKey:nil andModelManager:[appDelegate moralModelManager] andClassType:kContextReadWrite];
}

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager andClassType:(NSString *)classType {
    
    self = [super init];
    
    if (self) {

        if ([classType isEqualToString:kContextReadWrite]) {
            _context = [[moralModelManager readWriteManagedObjectContext] retain];
        } else {
            _context = [[moralModelManager managedObjectContext] retain];            
        }
        
        _classType = [[NSString alloc] initWithString:classType];
        _sorts = [[NSArray alloc] init];
        _predicates = [[NSArray alloc] init];
        _predicateDefaultName = [[NSMutableString alloc] initWithString:@""];
        _sortDefaultName = [[NSMutableString alloc] initWithString:@""];
        _managedObjectClassName = [[NSMutableString alloc] initWithString:@""];        
        
        if (key) {
            _currentKey = [[NSString alloc] initWithString:key];
        } else {
            _currentKey = [[NSString alloc] initWithString:@""];
        }
                
        _persistedObjects = [[NSMutableArray alloc] init];
        
    }
    
    return self;
    
}

- (id)createObject {
    if ([_classType isEqualToString:kContextReadWrite]) {
        return [NSEntityDescription insertNewObjectForEntityForName:self.managedObjectClassName inManagedObjectContext:self.context];   
    } else {
        return nil;
    }
}

- (NSManagedObject *)readObject:(NSString *)key {
    return [self findPersistedObject:key];
}

- (NSArray *)readAll {
    [self refreshData];    
    return self.persistedObjects;
}

- (BOOL)update {
    
    BOOL isUpdateSuccessful = FALSE;
    
    if ([_classType isEqualToString:kContextReadWrite]) {

        NSError *error = nil;
        
        if ([_context hasChanges]) {
            [_context save:&error];
        }
        
        isUpdateSuccessful = error ? TRUE : FALSE;
    } else {
        isUpdateSuccessful = FALSE;
    }
    
    return isUpdateSuccessful;
}

- (BOOL)delete:(NSManagedObject *)objectToDelete {

    BOOL isDeleteSuccessful = FALSE;
    
    if ([_classType isEqualToString:kContextReadWrite]) {

        NSError *error = nil;
        
        if (objectToDelete) {
            [_context delete:objectToDelete];
        } else {
            [_context delete:[self findPersistedObject:self.currentKey]];
        }
        
        if ([_context hasChanges]) {
            [_context save:&error];
        }
        
        isDeleteSuccessful = error ? TRUE : FALSE;
    } else {
        isDeleteSuccessful = FALSE;
    }
    
    return isDeleteSuccessful;
}

- (int)count {
    [self refreshData];
    return self.persistedObjects.count;
}

#pragma mark -
#pragma mark Private API
- (NSManagedObject *)findPersistedObject:(NSString *)key {
    
    [self refreshData];
    
    NSPredicate *findPred;
    NSArray *objects;
    
    if (![key isEqualToString:@""]) {
        findPred = [NSPredicate predicateWithFormat:@"%K == %@", self.predicateDefaultName, key];
    
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
}

- (NSArray *)retrievePersistedObjects {
    //Begin CoreData Retrieval			
	NSError *outError;
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:self.managedObjectClassName inManagedObjectContext:self.context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
    
    NSMutableArray *currentPredicates = [[NSMutableArray alloc] initWithArray:self.predicates];
    
    if (![self.currentKey isEqualToString:@""]) {

        NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@", self.predicateDefaultName, self.currentKey];
        [currentPredicates addObject:pred];
    }
    
    NSPredicate *currentPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:currentPredicates];
    [request setPredicate:currentPredicate];

    [currentPredicates release];

	if (self.sorts.count > 0) {
        [request setSortDescriptors:self.sorts];
    } else {
        NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:self.sortDefaultName ascending:YES];
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
    [_classType release];
    [_predicateDefaultName release];
    [_sortDefaultName release];
    [_managedObjectClassName release];
    [_context release];
    [_persistedObjects release];
    [super dealloc];
}

@end