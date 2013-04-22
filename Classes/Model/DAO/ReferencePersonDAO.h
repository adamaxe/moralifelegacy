/**
 ReferencePerson DAO subclass.  Readonly MoraLife ReferencePerson reward for Morathology

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class ReferencePersonDAO
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "ReferencePerson.h"

@interface ReferencePersonDAO : BaseDAO

/**
 Overloaded init to provide dependency injection of ModelManager for both release and testing
 @param key NSString to designate which NSManagedObject to return (optional)
 @param moralModelManager which persistence stack to reference (release file system or test in-memory)
 @return id ReferencePersonDAO created for designated Model
 */
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

/**
 Read method to fetch an ReferencePerson from the store
 @param key NSString to designate which ReferencePerson to return (optional)
 @return ReferencePerson NSManagedObject to be returned
 */
- (ReferencePerson *)read:(NSString *)key;

@end
