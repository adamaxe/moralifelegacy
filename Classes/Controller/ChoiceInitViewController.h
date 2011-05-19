/**
Choice Initialization View Controller.  Home Screen for Choice Tabbar menu selection.  

Primary screen in Choice/Luck Entry and Listing Workflows.  Allows for selection of entry type of a Good or Bad Choice, or the listing of all entered choices.
 
@class ChoiceInitViewController
@see MoraLifeAppDelegate

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 08/18/2010
*/

@class MoraLifeAppDelegate;

@interface ChoiceInitViewController : UIViewController {
	
	MoraLifeAppDelegate *appDelegate;           /**< delegate for application level callbacks */
	NSUserDefaults *prefs;                      /**< serialized state retention */
	
	IBOutlet UIButton *goodChoiceLabelButton;		/**< Label for Good Choice entry selection */
	IBOutlet UIButton *badChoiceLabelButton;		/**< Label for Bad Choice entry selection */
	IBOutlet UIButton *choiceListLabelButton;		/**< Label for All Choice listing selection */
	
	IBOutlet UIButton *goodChoiceButton;		/**< Button for Good Choice entry selection */
	IBOutlet UIButton *badChoiceButton;			/**< Button for Bad Choice entry selection */
	IBOutlet UIButton *choiceListButton;		/**< Button for All Choice listing selection */
	
	IBOutlet UIButton *goodLuckLabelButton;		/**< Label for Good Choice entry selection */
	IBOutlet UIButton *badLuckLabelButton;		/**< Label for Bad Choice entry selection */
	IBOutlet UIButton *luckListLabelButton;		/**< Label for All Choice listing selection */
	
	IBOutlet UIButton *goodLuckButton;		/**< Button for Good Choice entry selection */
	IBOutlet UIButton *badLuckButton;		/**< Button for Bad Choice entry selection */
	IBOutlet UIButton *luckListButton;		/**< Button for All Choice listing selection */

	NSArray *buttonNames;		/**< button image names */
	NSTimer *buttonTimer;		/**< Timer for animating buttons */
}

/**
Accepts User input to selects the data entry screen type for Choices or Luck
@param id Object which requested method
@return IBAction method is usable by Interface Builder
 */
- (IBAction) selectChoiceType:(id)sender;

/**
Randomly select which of buttons to animate
 */
- (void) refreshButtons;

/**
Animate the button's icon
@param buttonNumber NSNumber which requested button
 */
- (void) buttonAnimate:(NSNumber *) buttonNumber;

/**
Return the buttons icon to default after animation finishes
@param buttonNumber NSNumber which requested button
 */
- (void) buttonAnimationDone:(NSNumber *) buttonNumber;

@end
