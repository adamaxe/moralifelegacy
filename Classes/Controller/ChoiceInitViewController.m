/**
Implementation:  UIViewController allows subsequent screen selection, controls button animation and resets choices by clearing NSUserDefaults.
 
@class ChoiceInitViewController ChoiceInitViewController.h
*/

#import "ChoiceInitViewController.h"
#import "ChoiceListViewController.h"
#import "ChoiceHistoryModel.h"
#import "ChoiceViewController.h"

/**
 Determines which type of list to show
 */
typedef NS_ENUM(unsigned int, MLChoiceTypeChoice) {
	MLChoiceTypeChoiceGood,
	MLChoiceTypeChoiceBad,
	MLChoiceTypeChoiceList
};

@interface ChoiceInitViewController () <ViewControllerLocalization> {
	
	NSUserDefaults *prefs;                      /**< serialized state retention */

    IBOutlet UIImageView *goodChoiceView;                /**< Container view for Good Choice */
    IBOutlet UIImageView *badChoiceView;                /**< Container view for Good Choice */
    IBOutlet UIImageView *choiceListView;                /**< Container view for Good Choice */

	IBOutlet UILabel *goodChoiceLabel;		/**< Label for Good Choice entry selection */
	IBOutlet UILabel *badChoiceLabel;		/**< Label for Bad Choice entry selection */
	IBOutlet UILabel *choiceListLabel;		/**< Label for All Choice listing selection */
	
	IBOutlet UIButton *goodChoiceButton;		/**< Button for Good Choice entry selection */
	IBOutlet UIButton *badChoiceButton;			/**< Button for Bad Choice entry selection */
	IBOutlet UIButton *choiceListButton;		/**< Button for All Choice listing selection */

    NSArray *buttonNames;

}

@property (nonatomic, strong) NSTimer *buttonTimer;		/**< determines when Conscience thought disappears */

@end

@implementation ChoiceInitViewController

#pragma mark -
#pragma mark View lifecycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
-(instancetype)initWithModelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience {

	if ((self = [super initWithModelManager:modelManager andConscience:userConscience])) {
		//Create NSUserDefaults for serialized state retention
		prefs = [NSUserDefaults standardUserDefaults];
		buttonNames = @[@"choicegood", @"choicebad", @"choicelist"];
	}
    
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

    goodChoiceButton.tag = MLChoiceTypeChoiceGood;
    badChoiceButton.tag = MLChoiceTypeChoiceBad;
    choiceListButton.tag = MLChoiceTypeChoiceList;

    self.navigationItem.hidesBackButton = YES;
    goodChoiceLabel.font = [UIFont fontForHomeScreenButtons];
    badChoiceLabel.font = [UIFont fontForHomeScreenButtons];
    choiceListLabel.font = [UIFont fontForHomeScreenButtons];

    UIBarButtonItem *choiceBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"PrimaryNav1Label", nil) style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popToRootViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = choiceBarButton;

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
        
		_conscienceHelpViewController.isConscienceOnScreen = FALSE;
        _conscienceHelpViewController.numberOfScreens = 1;
        _conscienceHelpViewController.screenshot = [self prepareScreenForScreenshot];

        [self presentViewController:_conscienceHelpViewController animated:NO completion:nil];
        
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
		NSInteger choiceIndex = senderButton.tag;
		
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

        ChoiceViewController *choiceViewController = [[ChoiceViewController alloc] initWithModelManager:_modelManager andConscience:_userConscience];

        [self.navigationController pushViewController:choiceViewController animated:YES];
    } else {

        ChoiceHistoryModel *choiceHistoryModel = [[ChoiceHistoryModel alloc] initWithModelManager:_modelManager andDefaults:prefs];
        ChoiceListViewController *choiceListCont = [[ChoiceListViewController alloc] initWithModel:choiceHistoryModel modelManager:_modelManager andConscience:_userConscience];
        [self.navigationController pushViewController:choiceListCont animated:YES];
    }

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
            case 0: goodChoiceView.image = iconani1;goodChoiceView.animationImages = images;goodChoiceView.animationDuration = animationDuration;goodChoiceView.animationRepeatCount = animationRepeatCount;break;
            case 1: badChoiceView.image = iconani1;badChoiceView.animationImages = images;badChoiceView.animationDuration = animationDuration;badChoiceView.animationRepeatCount = animationRepeatCount;break;
            case 2: choiceListView.image = iconani1;choiceListView.animationImages = images;choiceListView.animationDuration = animationDuration;choiceListView.animationRepeatCount = animationRepeatCount;break;
            default:break;
        }

    }
}

/**
 Implementation: Build animated UIImage from sequential icon files
 */
- (void) buttonAnimate:(NSNumber *) buttonNumber{

	switch (buttonNumber.intValue){

        case 0: [goodChoiceView startAnimating];break;
        case 1: [badChoiceView startAnimating];break;
        case 2: [choiceListView startAnimating];break;
        default:break;
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
