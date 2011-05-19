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
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
    
	IBOutlet UILabel *conscienceStatus;			/**< Conscience's thought presented in bubble */
	IBOutlet UIImageView *thoughtBubbleView1;		/**< bubble surrounding Conscience's thought */
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
	IBOutlet UIButton *nextButton;			/**< area in which thought bubble appears */	
    
	NSTimer *moveTimer;				/**< controls Conscience movement */
	NSTimer *shakeTimer;				/**< limits Conscience shake response */
	NSTimer *holdTapTimer;				/**< determines if long press was initiated */
	NSTimer *thoughtChangeTimer;			/**< determines when Conscience thought disappears */
	
	CGFloat initialTapDistance;				/**< assists in gesture recognition */
    CGFloat animationDuration;
    
    int messageState;
    BOOL isImpatient;
	BOOL isBackgroundOK;				/**< determine if iOS3 is present */
	    
}

/**
Accepts User input to change the presently displayed UIView and possibly commit Choice
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)switchLast:(id)sender;
-(IBAction)switchNow:(id)sender;
-(void)resumeIntro;
-(void)dismissThoughtModal;
-(void)revealConscience;
-(void)setTimers;
-(void)stopTimers;
-(void)stopIntro;
-(void)animateDownButton;
-(void)animateNextButton;
-(void)makeAngel;
-(void)makeDevil;
-(void)makeNormal;
@end
