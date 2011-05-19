/**
List of available References.  
 
Secondary screen in Reference review Workflow.  User can filter and review a list of available References for further inspection.
 
@class ReferenceListViewController
@see ReferenceViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/04/2010
 */

#import <CoreData/CoreData.h>
@class MoraLifeAppDelegate;

@interface ReferenceListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
		
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
	NSEntityDescription *entityAssetDesc;	/**< select for request */
	
	NSMutableArray *references;			/**< text to appear as row name */
	NSMutableArray *referenceKeys;		/**< text to key on DB */
	NSMutableArray *icons;				/**< filename of picture to be shown in row */
	NSMutableArray *details;			/**< text to appear under row name */
	
	NSMutableArray *dataSource;			/**< array for storing of References populated from previous view*/
	NSMutableArray *searchedData;
	NSMutableArray *tableData;			/**< array for stored data displayed in table populated from dataSource */
	NSMutableArray *tableDataImages;		/**< array for stored data images */
	NSMutableArray *tableDataDetails;		/**< array for stored data details */
	NSMutableArray *tableDataKeys;		/**< array for stored data primary keys */	
	
	IBOutlet UITableView *referencesTableView;	/**< table housing requested data */ 
	IBOutlet UISearchBar *referenceSearchBar;		/**< search bar for limiting list */
	IBOutlet UIView *namesView;
}

@property (nonatomic, assign) int referenceType;	/**< int determining type of reference selection */

/**
Load Reference data from Core Data for table
 */
- (void) retrieveAllReferences;

/**
Remove entries from tableview that don't correspond to being searched
@param searchText NSString of requested reference
 */
- (void)filterResults:(NSString *) searchText;

@end