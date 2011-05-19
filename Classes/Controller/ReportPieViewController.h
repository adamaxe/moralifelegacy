/**
Report view displaying pie chart.  Create GraphView and then displays contents of aggregated data from choice entries.

@class ReportPieViewController
@see ConscienceModalViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/05/2010
@file
 */

#import <CoreData/CoreData.h>
@class MoraLifeAppDelegate;

@interface ReportPieViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
    
	NSMutableDictionary *reportValues;		/**< */
	NSMutableDictionary *moralDisplayNames;	/**< names to be displayed on list */
	NSMutableDictionary *moralImageNames;	/**< image file names for Moral */
	NSMutableDictionary *moralColors;		/**< text color associated with Moral */
    	
	NSString *reportName;				/**< label for name of the report */
	float runningTotal;				/**< total of Moral Weight for calculation purposes */
	IBOutlet UIView *thoughtModalArea;

	NSMutableArray *pieColors;		/**< all Moral colors in order */
	NSMutableArray *pieValues;		/**< all degrees of circle in order */
	NSMutableArray *reportNames;		
	NSMutableArray *moralNames;
    
	BOOL isGood;		/**< is current view for Virtues or Vices */
	BOOL isAscending;		/**< current order type */
	BOOL isAlphabetical;	/**< current sort type */
	
	IBOutlet UIImageView *moralType;		/**< image to depict current status of view (Virtue/Vice) */
	IBOutlet UIButton *moralTypeButton;		/**< button to switch between Virtue/Vice */
	/** @todo rename to moralSortButton */
	IBOutlet UIButton *moralListButton;		/**< button to toggle sort type (Name/Weight) */
	/** @todo rename to moralOrderButton */
	IBOutlet UIButton *moralSortButton;		/**< button to toggle order type (Asc/Des) */
	IBOutlet UITableView *reportTableView;	/**< table to house results */
    IBOutlet UILabel *moralTypeLabel;       /**< is report virtue or vice */
}

/**
Accepts User input to graph display type (sort/order/virtue/vice)  
@param sender id of object which requested method
@return IBAction referenced from Interface Builder
 */
- (IBAction) switchGraph:(id) sender;

/**
Accepts User input to return to ConscienceModalViewController  
@param sender id of object which requested method
@return IBAction referenced from Interface Builder
 */
- (IBAction) returnToHome:(id) sender;

/**
Retrieve all User entered Morals
 */
- (void) retrieveChoices;
//- (void) generatePieColors;

/**
Convert UserData into graphable data, create a GraphView
 */
- (void) generateGraph;

@end
