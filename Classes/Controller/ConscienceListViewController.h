/**
Conscience Listing screen.  View controller for accessing lists of available options for various Conscience screens.

Secondary Conscience interaction screen.  Most other Conscience interactions request this screen to list things from Core Data.  

@class ConscienceListViewController
@see ConscienceModalViewController
@see ConscienceAccessoryViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 08/26/2010
@file
 */

@interface ConscienceListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, assign) int accessorySlot;	/**< which slot is ConscienceAsset, set from ConscienceAccessoryViewController */

/**
Accepts User input to filter list of ConscienceAssets.
@param sender id of object which requested method
@return IBAction referenced from Interface Builder
 */
-(IBAction)filterByCost:(id)sender;

/**
Accepts User input to cancel the choice of ConscienceAsset.  Either returns User to ConscienceModalViewController in case of buttonNext or ConscienceListViewController in case of buttonNo.
@param sender id of object which requested method
@return IBAction referenced from Interface Builder
 */
-(IBAction)dismissThoughtModal:(id)sender;

/**
 Accepts User input to return to ConscienceModalViewController
 @param id Object which requested method
 @return IBAction method available from Interface Builder
 */
-(IBAction)returnToHome:(id)sender;

/**
Retrieve all available ConscienceAssets
 */
-(void)retrieveAllSelections;

/**
Retrieve amount of ethicals available to User (money)
 */
-(void)retrieveCurrentFunds;

@end