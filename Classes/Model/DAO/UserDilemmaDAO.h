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

/**
 Overloaded init to provide dependency injection of ModelManager for both release and testing
 @param NSString key to designate which NSManagedObject to return (optional)
 @param ModelManager which persistence stack to reference (release file system or test in-memory)
 @return id UserDilemmaDAO created for designated Model
 */
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

/**
 Read method to create an UserDilemma in the store
 @return UserDilemma Created NSManagedObject to be returned
 */
- (UserDilemma *)create;

/**
 Read method to fetch an UserDilemma from the store
 @param NSString key to designate which UserDilemma to return (optional)
 @return UserDilemma NSManagedObject to be returned
 */
- (UserDilemma *)read:(NSString *)key;

@end