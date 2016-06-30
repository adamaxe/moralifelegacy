/**
 ReferenceAsset DAO subclass.  Readonly MoraLife ReferenceAsset.

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class ReferenceAssetDAO
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "ReferenceAsset.h"

@interface ReferenceAssetDAO : BaseDAO

/**
 Overloaded init to provide dependency injection of ModelManager for both release and testing
 @param key NSString to designate which NSManagedObject to return (optional)
 @param moralModelManager which persistence stack to reference (release file system or test in-memory)
 @return id ReferenceAssetDAO created for designated Model
 */
- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager NS_DESIGNATED_INITIALIZER;

/**
 Read method to fetch an ReferenceAsset from the store
 @param key NSString to designate which ReferenceAsset to return (optional)
 @return ReferenceAsset NSManagedObject to be returned
 */
- (ReferenceAsset *)read:(NSString *)key;

@end
