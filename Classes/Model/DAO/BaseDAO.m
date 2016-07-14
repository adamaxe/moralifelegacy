#import "BaseDAO.h"

@interface BaseDAO () 

@property (nonatomic, strong) NSString *currentKey;             /**< current NSPredicate filter */
@property (nonatomic, strong) NSString *classType;              /**< current NSManagedObject type */
@property (nonatomic, strong) NSManagedObjectContext *context;  /**< injected context */
@property (nonatomic, strong) NSMutableArray *persistedObjects; /**< current NSManagedObjects under control */

- (NSManagedObject *)findPersistedObject:(NSString *)key;       /**< retrieve requested NSManagedObject from temp array */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *retrievePersistedObjects;                          /**< retrieve NSManagedObject from persisted store */

@end

@implementation BaseDAO 

NSString* const MLContextReadOnly = @"readOnly";
NSString* const MLContextReadWrite = @"readWrite";

#pragma mark -
#pragma mark Public API

/**
 Implementation: Default constructor.  Setup correct context type, instantiate ivars/props.  Dependency injection for the model manager allows for testing of all the DAOs
 */
- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager andClassType:(NSString *)classType {
    
    self = [super init];
    
    if (self) {

        if ([classType isEqualToString:MLContextReadWrite]) {
            self.context = moralModelManager.readWriteManagedObjectContext;
        } else {
            self.context = moralModelManager.managedObjectContext;
        }
        
        self.classType = [[NSString alloc] initWithString:classType];
        self.sorts = [[NSArray alloc] init];
        self.predicates = [[NSArray alloc] init];
        self.predicateDefaultName = [[NSMutableString alloc] initWithString:@""];
        self.sortDefaultName = [[NSMutableString alloc] initWithString:@""];
        self.managedObjectClassName = [[NSMutableString alloc] initWithString:@""];        
        
        if (key) {
            self.currentKey = [[NSString alloc] initWithString:key];
        } else {
            self.currentKey = @"";
        }
                
        self.persistedObjects = [[NSMutableArray alloc] init];
        
    }
    
    return self;
    
}

/**
 Implementation: Insert an NSManagedObject into the ReadWrite store, otherwise, cancel the create
 */
- (id)createObject {
    if ([self.classType isEqualToString:MLContextReadWrite]) {
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
    
    if ([_classType isEqualToString:MLContextReadWrite]) {

        NSError *error = nil;
        
        if (self.context.hasChanges) {
            [self.context save:&error];
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
    
    if ([self.classType isEqualToString:MLContextReadWrite]) {

        NSError *error = nil;
        
        if (objectToDelete) {
            [self.context delete:objectToDelete];
        } else {
            [self.context delete:[self findPersistedObject:self.currentKey]];
        }
        
        if (self.context.hasChanges) {
            [self.context save:&error];
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
- (NSInteger)count {
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
        return objects[0];
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
	request.entity = entityAssetDesc;

    //Get the default predicate
    NSMutableArray *currentPredicates = [[NSMutableArray alloc] initWithArray:self.predicates];

    //Determine if client requests a specific NSManagedObject
    if (![self.currentKey isEqualToString:@""]) {

        NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@", self.predicateDefaultName, self.currentKey];
        [currentPredicates addObject:pred];
    }
    
    NSPredicate *currentPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:currentPredicates];
    request.predicate = currentPredicate;


    //Determine if client requests a specific sort order
	if (self.sorts.count > 0) {
        request.sortDescriptors = self.sorts;
    } else {
        NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:self.sortDefaultName ascending:YES];
        NSArray* sortDescriptors = @[sortDescriptor];
        request.sortDescriptors = sortDescriptors;
    }
    
	NSArray *objects = [self.context executeFetchRequest:request error:&outError];
    	
    
    return objects;

}


@end
