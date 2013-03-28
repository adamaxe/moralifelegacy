/**
Moral selection screen.  Modal view to allow selection of Moral from Choice Entry screen.

Third screen in Moral Entry Workflow.  User can either Virtue or Vice depending upon User-requested value.
 
@class ChoiceModalViewController ChoiceModalViewController.h
@see ChoiceViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/24/2010
@file
 */

#import "MoraLifeViewController.h"

@interface ChoiceModalViewController : MoraLifeViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property(nonatomic, strong) UIImage *screenshot;       /**< screenshot of previous screen for transition */

/**
Accepts User Input to remove modal screen
 
@param id Object which requested method
@return IBAction method is usable by Interface Builder
 */
-(IBAction)dismissChoiceModal:(id)sender;

@end
