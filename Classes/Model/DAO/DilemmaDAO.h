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
 Overloaded init to provide dependency injection of ModelManager for both release and testing
 @param key NSString to designate which NSManagedObject to return (optional)
 @param moralModelManager which persistence stack to reference (release file system or test in-memory)
 @return id DilemmaDAO created for designated Model
 */
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

/**
 Read method to fetch an Dilemma from the store
 @param key NSString to designate which Dilemma to return (optional)
 @return Dilemma NSManagedObject to be returned
 */
- (Dilemma *)read:(NSString *)key;

@end
