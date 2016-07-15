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
 Read method to fetch an ReferenceAsset from the store
 @param key NSString to designate which ReferenceAsset to return (optional)
 @return ReferenceAsset NSManagedObject to be returned
 */
- (ReferenceAsset *)read:(NSString *)key;

@end
