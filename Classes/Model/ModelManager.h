//
//  ModelManager.h
//  MoraLife
//
//  Created by Adam Axe on 6/9/12.
//  Copyright (c) 2012 Team Axe, LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ModelManager : NSObject 

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator	*persistentStoreCoordinator;

/**
 Save the current Core Data context for whenever a modify is needed.
 */
- (void)saveContext;

@end
