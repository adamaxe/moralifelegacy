/**
MoraLife Home Screen.  Landing UIViewController for application.
Primary screen for entire Application Workflow.  Provides high-level feedback for User review.

@class ConscienceViewController
@see ConscienceModalViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/23/2010
@file
*/

#import "MoraLifeViewController.h"

@interface ConscienceViewController : MoraLifeViewController

/**
Accepts User input in order to determine which thought Bubble to dislay or ConscienceModalViewController
@param sender id which requested the function
 */
-(IBAction) selectNextView:(id) sender;

@end