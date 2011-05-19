/**
Secondary Accessory selection screen.  View that allows User to select accessories for Conscience.

Second screen in Conscience Accessory Workflow.  User can select type of ConscienceAsset via onscreen boxes denoting top, bottom, primary and secondary.
 
@class ConscienceAccessoryViewController
@see ConscienceModalViewController
@see ConscienceListViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 08/25/2010
 */

@class MoraLifeAppDelegate;

@interface ConscienceAccessoryViewController : UIViewController {
	MoraLifeAppDelegate *appDelegate;	/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
    
	IBOutlet UIView *consciencePlayground;		/**< ui for Conscience to sit */
	IBOutlet UILabel *statusMessage1;			/**< delegate for application level callbacks */
	IBOutlet UILabel *primaryAccessoryLabel;		/**< label for primary accessory outline */
	IBOutlet UILabel *secondaryAccessoryLabel;	/**< label for secondary accessory outline */
	IBOutlet UILabel *topAccessoryLabel;		/**< label for top accessory outline */
	IBOutlet UILabel *bottomAccessoryLabel;		/**< label for bottom accessory outline */
    
    int accessorySlot;
}

-(void) moveConscienceToCenter;
-(void) createList;

/**
Accepts User input to select a ConscienceAsset for review
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)selectChoice:(id) sender;

/**
Accepts User input to return to ConscienceModalViewController
 */
-(void)dismissAccessoryModal;

@end