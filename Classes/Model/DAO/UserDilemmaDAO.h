/**
 UserDilemma DAO subclass.  Readwrite MoraLife UserDilemma response to dilemmas in Morathology

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class UserDilemmaDAO
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "UserDilemma.h"

@interface UserDilemmaDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (UserDilemma *)create;
- (UserDilemma *)read:(NSString *)key;

@end