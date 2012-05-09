/**
Conscience Interaction dilemma screen.  View for Conscience asking User moral question.

@class DilemmaViewController
@see ConscienceListViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/9/2010
@file
 */

@interface DilemmaViewController : UIViewController

/**
Accepts User input to change the presently displayed UIView and possibly commit Choice
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)selectChoice:(id)sender;

/**
Accepts User input to return to ConscienceModalViewController
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)returnToHome:(id)sender;

/**
Load the dilemma's details from SystemData
 */
-(void)loadDilemma;

/**
Change the active UIView within the UIViewController
@param screenVersion intDesignating which page of screen to display
 */
-(void)changeScreen:(int) screenVersion;

/**
Commit User's choice to UserData
 */
-(void)commitDilemma;

@end