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

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ReferenceBelief *)read:(NSString *)key;

@end
