/**
Luck Listing screen.  Listing of all previously-entered in Lucks.

@class LuckListViewController
@see ChoiceInitViewController
@see LuckViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 11/13/2010
@file
 */

@interface LuckListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

/**
Accepts User input to selects the data sort and order types
@param id Object which requested method
@return IBAction method is usable by Interface Builder
 */
- (IBAction) switchList:(id) sender;

@end
