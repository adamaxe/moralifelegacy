//
//  ModelManager.m
//  MoraLife
//
//  Created by Adam Axe on 6/9/12.
//  Copyright (c) 2012 Team Axe, LLC. All rights reserved.
//

#import "ModelManager.h"

@interface ModelManager () {
 
@private	
	NSManagedObjectModel	*managedObjectModel;
	NSManagedObjectContext	*managedObjectContext;
	NSPersistentStoreCoordinator	*persistentStoreCoordinator;
}

@end

@implementation ModelManager

@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;

#pragma mark -
#pragma mark Core Data stack

- (id)init {
    self = [super init];
    
    if (self) {
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
	
	NSString *pathReadWrite = [[NSBundle mainBundle] pathForResource:@"UserData" ofType:@"momd"];
	NSURL *momURLReadWrite = [NSURL fileURLWithPath:pathReadWrite];
    
	NSManagedObjectModel *modelReadWrite = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadWrite]; 
	
	NSString *pathReadOnly = [[NSBundle mainBundle] pathForResource:@"SystemData" ofType:@"momd"];
	NSURL *momURLReadOnly = [NSURL fileURLWithPath:pathReadOnly];
	NSManagedObjectModel *modelReadOnly = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadOnly];      
	
	managedObjectModel = [NSManagedObjectModel modelByMergingModels:[NSArray arrayWithObjects:modelReadWrite, modelReadOnly, nil]];
	
	[modelReadOnly release];
	[modelReadWrite release];
	
	/*
     //After versioning enabled, mom becomes directory
     NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"SystemData" ofType:@"momd"];
     //NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"SystemData" ofType:@"mom"];
     
     NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
     managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
     */
	
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
    
    NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"SystemData" ofType:@"sqlite"];
    
    
	//Copy pre-loaded SQLite db from bundle to Documents if it doesn't exist
	if (!isSQLiteFilePresent) {
        
        NSString *defaultStorePathWrite = [[NSBundle mainBundle] pathForResource:@"UserData" ofType:@"sqlite"];
        
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
    
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
	
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURLReadWrite options:options error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    } 
    
    return persistentStoreCoordinator;
}

- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *saveManagedObjectContext = self.managedObjectContext;
    if (saveManagedObjectContext != nil) {
        if ([saveManagedObjectContext hasChanges] && ![saveManagedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
} 

@end
