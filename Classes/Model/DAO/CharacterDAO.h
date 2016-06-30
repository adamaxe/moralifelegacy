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
 Overloaded init to provide dependency injection of ModelManager for both release and testing
 @param key NSString to designate which NSManagedObject to return (optional)
 @param moralModelManager which persistence stack to reference (release file system or test in-memory)
 @return id CharacterDAO created for designated Model
 */
- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager NS_DESIGNATED_INITIALIZER;

/**
 Read method to fetch an Character from the store
 @param key NSString to designate which Character to return (optional)
 @return Character NSManagedObject to be returned
 */
- (Character *)read:(NSString *)key;

@end
