/**
Conscience Interaction Workflow.  View controller for selecting menu choices from thought bubble menu.

Primary screen in the Conscience Interaction Workflow.  User experience changes to fanciful thought bubble paradigm.  
Only interaction with the Conscience is available from this workflow.
User can change Conscience, answer Morathology dilemmas and see Moral Reports.

@class ConscienceModalViewController
@see ConscienceViewController
@see ConscienceListViewController
@see ConscienceDilemmaListViewController
@see ConscienceAccessoryViewController
@see ReportPieViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 08/19/2010
@file
 */

@class MoralifeAppDelegate;

@interface ConscienceModalViewController : UIViewController {

	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
    
	NSMutableDictionary *buttonLabels;		/**< various button labels for the screens of UI */
	NSMutableDictionary *buttonImages;		/**< various button image filenames for the screens of UI */
	NSArray *screenTitles;				/**< various screen titles for the pages of UI */
	
	IBOutlet UIView *thoughtModalArea;		/**< area in which user ConscienceView can float */
	IBOutlet UILabel *statusMessage1;		/**< title at top of screen */
	IBOutlet UIButton *labelButton1;		/**< label for menu choice button 1 */
	IBOutlet UIButton *labelButton2;		/**< label for menu choice button 2 */
	IBOutlet UIButton *labelButton3;		/**< label for menu choice button 3 */
	IBOutlet UIButton *labelButton4;		/**< label for menu choice button 4 */
	IBOutlet UIButton *button1;			/**< image for menu choice button 1 */
	IBOutlet UIButton *button2;			/**< image for menu choice button 2 */
	IBOutlet UIButton *button3;			/**< image for menu choice button 3 */
	IBOutlet UIButton *button4;			/**< image for menu choice button 4 */
	
	int currentState;					/**< current state of the screen (which button names, etc.) */
}

/**
Implementation:  Ensure Conscience is placed correctly.
*/
-(void) moveConscienceToBottom;

/**
Accepts User input to change the state of the screen.
@param sender id of object which requested method
@return IBAction referenced from Interface Builder
 */
-(IBAction)selectChoice:(id) sender;

/**
 Accepts User input to determine which version screen to present 
 @param sender id of object which requested method
 @return IBAction referenced from Interface Builder
 */
-(IBAction)dismissThoughtModal:(id)sender;

/**
 Accepts User input to cancel Conscience Interaction Workflow.  
 @param sender id of object which requested method
 @return IBAction referenced from Interface Builder
 */
-(IBAction)returnToHome:(id)sender;

/**
 Makes selection choices reappear 
 */
- (void) showSelectionChoices;

/**
 Changes the display of the UIViewController without additional XIB load
 */
-(void)changeSelectionScreen;

/**
 Accepts User input to change the state of the screen.
 @param controllerID int of UIViewController to be selected
 */
-(void)selectController:(int) controllerID;

/**
VERSION 2.0 FEATURE
Allows the deletion of all User content.
@todo implement delete capability
 */
-(void)removeUserData;

@end