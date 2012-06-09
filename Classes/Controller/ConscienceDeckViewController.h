/**
Deck of Cards screen.  

Secondary screen for selecting morality/asset cards.
 
@class ConscienceDeckViewController
@see ConscienceListViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/30/2010
@file
 */

@interface ConscienceDeckViewController : UIViewController

/**
Accept User input to flip card from selected to deselected state
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)cardToggle:(id)sender;

@end
