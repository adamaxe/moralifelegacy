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

@class DilemmaModel;

@interface DilemmaListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UIImage *screenshot;       /**< screenshot of previous screen for transition */

/**
 Dependency injection constructor to pass model
 @param referenceModel ReferenceModel handling business logic
 @param userConscience UserConscience for modals and help screens
 @return id instance of ReferenceModel
 */
- (id)initWithModel:(DilemmaModel *) dilemmaModel andConscience:(UserConscience *)userConscience;

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

@end