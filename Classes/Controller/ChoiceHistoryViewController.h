/**
 Choice History listing screen.  Screen listing of all previously-entered in Choices.
 
 Second screen in Choice/Luck entry Workflow.  User can select a Choice for review/edit.
 
 @class ChoiceHistoryViewController
 @see ChoiceViewController
 
 @author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 07/13/2010
 @file
 */

@class ChoiceHistoryModel;

@interface ChoiceHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> 

@property(nonatomic, strong) UIImage *screenshot;       /**< screenshot of previous screen for transition */

/**
 Dependency injection constructor to pass model
 @param choiceHistoryModel ChoiceHistoryModel handling business logic
 @return id instance of ChoiceHistoryModel
 */
- (id)initWithModel:(ChoiceHistoryModel *)choiceHistoryModel;

/**
 Accepts User Input to remove modal screen
 
@param id Object which requested method
@return IBAction method is usable by Interface Builder
*/
-(IBAction)dismissChoiceModal:(id)sender;

@end