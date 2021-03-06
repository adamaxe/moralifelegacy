/**
Choice data entry screen.
 
Second screen in Moral Entry Workflow.  User can either Virtue or Vice depending upon previously selected option.

@class ChoiceViewController
@see ChoiceInitViewController
@see ChoiceListViewController
@see ChoiceModalViewController
@see ChoiceDetailViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 05/17/2010
@file
*/

#import "MoraLifeViewController.h"
@interface ChoiceViewController : MoraLifeViewController <UITextFieldDelegate, UITextViewDelegate>

/**
Accepts User input to present ChoiceDetailViewController for User to enter in additional details.
 */
-(IBAction)showChoiceDetailEntry;

/**
Accepts User input to change the severity of the current Choice
@param sender Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)severityChange:(id) sender;

/**
Accepts User input to present ChoiceModalViewController for User to enter in Moral
@param sender Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)showChoiceModal:(id)sender;

/**
 Accepts User input to present ChoiceHistoryViewController for User to enter in previous choice
 @param sender Object which requested method
 @return IBAction method available from Interface Builder
 */
-(IBAction)showHistoryModal:(id)sender;

/**
Accepts User input to present ConscienceHelpViewController help screen for User to identify selected Moral
@param sender Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)selectMoralReference:(id)sender;

/**
Accepts User input to commit choice to UserData, will present help if commit is impossible
@param sender Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)commitChoice:(id) sender;

/**
Accepts User input to present ConscienceHelpViewController help screen for User to identify selected Moral
@param sender Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)cancelChoice:(id) sender;

@end