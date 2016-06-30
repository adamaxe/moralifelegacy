/**
 ConscienceAsset DAO subclass.  Readonly MoraLife ConscienceAsset

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class ConscienceAssetDAO
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "ConscienceAsset.h"

@interface ConscienceAssetDAO : BaseDAO

/**
 Overloaded init to provide dependency injection of ModelManager for both release and testing
 @param key NSString to designate which NSManagedObject to return (optional)
 @param moralModelManager which persistence stack to reference (release file system or test in-memory)
 @return id ConscienceAssetDAO created for designated Model
 */
- (instancetype)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager NS_DESIGNATED_INITIALIZER;

/**
 Read method to fetch an ConscienceAsset from the store
 @param key NSString to designate which ConscienceAsset to return (optional)
 @return ConscienceAsset NSManagedObject to be returned
 */
- (ConscienceAsset *)read:(NSString *)key;

@end
