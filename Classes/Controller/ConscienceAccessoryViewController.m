/**
Implementation:  User selects type of ConscienceAsset by tapping on appropriate bounding box surrounding Conscience.

@class ConscienceAccessoryViewController ConscienceAccessoryViewController.h
 */

#import "ConscienceAccessoryViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ConscienceView.h"
#import "ConscienceListViewController.h"
#import "ConscienceAccessories.h"
#import "ConscienceAsset.h"
#import "ViewControllerLocalization.h"

int const kConscienceCenterX = 145;
int const kConscienceCenterY = 165;

@interface ConscienceAccessoryViewController () <ViewControllerLocalization> {
	MoraLifeAppDelegate *appDelegate;	/**< delegate for application level callbacks */
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

    int accessorySlot;
}

-(void) moveConscienceToCenter;

-(void) createList;

@end

@implementation ConscienceAccessoryViewController

#pragma mark -
#pragma mark ViewController lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    prefs = [NSUserDefaults standardUserDefaults];
    
    accessorySlot = 0;
    
	//Rotate accessoryLabels to be parallel to longest side	
	primaryAccessoryLabel.transform = CGAffineTransformMakeRotation (3.14/2);
	secondaryAccessoryLabel.transform = CGAffineTransformMakeRotation (-3.14/2);
    
    [self localizeUI];

}


-(void) viewWillAppear:(BOOL)animated{

	[super viewWillAppear:animated];

	//[statusMessage1 setText:NSLocalizedString(@"ConscienceAccessoryStatusLabel",@"Label for status label")];

	[consciencePlayground addSubview:appDelegate.userConscienceView];

	//Move Conscience to center of boxes
//	CGPoint centerPoint = CGPointMake(kConscienceCenterX, kConscienceCenterY);

//	[UIView beginAnimations:@"MoveConscience" context:nil];
//	[UIView setAnimationDuration:0.5];
//	[UIView setAnimationBeginsFromCurrentState:YES];
//	appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//
//	appDelegate.userConscienceView.center = centerPoint;
//	
//	[UIView commitAnimations];
//	
//	[appDelegate.userConscienceView setNeedsDisplay];

    [UIView beginAnimations:@"conscienceHide" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    appDelegate.userConscienceView.alpha = 0;
    appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);

//    appDelegate.userConscienceView.center = centerPoint;
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(moveConscienceToCenter)];
    
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UI Interaction

-(void) moveConscienceToCenter{
    
    //Move Conscience to center of boxes
	CGPoint centerPoint = CGPointMake(kConscienceCenterX, kConscienceCenterY);
    appDelegate.userConscienceView.center = centerPoint;
    
    [UIView beginAnimations:@"conscienceRestore" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    appDelegate.userConscienceView.alpha = 1;
    appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
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
        appDelegate.userConscienceView.alpha = 0;
        appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
        //    appDelegate.userConscienceView.center = centerPoint;
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
    
    ConscienceListViewController *conscienceListCont = [[ConscienceListViewController alloc] init];
    
    [conscienceListCont setAccessorySlot:accessorySlot];
    
    
    [self.navigationController pushViewController:conscienceListCont animated:NO];
    [conscienceListCont release];
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
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint", @"Hint for previous button");
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",@"Label for previous button");
    
    primaryAccessoryButton.accessibilityHint = NSLocalizedString(@"ConscienceAccessoryScreenPrimaryAccessoryHint",@"Hint for Primary Accessory Button");
	primaryAccessoryButton.accessibilityLabel =  NSLocalizedString(@"ConscienceAccessoryScreenPrimaryAccessoryLabel",@"Label for Primary Accessory Button");
    secondaryAccessoryButton.accessibilityHint = NSLocalizedString(@"ConscienceAccessoryScreenSecondaryAccessoryHint",@"Hint for Secondary Accessory Button");
	secondaryAccessoryButton.accessibilityLabel =  NSLocalizedString(@"ConscienceAccessoryScreenSecondaryAccessoryLabel",@"Label for Secondary Accessory Button");
    topAccessoryButton.accessibilityHint = NSLocalizedString(@"ConscienceAccessoryScreenTopAccessoryHint",@"Hint for Top Accessory Button");
	topAccessoryButton.accessibilityLabel =  NSLocalizedString(@"ConscienceAccessoryScreenTopAccessoryLabel",@"Label for Top Accessory Button");
    bottomAccessoryButton.accessibilityHint = NSLocalizedString(@"ConscienceAccessoryScreenBottomAccessoryHint",@"Hint for Bottom Accessory Button");
	bottomAccessoryButton.accessibilityLabel =  NSLocalizedString(@"ConscienceAccessoryScreenBottomAccessoryLabel",@"Label for Bottom Accessory Button");
    
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [topAccessoryButton release];
    topAccessoryButton = nil;
    [primaryAccessoryButton release];
    primaryAccessoryButton = nil;
    [bottomAccessoryButton release];
    bottomAccessoryButton = nil;
    [secondaryAccessoryButton release];
    secondaryAccessoryButton = nil;
    [previousButton release];
    previousButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {

    [topAccessoryButton release];
    [primaryAccessoryButton release];
    [bottomAccessoryButton release];
    [secondaryAccessoryButton release];
    [previousButton release];
    [super dealloc];
}

@end
