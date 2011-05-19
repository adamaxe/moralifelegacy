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

#import <CoreData/CoreData.h>

@class MoraLifeAppDelegate;

@interface ConscienceListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */

	NSMutableArray *searchedData;			/**< array for matched data from User search */

	NSMutableArray *choices;			/**< unfiltered list of assets */
	NSMutableArray *choiceIDs;			/**< unfiltered list of asset pkeys */
	NSMutableArray *choiceCosts;			/**< unfiltered list of asset costs */
	NSMutableArray *choiceSubtitles;		/**< unfiltered list of asset descriptions */
	NSMutableArray *choiceImages;			/**< unfiltered list of asset images */
	
	NSMutableArray *dataSource;			/**< array for filtering raw data without having to re-query */
	NSMutableArray *tableData;			/**< array for filtering data displayed in table populated from dataSource */
	NSMutableArray *tableDataImages;		/**< array for filtering data images */
	NSMutableArray *tableDataDetails;		/**< array for filtering data details */
	NSMutableArray *tableDataKeys;		/**< array for filtering data primary keys */
	NSMutableArray *tableDataCosts;		/**< array for filtering item cost */
    
	IBOutlet UITableView *choicesTableView;	/**< tableview of choices */
    
	IBOutlet UIView *thoughtModalArea;			/**< area in which user ConscienceView can float */
	IBOutlet UIButton *fundsButton;			/**< allow User to filter only affordable choices */
	IBOutlet UILabel *listType;			/**< show which view is active */    
	
	IBOutlet UISearchBar *accessorySearchBar;		/**< ui element for limiting choices in table */
    
	int currentFunds;						/**< amount of ethicals possessed */
    	BOOL isLessThanCost;					/**< is User requesting to show only affordable options */
    int searchViewFilter;                    /**< which view to show */
}

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