/**
 Moralife Model Manager Implementation.  This class is the interface to Core Data and the entire persistence stack.
 
 @class ModelManager ModelManager.h
 */
#import "ModelManager.h"

@interface ModelManager () {
    
@private	
	NSManagedObjectModel	*managedObjectModel;
	NSManagedObjectContext	*managedObjectContext;
	NSPersistentStoreCoordinator	*persistentStoreCoordinator;
    
}

@property (nonatomic, retain) NSBundle *currentBundle;
@property (nonatomic, retain) NSString *storeType;

@end

@implementation ModelManager

@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;
@synthesize currentBundle;
@synthesize storeType;

#pragma mark -
#pragma mark Core Data stack

- (id)init {
    
    return [self initWithInMemoryStore:NO];
}

- (id)initWithInMemoryStore:(BOOL)isTransient {
    
    self = [super init];
    
    if (self) {
        self.currentBundle = [NSBundle bundleForClass:self.class];
        if (isTransient) {
            storeType = [[NSString alloc] initWithString:NSInMemoryStoreType];
        } else {
            storeType = [[NSString alloc] initWithString:NSSQLiteStoreType];
        }
        
        NSManagedObjectContext *context = [self managedObjectContext];
        managedObjectContext = context;
    }
    
    return self;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
	NSString *pathReadWrite = [self.currentBundle pathForResource:@"UserData" ofType:@"momd"];
	NSURL *momURLReadWrite = [NSURL fileURLWithPath:pathReadWrite];
    
	NSManagedObjectModel *modelReadWrite = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadWrite]; 
	
	NSString *pathReadOnly = [self.currentBundle pathForResource:@"SystemData" ofType:@"momd"];
	NSURL *momURLReadOnly = [NSURL fileURLWithPath:pathReadOnly];
	NSManagedObjectModel *modelReadOnly = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadOnly];      
	
	managedObjectModel = [NSManagedObjectModel modelByMergingModels:[NSArray arrayWithObjects:modelReadWrite, modelReadOnly, nil]];
	
	[modelReadOnly release];
	[modelReadWrite release];
    
	return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 Additionally, if the pre-populated DB hasn't been moved to Documents, this occurs.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
	//Retrieve readwrite Documents directory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	//Create pre-loaded SQLite db location
	NSString *preloadData =  [documentsDirectory stringByAppendingPathComponent:@"SystemData.sqlite"];
	NSURL *storeURL = [NSURL fileURLWithPath:preloadData];
	NSString *preloadDataReadWrite =  [documentsDirectory stringByAppendingPathComponent:@"UserData.sqlite"];
	NSURL *storeURLReadWrite = [NSURL fileURLWithPath:preloadDataReadWrite];
    
	//Create filemanager to manipulate filesystem
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	//Determine if pre-loaded SQLite db exists
	BOOL isSQLiteFilePresent = [fileManager fileExistsAtPath:preloadData];
    NSError *error = nil;
    
    NSString *defaultStorePath = [self.currentBundle pathForResource:@"SystemData" ofType:@"sqlite"];
    
    
	//Copy pre-loaded SQLite db from bundle to Documents if it doesn't exist
	if (!isSQLiteFilePresent) {
        
        NSString *defaultStorePathWrite = [self.currentBundle pathForResource:@"UserData" ofType:@"sqlite"];
        
		//Ensure that pre-loaded SQLite db exists in bundle before copy
		if (defaultStorePath) {
            
			[fileManager copyItemAtPath:defaultStorePath toPath:preloadData error:&error];
            
			NSLog(@"Unresolved error %@", error);
        }
        
		//Ensure that pre-loaded SQLite db exists in bundle before copy
		if (defaultStorePathWrite) {
			error = nil;
            
			[fileManager copyItemAtPath:defaultStorePathWrite toPath:preloadDataReadWrite error:&error];
            
			NSLog(@"Unresolved error %@", error);
		}  
        
    } else {
        
        error = nil;
        
        NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:defaultStorePath error:&error];
        NSDate *defaultFileDate =[dictionary objectForKey:NSFileModificationDate];
        dictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:preloadData error:&error];
        NSDate *preloadFileDate =[dictionary objectForKey:NSFileModificationDate];
        
        
        if ([defaultFileDate compare:preloadFileDate] == NSOrderedDescending) {
            NSLog(@"file overridden");
            [fileManager removeItemAtPath:preloadData error:&error];
            [fileManager copyItemAtPath:defaultStorePath toPath:preloadData  error:&error];
        }
        
    }
    
    
	//handle db upgrade for auto migration for minor schema changes
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
    error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
	if (![persistentStoreCoordinator addPersistentStoreWithType:self.storeType configuration:nil URL:storeURL options:options error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
	
	if (![persistentStoreCoordinator addPersistentStoreWithType:self.storeType configuration:nil URL:storeURLReadWrite options:options error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    } 
    
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark public API

- (id)create: (Class) insertedClass {
    
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(insertedClass) inManagedObjectContext:self.managedObjectContext];
}

- (NSArray *)readAll: (Class) requestedClass {
    NSError *error = nil;
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass(requestedClass)];
    
    NSArray *results;
    
    @try {
        results = [self.managedObjectContext executeFetchRequest: fetch error: &error];
    }
    @catch (NSException *exception) {
        @throw(exception);
    }    
    
    if (error) {
        NSString *errorMessage = [NSString stringWithFormat:@"Test Core Data fetch failed: %@\n\n", [error description]];
        [NSException raise:@"CoreDataFetchError" format:errorMessage];
    }
    
    return results;
}

- (id)read: (Class) requestedClass withKey: (id) classKey andValue:(id) keyValue {    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass(requestedClass)];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%@ == %@", classKey, keyValue];
	[request setPredicate:pred];
	[pred release];
    
    NSArray *results;
    
    @try {
        results = [self.managedObjectContext executeFetchRequest: request error: &error];
    }
    @catch (NSException *exception) {
        @throw(exception);
    }    
    
    if (error) {
        NSString *errorMessage = [NSString stringWithFormat:@"Test Core Data fetch failed: %@\n\n", [error description]];
        [NSException raise:@"CoreDataFetchError" format:errorMessage];
    }
    
    return [results objectAtIndex:0];
}


- (void)delete: (id) object {
    
    @try {
        [self.managedObjectContext deleteObject: object];
        [self saveContext];
    }
    @catch (NSException *exception) {
        @throw(exception); 
    }    
    
}


- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *saveManagedObjectContext = self.managedObjectContext;
    if (saveManagedObjectContext != nil) {
        
        @try {
            if ([saveManagedObjectContext hasChanges]) {
                [self.managedObjectContext save: &error];
            }
        }
        @catch (NSException *exception) {
            @throw(exception); 
            abort();
        }    
        
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"Test Core Data save failed: %@\n\n", [error description]];
            [NSException raise:@"CoreDataSaveError" format:errorMessage];
            
        }
        
    }
} 

-(void)dealloc {
    [storeType release];
    
    [super dealloc];
}
@end
