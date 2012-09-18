/**
 UserCollectable DAO subclass.  Readwrite MoraLife UserCollectable that can be won/bought through Morathology or Commissary.

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class UserCollectableDAO
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "UserCollectable.h"

extern NSString* const kCollectableEthicals;

@interface UserCollectableDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (UserCollectable *)create;
- (UserCollectable *)read:(NSString *)key;

@end
