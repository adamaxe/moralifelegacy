/**
 UserCollectable DAO subclass.  Readwrite MoraLife UserCollectable that can be won/bought through Morathology or Commissary.

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class UserCollectableDAO
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "UserCollectable.h"

extern NSString* const MLCollectableEthicals;

@interface UserCollectableDAO : BaseDAO

/**
 Read method to create an UserCollectable in the store
 @return UserCollectable Created NSManagedObject to be returned
 */
@property (NS_NONATOMIC_IOSONLY, readonly, strong) UserCollectable *create;

/**
 Read method to fetch an UserCollectable from the store
 @param key NSString to designate which UserCollectable to return (optional)
 @return UserCollectable NSManagedObject to be returned
 */
- (UserCollectable *)read:(NSString *)key;

@end
