/**
Implementation:  UIViewController allows subsequent screen selection, controls button animation and resets choices by clearing NSUserDefaults.
 
@class ChoiceInitViewController ChoiceInitViewController.h
*/

#import "ChoiceInitViewController.h"
#import "ChoiceListViewController.h"
#import "ChoiceHistoryModel.h"
#import "ChoiceViewController.h"
#import "ConscienceHelpViewController.h"
#import "MenuScreenAnimations.h"
#import "ViewControllerLocalization.h"
#import "UIViewController+Screenshot.h"
#import "UIFont+Utility.h"

@interface ChoiceInitViewController () <MenuScreenAnimations, ViewControllerLocalization> {
	
	NSUserDefaults *prefs;                      /**< serialized state retention */
	
	IBOutlet UIButton *goodChoiceLabelButton;		/**< Label for Good Choice entry selection */
	IBOutlet UIButton *badChoiceLabelButton;		/**< Label for Bad Choice entry selection */
	IBOutlet UIButton *choiceListLabelButton;		/**< Label for All Choice listing selection */
	
	IBOutlet UIButton *goodChoiceButton;		/**< Button for Good Choice entry selection */
	IBOutlet UIButton *badChoiceButton;			/**< Button for Bad Choice entry selection */
	IBOutlet UIButton *choiceListButton;		/**< Button for All Choice listing selection */
	    
	NSArray *buttonNames;		/**< button image names */
	NSTimer *buttonTimer;		/**< Timer for animating buttons */
}

@end

@implementation ChoiceInitViewController

#pragma mark -
#pragma mark View lifecycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		//Create NSUserDefaults for serialized state retention
		prefs = [NSUserDefaults standardUserDefaults];
		
		//Array to hold button names for random animations
		buttonNames = @[@"choicegood", @"choicebad", @"choicelist"];

	}
    
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    goodChoiceLabelButton.titleLabel.font = [UIFont fontForScreenButtons];
    [goodChoiceLabelButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goodChoiceLabelButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    badChoiceLabelButton.titleLabel.font = [UIFont fontForScreenButtons];
    [badChoiceLabelButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [badChoiceLabelButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    choiceListLabelButton.titleLabel.font = [UIFont fontForScreenButtons];
    [choiceListLabelButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [choiceListLabelButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];


    UIBarButtonItem *choiceBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(popToHome)];
    [self.navigationItem setLeftBarButtonItem:choiceBarButton];

    [self localizeUI];
}

- (void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

	//Setup repeating NSTimer to make the buttons animate randomly
	[self refreshButtons];
	buttonTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshButtons) userInfo:nil repeats:YES];

}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];

}

- (void)popToHome {

    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark -
#pragma mark UI Interaction

/**
Implementation: Show an initial help screen if this is the User's first use of the screen.  Set a User Default after help screen is presented.  Launch a ConscienceHelpViewController and populate a localized help message.
 */
-(void)showInitialHelpScreen {
    
    //If this is the first time that the app, then show the intro
    NSObject *firstChoiceCheck = [prefs objectForKey:@"firstChoice"];
    
    if (firstChoiceCheck == nil) {
        
        ConscienceHelpViewController *conscienceHelpViewController = [[ConscienceHelpViewController alloc] init];
        conscienceHelpViewController.viewControllerClassName = NSStringFromClass([self class]);
		conscienceHelpViewController.isConscienceOnScreen = FALSE;
        conscienceHelpViewController.numberOfScreens = 1;

        conscienceHelpViewController.screenshot = [self takeScreenshot];

        [self presentModalViewController:conscienceHelpViewController animated:NO];
        
        [prefs setBool:FALSE forKey:@"firstChoice"];
        
    }
}

/**
Implementation: A single view controller is utilized for both Good and Bad choices.  A boolean controls which version of the view controller is presented to User.
 */
- (IBAction) selectChoiceType:(id) sender{

	BOOL isGood = TRUE;
	BOOL isList = FALSE;
	
	//Set boolean to determine which version of screen to present
	if ([sender isKindOfClass:[UIButton class]]) {
		UIButton *senderButton = sender;
		int choiceIndex = senderButton.tag;
		
		switch (choiceIndex){
			case 0:isGood = TRUE;break;
			case 1:isGood = FALSE;break;
			case 2:isList = TRUE;break;				
			default:break;
		}
		
	}
	
	//User can back out of Choice Entry screen and state will be saved
	//unless a new choice is requested
	/** @todo refactor into new function */
	
	//Remove all state information
	[prefs removeObjectForKey:@"entryShortDescription"];
	[prefs removeObjectForKey:@"entryLongDescription"];
	[prefs removeObjectForKey:@"entryKey"];
	[prefs removeObjectForKey:@"entrySeverity"];
	[prefs removeObjectForKey:@"entryIsGood"];
	
	//Remove ChoiceDetail state information
	[prefs removeObjectForKey:@"choiceJustification"];
	[prefs removeObjectForKey:@"choiceConsequence"];
	[prefs removeObjectForKey:@"choiceInfluence"];	
	
	//Remove Moral state information
	[prefs removeObjectForKey:@"moralKey"];
	[prefs removeObjectForKey:@"moralName"];
	[prefs removeObjectForKey:@"moralImage"];
	
	[prefs setBool:isGood forKey:@"entryIsGood"];

    //Determine if List controller type or entry controller type is needed
    if (!isList) {

        ChoiceViewController *choiceViewController = [[ChoiceViewController alloc] init];

        [self.navigationController pushViewController:choiceViewController animated:YES];
    } else {

        ChoiceHistoryModel *choiceHistoryModel = [[ChoiceHistoryModel alloc] init];
        ChoiceListViewController *choiceListCont = [[ChoiceListViewController alloc] initWithModel:choiceHistoryModel];
        [self.navigationController pushViewController:choiceListCont animated:YES];
    }

}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    
    //Retrieve localized view title string
	[self setTitle:NSLocalizedString(@"ChoiceInitScreenTitle",nil)];
	self.accessibilityLabel = NSLocalizedString(@"ChoiceInitScreenLabel",nil);
	self.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenHint",nil);
    
	//Set localized Button Titles.  Do no do this in init, XIB is not loaded until viewDidLoad
	[goodChoiceLabelButton setTitle:NSLocalizedString(@"ChoiceInitScreenChoiceGoodLabel",nil) forState: UIControlStateNormal];
	[badChoiceLabelButton setTitle:NSLocalizedString(@"ChoiceInitScreenChoiceBadLabel",nil) forState: UIControlStateNormal];
	[choiceListLabelButton setTitle:NSLocalizedString(@"ChoiceInitScreenChoiceListLabel",nil) forState: UIControlStateNormal];
	goodChoiceLabelButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceGoodHint",nil);
	badChoiceLabelButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceBadHint",nil);
	choiceListLabelButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceListHint",nil);		
	goodChoiceButton.accessibilityLabel = NSLocalizedString(@"ChoiceInitScreenChoiceGoodLabel",nil);
	badChoiceButton.accessibilityLabel = NSLocalizedString(@"ChoiceInitScreenChoiceBadLabel",nil);
	choiceListButton.accessibilityLabel = NSLocalizedString(@"ChoiceInitScreenChoiceListLabel",nil);
	goodChoiceButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceGoodHint",nil);
	badChoiceButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceBadHint",nil);
	choiceListButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceListHint",nil);
	
}


#pragma mark -
#pragma mark MenuScreenAnimations Protocol

/**
 Implementation: Only animate at most 4 buttons at a time.  Otherwise, too visually distracting
 */
- (void) refreshButtons{

    //Determine which set of four buttons will be animated
	[self buttonAnimate:@(arc4random()%3)];
	[self buttonAnimate:@(arc4random()%3)];
	[self buttonAnimate:@(arc4random()%3)];
	[self buttonAnimate:@(arc4random()%3)];
}

/**
 Implementation: Build animated UIImage from sequential icon files
 */
- (void) buttonAnimate:(NSNumber *) buttonNumber{
	
    //Get button image base filename
	NSString *iconFileName = [NSString stringWithFormat:@"icon-%@ani", buttonNames[[buttonNumber intValue]]];

    //Build 4 frames of animation for selected button
	UIImage *iconani1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@1.png", iconFileName]];
	UIImage *iconani2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@2.png", iconFileName]];
	UIImage *iconani3 = [UIImage imageNamed:[NSString stringWithFormat:@"%@3.png", iconFileName]];
	UIImage *iconani4 = [UIImage imageNamed:[NSString stringWithFormat:@"%@4.png", iconFileName]];

    //Setup placeholder for image setup
	UIImage *iconBlank = [UIImage imageNamed:@""];
	
    //Build physical animation in UIImageView
	UIImageView *animation1 = [[UIImageView alloc] init];
	animation1.frame = CGRectMake(0,0,75,75);
	
	NSArray *images = @[iconani1, iconani2, iconani3, iconani4];
	animation1.animationImages = images;

    //Determine which button to animate
	switch ([buttonNumber intValue]){
		case 0: [goodChoiceButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[goodChoiceButton addSubview:animation1];break;
		case 1: [badChoiceButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[badChoiceButton addSubview:animation1];break;
		case 2: [choiceListButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[choiceListButton addSubview:animation1];break;
		default:break;
	}
	
	animation1.animationDuration = 0.75;
	animation1.animationRepeatCount = 1;
	[animation1 startAnimating];
	
	
	//Reset button after animation, delay slightly to allow animation to catchup
	[self performSelector:@selector(buttonAnimationDone:) withObject:buttonNumber afterDelay:0.70];
	
}

/**
 Implementation: Return the button's icon to default after animation finishes
 */
- (void) buttonAnimationDone:(NSNumber *) buttonNumber{
	
    //Return button to default state
	NSString *iconFileName = [NSString stringWithFormat:@"icon-%@ani1.png", buttonNames[[buttonNumber intValue]]];

	switch ([buttonNumber intValue]){
		case 0: [goodChoiceButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 1: [badChoiceButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 2: [choiceListButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		default:break;
	}
}

#pragma mark -
#pragma mark Memory Management

-(void) viewWillDisappear:(BOOL)animated {

	//Turn off button animations
	[buttonTimer invalidate];
	buttonTimer = nil;
	
}

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