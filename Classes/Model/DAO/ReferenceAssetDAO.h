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

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ReferenceAsset *)read:(NSString *)key;

@end
