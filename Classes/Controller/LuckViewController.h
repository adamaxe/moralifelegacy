/**
Luck entry screen.  

Secondary screen for Luck data entry.

@class LuckViewController
@see ChoiceInitViewController
@see LuckListViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 011/17/2010
@file
 */

@interface LuckViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

/**
Accepts User input to change the severity of the current Luck
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)severityChange:(id) sender;

/**
Accepts User input to commit luck to UserData, will present help if commit is impossible
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)commitLuck:(id) sender;

/**
Accepts User input to present ConscienceHelpViewController help screen for User to identify selected Moral
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)cancelLuck:(id) sender;

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

@end
