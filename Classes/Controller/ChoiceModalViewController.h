/**
Moral selection screen.  Modal view to allow selection of Moral from Choice Entry screen.

Third screen in Moral Entry Workflow.  User can either Virtue or Vice depending upon User-requested value.
 
@class ChoiceModalViewController ChoiceModalViewController.h
@see ChoiceViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/24/2010
@file
 */

#import <CoreData/CoreData.h>

@class MoraLifeAppDelegate;

@interface ChoiceModalViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
  
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */	
	
	IBOutlet UITableView *choiceModalTableView;  	/**< table referenced by IB */

	//Raw data of all available morals
	NSMutableArray *searchedData;			/**< array for matched data from User search */
	NSMutableArray *choiceNames;			/**< array for Moral pkey */
	NSMutableArray *choiceDisplayNames;		/**< array for Moral name */
	NSMutableArray *choiceImages;			/**< array for Moral Image */
	NSMutableArray *choiceDetails;		/**< array for Moral synonyms */

	//Data for filtering/searching sourced from raw data
	NSMutableArray *dataSource;				/**< array for storing of Choices populated from previous view*/
	NSMutableArray *tableData;				/**< array for stored data displayed in table populated from dataSource */
	NSMutableArray *tableDataImages;			/**< array for stored data images */
	NSMutableArray *tableDataDetails;			/**< array for stored data details */
	NSMutableArray *tableDataKeys;			/**< array for stored data pkeys */

	IBOutlet UISearchBar *moralSearchBar;			/**< ui element for limiting choices in table */
	
	IBOutlet UIView *thoughtModalArea;				/**< ui surrounding table */
	
	BOOL isVirtue;		/**< is Moral Virtue or Vice */
    
}

/**
Accepts User Input to remove modal screen
 
@param id Object which requested method
@return IBAction method is usable by Interface Builder
 */
-(IBAction)dismissChoiceModal:(id)sender;

/**
Retrieve all available Morals
 */
-(void)retrieveAllSelections;


@end
