/**
Application Introduction.  View controller for first time into app.  Only utilized on first boot.

@class IntroViewController
@see ConscienceViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 10/9/2010
@file
 */

@class MoraLifeAppDelegate, ConscienceView, ConscienceBody, ConscienceAccessories;

@interface IntroViewController : UIViewController {

	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;                  /**< serialized user settings/state retention */
    
	IBOutlet UILabel *conscienceStatus;			/**< Conscience's thought presented in bubble */
	IBOutlet UIImageView *thoughtBubbleView1;	/**< bubble surrounding Conscience's thought */
	IBOutlet UIImageView *backgroundImage;		/**< background image manipulation */
	IBOutlet UIImageView *navBarImage;			/**< image that will appear once interaction is done */
	IBOutlet UIImageView *tabBarImage;			/**< image that will appear once interaction is done */
	IBOutlet UIImageView *teamAxeLogoImage;		/**< Team Axe Logo */
	IBOutlet UIImageView *moraLifeLogoImage;	/**< MoraLife Logo */
    IBOutlet UIImageView *nextButtonImage;      /**< image for Next arrow */
    IBOutlet UIImageView *downButtonImage;      /**< image for Down arrow */
	IBOutlet UIView *consciencePlayground;		/**< area in which custom ConscienceView can float */
	IBOutlet UIView *thoughtArea;				/**< area in which thought bubble appears */
	
	IBOutlet UIButton *thoughtButton;			/**< area in which thought bubble appears */
	IBOutlet UIButton *nextButton;              /**< area in which thought bubble appears */	
    
	NSTimer *moveTimer;                 /**< controls Conscience movement */
	NSTimer *shakeTimer;				/**< limits Conscience shake response */
	NSTimer *thoughtChangeTimer;		/**< determines when Conscience thought disappears */
	
	CGFloat initialTapDistance;			/**< assists in gesture recognition */
    CGFloat animationDuration;          /**< duration variable for determining movement */
    
    int messageState;                   /**< which stage of intro is current */
    BOOL isImpatient;                   /**< has User decided to skip intro */
	    
}

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
Start timers for Conscience movement
 */
-(void)setTimers;
/**
Stop timers for Conscience movement
 */
-(void)stopTimers;
/**
In case of interruption, stop Intro and movement timers
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
