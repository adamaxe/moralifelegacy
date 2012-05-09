/**
 Choice History listing screen.  Screen listing of all previously-entered in Choices.
 
 Second screen in Choice/Luck entry Workflow.  User can select a Choice for review/edit.
 
 @class ChoiceHistoryViewController
 @see ChoiceViewController
 
 @author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 07/13/2010
 @file
 */

@interface ChoiceHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> 

/**
 Accepts User Input to remove modal screen
 
@param id Object which requested method
@return IBAction method is usable by Interface Builder
*/
-(IBAction)dismissChoiceModal:(id)sender;

/**
 Retrieve all User entered Choices
 */
- (void) retrieveAllChoices;

/**
 Retrieve choice for selection
 @param choiceKey NSString of requested pkey
 */
- (void) retrieveChoice:(NSString *) choiceKey;

/**
 Filter the list based on User search string
 @param searchText NSString of requested pkey
 */
- (void) filterResults: (NSString *)searchText;

@end