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
 Read method to create an UserCharacter in the store
 @return UserCharacter Created NSManagedObject to be returned
 */
@property (NS_NONATOMIC_IOSONLY, readonly, strong) UserCharacter *create;

/**
 Read method to fetch an UserCharacter from the store
 @param key NSString to designate which UserCharacter to return (optional)
 @return UserCharacter NSManagedObject to be returned
 */
- (UserCharacter *)read:(NSString *)key;

@end
