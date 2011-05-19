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

#import <CoreData/CoreData.h>

@class MoraLifeAppDelegate, StructuredTextField, UserLuck;

@interface LuckViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {

	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
		
	IBOutlet UILabel *severityLabel;					/**< UILabel for UISlider of luck's severity */
	IBOutlet UILabel *luckLabel;						/**< UILabel for UISlider of luck's severity */
	IBOutlet UIImageView *luckImageView;				/**< luck image */
	IBOutlet UIImageView *cloudImageView;				/**< luck image */
	IBOutlet UIImageView *backgroundImageView;			/**< background image */
	IBOutlet UIImageView *descriptionInnerShadow;			/**< faux inner drop shadow for UITextView */
	IBOutlet UIView *luckParametersView;				/**< UIView for hiding top parameters for keyboard */
	IBOutlet UIView *luckDescriptionView;				/**< UIView for shifting bottom parameter for keyboard */
	
	IBOutlet UIButton *hideKeyboardButton;					/**< done button for UITextView keyboard dismissal */
	IBOutlet UIButton *doneButton;						/**< done button for ViewController dismissal */
	IBOutlet UIButton *cancelButton;						/**< cancel button for ViewController dismissal and entry deletion*/
	
	IBOutlet StructuredTextField *luckTextField;			/**< overloaded text field for luck's title */
	IBOutlet UITextView *descriptionTextView;				/**< UITextView for luck's extended description */
	IBOutlet UISlider *severitySlider;						/**< UISlider for luck's severity */
	
	StructuredTextField *activeField;						/** temporary overloaded text field for determining active field */
	
	NSArray *luckSeverityLabelDescriptions;				/** list of positive localized severity descriptions */
	
	BOOL isGood;											/** determine if screen shown is good or bad */
	BOOL isLuckFinished;									/** determine if choice is complete */
	
	UserLuck *currentUserLuck;								/** nsmanagedobject of current luck */
	NSString *luckKey;										/** string to hold primary key of current luck */
	
}

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
