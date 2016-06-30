/**
 UserChoice DAO subclass.  Readwrite MoraLife UserChoice that represents a User's action.

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class UserChoiceDAO
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "UserChoice.h"

@interface UserChoiceDAO : BaseDAO

/**
 Overloaded init to provide dependency injection of ModelManager for both release and testing
 @param key NSString to designate which NSManagedObject to return (optional)
 @param moralModelManager which persistence stack to reference (release file system or test in-memory)
 @return id UserChoiceDAO created for designated Model
 */
- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager NS_DESIGNATED_INITIALIZER;

/**
 Read method to create an UserChoice in the store
 @return UserChoice Created NSManagedObject to be returned
 */
@property (NS_NONATOMIC_IOSONLY, readonly, strong) UserChoice *create;

/**
 Read method to fetch an UserChoice from the store
 @param key NSString to designate which UserChoice to return (optional)
 @return UserChoice NSManagedObject to be returned
 */
- (UserChoice *)read:(NSString *)key;

@end
