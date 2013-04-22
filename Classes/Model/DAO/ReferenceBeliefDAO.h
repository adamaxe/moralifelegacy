/**
 ReferenceBelief DAO subclass.  Readonly MoraLife ReferenceBelief accessor

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class ReferenceBelief
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "ReferenceBelief.h"

@interface ReferenceBeliefDAO : BaseDAO

/**
 Overloaded init to provide dependency injection of ModelManager for both release and testing
 @param key NSString to designate which NSManagedObject to return (optional)
 @param moralModelManager which persistence stack to reference (release file system or test in-memory)
 @return id ReferenceBeliefDAO created for designated Model
 */
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

/**
 Read method to fetch an ReferenceBelief from the store
 @param key NSString to designate which ReferenceBelief to return (optional)
 @return ReferenceBelief NSManagedObject to be returned
 */
- (ReferenceBelief *)read:(NSString *)key;

@end
