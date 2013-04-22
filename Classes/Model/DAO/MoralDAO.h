/**
 Moral DAO subclass.  Readonly MoraLife Moral for use in every aspect of the app.

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class MoralDAO
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "Moral.h"

@interface MoralDAO : BaseDAO

/**
 Overloaded init to provide dependency injection of ModelManager for both release and testing
 @param key NSString to designate which NSManagedObject to return (optional)
 @param moralModelManager which persistence stack to reference (release file system or test in-memory)
 @return id MoralDAO created for designated Model
 */
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

/**
 Read method to fetch an Moral from the store
 @param key NSString to designate which Moral to return (optional)
 @return Moral NSManagedObject to be returned
 */
- (Moral *)read:(NSString *)key;

@end
