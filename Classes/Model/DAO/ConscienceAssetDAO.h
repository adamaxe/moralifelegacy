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

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ConscienceAsset *)read:(NSString *)key;

@end
