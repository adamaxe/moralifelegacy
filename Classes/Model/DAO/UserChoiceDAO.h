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

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (UserChoice *)create;
- (UserChoice *)read:(NSString *)key;

@end
