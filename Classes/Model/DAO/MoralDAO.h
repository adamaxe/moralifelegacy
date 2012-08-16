/**
 Moral DAO subclass.  Readonly MoraLife Moral for use in every aspect of the app.

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @class MoralDAO
 @date 08/16/2012
 @file
 */

#import "BaseDAO.h"
#import "Moral.h"

@interface MoralDAO : BaseDAO

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (Moral *)read:(NSString *)key;

@end
