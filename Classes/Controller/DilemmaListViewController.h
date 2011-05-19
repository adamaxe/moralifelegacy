/**
List of available Dilemmas/Actions.  View Controller responsible for showing available dilemmas and progressing User through story.

@class DilemmaListViewController
@see ConscienceModalViewController
@see DilemmaViewController
@see ConscienceActionViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/24/2010
@file
 */

#import <CoreData/CoreData.h>

@class MoraLifeAppDelegate;

@interface DilemmaListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {

	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
	
	IBOutlet UITableView *dilemmaListTableView;  	/**< table referenced by IB */
    
	NSMutableArray *dataSource;				/**< array for storing of Choices populated from previous view*/
	NSMutableArray *tableData;				/**< array for stored data displayed in table populated from dataSource */
	NSMutableArray *tableDataImages;			/**< array for stored data images */
	NSMutableArray *tableDataDetails;			/**< array for stored data details */
	NSMutableArray *tableDataKeys;			/**< array for stored data primary keys */
    NSMutableArray *tableDataTypes;			/**< array for stored data primary keys */
    
	NSMutableArray *searchedData;			/**< array for matched data from User search */
	NSMutableArray *choiceNames;			/**< these arrays house origial queried data to be re-entered into search results */
	NSMutableArray *choiceDisplayNames;		/**< name to be shown to User */
	NSMutableArray *choiceImages;			/**< image in tableRowCell */
	NSMutableArray *choiceDetails;		/**< tableRowCell detailText */
    NSMutableArray *choiceTypes;		/**< tableRowCell detailText */

	NSMutableDictionary *userChoices;		/**< dictionary to hold Dilemmas already completed by User */
	NSMutableDictionary *moralNames;		/**< dictionary to hold names of selected Morals */
    
	IBOutlet UISearchBar *dilemmaSearchBar;			/**< ui element for limiting choices in table */
	
	IBOutlet UIView *thoughtModalArea;

}

/**
Remove DilemmaList screen and reset requested Dilemma Campaign
@param id Object which requested method
@return IBAction referenced from Interface Builder
 */
-(IBAction)dismissDilemmaModal:(id)sender;

/**
Accepts User input to return to ConscienceModalViewController
@param id Object which requested method
@return IBAction referenced from Interface Builder
 */
-(IBAction)returnToHome:(id)sender;

/**
Load User data to determine which Dilemmas have already been completed
 */
- (void) loadUserData;

/**
Load Dilemma data from Core Data for table
 */
- (void) retrieveAllDilemmas;

/**
VERSION 2.0
Allow limited ability to rechoose dilemma
 */
- (void) deleteChoice:(NSString *) choiceKey;

/**
Remove entries from tableview that don't correspond to being searched
 */
- (void)filterResults:(NSString *) searchText;

@end