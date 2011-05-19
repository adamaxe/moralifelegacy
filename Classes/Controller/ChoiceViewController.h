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

#import <CoreData/CoreData.h>

@class MoraLifeAppDelegate, StructuredTextField, UserChoice;

@interface ChoiceViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {

	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
	
	IBOutlet UILabel *severityLabel;					/**< UILabel for UISlider of choice's severity */
	IBOutlet UIImageView *moralImageView;				/**< moral image */
	IBOutlet UIImageView *backgroundImageView;			/**< background image */
	IBOutlet UIImageView *descriptionInnerShadow;			/**< faux inner drop shadow for UITextView */
	IBOutlet UIView *choiceParametersView;				/**< UIView for hiding top parameters for keyboard */
	IBOutlet UIView *choiceDescriptionView;				/**< UIView for shifting bottom parameter for keyboard */
	
	IBOutlet UIButton *hideKeyboardButton;				/**< done button for UITextView keyboard dismissal */
	IBOutlet UIButton *doneButton;					/**< done button for ViewController dismissal */
	IBOutlet UIButton *cancelButton;					/**< cancel button for ViewController dismissal and entry deletion*/
	IBOutlet UIButton *moralButton;					/**< moral button list selection for ViewController dismissal */
	IBOutlet UIButton *moralReferenceButton;				/**< moral button which selects moral reference */

	IBOutlet StructuredTextField *choiceTextField;			/**< overloaded text field for choice title */
	IBOutlet UITextView *descriptionTextView;				/**< UITextView for choice's extended description */
	IBOutlet UISlider *severitySlider;					/**< UISlider for choice's severity */
		
	StructuredTextField *activeField;					/** temporary overloaded text field for determining active field */
	
	NSArray *severityLabelDescriptions;				/** list of localized severity descriptions */
	
	BOOL isVirtue;							/** determine if screen shown is virtue or vice */
	BOOL isChoiceFinished;						/** determine if choice is complete */
	
	UserChoice *currentUserChoice;				/** nsmanagedobject of current choice */
	NSString *choiceKey;						/** string to hold primary key of current choice */
	NSString *moralKey;						/** string to hold primary key of current moral */

}

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