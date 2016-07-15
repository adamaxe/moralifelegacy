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

/**
 Read method to fetch an Character from the store
 @param key NSString to designate which Character to return (optional)
 @return Character NSManagedObject to be returned
 */
- (Character *)read:(NSString *)key;

@end
