/**
Implementation:  User selects type of ConscienceAsset by tapping on appropriate bounding box surrounding Conscience.

@class ConscienceAccessoryViewController ConscienceAccessoryViewController.h
 */

#import "ConscienceAccessoryViewController.h"
#import "ConscienceListViewController.h"
#import "UIColor+Utility.h"

int const MLConscienceCenterX = 145;
int const MLConscienceCenterY = 165;

@interface ConscienceAccessoryViewController () <ViewControllerLocalization> {
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
    
	IBOutlet UIView *consciencePlayground;		/**< ui for Conscience to sit */
	IBOutlet UILabel *statusMessage1;			/**< delegate for application level callbacks */
	IBOutlet UILabel *primaryAccessoryLabel;		/**< label for primary accessory outline */
	IBOutlet UILabel *secondaryAccessoryLabel;	/**< label for secondary accessory outline */
	IBOutlet UILabel *topAccessoryLabel;		/**< label for top accessory outline */
	IBOutlet UILabel *bottomAccessoryLabel;		/**< label for bottom accessory outline */

    IBOutlet UIButton *topAccessoryButton;          /**< button for top accessory outline */
    IBOutlet UIButton *primaryAccessoryButton;      /**< button for primary accessory outline */
    IBOutlet UIButton *bottomAccessoryButton;       /**< button for bottom accessory outline */
    IBOutlet UIButton *secondaryAccessoryButton;    /**< button for secondary accessory outline */
    IBOutlet UIButton *previousButton;              /**< button for accessing previous screen */

    NSInteger accessorySlot;
}

@property (nonatomic) IBOutlet UIImageView *previousScreen;

-(void) moveConscienceToCenter;

-(void) createList;

@end

@implementation ConscienceAccessoryViewController

#pragma mark -
#pragma mark ViewController lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    self.previousScreen.image = _screenshot;

    prefs = [NSUserDefaults standardUserDefaults];
    
    accessorySlot = 0;

    statusMessage1.textAlignment = NSTextAlignmentCenter;
    statusMessage1.textColor = [UIColor moraLifeChoiceGreen];
    statusMessage1.font = [UIFont fontForConscienceHeader];

    statusMessage1.minimumScaleFactor = 8.0/statusMessage1.font.pointSize;
    statusMessage1.numberOfLines = 1;
    statusMessage1.adjustsFontSizeToFitWidth = TRUE;

    primaryAccessoryLabel.textColor = [UIColor moraLifeBrown];
    topAccessoryLabel.textColor = [UIColor moraLifeBrown];
    bottomAccessoryLabel.textColor = [UIColor moraLifeBrown];
    secondaryAccessoryLabel.textColor = [UIColor moraLifeBrown];

	//Rotate accessoryLabels to be parallel to longest side	
	primaryAccessoryLabel.transform = CGAffineTransformMakeRotation (3.14/2);
	secondaryAccessoryLabel.transform = CGAffineTransformMakeRotation (-3.14/2);
    
    [self localizeUI];

}


-(void) viewWillAppear:(BOOL)animated{

	[super viewWillAppear:animated];

	[consciencePlayground addSubview:_userConscience.userConscienceView];

    [UIView beginAnimations:@"conscienceHide" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    _userConscience.userConscienceView.alpha = 0;
    _userConscience.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);

    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(moveConscienceToCenter)];
    
    [UIView commitAnimations];
}

-(void)setScreenshot:(UIImage *)screenshot {
    if (_screenshot != screenshot) {
        _screenshot = screenshot;
        self.previousScreen.image = screenshot;
    }
}

#pragma mark -
#pragma mark UI Interaction

-(void) moveConscienceToCenter{
    
    //Move Conscience to center of boxes
	CGPoint centerPoint = CGPointMake(MLConscienceCenterX, MLConscienceCenterY);
    _userConscience.userConscienceView.center = centerPoint;
    
    [UIView beginAnimations:@"conscienceRestore" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    _userConscience.userConscienceView.alpha = 1;
    _userConscience.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
    [UIView commitAnimations];
    
}

/**
Implementation: Present ChoiceDetailViewController to User from UINavigationBar button
 */
-(IBAction) selectChoice:(id) sender{
	
    if ([sender isKindOfClass:[UIButton class]]) {
		UIButton *senderButton = sender;
        
        accessorySlot = senderButton.tag;
    
        [UIView beginAnimations:@"conscienceHide" context:nil];
        [UIView setAnimationDuration:0.25];
        
        [UIView setAnimationBeginsFromCurrentState:YES];
        _userConscience.userConscienceView.alpha = 0;
        _userConscience.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
        [UIView setAnimationDelegate:self]; // self is a view controller
    
        if (senderButton.tag < 5) {
            [UIView setAnimationDidStopSelector:@selector(createList)];
        } else {
            [UIView setAnimationDidStopSelector:@selector(dismissAccessoryModal)];

        }    
        
        [UIView commitAnimations];


	}

        
}

-(void)createList{
    
    ConscienceListViewController *conscienceListController = [[ConscienceListViewController alloc] initWithModelManager:_modelManager andConscience:_userConscience];
    conscienceListController.screenshot = [self prepareScreenForScreenshot];
    conscienceListController.accessorySlot = accessorySlot;
    
    
    [self.navigationController pushViewController:conscienceListController animated:NO];
}

/**
 Implementation: Pop UIViewController from stack
 */
-(void)dismissAccessoryModal{
    [self.navigationController popViewControllerAnimated:FALSE];
    
}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint",nil);
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",nil);
    
    primaryAccessoryButton.accessibilityHint = NSLocalizedString(@"ConscienceAccessoryScreenPrimaryAccessoryHint",nil);
	primaryAccessoryButton.accessibilityLabel =  NSLocalizedString(@"ConscienceAccessoryScreenPrimaryAccessoryLabel",nil);
    secondaryAccessoryButton.accessibilityHint = NSLocalizedString(@"ConscienceAccessoryScreenSecondaryAccessoryHint",nil);
	secondaryAccessoryButton.accessibilityLabel =  NSLocalizedString(@"ConscienceAccessoryScreenSecondaryAccessoryLabel",nil);
    topAccessoryButton.accessibilityHint = NSLocalizedString(@"ConscienceAccessoryScreenTopAccessoryHint",nil);
	topAccessoryButton.accessibilityLabel =  NSLocalizedString(@"ConscienceAccessoryScreenTopAccessoryLabel",nil);
    bottomAccessoryButton.accessibilityHint = NSLocalizedString(@"ConscienceAccessoryScreenBottomAccessoryHint",nil);
	bottomAccessoryButton.accessibilityLabel =  NSLocalizedString(@"ConscienceAccessoryScreenBottomAccessoryLabel",nil);
    
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    topAccessoryButton = nil;
    primaryAccessoryButton = nil;
    bottomAccessoryButton = nil;
    secondaryAccessoryButton = nil;
    previousButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
