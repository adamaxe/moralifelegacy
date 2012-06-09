/**
Conscience modular Help screen.  View controller for Conscience helping User with Interface.

@class ConscienceHelpViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 10/9/2010
@file
 */

@interface ConscienceHelpViewController : UIViewController

@property(nonatomic, retain) NSArray *helpTitles;		/**< title for each page */
@property(nonatomic, retain) NSArray *helpTexts;		/**< text for each page */
@property(nonatomic, assign) BOOL isConscienceOnScreen;	/**< is Conscience already on screen */

/**
 Accepts User input to change the presently displayed UIView
 @param id Object which requested method
 @return IBAction method available from Interface Builder
 */
-(IBAction)selectChoice:(id)sender;

/**
 Accepts User input to return to ConscienceModalViewController
 @param id Object which requested method
 @return IBAction referenced from Interface Builder
 */
-(IBAction)returnToHome:(id)sender;

@end