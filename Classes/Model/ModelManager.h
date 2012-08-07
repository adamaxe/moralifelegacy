/**
 Moralife Model Manager.  This class handles the setup and destruction of backing store.
  
 @see MoraLifeAppDelegate
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class ModelManager
 @date 06/09/2012
 @file
 */

#import <CoreData/CoreData.h>

@interface ModelManager : NSObject 

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *readWriteManagedObjectContext;

/**
Provides access to backing data store while obscuring details of stack.  Provides dependency injection for testing
 @param isTransient BOOL showing whether the data store is in-memory or not
 @return id self
 */
- (id)initWithInMemoryStore:(BOOL)isTransient;

/**
 Provides ability to create an instance of a persisted managed object
 @param insertedClass Class to be persisted
 @return id instance of class requestsed
 */
- (id)create: (Class) insertedClass;
- (NSArray *)readAll: (Class) requestedClass;
- (id)read: (Class) requestedClass withKey: (id) classKey andValue:(id) keyValue;
- (void)delete: (id) object;
- (void)deleteReadWrite: (id) object;

/**
 Save the current Core Data context for whenever a modify is needed.
 */
- (void)saveContext;

@end
