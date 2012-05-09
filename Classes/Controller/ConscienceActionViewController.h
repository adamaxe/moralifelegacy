/**
Conscience Interaction action screen.  View controller for Consciences interacting with each other.

Last screen in Conscience Interaction Workflow.  Allows the User to take a request from antagonist and fulfill it.

@class ConscienceActionViewController
@see ConscienceListViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/9/2010
@file
 */

@interface ConscienceActionViewController : UIViewController

/**
Accepts User input to change the presently displayed UIView and possibly commit Choice

@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)selectChoice:(id)sender;

/**
Accepts User input to return to ConscienceModalViewController
 */
-(IBAction)returnToHome:(id)sender;

/**
Load the dilemma's details from SystemData
 */
-(void)loadDilemma;

/**
Change the active UIView within the UIViewController
@param screenVersion intDesignating which version of screen to display
 */
-(void)changeScreen:(int) screenVersion;

/**
Commit User's choice to UserData
 */
-(void)commitDilemma;

@end