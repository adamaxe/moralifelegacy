/**
Application Introduction.  View controller for first time into app.  Only utilized on first boot.

@class IntroViewController
@see HomeViewController
 
@author Copyright 2020 Adam Axe. All rights reserved. http://www.adamaxe.com
@date 10/9/2010
@file
 */

#import "MoraLifeViewController.h"

@interface IntroViewController : MoraLifeViewController

/**
Accepts User input to select the last choice in the Introduction
@param sender id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)switchLast:(id)sender;

/**
Accepts User input to advance the Intro one screen
@param sender id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)switchNow:(id)sender;

@end
