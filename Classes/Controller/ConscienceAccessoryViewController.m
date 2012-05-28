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

@interface ConscienceAccessoryViewController () {
	MoraLifeAppDelegate *appDelegate;	/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
    
	IBOutlet UIView *consciencePlayground;		/**< ui for Conscience to sit */
	IBOutlet UILabel *statusMessage1;			/**< delegate for application level callbacks */
	IBOutlet UILabel *primaryAccessoryLabel;		/**< label for primary accessory outline */
	IBOutlet UILabel *secondaryAccessoryLabel;	/**< label for secondary accessory outline */
	IBOutlet UILabel *topAccessoryLabel;		/**< label for top accessory outline */
	IBOutlet UILabel *bottomAccessoryLabel;		/**< label for bottom accessory outline */
    
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

}


-(void) viewWillAppear:(BOOL)animated{

	[super viewWillAppear:animated];

	/** 
	@todo utilize consistent localization string references 
	@todo convert localization of all UIViewControllers into protocol
	*/

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

- (void)dealloc {

    [super dealloc];
}

@end
