/**
MoraLife Home Screen.  Landing UIViewController for application.
Primary screen for entire Application Workflow.  Provides high-level feedback for User review.

@class HomeViewController
@see ConscienceViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/23/2010
@file
*/

#import "MoraLifeViewController.h"

@interface HomeViewController : MoraLifeViewController

/**
Accepts User input in order to determine which thought Bubble to display or ConscienceViewController
@param sender id which requested the function
 */
-(IBAction) selectNextView:(id) sender;

@end