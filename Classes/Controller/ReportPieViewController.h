/**
Report view displaying pie chart.  Create GraphView and then displays contents of aggregated data from choice entries.

@class ReportPieViewController
@see ConscienceViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/05/2010
@file
 */

@class ReportPieModel;
#import "MoraLifeViewController.h"

@interface ReportPieViewController : MoraLifeViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIImage *screenshot;       /**< screenshot of previous screen for transition */

/**
 Dependency injection constructor to pass model
 @param reportPieModel ReportPieModel handling business logic
 @param modelManager ModelManager data persistence
 @param userConscience UserConscience for modals and help screens
 @return id instance of ReportPieViewController
 */
- (instancetype)initWithModel:(ReportPieModel *)reportPieModel modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience NS_DESIGNATED_INITIALIZER;
/**
Accepts User input to graph display type (sort/order/virtue/vice)  
@param sender id of object which requested method
@return IBAction referenced from Interface Builder
 */
- (IBAction) switchGraph:(id) sender;

/**
Accepts User input to return to ConscienceViewController  
@param sender id of object which requested method
@return IBAction referenced from Interface Builder
 */
- (IBAction) returnToHome:(id) sender;

@end
