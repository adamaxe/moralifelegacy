/**
 ReferenceText DAO subclass.  Readonly MoraLife ReferenceText

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class ReferenceTextDAO
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "ReferenceText.h"

@interface ReferenceTextDAO : BaseDAO

/**
 Overloaded init to provide dependency injection of ModelManager for both release and testing
 @param key NSString to designate which NSManagedObject to return (optional)
 @param moralModelManager which persistence stack to reference (release file system or test in-memory)
 @return id ReferenceTextDAO created for designated Model
 */
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

/**
 Read method to fetch an ReferenceText from the store
 @param key NSString to designate which ReferenceText to return (optional)
 @return ReferenceText NSManagedObject to be returned
 */
- (ReferenceText *)read:(NSString *)key;

@end
