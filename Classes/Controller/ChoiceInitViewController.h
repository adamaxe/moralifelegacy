/**
Choice Initialization View Controller.  Home Screen for Choice Tabbar menu selection.  

Primary screen in Choice/Luck Entry and Listing Workflows.  Allows for selection of entry type of a Good or Bad Choice, or the listing of all entered choices.
 
@class ChoiceInitViewController

@author Copyright 2020 Adam Axe. All rights reserved. http://www.adamaxe.com
@date 08/18/2010
*/

#import "MoraLifeViewController.h"

@interface ChoiceInitViewController : MoraLifeViewController

/**
Accepts User input to selects the data entry screen type for Choices or Luck
@param sender Object which requested method
@return IBAction method is usable by Interface Builder
 */
- (IBAction) selectChoiceType:(id)sender;

@end
