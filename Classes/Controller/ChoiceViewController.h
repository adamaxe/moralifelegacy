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

@interface ChoiceViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

/**
Accepts User input to present ChoiceDetailViewController for User to enter in additional details.
 */
-(IBAction)showChoiceDetailEntry;

/**
Accepts User input to change the severity of the current Choice
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)severityChange:(id) sender;

/**
Accepts User input to present ChoiceModalViewController for User to enter in Moral
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)showChoiceModal:(id)sender;

/**
 Accepts User input to present ChoiceHistoryViewController for User to enter in previous choice
 @param id Object which requested method
 @return IBAction method available from Interface Builder
 */
-(IBAction)showHistoryModal:(id)sender;

/**
Accepts User input to present ConscienceHelpViewController help screen for User to identify selected Moral
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)selectMoralReference:(id)sender;

/**
Accepts User input to commit choice to UserData, will present help if commit is impossible
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)commitChoice:(id) sender;

/**
Accepts User input to present ConscienceHelpViewController help screen for User to identify selected Moral
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)cancelChoice:(id) sender;

/**
Present a customized Done UIButton on top of the UITextView for data entry.
 */
-(void)presentDoneButton;

/**
Shift UI elements to move UITextView to top of screen to accomodate keyboard
 */
-(void)animateOptionChange:(int)viewNumber;

/**
Called from custom Done button to return UI back to normal
 */
-(void)hideKeyboard;

/**
Prevent User from entering more text than field allows
 */
-(void)limitTextField:(NSNotification *)note;

/**
Actually commits data to UserData from User request
 */
-(void)commitDataToUserData;

/**
Add designated amount to User's amount of ethicals
 */
-(void)increaseEthicals;

@end