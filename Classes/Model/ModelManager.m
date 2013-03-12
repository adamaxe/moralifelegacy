/**
 Moralife Model Manager Implementation.  This class is the interface to Core Data and the entire persistence stack.
 
 MoraLife's ORM and Seed Data is complex.  Therefore, it is not advisable to use a single NSPersistentStoreCoordinator with configurations for the 2 store types.
 Migration is complicated by the fact that auto-migration is not smart enough to determine a mapping model on a single store of a merged model.
 Two complete CoreData stacks are constructed, then, in order to be able to update UserData and SystemData without having to make a mapping model for each version.
 
 @class ModelManager ModelManager.h
 */
#import "ModelManager.h"

NSString* const ModelManagerReadOnlyModelName = @"SystemData";
NSString* const ModelManagerReadWriteModelName = @"UserData";
NSString* const ModelManagerDataModelExtension = @"momd";
NSString* const ModelManagerStoreType = @"sqlite";

@interface ModelManager () 

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;             /**< readOnly NSManagedObjectModel */
@property (nonatomic, strong) NSManagedObjectModel *readWriteManagedObjectModel;    /**< readWrite NSManagedObjectModel */
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;             /**< readOnly NSManagedObjectContext */
@property (nonatomic, strong) NSManagedObjectContext *readWriteManagedObjectContext;    /**< readWrite NSManagedObjectContext */
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;             /**< readOnly NSPersistentStoreCoordinator */
@property (nonatomic, strong) NSPersistentStoreCoordinator *readWritePersistentStoreCoordinator;    /**< readWrite NSManagedObjectContext */
@property (nonatomic, strong) NSBundle *currentBundle;                                  /**< Bundle in which to look for the store */
@property (nonatomic, strong) NSString *storeType;                                      /**< Store type of in-memory or sqlite */

@end

@implementation ModelManager

#pragma mark -
#pragma mark Core Data stack

/**
If in-memory store type omitted, then sqlite is assumed
 */
- (id)init {
    
    return [self initWithInMemoryStore:NO];
}

/**
Allows for testing of the Core Data stack by setting up either the real, sqlite persistent store or an in-memory version
 */
- (id)initWithInMemoryStore:(BOOL)isTransient {
    
    self = [super init];
    
    if (self) {
        if (isTransient) {
            self.currentBundle = [NSBundle bundleForClass:self.class];
            self.storeType = [[NSString alloc] initWithString:NSInMemoryStoreType];
        } else {
            self.currentBundle = [NSBundle mainBundle];
            self.storeType = [[NSString alloc] initWithString:NSSQLiteStoreType];
        }
        
        self.managedObjectContext = [self managedObjectContext];
        self.readWriteManagedObjectContext = [self readWriteManagedObjectContext];
        
    }
    
    return self;
}

/**
 Returns the readonly managed object context for the application.
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
 Returns the read/write managed object context for the application.
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
 Returns the readonly managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
	NSString *pathReadOnly = [self.currentBundle pathForResource:ModelManagerReadOnlyModelName ofType:ModelManagerDataModelExtension];
	NSURL *momURLReadOnly = [NSURL fileURLWithPath:pathReadOnly];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadOnly];      
    
	return _managedObjectModel;
}

/**
 Returns the read/write managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)readWriteManagedObjectModel {
    
    if (_readWriteManagedObjectModel != nil) {
        return _readWriteManagedObjectModel;
    }
	
	NSString *pathReadWrite = [self.currentBundle pathForResource:ModelManagerReadWriteModelName ofType:ModelManagerDataModelExtension];
	NSURL *momURLReadWrite = [NSURL fileURLWithPath:pathReadWrite];
    _readWriteManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadWrite]; 
    
	return _readWriteManagedObjectModel;
}

/**
 Returns the legacy, merged managed object model for the application.  This is needed for legacy migration.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)mergedManagedObjectModel {
    
	NSString *pathReadWrite = [self.currentBundle pathForResource:ModelManagerReadWriteModelName ofType:ModelManagerDataModelExtension];
    NSBundle *bundleReadWrite = [NSBundle bundleWithPath:pathReadWrite];
    NSString *pathOriginalReadWriteMOM = [bundleReadWrite pathForResource:@"UserData" ofType:@"mom"];

	NSURL *momURLReadWrite = [NSURL fileURLWithPath:pathOriginalReadWriteMOM];
    NSManagedObjectModel *modelReadWrite = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadWrite]; 
	
    NSString *pathReadOnly = [self.currentBundle pathForResource:ModelManagerReadOnlyModelName ofType:ModelManagerDataModelExtension];
    NSBundle *bundleReadOnly = [NSBundle bundleWithPath:pathReadOnly];
    NSString *pathOriginalReadOnlyMOM = [bundleReadOnly pathForResource:@"SystemData2" ofType:@"mom"];

	NSURL *momURLReadOnly = [NSURL fileURLWithPath:pathOriginalReadOnlyMOM];
	NSManagedObjectModel *modelReadOnly = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadOnly];
    
    NSManagedObjectModel *mergedModel = [NSManagedObjectModel modelByMergingModels:@[modelReadWrite, modelReadOnly]];
	
    
	return mergedModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 Also, if the pre-populated DB hasn't been moved to Library/Caches, this occurs.
 Otherwise, if the pre-populated DB was found in Documents, the store is migrated to the new non-merged Model.
 Lastly, the non-merged Model-based store is moved to Library/Caches to keep it from iCloud/Backup
 
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    //Determine if store coordinator is instantiated already
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    //Retrieve legacy readwrite store from Documents directory if it exists
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    
    //Create pre-loaded, legacy SQLite db location
    NSString *readOnlyStore = [NSString stringWithFormat:@"%@.%@", ModelManagerReadOnlyModelName, ModelManagerStoreType];
    NSString *readOnlyStoreTemp = [NSString stringWithFormat:@"%@Temp.%@", ModelManagerReadOnlyModelName, ModelManagerStoreType];
    NSString *preloadLegacyData =  [documentsDirectory stringByAppendingPathComponent:readOnlyStore];
    NSURL *storeLegacyURL = [NSURL fileURLWithPath:preloadLegacyData];
    
    //Create the pre-loaded, correcdt SQLite db location in Library/Caches
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = cachePaths[0];
    
    //Create pre-loaded SQLite db location
    NSString *preloadCacheData =  [cacheDirectory stringByAppendingPathComponent:readOnlyStore];
    NSString *preloadCacheDataTemp =  [cacheDirectory stringByAppendingPathComponent:readOnlyStoreTemp];
    
    NSURL *storeCacheURL = [NSURL fileURLWithPath:preloadCacheData];
    NSURL *storeCacheURLTemp = [NSURL fileURLWithPath:preloadCacheDataTemp];
    
    
	//Create filemanager to manipulate filesystem
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	//Determine if pre-loaded SQLite db exists in the correct, Library/Caches path
	BOOL isSQLiteFilePresent = [fileManager fileExistsAtPath:preloadCacheData];
    NSError *error = nil;
    
    NSString *defaultStorePath = [self.currentBundle pathForResource:ModelManagerReadOnlyModelName ofType:ModelManagerStoreType];
    
	//Determine status of persistent store
	if (isSQLiteFilePresent) {
        
        //Copy pre-loaded SQLite db from bundle to Caches if it is bundle version is newer
        //This means that data was updated with the newer app version
        error = nil;
        
        NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:defaultStorePath error:&error];
        NSDate *defaultFileDate =dictionary[NSFileModificationDate];
        dictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:preloadCacheData error:&error];
        NSDate *preloadFileDate =dictionary[NSFileModificationDate];
        
        //Check to see if older data was found in cache, replace with newer version
        if ([defaultFileDate compare:preloadFileDate] == NSOrderedDescending) {
            [fileManager removeItemAtPath:preloadCacheData error:&error];
            [fileManager copyItemAtPath:defaultStorePath toPath:preloadCacheData  error:&error];
        }
        
    } else {
        
        BOOL isPreloadLegacyDataPresent = [fileManager fileExistsAtPath:preloadLegacyData];
        
        //DB was not found in Library/Caches.  This means it could be in Documents (legacy) or only in the bundle (first load).
        if(isPreloadLegacyDataPresent) {
            //DB was found in legacy location (Documents), move it to caches, remove legacy
            [fileManager removeItemAtPath:preloadLegacyData error:&error];
            
            if (error) {                
                NSLog(@"Error with copying legacy ReadOnly store from Documents Directory %@", error);
            }
            
        }
        
        BOOL isDefaultStoreDataPresent = [fileManager fileExistsAtPath:defaultStorePath];        
        
        if (isDefaultStoreDataPresent) {
            //Ensure that pre-loaded SQLite db exists in bundle before copy
			[fileManager copyItemAtPath:defaultStorePath toPath:preloadCacheData error:&error];
            
            if (error) {                
                NSLog(@"Error with copying ReadOnly store from bundle %@", error);
            }
        }
        
    }
    
	//handle db upgrade for auto migration for minor schema changes
	NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @(YES), NSInferMappingModelAutomaticallyOption: @(YES)};
    error = nil;    
    
    //Older model design utilized a merged model.  This needs to be corrected.
    //Determine if migration is necessary by checking to see if current Model is comaptible with current store metadata
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:storeCacheURL error:&error];
    
    BOOL isMigrationRequired = ![[self managedObjectModel] isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];;
    BOOL isMergedModelAcceptible;
    
    if (isMigrationRequired) {
        
        //Determine if legacy, merged model is capable of migrating the store
        isMergedModelAcceptible = [[self mergedManagedObjectModel] isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
    }
    
    //If both a migration is necessary and the legacy, merged model can migrate the current store.
    if (isMigrationRequired && isMergedModelAcceptible) {
        
        BOOL isDocumentsVersionPresent = [fileManager fileExistsAtPath:preloadLegacyData];
        BOOL isCacheVersionPresent = [fileManager fileExistsAtPath:preloadCacheData];
        
        if (isDocumentsVersionPresent) {
            
            [fileManager removeItemAtPath:preloadCacheData error:&error];
            
            [self migrateStore:storeLegacyURL toMigratedStore:storeCacheURL withModel:[self mergedManagedObjectModel] andDestinationModel:[self managedObjectModel] error:&error];
        } else {
            
            if (isCacheVersionPresent) {
                
                error = nil;
                [self migrateStore:storeCacheURL toMigratedStore:storeCacheURLTemp withModel:[self mergedManagedObjectModel] andDestinationModel:[self managedObjectModel] error:&error];
                
                [fileManager removeItemAtPath:preloadCacheData error:&error];
                [fileManager copyItemAtPath:preloadCacheDataTemp toPath:preloadCacheData error:&error];
                [fileManager removeItemAtPath:preloadCacheDataTemp error:&error];
            } 
        }
    }
    
    //Otherwise, simply load the store with automatic migration
    error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
	if (![_persistentStoreCoordinator addPersistentStoreWithType:self.storeType configuration:nil URL:storeCacheURL options:options error:&error]) {
        
        NSLog(@"Error with adding ReadOnly store to coordinator %@, %@", error, [error userInfo]);
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
    
    //Retrieve legacy readwrite store from Documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    //Create pre-loaded SQLite db location
    NSString *readWriteStore = [NSString stringWithFormat:@"%@.%@", ModelManagerReadWriteModelName, ModelManagerStoreType];
    NSString *readWriteStoreTemp = [NSString stringWithFormat:@"%@Temp.%@", ModelManagerReadWriteModelName, ModelManagerStoreType];
    NSString *preloadData =  [documentsDirectory stringByAppendingPathComponent:readWriteStore];
    NSURL *storeURL = [NSURL fileURLWithPath:preloadData];
    
    //Create pre-loaded SQLite db location
    NSString *preloadTempData =  [documentsDirectory stringByAppendingPathComponent:readWriteStoreTemp];
    NSURL *storeTempURL = [NSURL fileURLWithPath:preloadTempData];
    
	//Create filemanager to manipulate filesystem
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	//Determine if pre-loaded SQLite db exists
	BOOL isSQLiteFilePresent = [fileManager fileExistsAtPath:preloadData];
    NSError *error = nil;
    
	//Copy pre-loaded SQLite db from bundle to Documents if it doesn't exist
	if (!isSQLiteFilePresent) {
        
        NSString *defaultStorePathWrite = [self.currentBundle pathForResource:ModelManagerReadWriteModelName ofType:ModelManagerStoreType];
        
		//Ensure that pre-loaded SQLite db exists in bundle before copy
		if (defaultStorePathWrite) {
			error = nil;
            
			[fileManager copyItemAtPath:defaultStorePathWrite toPath:preloadData error:&error];
            
			NSLog(@"Error with copying ReadWrite default store %@", error);
		}  
        
    } 
    
	//handle db upgrade for auto migration for minor schema changes
	NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @(YES), NSInferMappingModelAutomaticallyOption: @(YES)};
    
    //Older model design utilized a merged model.  This needs to be corrected.
    //Determine if migration is necessary by checking to see if current Model is comaptible with current store metadata
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:storeURL error:&error];
    BOOL isMigrationRequired = ![[self readWriteManagedObjectModel] isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
    
    //Determine if legacy, merged model is capable of migrating the store
    BOOL isMergedModelAcceptible = [[self mergedManagedObjectModel] isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
    
    //If both a migration is necessary and the legacy, merged model can migrate the current store.
    if (isMigrationRequired && isMergedModelAcceptible) {
        
        //UserData might contain user entry, so it must not be simply overridden.
        //It must be migrated to a temporary location, the legacy must be deleted, and then migrated store moved into place
        [self migrateStore:storeURL toMigratedStore:storeTempURL withModel:[self mergedManagedObjectModel] andDestinationModel:[self readWriteManagedObjectModel] error:&error];
        [fileManager removeItemAtPath:preloadData error:&error];
        [fileManager copyItemAtPath:preloadTempData toPath:preloadData error:&error];
        [fileManager removeItemAtPath:preloadTempData error:&error];
        
    }    
    
    error = nil;
    _readWritePersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self readWriteManagedObjectModel]];
  	
	if (![_readWritePersistentStoreCoordinator addPersistentStoreWithType:self.storeType configuration:nil URL:storeURL options:options error:&error]) {
        
        NSLog(@"Error with adding ReadWrite store to coordinatorr %@, %@", error, [error userInfo]);
        abort();
    } 
    
    return _readWritePersistentStoreCoordinator;
}

/**
Performs a migration from the legacy store with a merged model to the new store
 */
- (BOOL)migrateStore:(NSURL *)storeURL toMigratedStore:(NSURL *)destinationStoreURL withModel:(NSManagedObjectModel *) sourceModel andDestinationModel:(NSManagedObjectModel *)destinationModel error:(NSError **)outError {
    
    // Try to get an inferred mapping model.
    NSMappingModel *mappingModel = [NSMappingModel inferredMappingModelForSourceModel:sourceModel
                                                                     destinationModel:destinationModel error:outError];
    
    // If Core Data cannot create an inferred mapping model, return NO.
    if (!mappingModel) {
        return NO;
    }
    
    // Get the migration manager class to perform the migration.
    NSValue *classValue = [NSPersistentStoreCoordinator registeredStoreTypes][NSSQLiteStoreType];
    Class sqliteStoreClass = (Class)[classValue pointerValue];
    Class sqliteStoreMigrationManagerClass = [sqliteStoreClass migrationManagerClass];
    
    NSMigrationManager *manager = [[sqliteStoreMigrationManagerClass alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];
    
    BOOL success = [manager migrateStoreFromURL:storeURL type:NSSQLiteStoreType
                                        options:nil withMappingModel:mappingModel toDestinationURL:destinationStoreURL
                                destinationType:NSSQLiteStoreType destinationOptions:nil error:outError];
    
    
    return success;
}

#pragma mark -
#pragma mark public API

/**
Create a single NSManagedObject of the type Class.
 Determine which store in which to create the Class.  All NSManagedObjects prefixed with User are assigned to the readWrite store.
 */

- (id)create:(Class) insertedClass {
    
    if ([NSStringFromClass(insertedClass) rangeOfString:@"User"].location == NSNotFound) {        
        return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(insertedClass) inManagedObjectContext:self.managedObjectContext];
    } else {
        return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(insertedClass) inManagedObjectContext:self.readWriteManagedObjectContext];        
    }

}

/**
 Read all NSManagedObjects for the requested Class
 Determine which store to read from based upon class.  All NSManagedObjects prefixed with User are assigned to the readWrite store
 */
- (NSArray *)readAll:(Class) requestedClass {
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass(requestedClass)];
    
    NSArray *results;
    
    @try {
        if ([NSStringFromClass(requestedClass) rangeOfString:@"User"].location == NSNotFound) {        
            results = [self.managedObjectContext executeFetchRequest:request error: &error];
        } else {
            results = [self.readWriteManagedObjectContext executeFetchRequest:request error: &error];
        }        
    }
    @catch (NSException *exception) {
        @throw(exception);
    }    
    
    if (error) {
        NSString *errorMessage = @"Test Core Data fetch failed: %@\n\n";
        [NSException raise:@"CoreDataFetchError" format:errorMessage, [error description]];
    }
    
    return results;
}

/**
Read a single NSManagedObject
 Determine which store to read from based upon class.  All NSManagedObjects prefixed with User are assigned to the readWrite store
 */
- (id)read:(Class) requestedClass withKey:(id) classKey andValue:(id) keyValue {    
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: NSStringFromClass(requestedClass)];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@", classKey, keyValue];
	[request setPredicate:pred];
    
    NSArray *results;
    
    @try {
        if ([NSStringFromClass(requestedClass) rangeOfString:@"User"].location == NSNotFound) {        
            results = [self.managedObjectContext executeFetchRequest:request error: &error];
        } else {
            results = [self.readWriteManagedObjectContext executeFetchRequest:request error: &error];
        }        

    }
    @catch (NSException *exception) {
        @throw(exception);
    }    
    
    if (error) {
        NSString *errorMessage = @"Test Core Data fetch failed: %@\n\n";
        [NSException raise:@"CoreDataFetchError" format:errorMessage, [error description]];
    }
    
    if ([results count] > 0) {
        return results[0];
    } else {
        return nil;
    }
}

/**
 Delete an NSManagedObjectContext from the readOnly store
 */
- (void)delete:(id) object {
    
    @try {
        [self.managedObjectContext deleteObject: object];

        [self saveContext];
    }
    @catch (NSException *exception) {
        @throw(exception); 
    }    
    
}

/**
Delete an NSManagedObjectContext from the readWrite store
 */
- (void)deleteReadWrite:(id) object {
    
    @try {
        [self.readWriteManagedObjectContext deleteObject: object];
        
        [self saveContext];
    }
    @catch (NSException *exception) {
        @throw(exception); 
    }    
    
}

/**
Save the current NSManagedObjectContext.  Allows for testing of the Core Data stack by throwing exceptions on save fails
 */
- (void)saveContext {
    
    NSError *error = nil;
    
    @try {
        if ([self.managedObjectContext hasChanges]) {
            [self.managedObjectContext save: &error];
        }
    }
    @catch (NSException *exception) {
        @throw(exception); 
        abort();
    }    
    
    if (error) {
        NSString *errorMessage = @"Core Data Read Only save failed: %@\n\n";
        [NSException raise:@"CoreDataSaveError" format:errorMessage, [error description]];
    }

    @try {
        if ([self.readWriteManagedObjectContext hasChanges]) {
            [self.readWriteManagedObjectContext save: &error];
        }
    }
    @catch (NSException *exception) {
        @throw(exception); 
        abort();
    }    
    
    if (error) {
        NSString *errorMessage = @"Core Data Read Write save failed: %@\n\n";
        [NSException raise:@"CoreDataSaveError" format:errorMessage, [error description]];
    }
} 

@end
