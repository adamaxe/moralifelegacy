/**
Conscience Interaction Workflow.  View controller for selecting menu choices from thought bubble menu.

Primary screen in the Conscience Interaction Workflow.  User experience changes to fanciful thought bubble paradigm.  
Only interaction with the Conscience is available from this workflow.
User can change Conscience, answer Morathology dilemmas and see Moral Reports.

@class ConscienceModalViewController
@see ConscienceViewController
@see ConscienceListViewController
@see ConscienceDilemmaListViewController
@see ConscienceAccessoryViewController
@see ReportPieViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 08/19/2010
@file
 */

@class ModelManager, UserConscience;

@interface ConscienceModalViewController : UIViewController 

@property(nonatomic, strong) UIImage *screenshot;       /**< screenshot of previous screen for transition */

/**
 Creates the viewController with the User's Conscience
 @param modelManager ModelManager data persistence
 @param userConscience UserConscience for modals and help screens
 @return id instance of ConscienceModalViewController
 */
-(id)initWithModelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience;

/**
Accepts User input to change the state of the screen.
@param sender id of object which requested method
@return IBAction referenced from Interface Builder
 */
-(IBAction)selectChoice:(id) sender;

/**
 Accepts User input to determine which version screen to present 
 @param sender id of object which requested method
 @return IBAction referenced from Interface Builder
 */
-(IBAction)dismissThoughtModal:(id)sender;

/**
 Accepts User input to cancel Conscience Interaction Workflow.  
 @param sender id of object which requested method
 @return IBAction referenced from Interface Builder
 */
-(IBAction)returnToHome:(id)sender;

@end