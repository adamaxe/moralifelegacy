/**
 ReferenceBelief DAO subclass.  Readonly MoraLife ReferenceBelief accessor

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class ReferenceBelief
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "ReferenceBelief.h"

@interface ReferenceBeliefDAO : BaseDAO

/**
 Read method to fetch an ReferenceBelief from the store
 @param key NSString to designate which ReferenceBelief to return (optional)
 @return ReferenceBelief NSManagedObject to be returned
 */
- (ReferenceBelief *)read:(NSString *)key;

@end
