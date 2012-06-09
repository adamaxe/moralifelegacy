/**
Choice listing screen.  Screen listing of all previously-entered in Choices.

Second screen in Choice/Luck Listing Workflow.  User can select a Choice for review/edit.

@class ChoiceListViewController
@see ChoiceInitViewController
@see ChoiceViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/13/2010
@file
 */

@interface ChoiceListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

/**
Accepts User input to selects the data sort and order types
@param id Object which requested method
@return IBAction method is usable by Interface Builder
 */
- (IBAction) switchList:(id) sender;

@end