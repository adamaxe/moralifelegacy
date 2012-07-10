/**
 Moralife Model Manager.  This class handles the setup and destruction of Core Data.
  
 @see MoraLifeAppDelegate
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class ModelManager
 @date 06/09/2012
 @file
 */

#import <CoreData/CoreData.h>

@interface ModelManager : NSObject 

extern NSString* const kMLCoreDataReadOnlyModelName;
extern NSString* const kMLCoreDataReadWriteModelName;
extern NSString* const kMLCoreDataPersistentStoreType;
extern NSString* const kMLCoreDataModelExtension;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *readWriteManagedObjectContext;

- (id)initWithInMemoryStore:(BOOL)isTransient;

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
