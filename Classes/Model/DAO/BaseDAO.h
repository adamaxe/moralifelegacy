/**
BaseDAO Superclass.  This class handles the interaction between the model and the persisted data.
 
 All other DAOs are subclasses
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class BaseDAO
 @date 06/09/2012
 @file
 */
#import "ModelManager.h"

@interface BaseDAO : NSObject

extern NSString* const kContextReadOnly;    /**< key to determine read only persistent store to access */
extern NSString* const kContextReadWrite;   /**< key to determine read write persistent store to access */

@property (nonatomic, strong) NSArray *sorts;       /**< array of NSSortDescriptors to order */
@property (nonatomic, strong) NSArray *predicates;  /**< array of NSPredicates to filter */
@property (nonatomic, strong) NSMutableString *predicateDefaultName;    /**< default NSPredicate attribute name */
@property (nonatomic, strong) NSMutableString *sortDefaultName;         /**< default NSSortDescriptor attribute name */
@property (nonatomic, strong) NSMutableString *managedObjectClassName;  /**< NSManagedObject type to act upon */

/**
Overloaded init to provide dependency injection of ModelManager for both release and testing
 @param NSString key to designate which NSManagedObject to return (optional)
 @param ModelManager which persistence stack to reference (release file system or test in-memory)
 @param NSString Class type provided by DAO subclass to determine which NSManagedObject to act upon
 @return id BaseDAO created for designated Model
 */
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager andClassType:(NSString *)classType;

/**
Create method to insert an NSManagedObject into the store
 @return NSManagedObject Return will be typecast by DAO subclass
 */
- (NSManagedObject *)createObject;

/**
 Read method to fetch an NSManagedObject from the store
 @return NSManagedObject Return will be typecast by DAO subclass
 */
- (NSManagedObject *)readObject:(NSString *)key;

/**
 List method to fetch all NSManagedObjects of subclass' type
 @return NSArray Return will contain subclass DAO type
 */
- (NSArray *)readAll;

/**
 Modify method to update an NSManagedObject in the store
 @return BOOL Communicate if update was successful
 */
- (BOOL)update;

/**
 Delete method to remove an NSManagedObject from the store
 @param NSManagedObject Actual NSManagedObject to delete
 @return BOOL Communicate if delete was successful
 */
- (BOOL)delete:(NSManagedObject *)objectToDelete;

/**
 Count method to return number of NSManagedObjects known by DAO
 @return int Number of NSManagedObjects under control
 */
- (int)count;

@end
