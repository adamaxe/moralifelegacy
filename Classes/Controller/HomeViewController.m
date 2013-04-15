/**
Implementation:  UIViewController can present many versions of itself without having to render entirely new UIViewControllers.
All other Conscience-based UIViewControllers are launched from this starting point.

@class HomeViewController HomeViewController.h
 */

#import "HomeViewController.h"
#import "HomeModel.h"
#import "ConscienceViewController.h"
#import "IntroViewController.h"
#import "ChoiceInitViewController.h"
#import "ReferenceViewController.h"
#import "UIColor+Utility.h"

typedef enum {
    MLHomeViewControllerVirtueButtonTag = 3030,
    MLHomeViewControllerViceButtonTag = 3031,
    MLHomeViewControllerRankButtonTag = 3032,
    MLHomeViewControllerThoughtButtonTag = 3033
} MLHomeViewControllerTags;

float const MLThoughtInterval = 5;

@interface HomeViewController () <ViewControllerLocalization> {
    
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
    
	IBOutlet UILabel *conscienceStatus;				/**< Conscience's thought presented in bubble */
	IBOutlet UIImageView *thoughtBubbleView1;			/**< bubble surrounding Conscience's thought */
	IBOutlet UIImageView *thoughtBubbleView2;			/**< bubble surrounding Conscience's thought */
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
	IBOutlet UIButton *rankButton;                  /**< picture frame to launch ConscienceViewController */
    
	NSTimer *thoughtFadeTimer;			/**< determines when Conscience thought disappears */
    
	CGFloat animationDuration;			/**< assists in gesture recognition */	
	CGFloat initialTapDistance;			/**< assists in gesture recognition */
    
	NSMutableString *homeVirtueDisplayName;	/**< most prominent virtue text */
	NSMutableString *homeViceDisplayName;	/**< most prominent vice text */
    NSMutableString *highestRankName;       /**< highest achieved rank */
    BOOL isThoughtOnScreen;             /**< whether Conscience Thought bubble is visible */
    
}

@property (nonatomic, strong) HomeModel *homeModel;

/**
 Present a thought bubble to the User, suggesting that the UserConscience is talking
 */
-(void) showThought;
/**
 Hide the thought bubble.
 */
-(void) hideThought;
/**
 Present the ConscienceViewController for Conscience interaction
 */
-(void) showConscienceModal;
/**
 On first launch, play an introduction
 */
-(void) showIntroView;

-(void) refreshConscience;
-(void) createMovementReaction;
-(void) setupModalWorkflow;

@end

@implementation HomeViewController

#pragma mark -
#pragma mark ViewController lifecycle

- (id)initWithModel:(HomeModel *) homeModel modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience {

    if ((self = [super initWithModelManager:modelManager andConscience:userConscience])) {
		prefs = [NSUserDefaults standardUserDefaults];

        homeVirtueDisplayName = [[NSMutableString alloc] init];
        homeViceDisplayName = [[NSMutableString alloc] init];
        highestRankName = [[NSMutableString alloc] init];

        self.homeModel = homeModel;

	}
    
	return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    virtueImage.alpha = 0;
    viceImage.alpha = 0;
    rankImage.alpha = 0;
    
    [virtueButton setTag:MLHomeViewControllerVirtueButtonTag];    
    [viceButton setTag:MLHomeViewControllerViceButtonTag];
    [rankButton setTag:MLHomeViewControllerRankButtonTag];
    virtueLabel.font = [UIFont fontForHomeScreenButtons];
    viceLabel.font = [UIFont fontForHomeScreenButtons];
    rankLabel.font = [UIFont fontForHomeScreenButtons];

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

    [conscienceStatus setTextColor:[UIColor moraLifeChoiceBlue]];
    [conscienceStatus setShadowColor:[UIColor moraLifeChoiceLightGray]];

    UIBarButtonItem *choiceBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Journal" style:UIBarButtonItemStylePlain target:self action:@selector(pushJournal)];
    UIBarButtonItem *referenceBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Collection" style:UIBarButtonItemStylePlain target:self action:@selector(pushReference)];
    [self.navigationItem setRightBarButtonItems:@[referenceBarButton, choiceBarButton] animated:FALSE];

    [self localizeUI];    

    UILabel* homeNavigationTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,30,self.view.frame.size.width/3,40)];
    homeNavigationTitle.font = [UIFont fontForNavigationBarTitle];
    homeNavigationTitle.textColor = [UIColor whiteColor];
    homeNavigationTitle.shadowColor = [UIColor blackColor];
    homeNavigationTitle.shadowOffset = CGSizeMake(0, -1);
    homeNavigationTitle.textAlignment = UITextAlignmentLeft;
    homeNavigationTitle.backgroundColor = [UIColor clearColor];
    homeNavigationTitle.text = self.navigationItem.title;
    self.navigationItem.titleView = homeNavigationTitle;

    [_userConscience.userConscienceView setNeedsDisplay];

}

-(void) viewWillAppear:(BOOL)animated{

	_userConscience.userConscienceView.alpha = 0;
    thoughtArea.hidden = FALSE;

	_userConscience.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    
	[consciencePlayground addSubview:_userConscience.userConscienceView];
	
    _userConscience.userConscienceView.center = CGPointMake(MLConscienceHomeX, MLConscienceHomeY);
    
	[UIView beginAnimations:@"ShowConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
    
	_userConscience.userConscienceView.alpha = 1;

	[UIView commitAnimations];
        
    //Determine if transient facial expression has been requested
    //@todo lessen transition difference between transient and real mood
    float transientMood = 0.0;
    
    //Check to see if transient was set
    NSObject *moodCheck = [prefs objectForKey:@"transientMind"];
	
	if (moodCheck != nil) {
        
		transientMood = [prefs floatForKey:@"transientMind"];
        _userConscience.transientMood = transientMood;
        //remove transient mood
        [prefs removeObjectForKey:@"transientMind"];
        
    }

	[consciencePlayground setNeedsDisplay];
    [conscienceStatus setText:[self.homeModel generateWelomeMessageWithTimeOfDay:[NSDate date] andMood:_userConscience.userConscienceMind.mood andEnthusiasm:_userConscience.userConscienceMind.enthusiasm]];

    [virtueImage setImage:self.homeModel.greatestVirtueImage];
    [homeVirtueDisplayName setString:self.homeModel.greatestVirtue];

    [viceImage setImage:self.homeModel.worstViceImage];
    [homeViceDisplayName setString:self.homeModel.worstVice];

	//In case of no granted Ranks, setup the default User
	[rankImage setImage:self.homeModel.highestRankImage];
	[highestRankName setString:self.homeModel.highestRank];

    [self selectNextView:nil];

}

- (void) pushJournal {
    ChoiceInitViewController *choiceIntViewController = [[ChoiceInitViewController alloc] initWithModelManager:_modelManager andConscience:_userConscience];
    [self.navigationController pushViewController:choiceIntViewController animated:YES];
}

- (void) pushReference {
    ReferenceViewController *referenceViewController = [[ReferenceViewController alloc] initWithModelManager:_modelManager andConscience:_userConscience];
    [self.navigationController pushViewController:referenceViewController animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    //Remove observers in case of backgrounding
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
        
    NSString *conscienceCenter = NSStringFromCGPoint(_userConscience.userConscienceView.center);
    [prefs setObject:conscienceCenter forKey:@"conscienceCenter"];
    
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark UI Interaction


/**
 Implementation:  Fade the thought bubble in and setup a timer to revoke it after a time
 */
-(void)showThought{
    
    thoughtBubbleView1.alpha = 0;
    conscienceStatus.alpha = 0;
    thoughtBubbleView1.hidden = FALSE;
    conscienceStatus.hidden = FALSE;

    [UIView animateWithDuration:0.35 delay:0 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        thoughtBubbleView1.alpha = 1;
        conscienceStatus.alpha = 1;

    }completion:^(BOOL finished) {
        isThoughtOnScreen = TRUE;
    }];

    //Dismiss the thought bubble after a time
    if (thoughtFadeTimer != nil) {
        [thoughtFadeTimer invalidate];
    }


    thoughtFadeTimer = [NSTimer scheduledTimerWithTimeInterval:MLThoughtInterval target:self selector:@selector(hideThought) userInfo:nil repeats:YES];

}

/**
 Implementation:  Fade the thought bubble from view.  Must be function so can be called from an NSTimer.
 */
-(void)hideThought{

    [UIView animateWithDuration:0.35 delay:0 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        thoughtBubbleView1.alpha = 0;
        conscienceStatus.alpha = 0;

    }completion:^(BOOL finished) {
        thoughtBubbleView1.hidden = TRUE;
        thoughtBubbleView2.hidden = TRUE;
        conscienceStatus.hidden = TRUE;
        isThoughtOnScreen = FALSE;
    }];

}

/**
 Implementation: Create the ConscienceViewController, present it.
 */
-(void)setupModalWorkflow{
    
    UINavigationController *conscienceNavigationController = [[UINavigationController alloc] init];
		
	conscienceNavigationController.tabBarItem.title = @"Customization";
	[conscienceNavigationController setNavigationBarHidden:YES];
	    
	ConscienceViewController *conscienceViewController = [[ConscienceViewController alloc] initWithModelManager:_modelManager andConscience:_userConscience];
    thoughtArea.hidden = TRUE;
    conscienceViewController.screenshot = [self prepareScreenForScreenshot];
	
    [conscienceNavigationController pushViewController:conscienceViewController animated:NO];
	
	[self presentModalViewController:conscienceNavigationController animated:NO];
	
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

	_userConscience.userConscienceView.alpha = 0;
    
	[UIView commitAnimations];
}

/**
 Implementation:  Launch Intro UIViewController in case of first launch.
 Will demonstrate interactions to User
 */
-(void)showIntroView{
    
    IntroViewController *introViewCont = [[IntroViewController alloc] initWithModelManager:_modelManager andConscience:_userConscience];
    
    [self presentModalViewController:introViewCont animated:NO];
}

-(void) refreshConscience{
	[[consciencePlayground viewWithTag:MLConscienceViewTag] setNeedsDisplay];
}

-(void) createMovementReaction {
    
    int randomResponse = arc4random()%3;

    if (_userConscience.userConscienceMind.mood > 45) {
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

    [_userConscience.userConscienceView setIsExpressionForced:TRUE];
    [_userConscience.userConscienceView setNeedsDisplay];
            
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
			case MLHomeViewControllerVirtueButtonTag:{
                isChoice = TRUE;
                if (![homeVirtueDisplayName isEqualToString:@""]) {
                    searchString = [NSString stringWithFormat:@"Your most developed Virtue is %@.", homeVirtueDisplayName];
                }
            }break;
			case MLHomeViewControllerViceButtonTag:{
                isChoice = TRUE;
                if (![homeViceDisplayName isEqualToString:@""]) {
                    searchString = [NSString stringWithFormat:@"Your most troublesome Vice is %@.", homeViceDisplayName];
                }
            }break;
			case MLHomeViewControllerRankButtonTag:{
                isChoice = TRUE;
                if (![highestRankName isEqualToString:@""]) {
                    searchString = [NSString stringWithFormat:@"Your current rank is %@.", highestRankName];
                }
            }break;                
			default:break;
		}
		
	}
    
    if (isChoice) {
        
        if ([searchString isEqualToString:@""]) {
            searchString = @"You haven't entered a moral, yet.  Go to your Journal and enter in a Choice!";
        }

        [UIView animateWithDuration:0.5 animations:^{
            conscienceStatus.alpha = 0;
        }completion:^(BOOL finished) {
            [conscienceStatus setText:searchString];
            [UIView animateWithDuration:0.5 animations:^{
                conscienceStatus.alpha = 1;
            }];
        }];



    }

    if (!isThoughtOnScreen) {
        [self showThought];
    }

}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
	[self setTitle:NSLocalizedString(@"ConscienceScreenTitle",nil)];
	self.accessibilityLabel = NSLocalizedString(@"ConscienceScreenLabel",nil);
	self.accessibilityHint = NSLocalizedString(@"ConscienceScreenHint",nil);
	consciencePlayground.multipleTouchEnabled = TRUE;
    
    [virtueLabel setText:NSLocalizedString(@"ConscienceScreenVirtueLabel",nil)];
    [viceLabel setText:NSLocalizedString(@"ConscienceScreenViceLabel",nil)];
    
    [virtueButton setAccessibilityLabel:NSLocalizedString(@"ConscienceScreenVirtueLabel",nil)];
    [viceButton setAccessibilityLabel:NSLocalizedString(@"ConscienceScreenViceLabel",nil)];
    [rankButton setAccessibilityLabel:NSLocalizedString(@"ConscienceScreenRankLabel",nil)];
    
}

#pragma mark -
#pragma mark UserConscienceTouchProtocol

-(void)userConscienceTouchBegan {
    [self createMovementReaction];
}

-(void)userConscienceTouchEnded {
    [self showConscienceModal];
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