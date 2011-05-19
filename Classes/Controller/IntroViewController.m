/**
Implementation:  Present Conscience and basic User interaction elements to User in measured, controlled way.

@class IntroViewController IntroViewController.h
 */

#import "IntroViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ConscienceView.h"
#import "ConscienceAccessories.h"
#import "ConscienceBody.h"
#import "ConscienceMind.h"
#import <QuartzCore/QuartzCore.h>

@implementation IntroViewController

static int numberOfShakes = 8;
static float durationOfShake = 0.5f;
static float vigourOfShake = 0.05f;

#pragma mark -
#pragma mark ViewController lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	isBackgroundOK = (&UIApplicationDidEnterBackgroundNotification != NULL); 
	
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	prefs = [NSUserDefaults standardUserDefaults];
    
	appDelegate.userConscienceAccessories.primaryAccessory = @"acc-nothing";
	appDelegate.userConscienceAccessories.secondaryAccessory = @"acc-nothing";
	appDelegate.userConscienceAccessories.topAccessory = @"acc-nothing";
	appDelegate.userConscienceAccessories.bottomAccessory = @"acc-nothing";
	appDelegate.userConscienceBody.symbolName = @"con-nothing";    
    
	[consciencePlayground addSubview:appDelegate.userConscienceView];
    
	CGPoint centerPoint = CGPointMake(kConscienceOffscreenBottomX, kConscienceOffscreenBottomY);
	
	appDelegate.userConscienceView.center = centerPoint;
	[conscienceStatus setText:@"Hello!  Welcome to..."];
    
	backgroundImage.alpha = 0;
	moraLifeLogoImage.alpha = 0;
    
	animationDuration = 1.0;
	messageState = 0;
	isImpatient = FALSE;
}

-(void) viewWillAppear:(BOOL)animated{
	    
	[super viewWillAppear:animated];

	teamAxeLogoImage.alpha = 0;

	if (isBackgroundOK) { 
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

	if (isBackgroundOK) { 
		[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];

		[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
	}
    
    if (messageState >=0) {
        [self stopIntro];
    }
    
}

-(void)resumeIntro {


    id placeholderID = nil;
    
    NSObject *introCheck = [prefs objectForKey:@"introStateRestore"];
    int messageStateRestore = 0;
    
    if (introCheck != nil) {
        messageStateRestore = [prefs integerForKey:@"introStateRestore"];        
        NSLog(@"interruptedintroreturn:%d", messageStateRestore);

    }
    
    
    if (messageStateRestore > 0) {
    
        NSLog(@"resume intro res:%d, message:%d", messageStateRestore, messageState);

        [prefs removeObjectForKey:@"introStateRestore"];
        messageState = messageStateRestore;
        
        [UIView beginAnimations:@"resetState" context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:NO];
        
        backgroundImage.alpha = 1;
                
        [UIView commitAnimations];
        [appDelegate.userConscienceView setNeedsDisplay];
        
        [self setTimers];
        [self switchNow:placeholderID];
        
    } else {
    
        messageState = 0;
        thoughtArea.alpha = 0;
        
        CGPoint centerPoint = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY-120);

        appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(kConscienceLargeSizeX, kConscienceLargeSizeY);
        
        [UIView beginAnimations:@"BottomUpConscience" context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationBeginsFromCurrentState:NO];
        
        backgroundImage.alpha = 1;
        teamAxeLogoImage.alpha = 1;

        appDelegate.userConscienceView.center = centerPoint;
        
        [UIView commitAnimations];
        [appDelegate.userConscienceView setNeedsDisplay];
                
        thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(startIntro) userInfo:nil repeats:NO];
    }

	[prefs removeObjectForKey:@"introStateRestore"];
    
}


-(void)stopIntro {
    NSLog(@"stop intro");
    [self stopTimers];
    
    //Stop the conscience from moving
    if(thoughtChangeTimer != nil && thoughtChangeTimer != NULL){
    		
    		[thoughtChangeTimer invalidate];
    		thoughtChangeTimer = nil;
    }
    
    [prefs setInteger:messageState forKey:@"introStateRestore"];
    NSLog(@"viewwilldisappear:%d", [prefs integerForKey:@"introStateRestore"]);
    
}

#pragma mark -
#pragma mark UI Interaction

-(void) timedMovement {
	BOOL switchOrientationBool = FALSE;
	
	//Create illusion that the conscience is randomly floating around screen
	CGPoint pos = CGPointMake(20,150);
	
	CGPoint posCenter = CGPointMake(consciencePlayground.center.x, consciencePlayground.center.y);
	CGPoint conCenter = CGPointMake(appDelegate.userConscienceView.center.x, appDelegate.userConscienceView.center.y);
	pos.x = (10 + arc4random() % 5);
	pos.y = (20 + arc4random() % 7);
    
	if (arc4random() % 2 < 1) {
		posCenter.x += pos.x;
	}else {
		posCenter.x -= pos.x;
	}
    
	if (arc4random() % 2 < 1) {
		posCenter.y += pos.y;
	}else {
		posCenter.y -= pos.y;
	}

	//Ensure that Conscience stays within bounds of area designated
	if(posCenter.x > 110 || posCenter.x < 70)
		posCenter.x = 90 + arc4random() % 20;
	if(posCenter.y > 230 || posCenter.y < 160)
		posCenter.y = 150 + arc4random() % 50;
	
	//Determine if Conscience change direction it is facing
	if(conCenter.x > 110){
		
		if (appDelegate.userConscienceView.directionFacing == kDirectionFacingRight) {
			switchOrientationBool = TRUE;
		}
		
	}
    
    if (appDelegate.userConscienceView.directionFacing == kDirectionFacingLeft) {
		switchOrientationBool = TRUE;
	}
    
    //Animate the change of facing direction
	if (switchOrientationBool) {
        
		[UIView beginAnimations:@"conscienceFlip" context:nil];
		[UIView setAnimationDuration:0.25];
		
		[UIView setAnimationBeginsFromCurrentState:YES];
		appDelegate.userConscienceView.alpha = 0;
		[UIView setAnimationDelegate:appDelegate.userConscienceView]; // self is a view controller
		[UIView setAnimationDidStopSelector:@selector(removeConscienceInvisibility)];
        
		[UIView commitAnimations];
        
	}
    
    //Conscience Float speed determined by enthusiasm
    float movementRandom = (1.0/((arc4random() % 7) + 1));  
    
    if ((arc4random() % 3 > 0) || switchOrientationBool) {
        
        //Animate the change of Conscience location
        [UIView beginAnimations:@"MoveConscience" context:nil];
        [UIView setAnimationDuration:(2+movementRandom)];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        
        appDelegate.userConscienceView.center = posCenter;
        
        [UIView commitAnimations];
        
    }
    
}

-(void) startIntro{
    
    CGPoint centerPoint = CGPointMake(kConscienceHomeX, kConscienceHomeY-40);
    
    [UIView beginAnimations:@"CenterConscience" context:nil];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    appDelegate.userConscienceView.center = centerPoint;
    
    thoughtArea.alpha = 1;
    teamAxeLogoImage.alpha = 0;
    appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(kConscienceSize, kConscienceSize);
	
	[UIView commitAnimations];
    [appDelegate.userConscienceView setNeedsDisplay];
    messageState = 0;
    
    [self setTimers];
    
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(switchText1) userInfo:nil repeats:NO];
    
}

-(void) switchText1{

    
	[UIView beginAnimations:@"labelFade1" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];

    conscienceStatus.alpha = 0;
    moraLifeLogoImage.alpha = 1;
	
	[UIView commitAnimations];
    [appDelegate.userConscienceView setNeedsDisplay];
    
    messageState = 1;
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(switchText2) userInfo:nil repeats:NO];
    
}

-(void) switchText2{
    
	[UIView beginAnimations:@"labelFade2" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    moraLifeLogoImage.alpha = 0;
    conscienceStatus.alpha = 1;
    [conscienceStatus setText:@"I am your Conscience.  I'll help you record the things you do throughout the day."];
    
	[UIView commitAnimations];
    
    messageState = 2;
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(switchText3) userInfo:nil repeats:NO];
    
}

-(void) switchText3{
    
	[UIView beginAnimations:@"labelFade3" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    conscienceStatus.alpha = 1;
    [conscienceStatus setText:@"Using MoraLife, you can journal your moral actions, and I'll usually respond to them."];
    
	[UIView commitAnimations];

    messageState = 3;    
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(switchText4) userInfo:nil repeats:NO];
    
}

-(void) switchText4{
    
	[UIView beginAnimations:@"labelFade3" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    conscienceStatus.alpha = 1;
    [conscienceStatus setText:@"...like so.  *Hay-LOW!*"];
    
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
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(switchText5) userInfo:nil repeats:NO];
    
}

-(void) switchText5{
    
	[UIView beginAnimations:@"labelFade3" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    conscienceStatus.alpha = 1;
    [conscienceStatus setText:@"You can record naughty actions as well and get the opposite results."];
    
	[UIView commitAnimations];
   
    messageState = 5;    
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(switchText6) userInfo:nil repeats:NO];
    
}

-(void) switchText6{
    
	[UIView beginAnimations:@"labelFade3" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    conscienceStatus.alpha = 1;
    [conscienceStatus setText:@"Check it out.  *Triah-DENT!*"];
    
	[UIView commitAnimations];
    
    [UIView beginAnimations:@"conscienceFlip" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];

    appDelegate.userConscienceMind.mood = 40;
    appDelegate.userConscienceMind.enthusiasm = 80;

    appDelegate.userConscienceView.alpha = 0;
    
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(makeDevil)];
    
    [UIView commitAnimations];

	[appDelegate.userConscienceView setIsExpressionForced:TRUE];
	[appDelegate.userConscienceView setNeedsDisplay];
    
    messageState = 6;
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(switchText7) userInfo:nil repeats:NO];
    
}

-(void) switchText7{
    
    [UIView beginAnimations:@"conscienceFlip" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    appDelegate.userConscienceMind.mood = 60;
    appDelegate.userConscienceMind.enthusiasm = 60;

    appDelegate.userConscienceView.alpha = 0;
    
    [conscienceStatus setText:@"You can think of me as your ethical accountant."];

    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(makeNormal)];
    
    [UIView commitAnimations];
    
    [appDelegate.userConscienceView setNeedsDisplay];
    
    messageState = 7;
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(switchText8) userInfo:nil repeats:NO];
    
}

-(void) switchText8{
    
	[UIView beginAnimations:@"labelFade7" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    [conscienceStatus setText:@"Now before we get started, I want to talk about how to use MoraLife."];
    
	[UIView commitAnimations];
    
    messageState = 8;
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(switchText9) userInfo:nil repeats:NO];
    
}

-(void) switchText9{
        
	[UIView beginAnimations:@"labelFade8" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
        
    [conscienceStatus setText:@"I'll communicate with you via these thought bubbles.  Tapping on me will present different options."];
    
	[UIView commitAnimations];
    
    messageState = 9;
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(switchText10) userInfo:nil repeats:NO];
    
}

-(void) switchText10{
    
    downButtonImage.alpha = 0;
    tabBarImage.alpha = 0;
    navBarImage.alpha = 0;
    downButtonImage.hidden = FALSE;
    tabBarImage.hidden = FALSE;
    navBarImage.hidden = FALSE;

    
	[UIView beginAnimations:@"labelFade9" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    tabBarImage.alpha = 1;
    navBarImage.alpha = 1;
    
    [conscienceStatus setText:@"I'll bring up the rest of the User Interface now.  Check out that woodgrain."];
    
	[UIView commitAnimations];
    
    messageState = 10;
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(switchText11) userInfo:nil repeats:NO];
    
}

-(void) switchText11{
    
    downButtonImage.alpha = 0;
    downButtonImage.hidden = FALSE;    
    downButtonImage.center = CGPointMake(48, 362);
    
	[UIView beginAnimations:@"labelFade10" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    downButtonImage.alpha = 1;
    
    [conscienceStatus setText:@"You can tap on the Home Tab Bar icon to return to this screen anytime."];
    
	[UIView commitAnimations];
    
    [self animateDownButton];
    
    messageState = 11;
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(switchText12) userInfo:nil repeats:NO];
    
}

-(void) switchText12{
            
	[UIView beginAnimations:@"labelFade11" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    downButtonImage.alpha = 1;
    downButtonImage.center = CGPointMake(166, downButtonImage.center.y);
    
    
    [tabBarImage setImage:[UIImage imageNamed:@"interface-tabbaricons2.jpg"]];
    [conscienceStatus setText:@"Tapping on the Journal Tab Bar icon lets you enter in moral or immoral Choices."];
    
	[UIView commitAnimations];
    
    [self animateDownButton];

    
    messageState = 12;
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(switchText13) userInfo:nil repeats:NO];
    
}

-(void) switchText13{
        
	[UIView beginAnimations:@"labelFade12" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    downButtonImage.alpha = 1;
    downButtonImage.center = CGPointMake(263, downButtonImage.center.y);

    [tabBarImage setImage:[UIImage imageNamed:@"interface-tabbaricons3.jpg"]];
    [conscienceStatus setText:@"Tap that Collection Tab Bar icon to review the loot that you've bought or won in Morathology."];
    
	[UIView commitAnimations];
    
    [self animateDownButton];
        
    messageState = 13;
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(switchText14) userInfo:nil repeats:NO];
    
}

-(void) switchText14{
    
	[UIView beginAnimations:@"labelFade13" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    downButtonImage.alpha = 1;
    downButtonImage.transform = CGAffineTransformMakeRotation (3.14);
    downButtonImage.center = CGPointMake(243, downButtonImage.center.y-125);

    [tabBarImage setImage:[UIImage imageNamed:@"interface-tabbaricons.jpg"]];
    [conscienceStatus setText:@"Lastly, you can tap on my thought bubble to access the Greenroom, Morathology and Reports."];
    
	[UIView commitAnimations];
    
    [self animateDownButton];
    
    messageState = 14;
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(switchText15) userInfo:nil repeats:NO];
    
}

-(void) switchText15{
    
	[UIView beginAnimations:@"labelFade14" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    downButtonImage.alpha = 0;
    
    [conscienceStatus setText:@"Most things in MoraLife will respond to touches.  So, go touch-crazy and tap on everything you see."];
    
	[UIView commitAnimations];
	downButtonImage.transform = CGAffineTransformMakeRotation (-3.14);

    messageState = 15;
    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(switchText16) userInfo:nil repeats:NO];
    
}

-(void) switchText16{
    
    nextButton.alpha = 0;
    nextButtonImage.alpha = 0;
    nextButton.hidden = FALSE;
    nextButtonImage.hidden = FALSE;
    
    [thoughtButton setEnabled:FALSE];
    
	[UIView beginAnimations:@"labelFade15" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    downButtonImage.alpha = 0;
    nextButton.alpha = 1;
    nextButtonImage.alpha = 1;
    
    [conscienceStatus setText:@"Whenever you see this little arrow, that means that you have control over advancing to the next screen.  Tap it and see."];
    
	[UIView commitAnimations];
    
    [self animateNextButton];
    
    messageState = 16;
    
}

-(IBAction)switchNow:(id)sender {
        
    id placeholderID = nil;
    isImpatient = TRUE;
    
    if(thoughtChangeTimer != nil){
        
        [thoughtChangeTimer invalidate];
        thoughtChangeTimer = nil;
    }

    if (messageState >= 0) {
        switch (messageState) {
            case 0:[self switchText1];break;            
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
	}
        
}

-(IBAction)switchLast:(id)sender {

    [UIView beginAnimations:@"conscienceFlip" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    appDelegate.userConscienceView.alpha = 0;
    
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(makeNormal)];
    
    [UIView commitAnimations];
    
	[UIView beginAnimations:@"labelFadeLast" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    nextButton.alpha = 0;
    nextButtonImage.alpha = 0;
    
    if (isImpatient) {
        [conscienceStatus setText:@"Okay, so I can tell that you're ready to go.  Let's skip the intro and get to the good stuff."];
    } else {
        [conscienceStatus setText:@"Awesome.  You're like the best User ever for not skipping this.  Let's rock this."];

    }
    
	[UIView commitAnimations];
    
    [prefs setBool:FALSE forKey:@"firstLaunch"];
    messageState = -1;

	[self stopTimers];

    thoughtChangeTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(dismissThoughtModal) userInfo:nil repeats:NO];
    
}

/**
 Implementation:  Animate the fading button to get User to see that they should either dismiss the view or continue to more help pages.
 */
-(void)animateDownButton{
    
    downButtonImage.alpha = 0;
    
    [UIView beginAnimations:@"AnimateDown" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationRepeatCount:15];
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

-(void) zoomConscienceIn{
        
	[UIView beginAnimations:@"ZoomIn" context:nil];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(kConscienceLargestSize, kConscienceLargestSize);
	
	[UIView commitAnimations];
    [appDelegate.userConscienceView setNeedsDisplay];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(zoomConscienceOut) userInfo:nil repeats:NO];
    
}

-(void) zoomConscienceOut{
    
	[UIView beginAnimations:@"ZoomOut" context:nil];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
    thoughtArea.alpha = 1;
    appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(kConscienceSize, kConscienceSize);
	
	[UIView commitAnimations];
    [appDelegate.userConscienceView setNeedsDisplay];
    
    
}

-(void) makeAngel{
    
    appDelegate.userConscienceAccessories.primaryAccessory = @"acc-pri-weapon-crook";
    appDelegate.userConscienceAccessories.secondaryAccessory = @"acc-nothing";
    appDelegate.userConscienceAccessories.topAccessory = @"acc-top-halo";
    appDelegate.userConscienceAccessories.bottomAccessory = @"acc-bottom-beard-longgray";
    
    [self revealConscience];

}

-(void) makeDevil{
    
    appDelegate.userConscienceAccessories.primaryAccessory = @"acc-pri-weapon-trident";
    appDelegate.userConscienceAccessories.secondaryAccessory = @"acc-sec-tail-bifurcated";
    appDelegate.userConscienceAccessories.topAccessory = @"acc-top-horns";
    appDelegate.userConscienceAccessories.bottomAccessory = @"acc-bottom-beard-pointblack";
    
    
    [self revealConscience];
    
}

-(void) makeNormal{
    
    appDelegate.userConscienceAccessories.primaryAccessory = @"acc-nothing";
    appDelegate.userConscienceAccessories.secondaryAccessory = @"acc-nothing";
    appDelegate.userConscienceAccessories.topAccessory = @"acc-nothing";
    appDelegate.userConscienceAccessories.bottomAccessory = @"acc-nothing";
    
    
    [self revealConscience];
    
}

-(void) revealConscience{

    
    [UIView beginAnimations:@"conscienceRestore" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    appDelegate.userConscienceView.alpha = 1;
    [appDelegate.userConscienceView setNeedsDisplay];

    [UIView commitAnimations];
    
}


-(void)dismissThoughtModal{

	[self stopTimers];

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
 Implementation:  Set the movement timer.  If UserConscience is asleep, it shouldn't move
 */
- (void) setTimers{
	        
    //Restart Conscience movement after User has moved it
    if(![moveTimer isValid]){
        moveTimer = [NSTimer scheduledTimerWithTimeInterval:kMovementInterval target:self selector:@selector(timedMovement) userInfo:nil repeats:YES];
    }
    
}

/**
 Implementation:  Stop the movement timer whenever UserConscience moves out of Home screen (since movement is not allowed)
 */
- (void) stopTimers{

	//Stop the conscience from moving
	if(moveTimer != nil && moveTimer != NULL){
		
		[moveTimer invalidate];
		moveTimer = nil;
	}
	
}

#pragma mark -
#pragma mark Movement Callbacks

-(CAKeyframeAnimation *) shakeAnimation:(CGRect)frame{
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];
	
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, CGRectGetMinX(frame), CGRectGetMinY(frame));
	int index;
	for (index = 0; index < numberOfShakes; ++index)
	{
		
		CGPathAddLineToPoint(shakePath, NULL, CGRectGetMidX(frame) - frame.size.width * vigourOfShake, CGRectGetMidY(frame) - frame.size.height * vigourOfShake);
		CGPathAddLineToPoint(shakePath, NULL, CGRectGetMidX(frame) + frame.size.width * vigourOfShake, CGRectGetMidY(frame) + frame.size.height * vigourOfShake);
		
	}
    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = durationOfShake;
    return shakeAnimation;
}


//Implement Shaking response
-(BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark -
#pragma mark Touch Callbacks

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	SEL shakeSelector = @selector(changeEyeDirection);
	SEL shakeEndSelector = @selector(shakeEnd);
	
	// create a singature from the selector
	NSMethodSignature *shakeSignature = [[ConscienceView class] instanceMethodSignatureForSelector:shakeSelector];
	NSMethodSignature *shakeEndSignature = [[self class] instanceMethodSignatureForSelector:shakeEndSelector];
	
	NSInvocation *shakeInvocation = [NSInvocation invocationWithMethodSignature:shakeSignature];
	NSInvocation *shakeEndInvocation = [NSInvocation invocationWithMethodSignature:shakeEndSignature];
	
	[shakeInvocation setTarget:appDelegate.userConscienceView];
	[shakeInvocation setSelector:shakeSelector];
	[shakeEndInvocation setTarget:self];
	[shakeEndInvocation setSelector:shakeEndSelector];	
    
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
		
		[appDelegate.userConscienceView.layer addAnimation:(CAAnimation *)[self shakeAnimation:[appDelegate.userConscienceView frame]] forKey:@"position"];
        
    }
}

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
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			
			[self stopTimers];
			
			CGPoint conscienceCenter = [touch locationInView:self.view];
			UIView* touchedView = [self.view hitTest:conscienceCenter withEvent:event];
			
			//Shrink the Conscience to emulate that User is pushing Conscience
			//into background.  Only animate this if User is actually touching Conscience.
			
			if (touchedView.tag==kConscienceViewTag) {
				                
				//Depress Conscience slightly to simulate actual contact
				[UIView beginAnimations:@"ResizeConscienceSmall" context:nil];
				[UIView setAnimationDuration:0.2];
				[UIView setAnimationBeginsFromCurrentState:YES];
				appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
				[appDelegate.userConscienceView.conscienceBubbleView setNeedsDisplay];	
				[UIView commitAnimations];
				
				[UIView beginAnimations:@"MoveConscience" context:nil];
				[UIView setAnimationDuration:animationDuration];
				[UIView setAnimationBeginsFromCurrentState:YES];
				conscienceCenter.x = conscienceCenter.x-20;
				conscienceCenter.y = conscienceCenter.y-100;
				
				if (conscienceCenter.y < 60) {
					conscienceCenter.y = 60;
				}
				
				appDelegate.userConscienceView.center = conscienceCenter;
                
				[UIView commitAnimations];
				
			}			
			
			switch ([touch tapCount])
			{
				case 1: //Single Tap.
				{
					//Start a timer for 2 seconds.
					holdTapTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self 
																  selector:@selector(refreshConscience) userInfo:nil repeats:NO];
				} break;
				case 2: /** @todo implement Conscience doubletap */;break;
                    
			}
		} break;
		default:break;
	}
	
	
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    //	[self clearTouches];
    
    initialTapDistance = -1;
    
	//Stop the doubletap counter from moving
	if(holdTapTimer != nil){
		
		[holdTapTimer invalidate];
		holdTapTimer = nil;
	}
	
	[self setTimers];
	
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

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
        
	//Stop the doubletap counter from moving
	if(holdTapTimer != nil){
		
		[holdTapTimer invalidate];
		holdTapTimer = nil;
	}	
	
	animationDuration = 0.1;
	
	if([touches count] < 2){
		[self touchesBegan:touches withEvent:event];
	}
	
	animationDuration = 1;
	
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


- (void)dealloc {
    [super dealloc];
    
}


@end
