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

/**
Animate the back or previous button to show User if more text is available.

@param isPrevious BOOL which determines which button to animate
 */
-(void)animateCorrectButton:(BOOL)isPrevious;

/**
Change the active UIView within the UIViewController
@param screenVersion intDesignating which version of screen to display
 */
-(void)changeScreen:(int) screenVersion;

/**
Commit User's choice to UserData
@param id Object which requested method
 */
-(void)dismissThoughtModal:(id)sender;

@end