/**
 Moralife Model Manager.  This class handles the setup and destruction of backing store.
  
 @see MoraLifeAppDelegate
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class ModelManager
 @date 06/09/2012
 @file
 */

#import <CoreData/CoreData.h>

/**
 Possible Reference Types
 typedef utilized to avoid having to use enum declaration
 */
typedef enum referenceModelTypeEnum{
	kReferenceModelTypeConscienceAsset,
	kReferenceModelTypeBelief,
	kReferenceModelTypeText,
	kReferenceModelTypePerson,
	kReferenceModelTypeMoral,
	kReferenceModelTypeReferenceAsset
}referenceModelTypeEnum;

@interface ModelManager : NSObject 

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *readWriteManagedObjectContext;

/**
Provides access to backing data store while obscuring details of stack.  Provides dependency injection for testing
 @param isTransient BOOL showing whether the data store is in-memory or not
 @return id self
 */
- (id)initWithInMemoryStore:(BOOL)isTransient;

/**
 Provides ability to create an instance of a persisted NSManagedObject
 @param insertedClass Class to be persisted
 @return id instance of class requested
 */
- (id)create: (Class) insertedClass;

/**
 Provides ability to read all NSManagedObject of the requested type
 @param requestedClass Class to be retrieved
 @return NSArray array of instances of class requested
 */
- (NSArray *)readAll: (Class) requestedClass;

/**
 Provides ability to read a single NSManagedObject of the requested type and pkey
 @param requestedClass Class to be retrieved
 @param classKey id for fetchrequest key
 @param keyValue id for fetchrequest value
 @return id instance of class requested
 */
- (id)read: (Class) requestedClass withKey: (id) classKey andValue:(id) keyValue;

/**
 Provides ability to delete a single NSManagedObject instance from ReadOnly store
 @param object id to be deleted
 */
- (void)delete: (id) object;

/**
 Provides ability to delete a single NSManagedObject instance from ReadWrite store
 @param object id to be deleted
 */
- (void)deleteReadWrite: (id) object;

/**
 Save the current Core Data context for whenever a modify is needed.
 */
- (void)saveContext;

@end
