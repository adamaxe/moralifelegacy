/**
 UserCharacter DAO subclass.  Readwrite MoraLife UserCharacter that represents User's conscience.

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class UserCharacterDAO
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "UserCharacter.h"

@interface UserCharacterDAO : BaseDAO

/**
 Overloaded init to provide dependency injection of ModelManager for both release and testing
 @param NSString key to designate which NSManagedObject to return (optional)
 @param ModelManager which persistence stack to reference (release file system or test in-memory)
 @return id UserCharacterDAO created for designated Model
 */
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

/**
 Read method to create an UserCharacter in the store
 @return UserCharacter Created NSManagedObject to be returned
 */
- (UserCharacter *)create;

/**
 Read method to fetch an UserCharacter from the store
 @param NSString key to designate which UserCharacter to return (optional)
 @return UserCharacter NSManagedObject to be returned
 */
- (UserCharacter *)read:(NSString *)key;

@end
