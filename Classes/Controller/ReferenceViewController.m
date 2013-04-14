/**
Implementation:  UIViewController allows subsequent screen selection, controls button animation and resets choices by clearing NSUserDefaults.
 
@class ReferenceViewController ReferenceViewController.h
 */

#import "ReferenceViewController.h"
#import "ReferenceListViewController.h"
#import "ReferenceModel.h"

@interface ReferenceViewController () <ViewControllerLocalization> {

    IBOutlet UIImageView *accessoriesView;    /**< view for Accessories */
    IBOutlet UIImageView *peopleView;        /**< view for People */
    IBOutlet UIImageView *moralsView;        /**< view for Morals */

	IBOutlet UILabel *peopleLabel;		/**< label for People button */
	IBOutlet UILabel *moralsLabel;		/**< label for Morals button */
	IBOutlet UILabel *accessoriesLabel;	/**< label for Accessories button */
	
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

-(id)initWithModelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience {
	if ((self = [super initWithModelManager:modelManager andConscience:userConscience])) {
		//Array to hold button names for random animations
		buttonNames = @[@"accessories", @"people", @"choicelist"];
	}

	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //Assign buttons to reference Types
    accessoriesButton.tag = MLReferenceModelTypeConscienceAsset;
    peopleButton.tag = MLReferenceModelTypePerson;
    moralsButton.tag = MLReferenceModelTypeMoral;

    self.navigationItem.hidesBackButton = YES;
    peopleLabel.font = [UIFont fontForScreenButtons];
    moralsLabel.font = [UIFont fontForScreenButtons];
    accessoriesLabel.font = [UIFont fontForScreenButtons];

    UIBarButtonItem *choiceBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popToRootViewControllerAnimated:)];
    [self.navigationItem setLeftBarButtonItem:choiceBarButton];

    [self localizeUI];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self buildButtons];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

	[self refreshButtons];

	self.buttonTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshButtons) userInfo:nil repeats:YES];

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
        
        ConscienceHelpViewController *conscienceHelpViewController = [[ConscienceHelpViewController alloc] initWithConscience:_userConscience];
        conscienceHelpViewController.viewControllerClassName = NSStringFromClass([self class]);
		conscienceHelpViewController.isConscienceOnScreen = FALSE;
        conscienceHelpViewController.numberOfScreens = 1;

        conscienceHelpViewController.screenshot = [self prepareScreenForScreenshot];

		[self presentModalViewController:conscienceHelpViewController animated:NO];
        
        [prefs setBool:FALSE forKey:@"firstReference"];
        
    }
}

/**
Implementation: Determine which type of reference is requested by the User.
 */
- (IBAction) selectReferenceType:(id) sender{
	
    ReferenceModel *referenceModel = [[ReferenceModel alloc] initWithModelManager:_modelManager andDefaults:[NSUserDefaults standardUserDefaults] andUserCollection:_userConscience.conscienceCollection];
    
	//Determine which choice was selected
	if ([sender isKindOfClass:[UIButton class]]) {
		UIButton *senderButton = sender;
        referenceModel.referenceType = senderButton.tag;

	}

    ReferenceListViewController *referenceListViewCont = [[ReferenceListViewController alloc] initWithModel:referenceModel modelManager:_modelManager andConscience:_userConscience];
    [self.navigationController pushViewController:referenceListViewCont animated:TRUE];

}

#pragma mark -
#pragma mark Menu Screen Animations

/**
 Implementation: Only animate at most 2 buttons at a time.  Otherwise, too visually distracting
 */
- (void) refreshButtons{

	[self buttonAnimate:@(arc4random()%3)];
	[self buttonAnimate:@(arc4random()%3)];
}

/**
 Implementation: Build animated UIImage from sequential icon files
 */
- (void) buildButtons{

    CGFloat animationDuration = 0.75;
    int animationRepeatCount = 1;
    
    for (int i = 0; i < 3; i++) {

        NSString *iconFileName = [NSString stringWithFormat:@"icon-%@ani", buttonNames[i]];

        UIImage *iconani1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@1.png", iconFileName]];
        UIImage *iconani2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@2.png", iconFileName]];
        UIImage *iconani3 = [UIImage imageNamed:[NSString stringWithFormat:@"%@3.png", iconFileName]];
        UIImage *iconani4 = [UIImage imageNamed:[NSString stringWithFormat:@"%@4.png", iconFileName]];

        NSArray *images = @[iconani1, iconani2, iconani3, iconani4];

        switch (i){
            case 0: accessoriesView.image = iconani1;accessoriesView.animationImages = images;accessoriesView.animationDuration = animationDuration;accessoriesView.animationRepeatCount = animationRepeatCount;break;
            case 1: peopleView.image = iconani1;peopleView.animationImages = images;peopleView.animationDuration = animationDuration;peopleView.animationRepeatCount = animationRepeatCount;break;
            case 2: moralsView.image = iconani1;moralsView.animationImages = images;moralsView.animationDuration = animationDuration;moralsView.animationRepeatCount = animationRepeatCount;break;
            default:break;
        }
        
    }
}

/**
 Implementation: Build animated UIImage from sequential icon files
 */
- (void) buttonAnimate:(NSNumber *) buttonNumber{

	switch ([buttonNumber intValue]){

        case 0: [accessoriesView startAnimating];break;
        case 1: [peopleView startAnimating];break;
        case 2: [moralsView startAnimating];break;
        default:break;
	}
    
}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    self.title = NSLocalizedString(@"ReferenceScreenTitle",nil);
    
    //Local Button Titles.  Do no do this in init, XIB is not loaded until viewDidLoad
    accessoriesLabel.text = NSLocalizedString(@"ReferenceScreenAccessoriesTitle",nil);
    peopleLabel.text = NSLocalizedString(@"ReferenceScreenPeopleTitle",nil);
    moralsLabel.text = NSLocalizedString(@"ReferenceScreenMoralsTitle",nil);
    
	peopleLabel.accessibilityHint = NSLocalizedString(@"ReferenceScreenPeopleHint",nil);
	peopleButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenPeopleHint",nil);
	peopleButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenPeopleLabel",nil);
	moralsLabel.accessibilityHint = NSLocalizedString(@"ReferenceScreenMoralsHint",nil);
	moralsButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenMoralsHint",nil);
	moralsButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenMoralsLabel",nil);
	accessoriesLabel.accessibilityHint = NSLocalizedString(@"ReferenceScreenAccessoriesHint",nil);
	accessoriesButton.accessibilityHint = NSLocalizedString(@"ReferenceScreenAccessoriesHint",nil);
	accessoriesButton.accessibilityLabel = NSLocalizedString(@"ReferenceScreenAccessoriesLabel",nil);    
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