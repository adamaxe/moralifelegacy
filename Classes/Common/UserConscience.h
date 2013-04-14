/**
 UserConscience class.  A class representing the visual and emotional state of the User's Conscience.

 Copyright 2012 Team Axe, LLC. All rights reserved.

 @class UserConscience
 @author Team Axe, LLC. http://www.teamaxe.org
 @date 02/18/2013
 */

#import "ConscienceView.h"
#import "ConscienceMind.h"

@class ConscienceBody, ConscienceAccessories, ConscienceView, ConscienceMind, ModelManager;
@interface UserConscience : NSObject

@property (nonatomic, strong) ConscienceBody *userConscienceBody;   /**< Representation of User's Conscience */
@property (nonatomic, strong) ConscienceAccessories *userConscienceAccessories;     /**< Representation of User's Accessories */
@property (nonatomic, strong) ConscienceView *userConscienceView;   /**< Visual representation of User's Conscience+Accessories */
@property (nonatomic, strong) ConscienceMind *userConscienceMind;   /**< Representation of User's Mental State */
@property (nonatomic, strong) NSMutableArray *conscienceCollection;       /**< Currently owned items */

/**
 Dependency injection constructor to pass model
 @param modelManager ModelManager data persistence
 @return id instance of UserConscience
 */
-(id)initWithModelManager:(ModelManager *)modelManager;

/**
 User choices affect UserConscience immediately, must return Conscience to regular state
 @param originalMood float representing overall Conscience mood
 @param originalEnthusiasm float representing overall Conscience enthusiasm
 */
-(void) resetMood:(float) originalMood andEnthusiasm:(float) originalEnthusiasm;

/**
 Cancel all of shooken UserConscience behavior
 */
-(void) shakeConscience;

@end
