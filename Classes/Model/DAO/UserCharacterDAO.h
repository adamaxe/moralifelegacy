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

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (UserCharacter *)create;
- (UserCharacter *)read:(NSString *)key;

@end
