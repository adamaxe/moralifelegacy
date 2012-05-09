/**
Secondary Choice Data entry screen.  Screen which allows User to enter in additional Choice information (Justification, Consequence, Influence).

Last screen in Choice/Luck Entry Workflow.
 
@class ChoiceDetailViewController
@see ChoiceViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/12/2010
@file
*/

@interface ChoiceDetailViewController : UIViewController <UITextFieldDelegate> 

/**
Accepts User input to change the description of the Influence slider
@param id Object which requested the slider change
@return IBAction referenced from Interface Builder
 */
-(IBAction)influenceChange:(id) sender;

/**
Accepts User input to dismiss current UIViewController
@param id Object which requested the view dismissal
@return IBAction referenced from Interface Builder
 */
-(IBAction)previousNav:(id) sender;

/**
Accepts User input to remove all changes
@param id Object which requested the button
@return IBAction referenced from Interface Builder
 */
-(IBAction)cancelChoice:(id) sender;

/**
 Accepts User input to view purpose of Influence slider
 @param id Object which requested the slider change
 @return IBAction referenced from Interface Builder
 */
-(IBAction)selectInfluence:(id) sender;

/**
Limit a text field for each key press
@param note NSNotification Allows system to check field length with every keypress
 */
-(void)limitTextField:(NSNotification *)note;

@end