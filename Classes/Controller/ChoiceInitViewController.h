/**
Choice Initialization View Controller.  Home Screen for Choice Tabbar menu selection.  

Primary screen in Choice/Luck Entry and Listing Workflows.  Allows for selection of entry type of a Good or Bad Choice, or the listing of all entered choices.
 
@class ChoiceInitViewController
@see MoraLifeAppDelegate

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 08/18/2010
*/

@class UserConscience;

@interface ChoiceInitViewController : UIViewController

/**
 Creates the viewController with the User's Conscience
 @param userConscience UserConscience for modals and help screens
 */
-(id)initWithConscience:(UserConscience *)userConscience;

/**
Accepts User input to selects the data entry screen type for Choices or Luck
@param id Object which requested method
@return IBAction method is usable by Interface Builder
 */
- (IBAction) selectChoiceType:(id)sender;

@end
