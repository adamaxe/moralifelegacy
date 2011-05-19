/**
Reference Menu screen.  

Primary screen of Reference selection Workflow.  User can select what type of Reference is desired.

@class ReferenceViewController
@see ReferenceListViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 05/17/2010
@file
@todo rename to ReferenceInitViewController
*/

@class MoraLifeAppDelegate;

@interface ReferenceViewController : UIViewController {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	    
	IBOutlet UIButton *peopleLabelButton;		/**< label for People button */
	IBOutlet UIButton *placesLabelButton;		/**< label for Places button */
	IBOutlet UIButton *booksLabelButton;		/**< label for Books button */
	IBOutlet UIButton *beliefsLabelButton;		/**< label for Beliefs button */
	IBOutlet UIButton *reportsLabelButton;		/**< label for Reports button */
	IBOutlet UIButton *accessoriesLabelButton;	/**< label for Accessories button */
	
	IBOutlet UIButton *peopleButton;		/**< label for People button */
	IBOutlet UIButton *placesButton;		/**< label for Places button */
	IBOutlet UIButton *booksButton;		/**< label for Books button */
	IBOutlet UIButton *beliefsButton;		/**< label for Beliefs button */
	IBOutlet UIButton *reportsButton;		/**< label for Reports button */
	IBOutlet UIButton *accessoriesButton;	/**< label for Accessories button */
	
	NSArray *buttonNames;
	NSTimer *buttonTimer;

}

/**
Accepts User input to determine type of Reference requested
@param id Object which requested method
@return IBAction referenced from Interface Builder
 */
- (IBAction) selectReferenceType:(id)sender;

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
