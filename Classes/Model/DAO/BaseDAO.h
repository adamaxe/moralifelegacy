/**
BaseDAO Superclass.  This class handles the interaction with the model.
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class BaseDAO
 @date 06/09/2012
 @file
 */

#import "ModelManager.h"

@interface BaseDAO : NSObject

extern NSString* const kContextReadOnly;
extern NSString* const kContextReadWrite;

@property (nonatomic, retain) NSArray *sorts;
@property (nonatomic, retain) NSArray *predicates;
@property (nonatomic, retain) NSMutableString *predicateDefaultName;
@property (nonatomic, retain) NSMutableString *sortDefaultName;
@property (nonatomic, retain) NSMutableString *managedObjectClassName;

- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager andClassType:(NSString *)classType;

- (NSManagedObject *)createObject;
- (NSManagedObject *)readObject:(NSString *)key;
- (NSArray *)readAll;
- (BOOL)update;
- (BOOL)delete:(NSManagedObject *)objectToDelete;

- (int)count;

@end
