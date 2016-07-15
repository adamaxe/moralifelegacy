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
 Read method to fetch an ConscienceAsset from the store
 @param key NSString to designate which ConscienceAsset to return (optional)
 @return ConscienceAsset NSManagedObject to be returned
 */
- (ConscienceAsset *)read:(NSString *)key;

@end
