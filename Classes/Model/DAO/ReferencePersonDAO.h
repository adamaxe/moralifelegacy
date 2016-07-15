/**
 ReferencePerson DAO subclass.  Readonly MoraLife ReferencePerson reward for Morathology

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class ReferencePersonDAO
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "ReferencePerson.h"

@interface ReferencePersonDAO : BaseDAO

/**
 Read method to fetch an ReferencePerson from the store
 @param key NSString to designate which ReferencePerson to return (optional)
 @return ReferencePerson NSManagedObject to be returned
 */
- (ReferencePerson *)read:(NSString *)key;

@end
