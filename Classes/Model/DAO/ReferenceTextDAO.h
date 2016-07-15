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
 Read method to fetch an ReferenceText from the store
 @param key NSString to designate which ReferenceText to return (optional)
 @return ReferenceText NSManagedObject to be returned
 */
- (ReferenceText *)read:(NSString *)key;

@end
