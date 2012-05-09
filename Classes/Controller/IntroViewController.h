/**
Application Introduction.  View controller for first time into app.  Only utilized on first boot.

@class IntroViewController
@see ConscienceViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 10/9/2010
@file
 */

@interface IntroViewController : UIViewController

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
/**
In case of interruption, return Intro to saved state
 */
-(void)resumeIntro;
/**
Gracefully dismiss Intro by fading out view
 */
-(void)dismissIntroModal;
/**
Fade ConscienceView back from being faded out and changed
 */
-(void)revealConscience;
/**
In case of interruption, stop Intro, save state
 */
-(void)stopIntro;
/**
Animate UI arrow to draw User attention
 */
-(void)animateDownButton;
/**
 Animate fading text
 */
-(void)animateStatusText;
/**
Animate UI arrow to draw User attention to interaction button
 */
-(void)animateNextButton;
/**
Change the Conscience to an angel
 */
-(void)makeAngel;
/**
Change the Conscience to a devil
 */
-(void)makeDevil;
/**
Return Conscience to normal state
 */
-(void)makeNormal;

@end
