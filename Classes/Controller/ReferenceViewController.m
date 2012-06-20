/**
Implementation:  UIViewController allows subsequent screen selection, controls button animation and resets choices by clearing NSUserDefaults.
 
@class ReferenceViewController ReferenceViewController.h
 */

#import "MoraLifeAppDelegate.h"
#import "ReferenceViewController.h"
#import "ReferenceListViewController.h"
#import "ConscienceHelpViewController.h"
#import "MenuScreenAnimations.h"
#import "ViewControllerLocalization.h"

@interface ReferenceViewController () <MenuScreenAnimations, ViewControllerLocalization> {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
    
	IBOutlet UIButton *peopleLabelButton;		/**< label for People button */
	IBOutlet UIButton *placesLabelButton;		/**< label for Places button */
	IBOutlet UIButton *booksLabelButton;		/**< label for Books button */
	IBOutlet UIButton *beliefsLabelButton;		/**< label for Beliefs button */
	IBOutlet UIButton *reportsLabelButton;		/**< label for Reports button */
	IBOutlet UIButton *accessoriesLabelButton;	/**< label for Accessories button */
	
	IBOutlet UIButton *peopleButton;		/**< label for People button */
	IBOutlet UIButton *placesButton;		/**< label for Places button */
	IBOutlet UIButton *booksButton;		/**< label for Books button */
	IBOutlet UIButton *beliefsButton;		/**< label for Beliefs button */
	IBOutlet UIButton *reportsButton;		/**< label for Reports button */
	IBOutlet UIButton *accessoriesButton;	/**< label for Accessories button */
	
	NSArray *buttonNames;
    
}

@property (nonatomic, retain) NSTimer *buttonTimer;		/**< determines when Conscience thought disappears */

@end

@implementation ReferenceViewController

@synthesize buttonTimer = _buttonTimer;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		
		//Array to hold button names for random animations
//		buttonNames = [[NSArray alloc] initWithObjects:@"accessories", @"beliefs", @"books", @"people", @"places", @"reports", nil];
		buttonNames = [[NSArray alloc] initWithObjects:@"accessories", @"beliefs", @"books", @"people", @"choicegood", @"reports", nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];	

	//Create appDelegate and referebce NSUserDefaults for Conscience and serialized state retention

	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	prefs = [NSUserDefaults standardUserDefaults];
    
    [self localizeUI];    

}

- (void) viewWillAppear:(BOOL)animated{
	
	[self refreshButtons];
	
	self.buttonTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshButtons) userInfo:nil repeats:YES];
	
}

-(void)viewDidAppear:(BOOL)animated {
    
	//Present help screen after a split second
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];
    
}

#pragma mark -
#pragma mark UI Interaction

/**
 Implementation: Show an initial help screen if this is the User's first use of the screen.  Set a User Default after help screen is presented.  Launch a ConscienceHelpViewController and populate a localized help message.
 */
-(void)showInitialHelpScreen {
    
    //If this is the first time that the app, then show the intro
    NSObject *firstReferenceCheck = [prefs objectForKey:@"firstReference"];
    
    if (firstReferenceCheck == nil) {
        
        ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
        [conscienceHelpViewCont setViewControllerClassName:NSStringFromClass([self class])];        
		[conscienceHelpViewCont setIsConscienceOnScreen:FALSE];
        [conscienceHelpViewCont setHelpVersion:0];
		[self presentModalViewController:conscienceHelpViewCont animated:NO];
		[conscienceHelpViewCont release];
        
        [prefs setBool:FALSE forKey:@"firstReference"];
        
    }
}

/**
Implementation: A single view controller is utilized for both Good and Bad choices.  A boolean controls which version of the view controller is presented to User.
 */
- (IBAction) selectReferenceType:(id) sender{
	
	//Create view controller to be pushed upon navigation stack
	ReferenceListViewController *referenceListViewCont = [[ReferenceListViewController alloc] init];

	int referenceType = 0;
		
	//Determine which choice was selected
	if ([sender isKindOfClass:[UIButton class]]) {
		UIButton *senderButton = sender;
		int choiceIndex = senderButton.tag;
		
		//Populate subsequent list controller with appropriate choice
		//Pass which reference type is requested
		switch (choiceIndex){
			case 0:referenceType = kReferenceTypeAccessories;break;
			case 1:referenceType = kReferenceTypeBeliefs;break;
			case 2:referenceType = kReferenceTypeBooks;break;
			case 3:referenceType = kReferenceTypePeople;break;
			case 4:referenceType = kReferenceTypePlaces;break;
			default:break;
		}
		
	}
	
    referenceListViewCont.referenceType = referenceType;		
    [self.navigationController pushViewController:referenceListViewCont animated:YES];

	[referenceListViewCont release];
}

#pragma mark -
#pragma mark MenuScreenAnimationsProtocol

/**
Implementation: Only animate at most 4 buttons at a time.  Otherwise, too visually distracting
 */
- (void) refreshButtons{
	
	[self buttonAnimate:[NSNumber numberWithInt:arc4random()%6]];
	[self buttonAnimate:[NSNumber numberWithInt:arc4random()%6]];
	[self buttonAnimate:[NSNumber numberWithInt:arc4random()%6]];
	[self buttonAnimate:[NSNumber numberWithInt:arc4random()%6]];
}

/**
Implementation: Build animated UIImage from sequential icon files
 */
- (void) buttonAnimate:(NSNumber *) buttonNumber{
	
	NSString *iconFileName = [NSString stringWithFormat:@"icon-%@ani", [buttonNames objectAtIndex: [buttonNumber intValue]]];

	UIImage *iconani1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@1.png", iconFileName]];
	UIImage *iconani2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@2.png", iconFileName]];
	UIImage *iconani3 = [UIImage imageNamed:[NSString stringWithFormat:@"%@3.png", iconFileName]];
	UIImage *iconani4 = [UIImage imageNamed:[NSString stringWithFormat:@"%@4.png", iconFileName]];

	UIImage *iconBlank = [UIImage imageNamed:@""];
	
	UIImageView *animation1 = [[UIImageView alloc] init];
	animation1.frame = CGRectMake(0,0,75,75);
	
	NSArray *images = [[NSArray alloc] initWithObjects:iconani1, iconani2, iconani3, iconani4, nil];
	animation1.animationImages = images;
	[images release];

	switch ([buttonNumber intValue]){
		case 0: [accessoriesButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[accessoriesButton addSubview:animation1];break;
		case 1: [beliefsButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[beliefsButton addSubview:animation1];break;
		case 2: [booksButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[booksButton addSubview:animation1];break;
		case 3: [peopleButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[peopleButton addSubview:animation1];break;
		case 4: [placesButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[placesButton addSubview:animation1];break;
		case 5: [reportsButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[reportsButton addSubview:animation1];break;
		default:break;
	}
	
	animation1.animationDuration = 0.75;
	animation1.animationRepeatCount = 1;
	[animation1 startAnimating];
	
	[animation1 release];
		
	[self performSelector:@selector(buttonAnimationDone:) withObject:buttonNumber afterDelay:0.70];
	
}

/**
Implementation: Return the button's icon to default after animation finishes
 */
- (void) buttonAnimationDone:(NSNumber *) buttonNumber{
	
	NSString *iconFileName = [NSString stringWithFormat:@"icon-%@ani1.png", [buttonNames objectAtIndex:[buttonNumber intValue]]];

	switch ([buttonNumber intValue]){
		case 0: [accessoriesButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 1: [beliefsButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 2: [booksButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 3: [peopleButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 4: [placesButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 5: [reportsButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		default:break;
	}
}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    self.title = NSLocalizedString(@"ReferenceScreenTitle",@"Title for Reference Home Screen");
    
    //Local Button Titles.  Do no do this in init, XIB is not loaded until viewDidLoad
    [accessoriesLabelButton setTitle:NSLocalizedString(@"ReferenceScreenAccessoriesTitle",@"Title for Accessories Button") forState:UIControlStateNormal];	
    [peopleLabelButton setTitle:NSLocalizedString(@"ReferenceScreenPeopleTitle",@"Title for People Button") forState:UIControlStateNormal];
    [placesLabelButton setTitle:NSLocalizedString(@"ReferenceScreenMoralsTitle",@"Title for Morals Button") forState:UIControlStateNormal];
    [booksLabelButton setTitle:NSLocalizedString(@"ReferenceScreenBooksTitle",@"Title for Books Button") forState:UIControlStateNormal];
    [beliefsLabelButton setTitle:NSLocalizedString(@"ReferenceScreenBeliefsTitle",@"Title for Beliefs Button") forState:UIControlStateNormal];
    [reportsLabelButton setTitle:NSLocalizedString(@"ReferenceScreenReportsTitle",@"Title for Reports Button") forState:UIControlStateNormal];
    
	peopleLabelButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenPeopleHint",@"Hint for People Button");
	peopleButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenPeopleHint",@"Hint for People Button");
	peopleButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenPeopleLabel",@"Label for People Button");
	placesLabelButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenPlacesHint",@"Hint for Places Button");
	placesButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenMoralsHint",@"Hint for Morals Button");
	placesButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenMoralsLabel",@"Label for Morals Button");
	booksLabelButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenBooksHint",@"Hint for Books Button");
	booksButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenBooksHint",@"Hint for Books Button");
	booksButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenBooksLabel",@"Label for Books Button");
	beliefsLabelButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenBeliefsHint",@"Hint for Beliefs Button");
	beliefsButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenBeliefsHint",@"Hint for Beliefs Button");
	beliefsButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenBeliefsLabel",@"Label for Beliefs Button");
	reportsLabelButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenReportsHint",@"Hint for Reports Button");
	reportsButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenReportsHint",@"Hint for Reports Button");
	reportsButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenReportsLabel",@"Label for Reports Button");
	accessoriesLabelButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenAccessoriesHint",@"Hint for Accessories Button");
	accessoriesButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenAccessoriesHint",@"Hint for Accessories Button");
	accessoriesButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenAccessoriesLabel",@"Label for Accessories Button");    
}

#pragma mark -
#pragma mark Memory management

-(void) viewWillDisappear:(BOOL)animated {
	
	[self.buttonTimer invalidate];
	self.buttonTimer = nil;
	
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

- (void)dealloc {
	[buttonNames release];
    [super dealloc];

}

@end