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

#import "CoreData/CoreData.h"

@class MoraLifeAppDelegate, ConscienceBody, ConscienceAccessories, ConscienceMind;

@interface ConscienceAcceptViewController : UIViewController {

	MoraLifeAppDelegate *appDelegate;	/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;	/**< Core Data context */
	
	NSString *currentFeature;           /**< filename of ConscienceAsset image */
    NSMutableString *resetFeature;
    
	IBOutlet UIImageView *moralImageView;			/**< image of ConscienceAsset::relatedMoral */
	IBOutlet UIView *thoughtModalArea;				/**< area in which user ConscienceView can float */
	IBOutlet UIView *consciencePlayground;			/**< area in which custom ConscienceView can float */
	IBOutlet UILabel *currentFundsLabel;			/**< display of User's current ethicals */
	IBOutlet UILabel *accessoryNameLabel;			/**< name of ConscienceAsset */
	IBOutlet UILabel *accessoryCostLabel;			/**< cost of ConscienceAsset */
	IBOutlet UILabel *insufficientEthicalsLabel;	/**< insufficient ethicals notification */
    
	IBOutlet UIButton *yesButton;					/**< button used to accept new ConscienceAsset */
	IBOutlet UIButton *noButton;					/**< button used to reject new ConscienceAsset */
    
 	int currentFunds;		/**< current amount of ethicals from MoraLifeAppDelegate::userCollection */
	int assetCost;		/**< cost of ConscienceAsset */
    
	BOOL isOwned;		/**< is ConscienceAsset already owned by User */
	
}

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
