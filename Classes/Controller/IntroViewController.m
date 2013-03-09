/**
Implementation:  Present Conscience and basic User interaction elements to User in measured, controlled way.
Monitor will float around screen, talk to User, introduce UI elements and acclimate User to the design metaphors of 
the application.

@class IntroViewController IntroViewController.h
 */

#import "IntroViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ConscienceView.h"
#import "ConscienceAccessories.h"
#import "ConscienceBody.h"
#import "ConscienceMind.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewControllerLocalization.h"

@interface IntroViewController () <ViewControllerLocalization> {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;                  /**< serialized user settings/state retention */
    
	IBOutlet UILabel *conscienceStatus;			/**< Conscience's thought presented in bubble */
	IBOutlet UIImageView *thoughtBubbleView1;	/**< bubble surrounding Conscience's thought */
	IBOutlet UIImageView *backgroundImage;		/**< background image manipulation */
	IBOutlet UIImageView *navBarImage;			/**< image that will appear once interaction is done */
	IBOutlet UIImageView *teamAxeLogoImage;		/**< Team Axe Logo */
	IBOutlet UIImageView *moraLifeLogoImage;	/**< MoraLife Logo */
    IBOutlet UIImageView *nextButtonImage;      /**< image for Next arrow */
    IBOutlet UIImageView *downButtonImage;      /**< image for Down arrow */
	IBOutlet UIView *consciencePlayground;		/**< area in which custom ConscienceView can float */
	IBOutlet UIView *thoughtArea;				/**< area in which thought bubble appears */
	
	IBOutlet UIButton *thoughtButton;			/**< area in which thought bubble appears */
	IBOutlet UIButton *nextButton;              /**< area in which thought bubble appears */	
    
	NSTimer *shakeTimer;				/**< limits Conscience shake response */

	CGFloat initialTapDistance;			/**< assists in gesture recognition */
    CGFloat animationDuration;          /**< duration variable for determining movement */
    
    int messageState;                   /**< which stage of intro is current */
    BOOL isImpatient;                   /**< has User decided to skip intro */
    
}

@property (nonatomic, strong) NSTimer *thoughtChangeTimer;		/**< determines when Conscience thought disappears */

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

@implementation IntroViewController

#pragma mark -
#pragma mark ViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	prefs = [NSUserDefaults standardUserDefaults];
    
	//Setup the default Conscience
	appDelegate.userConscienceAccessories.primaryAccessory = MLPrimaryAccessoryFileNameResourceDefault;
	appDelegate.userConscienceAccessories.secondaryAccessory = MLSecondaryAccessoryFileNameResourceDefault;
	appDelegate.userConscienceAccessories.topAccessory = MLTopAccessoryFileNameResourceDefault;
	appDelegate.userConscienceAccessories.bottomAccessory = MLBottomAccessoryFileNameResourceDefault;
	appDelegate.userConscienceBody.symbolName = MLSymbolFileNameResourceDefault;    
    
	[self.view addSubview:appDelegate.userConscienceView];
    
	CGPoint centerPoint = CGPointMake(MLConscienceOffscreenBottomX, MLConscienceOffscreenBottomY);
	
	appDelegate.userConscienceView.center = centerPoint;
	[conscienceStatus setText:@"Hello there!  Welcome to..."];

	backgroundImage.alpha = 0;
	moraLifeLogoImage.alpha = 0;
    
	animationDuration = 1.0;
	messageState = 0;
	isImpatient = TRUE;

    self.thoughtChangeTimer = [NSTimer timerWithTimeInterval:0 invocation:nil repeats:NO];
    
    [self localizeUI];    

}

-(void) viewWillAppear:(BOOL)animated{
	    
	[super viewWillAppear:animated];

	teamAxeLogoImage.alpha = 0;

    //If device is capable of multitasking setup notifcations for backgrounding
	if ([appDelegate isCurrentIOS]) { 
		[[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(stopIntro) 
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];

		[[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(resumeIntro) 
                                                 name: UIApplicationWillEnterForegroundNotification
                                               object: nil];
	}

	[self resumeIntro];
    
}

-(void)viewWillDisappear:(BOOL)animated {

	//If multitasking OS is available, remove notifications
	if ([appDelegate isCurrentIOS]) { 
		[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];

		[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
	}

	//Save state of intro
    if (messageState >=0) {
        [self stopIntro];
    }
    
    if(self.thoughtChangeTimer != nil)
    {
        [self.thoughtChangeTimer invalidate];
        self.thoughtChangeTimer = nil;
    }
    
}

/**
 Implementation: In case introduction was interrupted, restart script from point last reached.
 */
-(void)resumeIntro {

    id placeholderID = nil;
    
	//Check for presences of previously interrupted intro
    NSObject *introCheck = [prefs objectForKey:@"introStateRestore"];
    int messageStateRestore = 0;
    
    if (introCheck != nil) {
        messageStateRestore = [prefs integerForKey:@"introStateRestore"];        
    }
    
    //If User was left at a particular stage in the intro, return them to that state
    if (messageStateRestore > 0) {
    
        [prefs removeObjectForKey:@"introStateRestore"];
        messageState = messageStateRestore;
        
        [UIView beginAnimations:@"resetState" context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:NO];
        
        backgroundImage.alpha = 1;
        appDelegate.userConscienceView.center = CGPointMake(MLConscienceIntroX, MLConscienceIntroY-40);
                
        [UIView commitAnimations];
        [appDelegate.userConscienceView setNeedsDisplay];
        
        [self switchNow:placeholderID];
        
    } else {

       //Restart introduction
        messageState = 0;
        thoughtArea.alpha = 0;
        
        CGPoint centerPoint = CGPointMake(MLConscienceLowerLeftXIntro, MLConscienceLowerLeftYIntro);

        appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(MLConscienceLargeSizeX, MLConscienceLargeSizeY);
        
        [UIView beginAnimations:@"BottomUpConscience" context:nil];
        [UIView setAnimationDuration:1.75];
        [UIView setAnimationBeginsFromCurrentState:NO];
        
        backgroundImage.alpha = 1;
        teamAxeLogoImage.alpha = 1;

        appDelegate.userConscienceView.center = centerPoint;
        
        [UIView commitAnimations];
        [appDelegate.userConscienceView setNeedsDisplay];
                
        self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(startIntro) userInfo:nil repeats:NO];
    }

	[prefs removeObjectForKey:@"introStateRestore"];
    
}

/**
 Implementation: In case introduction was interrupted, stop the script, so that User can continue where it left off.
 */
-(void)stopIntro {
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = nil;
        
    [prefs setInteger:messageState forKey:@"introStateRestore"];
    
}

#pragma mark -
#pragma mark Intro States

/**
 Implementation: Begin introduction.  Shrink Conscience, move to middle of screen, flash screen and dismiss TAO logo.
 */
-(void) startIntro{
    
    CGPoint centerPoint = CGPointMake(MLConscienceIntroX, MLConscienceIntroY);

	//Move Monitor onscreen, resize to simulate moving into background
    [UIView beginAnimations:@"CenterConscience" context:nil];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    appDelegate.userConscienceView.center = centerPoint;
    
    thoughtArea.alpha = 1;
    teamAxeLogoImage.alpha = 0;
    appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(MLConscienceSizeDefault, MLConscienceSizeDefault);
	
	[UIView commitAnimations];
    [appDelegate.userConscienceView setNeedsDisplay];
    messageState = 0;
    
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(switchText) userInfo:nil repeats:NO];
    
}

/**
  Implementation: Multiple private methods utilized for scripting due to flexibility needed in animation Monitor/text.
*/
-(void) switchText{

    
	[UIView beginAnimations:@"labelFade1" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];

    conscienceStatus.alpha = 0;
    moraLifeLogoImage.alpha = 1;
	
	[UIView commitAnimations];
    [appDelegate.userConscienceView setNeedsDisplay];
    
    messageState = 1;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(switchText0) userInfo:nil repeats:NO];
    
}

-(void) switchText0{

    [conscienceStatus setText:@"I am your Conscience.  I'll help you record the things you do throughout the day."];
    
	[UIView beginAnimations:@"labelFade2" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    moraLifeLogoImage.alpha = 0;
    conscienceStatus.alpha = 1;
    
	[UIView commitAnimations];
    
    messageState = 2;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(switchText1) userInfo:nil repeats:NO];
    
}

-(void) switchText1{
    
    nextButton.alpha = 0;
    nextButtonImage.alpha = 0;
    nextButton.hidden = FALSE;
    nextButtonImage.hidden = FALSE;
    
    [self animateStatusText];
    
    [conscienceStatus setText:@"You can skip this introduction by tapping on the right arrow bubble over there."];

	[UIView beginAnimations:@"labelFade2a" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    nextButton.alpha = 1;
    nextButtonImage.alpha = 1;
    
    moraLifeLogoImage.alpha = 0;
    conscienceStatus.alpha = 1;    
	[UIView commitAnimations];
    
    [self animateNextButton];
    
    messageState = 2;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(switchText2) userInfo:nil repeats:NO];
    
}

-(void) switchText2{
        
    [self animateStatusText];

    [conscienceStatus setText:@"But I get lonely, so you should stick around until the end.  You can tap my thought bubble to get me to hurry up, though."];

	[UIView beginAnimations:@"labelFade2b" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    moraLifeLogoImage.alpha = 0;
    conscienceStatus.alpha = 1;

    [UIView commitAnimations];

    messageState = 2;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(switchText3) userInfo:nil repeats:NO];
    
}

-(void) switchText3{
    
    [self animateStatusText];
    [conscienceStatus setText:@"Using MoraLife, you can journal your moral actions, and I'll usually respond to them."];
    
	[UIView beginAnimations:@"labelFade3" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    conscienceStatus.alpha = 1;
    
	[UIView commitAnimations];

    messageState = 3;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(switchText4) userInfo:nil repeats:NO];
    
}

-(void) switchText4{
    
    [self animateStatusText];
    [conscienceStatus setText:@"...like so.  *Hay-LOW!*"];
    
	[UIView beginAnimations:@"labelFade3" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    conscienceStatus.alpha = 1;
    
	[UIView commitAnimations];
    
    [UIView beginAnimations:@"conscienceFlip" context:nil];
    [UIView setAnimationDuration:0.25];
    

    [UIView setAnimationBeginsFromCurrentState:YES];
    appDelegate.userConscienceMind.mood = 80;
    appDelegate.userConscienceMind.enthusiasm = 80;

    appDelegate.userConscienceView.alpha = 0;
    
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(makeAngel)];
    
    [UIView commitAnimations];
    
	[appDelegate.userConscienceView setIsExpressionForced:TRUE];
	[appDelegate.userConscienceView setNeedsDisplay];
    
    messageState = 4; 
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(switchText5) userInfo:nil repeats:NO];
    
}

-(void) switchText5{
    
    [self animateStatusText];
    [conscienceStatus setText:@"You can record naughty actions as well and get the opposite results."];    
    
	[UIView beginAnimations:@"labelFade3" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    conscienceStatus.alpha = 1;
    
	[UIView commitAnimations];
   
    messageState = 5;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(switchText6) userInfo:nil repeats:NO];
    
}

-(void) switchText6{
    
    [self animateStatusText];
    [conscienceStatus setText:@"Check it out.  *Triah-DENT!*"];    
    
	[UIView beginAnimations:@"labelFade3" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    conscienceStatus.alpha = 1;
    
	[UIView commitAnimations];
    
    [UIView beginAnimations:@"conscienceFlip" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];

    appDelegate.userConscienceView.alpha = 0;
    
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(makeDevil)];
    
    [UIView commitAnimations];
    
    appDelegate.userConscienceMind.mood = 35;
    appDelegate.userConscienceMind.enthusiasm = 80;

	[appDelegate.userConscienceView setIsExpressionForced:TRUE];
	[appDelegate.userConscienceView setNeedsDisplay];
    
    messageState = 6;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(switchText7) userInfo:nil repeats:NO];
    
}

-(void) switchText7{
    
    [self animateStatusText];
    appDelegate.userConscienceMind.mood = 60;
    appDelegate.userConscienceMind.enthusiasm = 60;
    [conscienceStatus setText:@"You can think of me as your ethical accountant."];
    
    [UIView beginAnimations:@"conscienceFlip" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];

    appDelegate.userConscienceView.alpha = 0;
    
    conscienceStatus.alpha = 1;
    
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(makeNormal)];
    
    [UIView commitAnimations];
    
    [appDelegate.userConscienceView setNeedsDisplay];
    
    messageState = 7;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(switchText8) userInfo:nil repeats:NO];
    
}

-(void) switchText8{
    
    [self animateStatusText];
    [conscienceStatus setText:@"Now before we get started, I want to talk about how to use MoraLife."];
    
	[UIView beginAnimations:@"labelFade7" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    conscienceStatus.alpha = 1;
        
	[UIView commitAnimations];
    
    messageState = 8;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(switchText9) userInfo:nil repeats:NO];
    
}

-(void) switchText9{
    
    [self animateStatusText];
    [conscienceStatus setText:@"I'll communicate with you via these thought bubbles.  Tapping on me will present different options."];
        
	[UIView beginAnimations:@"labelFade8" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
        
    conscienceStatus.alpha = 1;
        
	[UIView commitAnimations];
    
    messageState = 9;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(switchText10) userInfo:nil repeats:NO];
    
}

-(void) switchText10{
    
    downButtonImage.alpha = 0;
    navBarImage.alpha = 0;
    downButtonImage.hidden = FALSE;
    navBarImage.hidden = FALSE;

    [self animateStatusText];
    [conscienceStatus setText:@"I'll bring up the rest of the User Interface now.  Check out that woodgrain."];
    
	[UIView beginAnimations:@"labelFade9" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    navBarImage.alpha = 1;
    conscienceStatus.alpha = 1;
        
	[UIView commitAnimations];
    
    messageState = 10;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(switchText11) userInfo:nil repeats:NO];
    
}

-(void) switchText11{
    
    downButtonImage.alpha = 0;
    downButtonImage.hidden = FALSE;    
    downButtonImage.center = CGPointMake(38, 52);
    
    [self animateStatusText];
    [conscienceStatus setText:@"This Navigation bar will allow you to access the other features in MoraLife."];
    
	[UIView beginAnimations:@"labelFade10" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];

    downButtonImage.transform = CGAffineTransformMakeRotation (M_PI);
    conscienceStatus.alpha = 1;
    downButtonImage.alpha = 1;
    
	[UIView commitAnimations];
    
    [self animateDownButton];
    
    messageState = 11;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(switchText12) userInfo:nil repeats:NO];
    
}

-(void) switchText12{
    
    [self animateStatusText];
    [conscienceStatus setText:@"Tapping on the Journal Button lets you enter in moral or immoral Choices."];
    
	[UIView beginAnimations:@"labelFade11" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    downButtonImage.transform = CGAffineTransformMakeRotation (-M_PI/2);

    downButtonImage.alpha = 1;
    downButtonImage.center = CGPointMake(140, 21);
    conscienceStatus.alpha = 1;
        
	[UIView commitAnimations];
    
    [self animateDownButton];

    
    messageState = 12;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(switchText13) userInfo:nil repeats:NO];
    
}

-(void) switchText13{
    
    [self animateStatusText];

    [conscienceStatus setText:@"Tap that Collection Button to review the things that you've bought or received in Morathology."];
    
	[UIView beginAnimations:@"labelFade12" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];

    downButtonImage.transform = CGAffineTransformMakeRotation (M_PI);
    downButtonImage.alpha = 1;
    downButtonImage.center = CGPointMake(283, 62);
    conscienceStatus.alpha = 1;
    
	[UIView commitAnimations];
    
    [self animateDownButton];
        
    messageState = 13;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(switchText14) userInfo:nil repeats:NO];
    
}

-(void) switchText14{

    [self animateStatusText];

    [conscienceStatus setText:@"Lastly, you can tap on my thought bubble to dismiss it."];
    
	[UIView beginAnimations:@"labelFade13" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    downButtonImage.alpha = 1;
    downButtonImage.transform = CGAffineTransformMakeRotation (0.5*M_PI);
    downButtonImage.center = CGPointMake(283, 135);
    conscienceStatus.alpha = 1;
    
	[UIView commitAnimations];
    
    [self animateDownButton];
    
    messageState = 14;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(switchText15) userInfo:nil repeats:NO];
    
}

-(void) switchText15{
    
    [self animateStatusText];
    
    [conscienceStatus setText:@"Most things in MoraLife will respond to touches.  So, go touch-crazy and tap on everything you see."];
    
	[UIView beginAnimations:@"labelFade14" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    downButtonImage.alpha = 0;
    conscienceStatus.alpha = 1;
        
	[UIView commitAnimations];

    messageState = 15;
    
    [self.thoughtChangeTimer invalidate];
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(switchText16) userInfo:nil repeats:NO];
    
}

-(void) switchText16{
    
    nextButton.alpha = 0;
    nextButtonImage.alpha = 0;
    nextButton.hidden = FALSE;
    nextButtonImage.hidden = FALSE;
    
    [self animateStatusText];
    [conscienceStatus setText:@"So, I'm done yapping at you, now.  Tap the right arrow to get started."];
    [thoughtButton setEnabled:FALSE];
    
    isImpatient = FALSE;
    
	[UIView beginAnimations:@"labelFade15" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    conscienceStatus.alpha = 1;
    downButtonImage.alpha = 0;
    nextButton.alpha = 1;
    nextButtonImage.alpha = 1;
    
    
	[UIView commitAnimations];
    
    [self animateNextButton];
    
    messageState = 16;
    
//    [self.thoughtChangeTimer invalidate];

    
}

/**
Implementation:  Accessorize Conscience with Angel accessories
 */
-(void) makeAngel{
    
    appDelegate.userConscienceAccessories.primaryAccessory = @"acc-pri-weapon-crook";
    appDelegate.userConscienceAccessories.secondaryAccessory = MLSecondaryAccessoryFileNameResourceDefault;
    appDelegate.userConscienceAccessories.topAccessory = @"acc-top-halo";
    appDelegate.userConscienceAccessories.bottomAccessory = @"acc-bottom-beard-longgray";
    
    [self revealConscience];

}

/**
Implementation:  Accessorize Conscience with Devil accessories
 */
-(void) makeDevil{
    
    appDelegate.userConscienceAccessories.primaryAccessory = @"acc-pri-weapon-trident";
    appDelegate.userConscienceAccessories.secondaryAccessory = @"acc-sec-tail-bifurcated";
    appDelegate.userConscienceAccessories.topAccessory = @"acc-top-horns";
    appDelegate.userConscienceAccessories.bottomAccessory = @"acc-bottom-beard-pointblack";
    
    
    [self revealConscience];
    
}

/**
Implementation:  Remove Conscience accessories
 */
-(void) makeNormal{
    
    appDelegate.userConscienceAccessories.primaryAccessory = @"acc-nothing";
    appDelegate.userConscienceAccessories.secondaryAccessory = @"acc-nothing";
    appDelegate.userConscienceAccessories.topAccessory = @"acc-nothing";
    appDelegate.userConscienceAccessories.bottomAccessory = @"acc-nothing";
    
    
    [self revealConscience];
    
}

/**
Implementation:  Return conscience to view
 */
-(void) revealConscience{

    
    [UIView beginAnimations:@"conscienceRestore" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    appDelegate.userConscienceView.alpha = 1;
    [appDelegate.userConscienceView setNeedsDisplay];

    [UIView commitAnimations];
    
}

#pragma mark -
#pragma mark UI configuration/interaction

/**
 Implementation:  User can advance Intro state by selecting Conscience Thought bubbble.  Determine current Intro state by inspecting ivar, switch to appropriate state
 */
-(IBAction)switchNow:(id)sender {
    
    //setup id for passing to IB capable method
    id placeholderID = nil;
    
    //Determine current state of Intro, then advance to next state
    if (messageState >= 0) {
        switch (messageState) {
            case 0:[self switchText1];moraLifeLogoImage.alpha = 0;break;            
            case 1:[self switchText2];break;
            case 2:[self switchText3];break;
            case 3:[self switchText4];break;
            case 4:[self switchText5];break;
            case 5:[self switchText6];break;            
            case 6:[self switchText7];break;            
            case 7:[self switchText8];break;            
            case 8:[self switchText9];break;            
            case 9:[self switchText10];break;            
            case 10:[self switchText11];break;            
            case 11:[self switchText12];break;            
            case 12:[self switchText13];break;            
            case 13:[self switchText14];break;            
            case 14:[self switchText15];break;            
            case 15:[self switchText16];break;            
            case 16:[self switchLast:placeholderID];break;           
            default:
                break;
        }
        
        if ((nextButton.hidden == TRUE) || (nextButton.alpha == 0)) {

            nextButton.hidden = FALSE;
            nextButtonImage.hidden = FALSE;
            
            [UIView beginAnimations:@"labelFade2a" context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:NO];
            
            nextButton.alpha = 1;
            nextButtonImage.alpha = 1;
            
            [UIView commitAnimations];
            
            [self animateNextButton];        
        
        }
    }
    
}

/**
 Implementation:  Determine if User has skipped any of the intro, return the Conscience to the normal state, delay dismissal of 
 ViewController
 */
-(IBAction)switchLast:(id)sender {
    
    //Conscience could be Angel or Devil if User skipped
    //Ensure that normal conscience is reset
    [UIView beginAnimations:@"conscienceFlip" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    appDelegate.userConscienceView.alpha = 0;
    
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(makeNormal)];
    
    [UIView commitAnimations];
    
    //Set NSUserDefaults indicating intro has been completed.
    [prefs setBool:TRUE forKey:@"introComplete"];
    [prefs removeObjectForKey:@"introStateRestore"];
    
    [prefs synchronize];

    [self animateStatusText];

    //Display appropriate text if User has watched entire Intro
    if (isImpatient) {
        [conscienceStatus setText:@"Okay, so I can tell that you're ready to go.  Let's skip the intro and get to the good stuff."];
    } else {
        [conscienceStatus setText:@"Awesome.  You're like the best User ever for not skipping the intro.  Let's rock this."];
        
    }

	[UIView beginAnimations:@"labelFadeLast" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];

	conscienceStatus.alpha = 1;
   
	nextButton.alpha = 0;
	nextButtonImage.alpha = 0;
	downButtonImage.alpha = 0;
    
	[UIView commitAnimations];
    
    appDelegate.userConscienceMind.mood = 60;
    appDelegate.userConscienceMind.enthusiasm = 60;

    messageState = -1;
    if (self.thoughtChangeTimer) {
        [self.thoughtChangeTimer invalidate];
    }
    self.thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(dismissIntroModal) userInfo:nil repeats:NO];
    
}

/**
Implementation:  Animate the fading button to get User to see that they should either dismiss the view or continue to more help pages.
 */
-(void)animateDownButton{
    
    downButtonImage.alpha = 0;
    
    [UIView beginAnimations:@"AnimateDown" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationRepeatCount:10];
    [UIView setAnimationRepeatAutoreverses:TRUE];        
    
    downButtonImage.alpha = 0.5;
    
    [UIView commitAnimations];
}

/**
Implementation:  Animate the fading button to get User to see that they should either dismiss the view or continue to more help pages.
 */
-(void)animateNextButton{
    
    [UIView beginAnimations:@"AnimateNext" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationRepeatCount:5];
    [UIView setAnimationRepeatAutoreverses:TRUE];        
    
    nextButtonImage.alpha = 0.5;
    
    [UIView commitAnimations];
}

/**
 Implementation:  Animate the fading button to get User to see that they should either dismiss the view or continue to more help pages.
 */
-(void)animateStatusText{
    
    [UIView beginAnimations:@"AnimateStatus" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    conscienceStatus.alpha = 0;
    
    [UIView commitAnimations];
}

/**
Implementation:  Stop any timers, animate Conscience and Thought fades, delay dismissal of View Controller until animation has finished.
 */
-(void)dismissIntroModal{

	//Fade view controller from view
	[UIView beginAnimations:@"HideBubble" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	thoughtArea.alpha = 0;
    appDelegate.userConscienceView.alpha = 0;
    
	[UIView commitAnimations];

	//Delay actual dismissal in order to show Conscience and fade animations
	SEL selector = @selector(dismissModalViewControllerAnimated:);
	
	NSMethodSignature *signature = [UIViewController instanceMethodSignatureForSelector:selector];
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
	[invocation setSelector:selector];
	
	BOOL timerBool = NO;
	
	//Set the arguments
	[invocation setTarget:self];
	[invocation setArgument:&timerBool atIndex:2];
	
	[NSTimer scheduledTimerWithTimeInterval:0.5 invocation:invocation repeats:NO];
	
}

/**
  Implementation: firstResponder necessary for implementation of shake gesture recognizer
*/
-(BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark -
#pragma mark Touch Callbacks

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	SEL shakeSelector = @selector(changeEyeDirection);
	SEL shakeEndSelector = @selector(shakeEnd);
	
	// create a singature from the selectors, google the eyes and shake the physical Monitor
	NSMethodSignature *shakeSignature = [[ConscienceView class] instanceMethodSignatureForSelector:shakeSelector];
	NSMethodSignature *shakeEndSignature = [[self class] instanceMethodSignatureForSelector:shakeEndSelector];
	
	NSInvocation *shakeInvocation = [NSInvocation invocationWithMethodSignature:shakeSignature];
	NSInvocation *shakeEndInvocation = [NSInvocation invocationWithMethodSignature:shakeEndSignature];
	
	[shakeInvocation setTarget:appDelegate.userConscienceView];
	[shakeInvocation setSelector:shakeSelector];
	[shakeEndInvocation setTarget:self];
	[shakeEndInvocation setSelector:shakeEndSelector];	

	//Detect if a User has shaken the device  
    if (motion == UIEventSubtypeMotionShake)
    {
		//Stop the conscience from moving
		if(shakeTimer != nil){
			
			[shakeTimer invalidate];
			shakeTimer = nil;
		}else {
			shakeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 invocation:shakeInvocation repeats:YES];
			[NSTimer scheduledTimerWithTimeInterval:1.5 invocation:shakeEndInvocation repeats:NO];
            
		}
		
		[appDelegate.userConscienceView.layer addAnimation:(CAAnimation *)[appDelegate.userConscienceView shakeAnimation] forKey:@"position"];
        
    }
}

/**
  Implementation: Terminate the shake animation NSTimer
*/
- (void) shakeEnd
{
    if(shakeTimer != nil){

        [shakeTimer invalidate];
        shakeTimer = nil;
    }
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet *allTouches = [event allTouches];
    
	switch ([allTouches count]) {
		case 1: { //Single touch
			
			//Get the first touch.
			UITouch *touch = [allTouches allObjects][0];
    
			CGPoint conscienceCenter = [touch locationInView:self.view];
			UIView* touchedView = [self.view hitTest:conscienceCenter withEvent:event];
			
			//Shrink the Conscience to emulate that User is pushing Conscience
			//into background.  Only animate this if User is actually touching Conscience.
			
			if (touchedView.tag==MLConscienceViewTag) {
				                
				//Depress Conscience slightly to simulate actual contact
				[UIView beginAnimations:@"ResizeConscienceSmall" context:nil];
				[UIView setAnimationDuration:0.2];
				[UIView setAnimationBeginsFromCurrentState:YES];
				appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
				[appDelegate.userConscienceView.conscienceBubbleView setNeedsDisplay];	
				[UIView commitAnimations];
								
			}			
			
		} break;
		default:break;
	}
	
	
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    //	[self clearTouches];
    
    initialTapDistance = -1;
    	
	//Return the Conscience to regular size in event of touched or zoomed
	[UIView beginAnimations:@"ResizeConscienceBig" context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
	[appDelegate.userConscienceView.conscienceBubbleView setNeedsDisplay];
	[UIView commitAnimations];
    
	
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
    
	[self touchesEnded:touches withEvent:event];
    
    
}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    
    nextButton.accessibilityHint = NSLocalizedString(@"NextButtonHint",nil);
	nextButton.accessibilityLabel =  NSLocalizedString(@"NextButtonLabel",nil);
    thoughtButton.accessibilityHint = NSLocalizedString(@"IntroThoughtButtonHint",nil);
	thoughtButton.accessibilityLabel =  NSLocalizedString(@"IntroThoughtButtonLabel",nil);

    
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
