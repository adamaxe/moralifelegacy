/**
Report view displaying pie chart.  Create GraphView and then displays contents of aggregated data from choice entries.

@class ReportPieViewController
@see ConscienceModalViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/05/2010
@file
 */

@interface ReportPieViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 

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
