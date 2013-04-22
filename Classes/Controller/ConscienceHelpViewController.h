/**
Conscience modular Help screen.  View controller for Conscience helping User with Interface.

@class ConscienceHelpViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 10/9/2010
@file
 */

@class UserConscience;

@interface ConscienceHelpViewController : UIViewController

@property(nonatomic, strong) NSString *viewControllerClassName;

@property(nonatomic, strong) UIImage *screenshot;       /**< screenshot of previous screen for transition */
@property(nonatomic, strong) NSArray *helpTitles;		/**< title for each page */
@property(nonatomic, strong) NSArray *helpTexts;		/**< text for each page */
@property(nonatomic, assign) int numberOfScreens;       /**< the help screen requested */
@property(nonatomic, assign) BOOL isConscienceOnScreen;	/**< is Conscience already on screen */

/**
 Creates the viewController with the User's Conscience
 @param userConscience UserConscience for modals and help screens
 @return id instance of ConscienceHelpViewController
 */
-(id)initWithConscience:(UserConscience *)userConscience;

/**
 Accepts User input to change the presently displayed UIView
 @param sender id Object which requested method
 @return IBAction method available from Interface Builder
 */
-(IBAction)selectChoice:(id)sender;

/**
 Accepts User input to return to ConscienceViewController
 @param sender id Object which requested method
 @return IBAction referenced from Interface Builder
 */
-(IBAction)returnToHome:(id)sender;

@end