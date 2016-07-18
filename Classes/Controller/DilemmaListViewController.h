/**
List of available Dilemmas/Actions.  View Controller responsible for showing available dilemmas and progressing User through story.

@class DilemmaListViewController
@see ConscienceViewController
@see DilemmaViewController
@see ConscienceActionViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/24/2010
@file
 */

@class DilemmaListModel;
#import "MoraLifeViewController.h"

@interface DilemmaListViewController : MoraLifeViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UIImage *screenshot;       /**< screenshot of previous screen for transition */

- (instancetype)initWithModelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience NS_UNAVAILABLE;

/**
 Dependency injection constructor to pass model
 @param dilemmaModel DilemmaModel handling business logic
 @param modelManager ModelManager data persistence
 @param userConscience UserConscience for modals and help screens
 @return id instance of DilemmaListViewController
 */
- (instancetype)initWithModel:(DilemmaListModel *) dilemmaModel modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience NS_DESIGNATED_INITIALIZER;

/**
Remove DilemmaList screen and reset requested Dilemma Campaign
@param sender id Object which requested method
@return IBAction referenced from Interface Builder
 */
-(IBAction)dismissDilemmaModal:(id)sender;

/**
Accepts User input to return to ConscienceViewController
@param sender id Object which requested method
@return IBAction referenced from Interface Builder
 */
-(IBAction)returnToHome:(id)sender;

@end
