/**
Accessory accept screen.  View that allows User to approve purchase/selection.
 
Last screen in the workflow of User attempting to purchase/outfit the Conscience with a ConscienceAsset.

@class ConscienceAcceptViewController
@see ConscienceListViewController
@see ConscienceModalViewController
@see ConscienceViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 08/25/2010
 */

@interface ConscienceAcceptViewController : UIViewController

@property (nonatomic, assign) int accessorySlot;		/**< which slot is ConscienceAsset, set from ConscienceListViewController */
@property (nonatomic, retain) NSString *assetSelection;	/**< which ConscienceAsset, set from ConscienceListViewController */

/**
Accepts User input to commit the choice of ConscienceAsset to persistence.  Returns User to ConscienceViewController.
@param sender id of object which requested method
@return IBAction referenced from Interface Builder
 */
-(IBAction)acceptThoughtModal:(id)sender;

/**
Accepts User input to return to ConscienceModalViewController
 */
-(void)dismissAcceptModal;

/**
Accepts User input to return to ConscienceModalViewController
 */
-(void)returnToHome;

/**
Retrieve how many ethicals User currently has from MoraLifeAppDelegate::userCollection.
 */
-(void)retrieveCurrentFunds;

/**
Subtract cost of ConscienceAsset from MoraLifeAppDelegate::userCollection.
 */
-(void)processCollection;

/**
Commit the choice of ConscienceAsset to ConscienceView.
 */
-(void)saveConscience;

@end
