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

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (ReferenceText *)read:(NSString *)key;

@end
