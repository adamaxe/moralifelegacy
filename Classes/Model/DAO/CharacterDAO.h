/**
 CharacterDAO DAO subclass.  Readonly MoraLife Dilemma Character

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class CharacterDAO
 @date 06/09/2012
 @file
 */

#import "BaseDAO.h"
#import "Character.h"

@interface CharacterDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (Character *)read:(NSString *)key;

@end
