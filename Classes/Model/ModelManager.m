/**
 Moralife Model Manager Implementation.  This class is the interface to Core Data and the entire persistence stack.
 
 @class ModelManager ModelManager.h
 */
#import "ModelManager.h"

NSString* const kMLCoreDataReadOnlyModelName = @"SystemData";
NSString* const kMLCoreDataReadWriteModelName = @"UserData";
NSString* const kMLCoreDataModelExtension = @"momd";
NSString* const kMLCoreDataPersistentStoreType = @"sqlite";

@interface ModelManager () 

@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectModel *readWriteManagedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *readWriteManagedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSPersistentStoreCoordinator *readWritePersistentStoreCoordinator;
@property (nonatomic, retain) NSBundle *currentBundle;
@property (nonatomic, retain) NSString *storeType;

@end

@implementation ModelManager

@synthesize managedObjectModel = _managedObjectModel;
@synthesize readWriteManagedObjectModel = _readWriteManagedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize readWriteManagedObjectContext = _readWriteManagedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize readWritePersistentStoreCoordinator = _readWritePersistentStoreCoordinator;
@synthesize currentBundle = _currentBundle;
@synthesize storeType = _storeType;

#pragma mark -
#pragma mark Core Data stack

- (id)init {
    
    return [self initWithInMemoryStore:NO];
}

- (id)initWithInMemoryStore:(BOOL)isTransient {
    
    self = [super init];
    
    if (self) {
        if (isTransient) {
            _currentBundle = [NSBundle bundleForClass:self.class];
            _storeType = [[NSString alloc] initWithString:NSInMemoryStoreType];
        } else {
            _currentBundle = [NSBundle mainBundle];
            _storeType = [[NSString alloc] initWithString:NSSQLiteStoreType];
        }
        
        _managedObjectContext = [self managedObjectContext];
        _readWriteManagedObjectContext = [self readWriteManagedObjectContext];

    }
    
    return self;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)readWriteManagedObjectContext {
    
    if (_readWriteManagedObjectContext != nil) {
        return _readWriteManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self readWritePersistentStoreCoordinator];
    if (coordinator != nil) {
        _readWriteManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [_readWriteManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _readWriteManagedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
		
	NSString *pathReadOnly = [self.currentBundle pathForResource:@"SystemData" ofType:@"momd"];
	NSURL *momURLReadOnly = [NSURL fileURLWithPath:pathReadOnly];
	NSManagedObjectModel *modelReadOnly = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadOnly];      
	
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadOnly]; 
	
	[modelReadOnly release];
    
	return _managedObjectModel;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)readWriteManagedObjectModel {
    
    if (_readWriteManagedObjectModel != nil) {
        return _readWriteManagedObjectModel;
    }
	
	NSString *pathReadWrite = [self.currentBundle pathForResource:@"UserData" ofType:@"momd"];
	NSURL *momURLReadWrite = [NSURL fileURLWithPath:pathReadWrite];
    _readWriteManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadWrite]; 
	
	return _readWriteManagedObjectModel;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)mergedManagedObjectModel {
    	
	NSString *pathReadWrite = [self.currentBundle pathForResource:@"UserData" ofType:@"momd"];
	NSURL *momURLReadWrite = [NSURL fileURLWithPath:pathReadWrite];
    NSManagedObjectModel *modelReadWrite = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadWrite]; 
	
    NSString *pathReadOnly = [self.currentBundle pathForResource:@"SystemData" ofType:@"momd"];
	NSURL *momURLReadOnly = [NSURL fileURLWithPath:pathReadOnly];
	NSManagedObjectModel *modelReadOnly = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadOnly];
    
    NSManagedObjectModel *mergedModel = [[NSManagedObjectModel modelByMergingModels:[NSArray arrayWithObjects:modelReadWrite, modelReadOnly, nil]] retain];
	
	[modelReadOnly release];
	[modelReadWrite release];

	return [mergedModel autorelease];
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 Additionally, if the pre-populated DB hasn't been moved to Documents, this occurs.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
	//Retrieve readwrite Documents directory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	//Create pre-loaded SQLite db location
	NSString *preloadData =  [documentsDirectory stringByAppendingPathComponent:@"SystemData.sqlite"];
	NSURL *storeURL = [NSURL fileURLWithPath:preloadData];
    
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [cachePaths objectAtIndex:0];
    //Create pre-loaded SQLite db location
    NSString *preloadCacheData =  [cacheDirectory stringByAppendingPathComponent:@"SystemData.sqlite"];
    NSURL *storeCacheURL = [NSURL fileURLWithPath:preloadCacheData];

    
	//Create filemanager to manipulate filesystem
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	//Determine if pre-loaded SQLite db exists
	BOOL isSQLiteFilePresent = [fileManager fileExistsAtPath:preloadData];
    NSError *error = nil;
    
    NSString *defaultStorePath = [self.currentBundle pathForResource:@"SystemData" ofType:@"sqlite"];
    
    
	//Copy pre-loaded SQLite db from bundle to Documents if it doesn't exist
	if (!isSQLiteFilePresent) {
                
		//Ensure that pre-loaded SQLite db exists in bundle before copy
		if (defaultStorePath) {
            
			[fileManager copyItemAtPath:defaultStorePath toPath:preloadData error:&error];
            
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
    
    // Create one coordinator that just migrates, but isn't used.
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    error = nil;    
    
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:storeURL error:&error];
    BOOL isMigrationRequired = ![[self managedObjectModel] isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
    BOOL isMergedModelAcceptible = [[self mergedManagedObjectModel] isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];

    if (isMigrationRequired && isMergedModelAcceptible) {
        
        [self migrateStore:storeURL toMigratedStore:storeCacheURL withModel:[self mergedManagedObjectModel] andDestinationModel:[self managedObjectModel] error:&error];
        
    }
    
    error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
	if (![_persistentStoreCoordinator addPersistentStoreWithType:self.storeType configuration:nil URL:storeURL options:options error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 Additionally, if the pre-populated DB hasn't been moved to Documents, this occurs.
 */
- (NSPersistentStoreCoordinator *)readWritePersistentStoreCoordinator {
    
    if (_readWritePersistentStoreCoordinator != nil) {
        return _readWritePersistentStoreCoordinator;
    }
    
	//Retrieve readwrite Documents directory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	//Create pre-loaded SQLite db location
	NSString *preloadDataReadWrite =  [documentsDirectory stringByAppendingPathComponent:@"UserData.sqlite"];
	NSURL *storeURLReadWrite = [NSURL fileURLWithPath:preloadDataReadWrite];
    
	//Create filemanager to manipulate filesystem
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	//Determine if pre-loaded SQLite db exists
	BOOL isSQLiteFilePresent = [fileManager fileExistsAtPath:preloadDataReadWrite];
    NSError *error = nil;
    
	//Copy pre-loaded SQLite db from bundle to Documents if it doesn't exist
	if (!isSQLiteFilePresent) {
        
        NSString *defaultStorePathWrite = [self.currentBundle pathForResource:@"UserData" ofType:@"sqlite"];
        
		//Ensure that pre-loaded SQLite db exists in bundle before copy
		if (defaultStorePathWrite) {
			error = nil;
            
			[fileManager copyItemAtPath:defaultStorePathWrite toPath:preloadDataReadWrite error:&error];
            
			NSLog(@"Unresolved error %@", error);
		}  
        
    }     
    
	//handle db upgrade for auto migration for minor schema changes
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
    error = nil;
    _readWritePersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self readWriteManagedObjectModel]];
    
	
	if (![_readWritePersistentStoreCoordinator addPersistentStoreWithType:self.storeType configuration:nil URL:storeURLReadWrite options:options error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    } 
    
    return _readWritePersistentStoreCoordinator;
}


- (BOOL)migrateStore:(NSURL *)storeURL toMigratedStore:(NSURL *)destinationStoreURL withModel:(NSManagedObjectModel *) sourceModel andDestinationModel:(NSManagedObjectModel *)destinationModel error:(NSError **)outError {
    
    // Try to get an inferred mapping model.
    NSMappingModel *mappingModel = [NSMappingModel inferredMappingModelForSourceModel:sourceModel
                                      destinationModel:destinationModel error:outError];
    
    // If Core Data cannot create an inferred mapping model, return NO.
    if (!mappingModel) {
        return NO;
    }
    
    // Get the migration manager class to perform the migration.
    NSValue *classValue = [[NSPersistentStoreCoordinator registeredStoreTypes] objectForKey:NSSQLiteStoreType];
    Class sqliteStoreClass = (Class)[classValue pointerValue];
    Class sqliteStoreMigrationManagerClass = [sqliteStoreClass migrationManagerClass];
    
    NSMigrationManager *manager = [[sqliteStoreMigrationManagerClass alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];
    
    BOOL success = [manager migrateStoreFromURL:storeURL type:NSSQLiteStoreType
                                        options:nil withMappingModel:mappingModel toDestinationURL:destinationStoreURL
                                destinationType:NSSQLiteStoreType destinationOptions:nil error:outError];
    
    [manager release];
    
    return success;
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
    
    if ([results count] > 0) {
        return [results objectAtIndex:0];
    } else {
        return nil;
    }
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
	NSManagedObjectContext *saveReadWriteManagedObjectContext = self.readWriteManagedObjectContext;
    
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
            NSString *errorMessage = [NSString stringWithFormat:@"Core Data Read Only save failed: %@\n\n", [error description]];
            [NSException raise:@"CoreDataSaveError" format:errorMessage];
            
        }
        
    }
    
    if (saveReadWriteManagedObjectContext != nil) {
        
        @try {
            if ([saveReadWriteManagedObjectContext hasChanges]) {
                [self.readWriteManagedObjectContext save: &error];
            }
        }
        @catch (NSException *exception) {
            @throw(exception); 
            abort();
        }    
        
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"Core Data Read Write save failed: %@\n\n", [error description]];
            [NSException raise:@"CoreDataSaveError" format:errorMessage];
            
        }
        
    }    
} 

-(void)dealloc {
    [_storeType release];
    
    [super dealloc];
}
@end
