/**
Reference Menu screen.  

Primary screen of Reference selection Workflow.  User can select what type of Reference is desired.

@class ReferenceViewController
@see ReferenceListViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 05/17/2010
@file
@todo rename to ReferenceInitViewController
*/

@class ModelManager, UserConscience;

@interface ReferenceViewController : UIViewController

/**
 Creates the viewController with the User's Conscience
 @param modelManager ModelManager data persistence
 @param userConscience UserConscience for modals and help screens
 @return id instance of ReferenceViewController
 */
-(id)initWithModelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience;

/**
Accepts User input to determine type of Reference requested
@param id Object which requested method
@return IBAction referenced from Interface Builder
 */
- (IBAction) selectReferenceType:(id)sender;

@end
