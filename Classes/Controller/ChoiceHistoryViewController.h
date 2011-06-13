/**
 Choice History listing screen.  Screen listing of all previously-entered in Choices.
 
 Second screen in Choice/Luck entry Workflow.  User can select a Choice for review/edit.
 
 @class ChoiceHistoryViewController
 @see ChoiceViewController
 
 @author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 07/13/2010
 @file
 */

#import <CoreData/CoreData.h>

@class MoraLifeAppDelegate;

@interface ChoiceHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
	
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
	    
	//Raw data of all entered choices
	NSMutableArray *choices;			/**< Array of User-entered choice titles */
	NSMutableArray *choicesAreGood;     	/**< Array of whether choices are good/bad */
	NSMutableArray *choiceKeys;			/**< Array of User-entered choice titles */
	NSMutableArray *details;			/**< Array of User-entered details */
	NSMutableArray *icons;				/**< Array of associated images */
    
	//Data for filtering/searching sourced from raw data
	NSMutableArray *dataSource;			/**< array for storing of Choices populated from previous view*/
	NSMutableArray *tableData;			/**< array for stored data displayed in table populated from dataSource */
	NSMutableArray *tableDataColorBools;	/**< array for stored data booleans for Virtue/Vice distinction */
	NSMutableArray *tableDataImages;		/**< array for stored data images */
	NSMutableArray *tableDataDetails;		/**< array for stored data details */
	NSMutableArray *tableDataKeys;		/**< array for stored data primary keys */
	
	IBOutlet UISearchBar *choiceSearchBar;	/**< ui element for limiting choices in table */
	
	IBOutlet UITableView *choicesTableView;	/**< table of User choices*/
    IBOutlet UIView *thoughtArea;			/**< area in which thought bubble appears */
        
    
	NSMutableString *choiceSortDescriptor;	/**< sort descriptor for filtering Core Data */
	BOOL isAscending;					/**< is data ascending or descending order */
    BOOL isVirtue;
}

/**
 Accepts User Input to remove modal screen
 
@param id Object which requested method
@return IBAction method is usable by Interface Builder
*/
-(IBAction)dismissChoiceModal:(id)sender;

/**
 Retrieve all User entered Choices
 */
- (void) retrieveAllChoices;

/**
 Retrieve choice for selection
 @param choiceKey NSString of requested pkey
 */
- (void) retrieveChoice:(NSString *) choiceKey;

/**
 Filter the list based on User search string
 @param searchText NSString of requested pkey
 */
- (void) filterResults: (NSString *)searchText;

@end