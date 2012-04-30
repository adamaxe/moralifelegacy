/**
 Core Data Helper Class.  Setup an in-memory Core Data stack for use in the rest of the test suite.
  
 @class TestCoreDataStack
 
 @author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/25/2011
 @file
 */

@class NSManagedObjectContext;

@interface TestCoreDataStack : NSObject

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext; /**< Provide handle to MOC for other functions */

/**
Inserts an NSManagedObject
 @param Class type of Class to be inserted
 @return id Class type that was sent for insertion
 */
- (id)insert: (Class) testClass;

/**
Asks the MOC to save
 @throws NSException for inspection in test suites
 */
- (void)save;

/**
Deletes the requested NSManagedObject
 @param id object to be deleted
 @throws NSException for inspection in test suites
 */
- (void)delete: (id) object;

/**
Retrieves an NSArray of all Entities matching the requested Class
 @param Class NSEntity to be searched
 @return NSArray All NSManagedObjects of the param type
 @throws NSException for inspection in test suites
 */
- (NSArray *)fetch: (Class) testClass;

@end