/**
Secondary Accessory selection screen.  View that allows User to select accessories for Conscience.

Second screen in Conscience Accessory Workflow.  User can select type of ConscienceAsset via onscreen boxes denoting top, bottom, primary and secondary.
 
@class ConscienceAccessoryViewController
@see ConscienceViewController
@see ConscienceListViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 08/25/2010
 */

#import "MoraLifeViewController.h"

@interface ConscienceAccessoryViewController : MoraLifeViewController

@property (nonatomic, strong) UIImage *screenshot;       /**< screenshot of previous screen for transition */

/**
Accepts User input to select a ConscienceAsset for review
@param sender id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)selectChoice:(id) sender;

/**
Accepts User input to return to ConscienceViewController
 */
-(IBAction)dismissAccessoryModal;

@end