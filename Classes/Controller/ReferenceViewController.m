/**
Implementation:  UIViewController allows subsequent screen selection, controls button animation and resets choices by clearing NSUserDefaults.
 
@class ReferenceViewController ReferenceViewController.h
 */

#import "MoraLifeAppDelegate.h"
#import "ReferenceViewController.h"
#import "ReferenceListViewController.h"
#import "ReferenceModel.h"
#import "ConscienceHelpViewController.h"
#import "MenuScreenAnimations.h"
#import "ViewControllerLocalization.h"

@interface ReferenceViewController () <MenuScreenAnimations, ViewControllerLocalization> {
        
	IBOutlet UIButton *peopleLabelButton;		/**< label for People button */
	IBOutlet UIButton *moralsLabelButton;		/**< label for Morals button */
	IBOutlet UIButton *booksLabelButton;		/**< label for Books button */
	IBOutlet UIButton *beliefsLabelButton;		/**< label for Beliefs button */
	IBOutlet UIButton *reportsLabelButton;		/**< label for Reports button */
	IBOutlet UIButton *accessoriesLabelButton;	/**< label for Accessories button */
	
	IBOutlet UIButton *peopleButton;		/**< label for People button */
	IBOutlet UIButton *moralsButton;		/**< label for Places button */
	IBOutlet UIButton *booksButton;		/**< label for Books button */
	IBOutlet UIButton *beliefsButton;		/**< label for Beliefs button */
	IBOutlet UIButton *reportsButton;		/**< label for Reports button */
	IBOutlet UIButton *accessoriesButton;	/**< label for Accessories button */
	
	NSArray *buttonNames;
    
}

@property (nonatomic, strong) NSTimer *buttonTimer;		/**< determines when Conscience thought disappears */

@end

@implementation ReferenceViewController

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		
		//Array to hold button names for random animations
		buttonNames = @[@"accessories", @"beliefs", @"books", @"people", @"choicegood", @"reports"];

        //Assign buttons to reference Types
        peopleButton.tag = MLReferenceModelTypePerson;
        moralsButton.tag = MLReferenceModelTypeMoral;
        booksButton.tag = MLReferenceModelTypeText;
        beliefsButton.tag = MLReferenceModelTypeBelief;
        reportsButton.tag = MLReferenceModelTypeReferenceAsset;
        accessoriesButton.tag = MLReferenceModelTypeConscienceAsset;

        peopleLabelButton.tag = MLReferenceModelTypePerson;
        moralsLabelButton.tag = MLReferenceModelTypeMoral;
        booksLabelButton.tag = MLReferenceModelTypeText;
        beliefsLabelButton.tag = MLReferenceModelTypeBelief;
        reportsLabelButton.tag = MLReferenceModelTypeReferenceAsset;
        accessoriesLabelButton.tag = MLReferenceModelTypeConscienceAsset;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSObject *firstReferenceCheck = [prefs objectForKey:@"firstReference"];
    
    if (firstReferenceCheck == nil) {
        
        ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
        [conscienceHelpViewCont setViewControllerClassName:NSStringFromClass([self class])];        
		[conscienceHelpViewCont setIsConscienceOnScreen:FALSE];
        [conscienceHelpViewCont setHelpVersion:0];
		[self presentModalViewController:conscienceHelpViewCont animated:NO];
        
        [prefs setBool:FALSE forKey:@"firstReference"];
        
    }
}

/**
Implementation: Determine which type of reference is requested by the User.
 */
- (IBAction) selectReferenceType:(id) sender{
	
	//Create view controller to be pushed upon navigation stack
    ReferenceModel *referenceModel = [[ReferenceModel alloc] init];

	//Determine which choice was selected
	if ([sender isKindOfClass:[UIButton class]]) {
		UIButton *senderButton = sender;
        referenceModel.referenceType = senderButton.tag;

	}
    
    ReferenceListViewController *referenceListViewCont = [[ReferenceListViewController alloc] initWithModel:referenceModel];
    [self.navigationController pushViewController:referenceListViewCont animated:YES];

}

#pragma mark -
#pragma mark MenuScreenAnimationsProtocol

/**
Implementation: Only animate at most 4 buttons at a time.  Otherwise, too visually distracting
 */
- (void) refreshButtons{
	
	[self buttonAnimate:@(arc4random()%6)];
	[self buttonAnimate:@(arc4random()%6)];
	[self buttonAnimate:@(arc4random()%6)];
	[self buttonAnimate:@(arc4random()%6)];
}

/**
Implementation: Build animated UIImage from sequential icon files
 */
- (void) buttonAnimate:(NSNumber *) buttonNumber{
	
	NSString *iconFileName = [NSString stringWithFormat:@"icon-%@ani", buttonNames[[buttonNumber intValue]]];

	UIImage *iconani1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@1.png", iconFileName]];
	UIImage *iconani2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@2.png", iconFileName]];
	UIImage *iconani3 = [UIImage imageNamed:[NSString stringWithFormat:@"%@3.png", iconFileName]];
	UIImage *iconani4 = [UIImage imageNamed:[NSString stringWithFormat:@"%@4.png", iconFileName]];

	UIImage *iconBlank = [UIImage imageNamed:@""];
	
	UIImageView *animation1 = [[UIImageView alloc] init];
	animation1.frame = CGRectMake(0,0,75,75);
	
	NSArray *images = @[iconani1, iconani2, iconani3, iconani4];
	animation1.animationImages = images;

	switch ([buttonNumber intValue]){
		case 0: [accessoriesButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[accessoriesButton addSubview:animation1];break;
		case 1: [beliefsButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[beliefsButton addSubview:animation1];break;
		case 2: [booksButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[booksButton addSubview:animation1];break;
		case 3: [peopleButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[peopleButton addSubview:animation1];break;
		case 4: [moralsButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[moralsButton addSubview:animation1];break;
		case 5: [reportsButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[reportsButton addSubview:animation1];break;
		default:break;
	}
	
	animation1.animationDuration = 0.75;
	animation1.animationRepeatCount = 1;
	[animation1 startAnimating];
	
		
	[self performSelector:@selector(buttonAnimationDone:) withObject:buttonNumber afterDelay:0.70];
	
}

/**
Implementation: Return the button's icon to default after animation finishes
 */
- (void) buttonAnimationDone:(NSNumber *) buttonNumber{
	
	NSString *iconFileName = [NSString stringWithFormat:@"icon-%@ani1.png", buttonNames[[buttonNumber intValue]]];

	switch ([buttonNumber intValue]){
		case 0: [accessoriesButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 1: [beliefsButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 2: [booksButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 3: [peopleButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 4: [moralsButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 5: [reportsButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		default:break;
	}
}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    self.title = NSLocalizedString(@"ReferenceScreenTitle",nil);
    
    //Local Button Titles.  Do no do this in init, XIB is not loaded until viewDidLoad
    [accessoriesLabelButton setTitle:NSLocalizedString(@"ReferenceScreenAccessoriesTitle",nil) forState:UIControlStateNormal];	
    [peopleLabelButton setTitle:NSLocalizedString(@"ReferenceScreenPeopleTitle",nil) forState:UIControlStateNormal];
    [moralsLabelButton setTitle:NSLocalizedString(@"ReferenceScreenMoralsTitle",nil) forState:UIControlStateNormal];
    [booksLabelButton setTitle:NSLocalizedString(@"ReferenceScreenBooksTitle",nil) forState:UIControlStateNormal];
    [beliefsLabelButton setTitle:NSLocalizedString(@"ReferenceScreenBeliefsTitle",nil) forState:UIControlStateNormal];
    [reportsLabelButton setTitle:NSLocalizedString(@"ReferenceScreenReportsTitle",nil) forState:UIControlStateNormal];
    
	peopleLabelButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenPeopleHint",nil);
	peopleButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenPeopleHint",nil);
	peopleButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenPeopleLabel",nil);
	moralsLabelButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenMoralsHint",nil);
	moralsButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenMoralsHint",nil);
	moralsButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenMoralsLabel",nil);
	booksLabelButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenBooksHint",nil);
	booksButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenBooksHint",nil);
	booksButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenBooksLabel",nil);
	beliefsLabelButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenBeliefsHint",nil);
	beliefsButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenBeliefsHint",nil);
	beliefsButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenBeliefsLabel",nil);
	reportsLabelButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenReportsHint",nil);
	reportsButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenReportsHint",nil);
	reportsButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenReportsLabel",nil);
	accessoriesLabelButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenAccessoriesHint",nil);
	accessoriesButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenAccessoriesHint",nil);
	accessoriesButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenAccessoriesLabel",nil);    
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


@end