/**
Implementation:  UIViewController allows subsequent screen selection, controls button animation and resets choices by clearing NSUserDefaults.
 
@class ChoiceInitViewController ChoiceInitViewController.h
*/

#import "ChoiceInitViewController.h"
#import "UserConscience.h"
#import "ChoiceListViewController.h"
#import "ChoiceHistoryModel.h"
#import "ChoiceViewController.h"
#import "ConscienceHelpViewController.h"
#import "ViewControllerLocalization.h"
#import "UIViewController+Screenshot.h"
#import "UIFont+Utility.h"

@interface ChoiceInitViewController () <ViewControllerLocalization> {
	
	NSUserDefaults *prefs;                      /**< serialized state retention */

    IBOutlet UIView *goodChoiceView;                /**< Container view for Good Choice */
    IBOutlet UIView *badChoiceView;                /**< Container view for Good Choice */
    IBOutlet UIView *choiceListView;                /**< Container view for Good Choice */

	IBOutlet UILabel *goodChoiceLabel;		/**< Label for Good Choice entry selection */
	IBOutlet UILabel *badChoiceLabel;		/**< Label for Bad Choice entry selection */
	IBOutlet UILabel *choiceListLabel;		/**< Label for All Choice listing selection */
	
	IBOutlet UIButton *goodChoiceButton;		/**< Button for Good Choice entry selection */
	IBOutlet UIButton *badChoiceButton;			/**< Button for Bad Choice entry selection */
	IBOutlet UIButton *choiceListButton;		/**< Button for All Choice listing selection */
}

@property (nonatomic) UserConscience *userConscience;

@end

@implementation ChoiceInitViewController

#pragma mark -
#pragma mark View lifecycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
-(id)initWithConscience:(UserConscience *)userConscience {

	if ((self = [super init])) {
		//Create NSUserDefaults for serialized state retention
		prefs = [NSUserDefaults standardUserDefaults];
        self.userConscience = userConscience;
		
	}
    
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

    goodChoiceLabel.font = [UIFont fontForHomeScreenButtons];
    badChoiceLabel.font = [UIFont fontForHomeScreenButtons];
    choiceListLabel.font = [UIFont fontForHomeScreenButtons];

    self.navigationItem.hidesBackButton = YES;

    UIBarButtonItem *choiceBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popToRootViewControllerAnimated:)];
    [self.navigationItem setLeftBarButtonItem:choiceBarButton];

    [self localizeUI];
}

- (void) viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];

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
        
        ConscienceHelpViewController *conscienceHelpViewController = [[ConscienceHelpViewController alloc] initWithConscience:self.userConscience];
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

        ChoiceViewController *choiceViewController = [[ChoiceViewController alloc] initWithConscience:self.userConscience];

        [self.navigationController pushViewController:choiceViewController animated:YES];
    } else {

        ChoiceHistoryModel *choiceHistoryModel = [[ChoiceHistoryModel alloc] init];
        ChoiceListViewController *choiceListCont = [[ChoiceListViewController alloc] initWithModel:choiceHistoryModel andConscience:self.userConscience];
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
	goodChoiceLabel.text = NSLocalizedString(@"ChoiceInitScreenChoiceGoodLabel",nil);
	badChoiceLabel.text = NSLocalizedString(@"ChoiceInitScreenChoiceBadLabel",nil);
	choiceListLabel.text = NSLocalizedString(@"ChoiceInitScreenChoiceListLabel",nil);
	goodChoiceLabel.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceGoodHint",nil);
	badChoiceLabel.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceBadHint",nil);
	choiceListLabel.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceListHint",nil);		
	goodChoiceButton.accessibilityLabel = NSLocalizedString(@"ChoiceInitScreenChoiceGoodLabel",nil);
	badChoiceButton.accessibilityLabel = NSLocalizedString(@"ChoiceInitScreenChoiceBadLabel",nil);
	choiceListButton.accessibilityLabel = NSLocalizedString(@"ChoiceInitScreenChoiceListLabel",nil);
	goodChoiceButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceGoodHint",nil);
	badChoiceButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceBadHint",nil);
	choiceListButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceListHint",nil);
	
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end