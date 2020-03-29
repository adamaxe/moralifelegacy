/**
MoraLife Home Screen.  Landing UIViewController for application.
Primary screen for entire Application Workflow.  Provides high-level feedback for User review.

@class HomeViewController
@see ConscienceViewController

@author Copyright 2020 Adam Axe. All rights reserved. http://www.adamaxe.com
@date 06/23/2010
@file
*/

#import "MoraLifeViewController.h"

@class HomeModel;

@interface HomeViewController : MoraLifeViewController

/**
 Dependency injection constructor to pass model
 @param homeModel HomeModel handling business logic
 @param modelManager ModelManager data persistence
 @param userConscience UserConscience for modals and help screens
 @return id instance of ReferenceDetailViewController
 */
- (id)initWithModel:(HomeModel *) homeModel modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience;

/**
Accepts User input in order to determine which thought Bubble to display or ConscienceViewController
@param sender id which requested the function
 */
-(IBAction) selectNextView:(id) sender;

@end
