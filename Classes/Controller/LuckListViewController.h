/**
Luck Listing screen.  Listing of all previously-entered in Lucks.

@class LuckListViewController
@see ChoiceInitViewController
@see LuckViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 11/13/2010
@file
 */

#import <CoreData/CoreData.h>

@class MoraLifeAppDelegate;

@interface LuckListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {

	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */

	NSMutableArray *lucks;			/**< Array of User-entered luck titles */
	NSMutableArray *lucksAreGood;		/**< Array of whether choices are good/bad */
	NSMutableArray *luckKeys;		/**< Array of User-entered luck pkeys */
	NSMutableArray *details;		/**< Array of User-entered severities */
	NSMutableArray *icons;			/**< Array of User-entered severities */
	
	NSMutableArray *dataSource;			/**< array for storing of Choices populated from previous view*/
	NSMutableArray *tableData;			/**< array for stored data displayed in table populated from dataSource */
	NSMutableArray *tableDataColorBools;	/**< array for stored data boolean */
	NSMutableArray *tableDataImages;		/**< array for stored data images */
	NSMutableArray *tableDataDetails;		/**< array for stored data details */
	NSMutableArray *tableDataKeys;		/**< array for stored data primary keys */
	
	IBOutlet UISearchBar *luckSearchBar;	/**< ui element for limiting choices in table */
	
	IBOutlet UITableView *lucksTableView;	/**< table of User lucks */
	IBOutlet UIView *lucksView;			/**< ui surrounding tableview */
    
	IBOutlet UIButton *luckSortButton;		/**< button for sorting criteria */
	IBOutlet UIButton *luckOrderButton;		/**< button for ordering criteria */
    
	NSMutableString *luckSortDescriptor;	/**< sort descriptor for filtering Core Data */
	BOOL isAscending;					/**< is data ascending or descending order */
}

/**
Accepts User input to selects the data sort and order types
@param id Object which requested method
@return IBAction method is usable by Interface Builder
 */
- (IBAction) switchList:(id) sender;

/**
Retrieve all User entered Lucks
 */
- (void) retrieveAllLucks;

/**
Filter the list based on User search string
@param searchText NSString of requested pkey
 */
- (void) filterResults: (NSString *)searchText;

/**
Retrieve luck for selection
@param choiceKey NSString of requested pkey
 */
- (void) retrieveLuck:(NSString *) luckKey;

/**
Delete the particular luck
@param choiceKey NSString of requested pkey
@todo v2.0 determine best course for Luck deletion
 */
- (void) deleteLuck:(NSString *) luckKey;

@end
