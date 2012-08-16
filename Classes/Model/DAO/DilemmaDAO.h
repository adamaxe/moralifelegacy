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

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key andModelManager:(ModelManager *)moralModelManager;

- (Dilemma *)read:(NSString *)key;

@end
