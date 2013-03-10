/**
Application Introduction.  View controller for first time into app.  Only utilized on first boot.

@class IntroViewController
@see ConscienceViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 10/9/2010
@file
 */

@class UserConscience;

@interface IntroViewController : UIViewController

/**
 Creates the viewController with the User's Conscience
 @param userConscience UserConscience for modals and help screens
 @return id instance of IntroViewController
 */
-(id)initWithConscience:(UserConscience *)userConscience;

/**
Accepts User input to select the last choice in the Introduction
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)switchLast:(id)sender;

/**
Accepts User input to advance the Intro one screen
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)switchNow:(id)sender;

@end
