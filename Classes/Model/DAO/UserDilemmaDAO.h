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
 Read method to create an UserDilemma in the store
 @return UserDilemma Created NSManagedObject to be returned
 */
@property (NS_NONATOMIC_IOSONLY, readonly, strong) UserDilemma *create;

/**
 Read method to fetch an UserDilemma from the store
 @param key NSString to designate which UserDilemma to return (optional)
 @return UserDilemma NSManagedObject to be returned
 */
- (UserDilemma *)read:(NSString *)key;

@end
