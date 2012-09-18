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

extern NSString* const kLuckImageNameGood;
extern NSString* const kLuckImageNameBad;

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

@end
