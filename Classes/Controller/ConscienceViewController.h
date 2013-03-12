/**
MoraLife Home Screen.  Landing UIViewController for application.
Primary screen for entire Application Workflow.  Provides high-level feedback for User review.

@class ConscienceViewController
@see ConscienceModalViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/23/2010
@file
*/

@class ModelManager, UserConscience;

@interface ConscienceViewController : UIViewController

/**
 Creates the viewController with the User's Conscience
 @param modelManager ModelManager data persistence
 @param userConscience UserConscience for modals and help screens
 @return id instance of ConscienceViewController
 */
-(id)initWithModelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience;

/**
Accepts User input in order to determine which thought Bubble to dislay or ConscienceModalViewController
@param sender id which requested the function
 */
-(IBAction) selectNextView:(id) sender;

@end