/**
 Implementation:  Present a GraphView of piechart type with accompanying data descriptors.

 @class BaseDAO BaseDAO.h
 */

#import "BaseDAO.h"
#import "MoraLifeAppDelegate.h"

@interface BaseDAO () 

@property (nonatomic, retain) NSString *currentKey;             /**< current NSPredicate filter */
@property (nonatomic, retain) NSString *classType;              /**< current NSManagedObject type */
@property (nonatomic, retain) NSManagedObjectContext *context;  /**< injected context */
@property (nonatomic, retain) NSMutableArray *persistedObjects; /**< current NSManagedObjects under control */

- (NSManagedObject *)findPersistedObject:(NSString *)key;       /**< retrieve requested NSManagedObject from temp array */
- (NSArray *)retrievePersistedObjects;                          /**< retrieve NSManagedObject from persisted store */

@end

@implementation BaseDAO 

NSString* const kContextReadOnly = @"readOnly";
NSString* const kContextReadWrite = @"readWrite";

/**
 Implementation: In case of base init is called, forward call to default constructor to utilize rw context
 */
- (id) init {
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [self initWithKey:nil andModelManager:[appDelegate moralModelManager] andClassType:kContextReadWrite];
}

#pragma mark -
#pragma mark Public API

/**
 Implementation: Default constructor.  Setup correct context type, instantiate ivars/props.  Dependency injection for the model manager allows for testing of all the DAOs
 */
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

/**
 Implementation: Insert an NSManagedObject into the ReadWrite store, otherwise, cancel the create
 */
- (id)createObject {
    if ([_classType isEqualToString:kContextReadWrite]) {
        return [NSEntityDescription insertNewObjectForEntityForName:self.managedObjectClassName inManagedObjectContext:self.context];   
    } else {
        return nil;
    }
}

/**
 Implementation: Read a single NSManagedObject from either Store based upon the key
 */
- (NSManagedObject *)readObject:(NSString *)key {
    return [self findPersistedObject:key];
}

/**
 Implementation: Read all NSManagedObjects from either Store based upon the Class
 */
- (NSArray *)readAll {
    [self refreshData];    
    return self.persistedObjects;
}

/**
 Implementation: Update the current, single NSManagedObject from the readWrite Store, otherwise fail
 */
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

/**
 Implementation: Delete a single NSManagedObject from the readWrite Store, otherwise fail
 */
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

/**
 Implementation: Count of current NSManagedObjects known to the DAO
 */
- (int)count {
    [self refreshData];
    return self.persistedObjects.count;
}

#pragma mark -
#pragma mark Private API

/**
 Implementation: Locate the requested NSManagedObject using a default predicate
 */
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

/**
 Implementation: Reload the NSManagedObjects known to DAO
 */
- (void)refreshData {
    [self.persistedObjects removeAllObjects];
    [self.persistedObjects addObjectsFromArray:[self retrievePersistedObjects]];
}

/**
 Implementation: Retrieve the current objects based upon the current predicate, object type and requested sort order
 */
- (NSArray *)retrievePersistedObjects {

	NSError *outError;
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:self.managedObjectClassName inManagedObjectContext:self.context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];

    //Get the default predicate
    NSMutableArray *currentPredicates = [[NSMutableArray alloc] initWithArray:self.predicates];

    //Determine if client requests a specific NSManagedObject
    if (![self.currentKey isEqualToString:@""]) {

        NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@", self.predicateDefaultName, self.currentKey];
        [currentPredicates addObject:pred];
    }
    
    NSPredicate *currentPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:currentPredicates];
    [request setPredicate:currentPredicate];

    [currentPredicates release];

    //Determine if client requests a specific sort order
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
