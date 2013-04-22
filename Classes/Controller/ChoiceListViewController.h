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

@class ChoiceHistoryModel;
#import "MoraLifeViewController.h"

@interface ChoiceListViewController : MoraLifeViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

/**
 Dependency injection constructor to pass model
 @param choiceHistoryModel ChoiceHistoryModel handling business logic
 @param modelManager ModelManager data persistence
 @param userConscience UserConscience for modals and help screens
 @return id instance of ChoiceListViewController
 */
- (id)initWithModel:(ChoiceHistoryModel *)choiceHistoryModel modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience;

/**
Accepts User input to selects the data sort and order types
@param sender Object which requested method
@return IBAction method is usable by Interface Builder
 */
- (IBAction) switchList:(id) sender;

@end