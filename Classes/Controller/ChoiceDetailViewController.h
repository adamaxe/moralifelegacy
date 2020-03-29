/**
Secondary Choice Data entry screen.  Screen which allows User to enter in additional Choice information (Justification, Consequence, Influence).

Last screen in Choice/Luck Entry Workflow.
 
@class ChoiceDetailViewController
@see ChoiceViewController

@author Copyright 2020 Adam Axe. All rights reserved. http://www.adamaxe.com
@date 07/12/2010
@file
*/

#import "MoraLifeViewController.h"

@interface ChoiceDetailViewController : MoraLifeViewController <UITextFieldDelegate>

/**
Accepts User input to change the description of the Influence slider
@param sender Object which requested the slider change
@return IBAction referenced from Interface Builder
 */
-(IBAction)influenceChange:(id) sender;

/**
Accepts User input to dismiss current UIViewController
@param sender Object which requested the view dismissal
@return IBAction referenced from Interface Builder
 */
-(IBAction)saveTapped:(id) sender;

/**
Accepts User input to remove all changes
@return IBAction referenced from Interface Builder
 */
-(IBAction)cancelTapped;

/**
 Accepts User input to view purpose of Influence slider
 @param sender Object which requested the slider change
 @return IBAction referenced from Interface Builder
 */
-(IBAction)selectInfluence:(id) sender;

@end
