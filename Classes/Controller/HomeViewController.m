/**
Implementation:  UIViewController can present many versions of itself without having to render entirely new UIViewControllers.
All other Conscience-based UIViewControllers are launched from this starting point.

@class HomeViewController HomeViewController.h
 */

#import "HomeViewController.h"
#import "ConscienceViewController.h"
#import "UserChoiceDAO.h"
#import "UserCollectableDAO.h"
#import "MoralDAO.h"
#import "ConscienceAssetDAO.h"
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

float const MLTransientInterval = 7;
int const MLThoughtIterations = 5;
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
/**
 Create welcome message thought bubble for UserConscience
 */
-(void) createWelcomeMessage;
/**
 Calculate through all UserChoices which most prominent/troublesome virtue/vice is
 @param isVirtue bool representing whether virtue or vice was requested
 */
-(void) retrieveBiggestChoiceAsVirtue:(BOOL) isVirtue;
/**
 Find highest rank
 */
-(void) retrieveHighestRank;
-(void) createMovementReaction;
-(void) setupModalWorkflow;

@end

@implementation HomeViewController

/** @todo externalize angle and shake functions if possible */
static int thoughtVersion = 0;

#pragma mark -
#pragma mark ViewController lifecycle

-(id)initWithModelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience {

    if ((self = [super initWithModelManager:modelManager andConscience:userConscience])) {
		prefs = [NSUserDefaults standardUserDefaults];

        homeVirtueDisplayName = [[NSMutableString alloc] init];
        homeViceDisplayName = [[NSMutableString alloc] init];
        highestRankName = [[NSMutableString alloc] init];

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

    [self createWelcomeMessage];

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
        
        //store previous mood
        float restoreMood = _userConscience.userConscienceMind.mood;
        float restoreEnthusiasm = _userConscience.userConscienceMind.enthusiasm;
        
        //set new mood
        _userConscience.userConscienceMind.mood = transientMood;
        _userConscience.userConscienceMind.enthusiasm = 100.0;
        [_userConscience.userConscienceView setIsExpressionForced:TRUE];
        
        //Setup invocation for delayed mood reset
        SEL selector = @selector(resetMood:andEnthusiasm:);
        
        NSMethodSignature *signature = [UserConscience instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setSelector:selector];
        
        //Set the arguments
        [invocation setTarget:_userConscience];
        [invocation setArgument:&restoreMood atIndex:2];
        [invocation setArgument:&restoreEnthusiasm atIndex:3];        
        
        //remove transient mood
        [prefs removeObjectForKey:@"transientMind"];
        [_userConscience.userConscienceView setNeedsDisplay];
        
        [NSTimer scheduledTimerWithTimeInterval:MLTransientInterval invocation:invocation repeats:NO];
        
    }

	[consciencePlayground setNeedsDisplay];
    [self createWelcomeMessage];

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

-(void)viewDidAppear:(BOOL)animated {
    
	[super viewDidAppear:animated];
    [self becomeFirstResponder];
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
    
    [self resignFirstResponder];
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


/**
Implementation:  Determine time of day, and which thought should be displayed.  Cycle through available dilemmas,  current mood, etc.
 */
-(void) createWelcomeMessage{
    
    [self retrieveBiggestChoiceAsVirtue:TRUE];
    [self retrieveBiggestChoiceAsVirtue:FALSE];
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
    
    if ((_userConscience.userConscienceMind.enthusiasm < 50) || (_userConscience.userConscienceMind.mood < 50)) {
        mood = @"Bad";
    }
    
    
    UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:@"" andModelManager:_modelManager];
    currentUserCollectableDAO.predicates = @[[NSPredicate predicateWithFormat:@"collectableName == %@", MLCollectableEthicals]];
    UserCollectable *currentUserCollectable = [currentUserCollectableDAO read:@""];
    
    int ethicals = 0;
    //Increase the moral's value
    ethicals = [[currentUserCollectable collectableValue] intValue];		
        
    NSString *welcomeTextName =[[NSString alloc] initWithFormat:@"%@Welcome%@%@",NSStringFromClass([self class]), timeOfDay, mood ];
    NSString *welcomeText = [[NSString alloc] initWithString:NSLocalizedString(welcomeTextName,nil)];
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
            
            int moodIndex = [@(_userConscience.userConscienceMind.mood) intValue];
            int enthusiasmIndex = [@(_userConscience.userConscienceMind.enthusiasm) intValue];

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
    
    if (thoughtVersion < MLThoughtIterations-1) {
        thoughtVersion++;
    } else {
        thoughtVersion = 0;
    }
    
    [conscienceStatus setText:thoughtSpecialized];

}

/**
Implementation:  Must iterate through every UserChoice entered and sum each like entry to determine most prominent/troublesome virtue/vice 
 */
- (void) retrieveBiggestChoiceAsVirtue:(BOOL) isVirtue{
    
    UserChoiceDAO *currentUserChoiceDAO = [[UserChoiceDAO alloc] initWithKey:@"" andModelManager:_modelManager];
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

        MoralDAO *currentMoralDAO = [[MoralDAO alloc] initWithKey:@"" andModelManager:_modelManager];
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
    UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:@"" andModelManager:_modelManager];
    
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
        ConscienceAssetDAO *currentAssetDAO = [[ConscienceAssetDAO alloc] initWithKey:@"" andModelManager:_modelManager];
        ConscienceAsset *currentAsset = [currentAssetDAO read:value];
        
        if (currentAsset) {
            [rankImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-sm.png", currentAsset.imageNameReference]]];
            [highestRankName setString:currentAsset.displayNameReference];
        }
        
                        
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