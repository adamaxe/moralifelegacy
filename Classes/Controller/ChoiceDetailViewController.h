/**
Secondary Choice Data entry screen.  Screen which allows User to enter in additional Choice information (Justification, Consequence, Influence).

Last screen in Choice/Luck Entry Workflow.
 
@class ChoiceDetailViewController
@see ChoiceViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/12/2010
@file
*/

@class StructuredTextField;

@interface ChoiceDetailViewController : UIViewController <UITextFieldDelegate> {

	NSUserDefaults *prefs;					/**< serialized user settings/state retention */
	
	IBOutlet UIImageView *influenceImageView;		/**< people image decorating influenceSlider */
	IBOutlet UIImageView *cloudImageView;		/**< cloud image decorating influenceSlider */

	IBOutlet UISlider *influenceSlider;         /**< Slider control dictating how many people were affected */
	IBOutlet UILabel *influenceLabel;           /**< Label that shows User amount of influence */
	IBOutlet UILabel *justificationLabel;       /**< Justification textField label */
	IBOutlet UILabel *consequencesLabel;        /**< Consequences textField label */
	NSArray *influenceLabelDescriptions;        /**< Array of NSLocalized Strings to display to User */
	
	IBOutlet UIButton *doneButton;		/**< Done Button */
	IBOutlet UIButton *cancelButton;		/**< Cancel Button */
	IBOutlet UIButton *influenceButton;		/**< Influence Button */	
    
	IBOutlet StructuredTextField *justificationTextField;	/**< Text field for User-entered justification */
	IBOutlet StructuredTextField *consequencesTextField;	/**< Text field for User-entered consequence */
	StructuredTextField *activeField;				/**< Temporary field designation for active field */

	/** @todo rename BOOL to correct description */	
	BOOL isChoiceFinished;		/**< is Choice being cancelled */
}

/**
Accepts User input to change the description of the Influence slider
@param id Object which requested the slider change
@return IBAction referenced from Interface Builder
 */
-(IBAction)influenceChange:(id) sender;

/**
Accepts User input to dismiss current UIViewController
@todo possibly rename previousNav to consistent name

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