/**
 Dilemma DAO subclass.  Readonly MoraLife Dilemma for viewing in the Morathology

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class DilemmaDAO
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "Dilemma.h"

@interface DilemmaDAO : BaseDAO

/**
 Read method to fetch an Dilemma from the store
 @param key NSString to designate which Dilemma to return (optional)
 @return Dilemma NSManagedObject to be returned
 */
- (Dilemma *)read:(NSString *)key;

@end
