/**
List of available Dilemmas/Actions.  View Controller responsible for showing available dilemmas and progressing User through story.

@class DilemmaListViewController
@see ConscienceModalViewController
@see DilemmaViewController
@see ConscienceActionViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/24/2010
@file
 */

@interface DilemmaListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

/**
Remove DilemmaList screen and reset requested Dilemma Campaign
@param id Object which requested method
@return IBAction referenced from Interface Builder
 */
-(IBAction)dismissDilemmaModal:(id)sender;

/**
Accepts User input to return to ConscienceModalViewController
@param id Object which requested method
@return IBAction referenced from Interface Builder
 */
-(IBAction)returnToHome:(id)sender;

/**
Load User data to determine which Dilemmas have already been completed
 */
- (void) loadUserData;

/**
Load Dilemma data from Core Data for table
 */
- (void) retrieveAllDilemmas;

/**
VERSION 2.0
Allow limited ability to rechoose dilemma
 */
- (void) deleteChoice:(NSString *) choiceKey;

/**
Remove entries from tableview that don't correspond to being searched
 */
- (void)filterResults:(NSString *) searchText;

@end