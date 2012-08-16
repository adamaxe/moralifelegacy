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

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ReferencePerson *)read:(NSString *)key;

@end
