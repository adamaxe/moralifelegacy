/**
Implementation:  UIViewController can present many versions of itself without having to render entirely new UIViewControllers.
All other Conscience-based UIViewControllers are launched from this starting point.

@class ConscienceViewController ConscienceViewController.h
 */

#import "ConscienceViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "ConscienceView.h"
#import "ConscienceModalViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ConscienceMind.h"
#import "CoreData/CoreData.h"
#import "UserChoiceDAO.h"
#import "UserCollectableDAO.h"
#import "MoralDAO.h"
#import "IntroViewController.h"
#import "UserCharacterDAO.h"
#import "ConscienceAssetDAO.h"
#import "ViewControllerLocalization.h"

typedef enum {
    kHomeVirtueButtonTag = 3030,
    kHomeViceButtonTag = 3031,
    kHomeRankButtonTag = 3032,
    kHomeThoughtButtonTag = 3033
} kConscienceViewControllerTags;

float const kTransientInterval = 7;
int const kThoughtIterations = 5;
float const kThoughtInterval = 5;

@interface ConscienceViewController () <ViewControllerLocalization> {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
    
	IBOutlet UILabel *conscienceStatus;				/**< Conscience's thought presented in bubble */
	IBOutlet ConscienceView *initialConscienceView;		/**< pointer to UserConscienceView */
	IBOutlet UIImageView *thoughtBubbleView1;			/**< bubble surrounding Conscience's thought */
	IBOutlet UIView *consciencePlayground;			/**< area in which custom ConscienceView can float */
	IBOutlet UIView *thoughtArea;					/**< area in which thought bubble appears */
	
	IBOutlet UIImageView *virtueImage;				/**< most prominent virtue image */
	IBOutlet UIImageView *viceImage;				/**< most troublesome vice image */
	IBOutlet UIImageView *rankImage;				/**< current rank image */
	IBOutlet UILabel *virtueLabel;				/**< most prominent virtue label */
	IBOutlet UILabel *viceLabel;					/**< most prominent vice label */
	IBOutlet UILabel *rankLabel;					/**< rank frame label */    
    
	IBOutlet UIButton *virtueButton;				/**< button surrounding picture frame to cue virtue thought */
	IBOutlet UIButton *viceButton;                  /**< button surrounding picture frame to cue vice thought */
	IBOutlet UIButton *rankButton;                  /**< picture frame to launch ConscienceModalViewController */
    
	NSTimer *shakeTimer;				/**< limits Conscience shake response */
	NSTimer *thoughtFadeTimer;			/**< determines when Conscience thought disappears */
    
	CGFloat animationDuration;			/**< assists in gesture recognition */	
	CGFloat initialTapDistance;			/**< assists in gesture recognition */
    
	NSMutableString *homeVirtueDisplayName;	/**< most prominent virtue text */
	NSMutableString *homeViceDisplayName;	/**< most prominent vice text */
    NSMutableString *highestRankName;       /**< highest achieved rank */
    
}

/**
 Present a thought bubble to the User, suggesting that the UserConscience is talking
 */
-(void) showThought;
/**
 Hide the thought bubble.
 */
-(void) hideThought;
/**
 Present the ConscienceModalViewController for Conscience interaction
 */
-(void) showConscienceModal;
/**
 On first launch, play an introduction
 */
-(void) showIntroView;

-(void) refreshConscience;
/**
 Cancel all of shooken UserConscience behavior
 */
-(void) shakeEnd;
/**
 Create welcome message thought bubble for UserConscience
 */
-(void) createWelcomeMessage;
/**
 Calculate through all UserChoices which most prominent/troublesome virtue/vice is
 @param isVirtue bool representing whether virtue or vice was requested
 */
-(void) retrieveBiggestChoice:(BOOL) isVirtue;
/**
 Find highest rank
 */
-(void) retrieveHighestRank;
/**
 User choices affect UserConscience immediately, must return Conscience to regular state
 @param originalMood float representing overall Conscience mood
 @param originalEnthusiasm float representing overall Conscience enthusiasm
 */
-(void) resetMood:(float) originalMood andEnthusiasm:(float) originalEnthusiasm;

-(void) createMovementReaction;
-(void) endMovementReaction;
-(void) setupModalWorkflow;

@end

@implementation ConscienceViewController

/** @todo externalize angle and shake functions if possible */
static int thoughtVersion = 0;

#pragma mark -
#pragma mark ViewController lifecycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		//Create appDelegate and referebce NSUserDefaults for Conscience and serialized state retention
		appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
		prefs = [NSUserDefaults standardUserDefaults];
        context = [appDelegate.moralModelManager readWriteManagedObjectContext];

        homeVirtueDisplayName = [[NSMutableString alloc] init];
        homeViceDisplayName = [[NSMutableString alloc] init];
        highestRankName = [[NSMutableString alloc] init];

	}
    
	return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    initialConscienceView = appDelegate.userConscienceView;
    
    virtueImage.alpha = 0;
    viceImage.alpha = 0;
    rankImage.alpha = 0;
    
    [virtueButton setTag:kHomeVirtueButtonTag];    
    [viceButton setTag:kHomeViceButtonTag];
    [rankButton setTag:kHomeRankButtonTag];

	animationDuration = 1.0;
    
	thoughtBubbleView1.alpha = 0;
    virtueImage.alpha = 1;
    viceImage.alpha = 1;
    rankImage.alpha = 1;
    
    //If this is the first time that the app, then show the intro
    BOOL introComplete = [prefs boolForKey:@"introComplete"];
    
    if (!introComplete) {
        
        [self showIntroView];
        
    }  
    
    [self createWelcomeMessage];
    
    [self localizeUI];    
    
}

-(void) viewWillAppear:(BOOL)animated{

    //Setup notifications for rest of application to catch backgrounding
//    if ([appDelegate isCurrentIOS]) { 
//		[[NSNotificationCenter defaultCenter] addObserver: self
//                                                 selector: @selector(stopTimers) 
//                                                     name: UIApplicationDidEnterBackgroundNotification
//                                                   object: nil];
//        
//		[[NSNotificationCenter defaultCenter] addObserver: self
//                                                 selector: @selector(setTimers) 
//                                                     name: UIApplicationWillEnterForegroundNotification
//                                                   object: nil];
//	}
                
	initialConscienceView.alpha = 0;
	
	initialConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    
	[consciencePlayground addSubview:initialConscienceView];
	
    initialConscienceView.center = CGPointMake(kConscienceHomeX, kConscienceHomeY);
    
	[UIView beginAnimations:@"ShowConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
	initialConscienceView.alpha = 1;
    
	[UIView commitAnimations];
        
    //Determine if transient facial expression has been requested
    //@todo lessen transition difference between transient and real mood
    float transientMood = 0.0;
    
    //Check to see if transient was set
    NSObject *moodCheck = [prefs objectForKey:@"transientMind"];
	
	if (moodCheck != nil) {
        
		transientMood = [prefs floatForKey:@"transientMind"];
        
        //store previous mood
        float restoreMood = appDelegate.userConscienceMind.mood;
        float restoreEnthusiasm = appDelegate.userConscienceMind.enthusiasm;
        
        //set new mood
        appDelegate.userConscienceMind.mood = transientMood;
        appDelegate.userConscienceMind.enthusiasm = 100.0;
        [appDelegate.userConscienceView setIsExpressionForced:TRUE];

        
        //Setup invocation for delayed mood reset
        SEL selector = @selector(resetMood:andEnthusiasm:);
        
        NSMethodSignature *signature = [ConscienceViewController instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:selector];
        
        //Set the arguments
        [invocation setTarget:self];
        [invocation setArgument:&restoreMood atIndex:2];
        [invocation setArgument:&restoreEnthusiasm atIndex:3];        
        
        //remove transient mood
        [prefs removeObjectForKey:@"transientMind"];
        [initialConscienceView setNeedsDisplay];
        
        [NSTimer scheduledTimerWithTimeInterval:kTransientInterval invocation:invocation repeats:NO];
        
    }
    
	[consciencePlayground setNeedsDisplay];
    [self createWelcomeMessage];
    [self showThought];

	
}

-(void)viewDidAppear:(BOOL)animated {
    
	[super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    //Remove observers in case of backgrounding
	if ([appDelegate isCurrentIOS]) { 
		[[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidEnterBackgroundNotification
                                                      object:nil];
        
		[[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationWillEnterForegroundNotification
                                                      object:nil];
	}
        
    NSString *conscienceCenter = NSStringFromCGPoint(initialConscienceView.center);    
    [prefs setObject:conscienceCenter forKey:@"conscienceCenter"];
    
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark UI Interaction


/**
 Implementation:  Fade the thought bubble in and setup a timer to revoke it after a time
 */
-(void)showThought{
    
    thoughtBubbleView1.hidden = FALSE;
    
    //Only show status when User interacts with Conscience
    [UIView beginAnimations:@"showThought" context:nil];
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    thoughtBubbleView1.alpha = 1;
    conscienceStatus.alpha = 1;
    
    [UIView commitAnimations];
    
    //Dismiss the thought bubble after a time
    if (thoughtFadeTimer != nil) {
        [thoughtFadeTimer invalidate];
    }
    
    thoughtFadeTimer = [NSTimer scheduledTimerWithTimeInterval:kThoughtInterval target:self selector:@selector(hideThought) userInfo:nil repeats:YES];

}

/**
 Implementation:  Fade the thought bubble from view.  Must be function so can be called from an NSTimer.
 */
-(void)hideThought{
        
    [UIView beginAnimations:@"hideThought" context:nil];
	[UIView setAnimationDuration:1.0];
	
	[UIView setAnimationBeginsFromCurrentState:YES];
	thoughtBubbleView1.alpha = 0;
	conscienceStatus.alpha = 0;
	[UIView setAnimationDelegate:self]; // self is a view controller
	
	[UIView commitAnimations];
    
}

/**
 Implementation: Create the ConscienceModalViewController, present it.
 */
-(void)setupModalWorkflow{
    
    UINavigationController *modalNavController1 = [[UINavigationController alloc] init];
	
	NSString *modalNavTitle1 = @"Customization";
	
	modalNavController1.tabBarItem.title = modalNavTitle1;
	[modalNavController1 setNavigationBarHidden:YES];
	
	// Create the root view controller for the navigation controller
	// The new view controller configures a Cancel and Done button for the
	// navigation bar.
    
	ConscienceModalViewController *conscienceModalViewController1 = [[ConscienceModalViewController alloc] init];
	
    [modalNavController1 pushViewController:conscienceModalViewController1 animated:NO];
	
	[self presentModalViewController:modalNavController1 animated:NO];
	
	// The navigation controller is now owned by the current view controller
	// and the root view controller is owned by the navigation controller,
	// so both objects should be released to prevent over-retention.

}

/**
 Implementation:  Stop the background movements, hide Conscience with animation, call function to setup new nav stack
 */
-(void)showConscienceModal{
	    
    [UIView beginAnimations:@"HideConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(setupModalWorkflow)];

	initialConscienceView.alpha = 0;
    
	[UIView commitAnimations];
}

/**
 Implementation:  Launch Intro UIViewController in case of first launch.
 Will demonstrate interactions to User
 */
-(void)showIntroView{
    
    IntroViewController *introViewCont = [[IntroViewController alloc] init];
    
    [self presentModalViewController:introViewCont animated:NO];
}


/** Implementation:  Needs function due to invocation
 */
-(void) refreshConscience{
	[[consciencePlayground viewWithTag:kConscienceViewTag] setNeedsDisplay];
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
	
	[shakeInvocation setTarget:initialConscienceView];
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

        [initialConscienceView.layer addAnimation:(CAAnimation *)[initialConscienceView shakeAnimation] forKey:@"position"];
        
    }
}

- (void) shakeEnd
{
	[shakeTimer invalidate];
	shakeTimer = nil;
	
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
			if (touchedView.tag==kConscienceViewTag) {
				                
                /** @todo fix Conscience movement */
				//Depress Conscience slightly to simulate actual contact
				[UIView beginAnimations:@"ResizeConscienceSmall" context:nil];
				[UIView setAnimationDuration:0.2];
				[UIView setAnimationBeginsFromCurrentState:YES];
				initialConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
				[UIView commitAnimations];
				
                [self createMovementReaction];
				
			}	

		} break;
		default:break;
	}
	
	
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    initialTapDistance = -1;
		
	//Return the Conscience to regular size in event of touched or zoomed
	[UIView beginAnimations:@"ResizeConscienceBig" context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationBeginsFromCurrentState:YES];
	
	initialConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);

	[UIView commitAnimations];
    
    [self endMovementReaction];
    
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches allObjects][0];

    CGPoint conscienceCenter = [touch locationInView:self.view];

    UIView* touchedView = [self.view hitTest:conscienceCenter withEvent:event];

    if (touchedView.tag==kConscienceViewTag) {
    
        [self showConscienceModal];
    }
	
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	    
	[self touchesEnded:touches withEvent:event];
    
    [self endMovementReaction];

}

-(void) createMovementReaction {
    
    int randomResponse = arc4random()%3;

    if (appDelegate.userConscienceMind.mood > 45) {
        if (randomResponse == 0) {
            [conscienceStatus setText:@"Wee!"];
        } else if (randomResponse == 1){
            [conscienceStatus setText:@"Tickles!"];
        } else {
            [conscienceStatus setText:@"I'm touched.  LOL!"];
        }
                
    } else {

        if (randomResponse == 0) {
            [conscienceStatus setText:@"Please stop."];
        } else if (randomResponse == 1){
            [conscienceStatus setText:@"I'm not in the mood."];
        } else {
            [conscienceStatus setText:@"Ugh!"];
        }
        
    }

    [appDelegate.userConscienceView setIsExpressionForced:TRUE];        
    [initialConscienceView setNeedsDisplay];
            
}

-(void) endMovementReaction {
    
    UserCharacterDAO *currentUserCharacterDAO = [[UserCharacterDAO alloc] init];
    UserCharacter *currentUserCharacter = [currentUserCharacterDAO read:@""];
    appDelegate.userConscienceMind.mood = [[currentUserCharacter characterMood] floatValue];
    appDelegate.userConscienceMind.enthusiasm = [[currentUserCharacter characterEnthusiasm] floatValue];
    
    [currentUserCharacterDAO update];
    
    
}

#pragma mark -
#pragma Data Manipulation

/**
 Implementation:  Determine which bubble to view.
 */
-(IBAction)selectNextView:(id) sender{
    
    BOOL isChoice = FALSE;
    NSString *searchString = @"";
    
	//Set boolean to determine which version of screen to present
	if ([sender isKindOfClass:[UIButton class]]) {
		UIButton *senderButton = sender;
		int choiceIndex = senderButton.tag;
        
		switch (choiceIndex){
			case kHomeVirtueButtonTag:{
                isChoice = TRUE;
                if (![homeVirtueDisplayName isEqualToString:@""]) {
                    searchString = [NSString stringWithFormat:@"Your most developed Virtue is %@.", homeVirtueDisplayName];
                }
            }break;
			case kHomeViceButtonTag:{
                isChoice = TRUE;
                if (![homeViceDisplayName isEqualToString:@""]) {
                    searchString = [NSString stringWithFormat:@"Your most troublesome Vice is %@.", homeViceDisplayName];
                }
            }break;
			case kHomeRankButtonTag:{
                isChoice = TRUE;
                if (![highestRankName isEqualToString:@""]) {
                    searchString = [NSString stringWithFormat:@"Your current rank is %@.", highestRankName];
                }
            }break;                
			default:break;
		}
		
	}
    
    if (isChoice) {
        
        if (![searchString isEqualToString:@""]) {
            
            [conscienceStatus setText:searchString];
            
        } else {
            
            [conscienceStatus setText:@"You haven't entered a moral, yet.  Go to your Journal and enter in a Choice!"];
            
        }
        
        [self showThought];
        
    } else {
        [self hideThought];
    }
    
}


/**
Implementation:  Determine time of day, and which thought should be displayed.  Cycle through available dilemmas,  current mood, etc.
 */
-(void) createWelcomeMessage{
    
    //Only show status when User interacts with Conscience
    [UIView beginAnimations:@"hideThoughtLabel" context:nil];
    [UIView setAnimationDuration:0.5];
    
    conscienceStatus.alpha = 0;
    
    [UIView commitAnimations];
    
    [self retrieveBiggestChoice:TRUE];
    [self retrieveBiggestChoice:FALSE];
    [self retrieveHighestRank];

    
    /** @todo localize everything */
    NSString *timeOfDay = @"Morning";
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
    NSInteger hour = [components hour];
    
    NSArray *conscienceEnthusiasm = @[@"Stuporous", @"Unresponsive", @"Apathetic", @"Lethargic", @"Indifferent", @"Calm", @"Focused", @"Animated", @"Excited", @"Passionate", @"Unbridled"];
    NSArray *conscienceMood = @[@"Livid", @"Angry", @"Depressed", @"Sad", @"Discontent", @"Normal", @"Content", @"Pleasant", @"Happy", @"Ecstatic", @"Jubilant"];
    
    if (hour < 4) {
        timeOfDay = @"Night";
    } else if (hour < 12) {
        timeOfDay = @"Morning";
    } else if (hour < 17) {
        timeOfDay = @"Afternoon";
    } else if (hour <= 24) {
        timeOfDay = @"Night";
    }
    
    NSString *mood = @"Good";
    
    if ((appDelegate.userConscienceMind.enthusiasm < 50) || (appDelegate.userConscienceMind.mood < 50)) {
        mood = @"Bad";
    }
    
    
    UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] init];
    currentUserCollectableDAO.predicates = @[[NSPredicate predicateWithFormat:@"collectableName == %@", kCollectableEthicals]];
    UserCollectable *currentUserCollectable = [currentUserCollectableDAO read:@""];
    
    int ethicals = 0;
    //Increase the moral's value
    ethicals = [[currentUserCollectable collectableValue] intValue];		
    
        
    NSString *welcomeTextName =[[NSString alloc] initWithFormat:@"%@Welcome%@%@",NSStringFromClass([self class]), timeOfDay, mood ];
    NSString *welcomeText = [[NSString alloc] initWithString:NSLocalizedString(welcomeTextName,@"Welcome Text")];
    NSMutableString *thoughtSpecialized = [[NSMutableString alloc] init];
    
    /** @todo localize Conscience responses */
    switch (thoughtVersion) {
        case 0:{
            [thoughtSpecialized appendString:@"Have you read your Moral Report lately? Tap the Rank Button to review it!"];
            break;
        }
        case 1:{
            
            if (ethicals == 0) {
                [thoughtSpecialized appendString:@"You have no ethicals left.\n\nEarn some in Morathology by tapping the Rank Button!"];
            } else {
                [thoughtSpecialized appendFormat:@"You have %dε in the bank.\n\nTap the Rank Button to spend them in the Commissary!", ethicals];
            }
            break;
        }
        case 2:{
            
            int moodIndex = [@(appDelegate.userConscienceMind.mood) intValue];
            int enthusiasmIndex = [@(appDelegate.userConscienceMind.enthusiasm) intValue];

            [thoughtSpecialized appendFormat:@"I'm feeling %@ and %@.", conscienceMood[moodIndex/10], conscienceEnthusiasm[enthusiasmIndex/10]];
            
            break;
        }               
        case 3:{
            [thoughtSpecialized appendFormat:@"Your current rank is %@.", highestRankName];
            break;
        }
        default:
            [thoughtSpecialized setString:welcomeText];
            break;
            
    }
    
    if (thoughtVersion < kThoughtIterations-1) {
        thoughtVersion++;
    } else {
        thoughtVersion = 0;
    }
    
    [conscienceStatus setText:thoughtSpecialized];
    
    
    //Only show status when User interacts with Conscience
    [UIView beginAnimations:@"hideThoughtLabel" context:nil];
    [UIView setAnimationDuration:0.5];
    
    conscienceStatus.alpha = 1;
    
    [UIView commitAnimations];

}

/**
Implementation:  Must iterate through every UserChoice entered and sum each like entry to determine most prominent/troublesome virtue/vice 
 */
- (void) retrieveBiggestChoice:(BOOL) isVirtue{
    
    UserChoiceDAO *currentUserChoiceDAO = [[UserChoiceDAO alloc] init];
    NSPredicate *pred;
    
    if (isVirtue) {
        pred = [NSPredicate predicateWithFormat:@"choiceWeight > %d", 0];
    } else {
        pred = [NSPredicate predicateWithFormat:@"choiceWeight < %d", 0];
    }
    
	currentUserChoiceDAO.predicates = @[pred];    
    
    NSMutableString *moralDisplayName = [NSMutableString stringWithString:@"unknown"];
    NSMutableString *moralImageName = [NSMutableString stringWithString:@"card-doubt"];
    
	NSArray *objects = [currentUserChoiceDAO readAll];
    NSMutableDictionary *reportValues = [[NSMutableDictionary alloc] initWithCapacity:[objects count]];
    
	if ([objects count] == 0) {
		NSLog(@"No matches");
        
        if (isVirtue) {
            [virtueImage setImage:[UIImage imageNamed:@"card-doubt.png"]];
        } else {
            [viceImage setImage:[UIImage imageNamed:@"card-doubt.png"]];
        }
        
	} else {
        
        float currentValue = 0.0;
        
        
        for (UserChoice *match in objects){
            
            NSNumber *choiceWeightTemp = reportValues[[match choiceMoral]];
            
            if (choiceWeightTemp != nil) {
                currentValue = [choiceWeightTemp floatValue];
            } else {
                currentValue = 0.0;
            }
            
            currentValue += fabsf([[match choiceWeight] floatValue]);
            
            [reportValues setValue:@(currentValue) forKey:[match choiceMoral]];
        }
        
        NSArray *sortedPercentages = [reportValues keysSortedByValueUsingSelector:@selector(compare:)];
        NSArray* reversedPercentages = [[sortedPercentages reverseObjectEnumerator] allObjects];
        
        NSString *value = reversedPercentages[0];

        MoralDAO *currentMoralDAO = [[MoralDAO alloc] init];
        Moral *currentMoral = [currentMoralDAO read:value];

        if (currentMoral) {
            [moralDisplayName setString:currentMoral.displayNameMoral];
            [moralImageName setString:currentMoral.imageNameMoral];            
        }
                
        
        if (isVirtue) {
            [virtueButton setEnabled:TRUE];
            [virtueImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", moralImageName]]];
            
            [homeVirtueDisplayName setString:moralDisplayName]; 
        } else {
            [viceButton setEnabled:TRUE];
            [viceImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", moralImageName]]];
            
            [homeViceDisplayName setString:moralDisplayName];  
        }
        
        
	}
	
	
}

/**
 Implementation:  Must iterate through every UserCollectable to find all ranks given.  Sort by collectableName as ranks increase alphabetically.  
Change the Rank picture and description.
 */
- (void) retrieveHighestRank {
    
	//Begin CoreData Retrieval to find all Ranks in possession.
    UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] init];
    
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"collectableName contains[cd] %@", @"asse-rank"];
	currentUserCollectableDAO.predicates = @[pred];
    
	NSSortDescriptor* sortDescriptor;
    
	//sort by collectablename as all ranks are alphabetically/numerically sorted by collectableName
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"collectableName" ascending:FALSE];
    
	NSArray* sortDescriptors = @[sortDescriptor];
	currentUserCollectableDAO.sorts = sortDescriptors;
    
	NSArray *objects = [currentUserCollectableDAO readAll];

	//In case of no granted Ranks, setup the default User
	[rankImage setImage:[UIImage imageNamed:@"card-doubt.png"]];
	[highestRankName setString:@"Neophyte"];       
    
	//Ensure that at least one rank is present
	if ([objects count] > 0) {
        
        NSString *value = [objects[0] collectableName];
        ConscienceAssetDAO *currentAssetDAO = [[ConscienceAssetDAO alloc] init];
        ConscienceAsset *currentAsset = [currentAssetDAO read:value];
        
        if (currentAsset) {
            [rankImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-sm.png", currentAsset.imageNameReference]]];
            [highestRankName setString:currentAsset.displayNameReference];
        }
        
                        
	}
	
    
}

/**
 Implementation: Return UserConscience's Mood to previous state.  Eliminate transient mood/enthusiasm.  Fade results since glow change would be jarring, visually.
 */
- (void) resetMood:(float) originalMood andEnthusiasm:(float) originalEnthusiasm{
    
    [UIView beginAnimations:@"conscienceFade" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    initialConscienceView.alpha = 0;
    appDelegate.userConscienceMind.mood = originalMood;
    appDelegate.userConscienceMind.enthusiasm = originalEnthusiasm;    
    [initialConscienceView setNeedsDisplay];
    
    [UIView setAnimationDelegate:initialConscienceView]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(makeConscienceVisible)];
    
    [UIView commitAnimations];
    
}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
	[self setTitle:NSLocalizedString(@"ConscienceScreenTitle",@"Title for Conscience Screen")];
	self.accessibilityLabel = NSLocalizedString(@"ConscienceScreenLabel",@"Label for Conscience Screen");
	self.accessibilityHint = NSLocalizedString(@"ConscienceScreenHint",@"Hint for Conscience Screen");
	consciencePlayground.multipleTouchEnabled = TRUE;
    
    [virtueLabel setText:NSLocalizedString(@"ConscienceScreenVirtueLabel",@"Label for Virtue Button")];
    [viceLabel setText:NSLocalizedString(@"ConscienceScreenViceLabel",@"Label for Vice Button")];
    
    [virtueButton setAccessibilityLabel:NSLocalizedString(@"ConscienceScreenVirtueLabel",@"Label for Virtue Button")];
    [viceButton setAccessibilityLabel:NSLocalizedString(@"ConscienceScreenViceLabel",@"Label for Vice Button")];
    [rankButton setAccessibilityLabel:NSLocalizedString(@"ConscienceScreenRankLabel",@"Label for Rank Button")];
    
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