/**
Implementation: Present a menu of options to User.
Determine what information needs to be passed to subsequent UIViewController depending upon User Choice.
User selection causes selectChoice to be called which sets the currentState variable to which version of the screen should be presented.
 
@class ConscienceModalViewController ConscienceModalViewController.h
 */

#import "MoraLifeAppDelegate.h"
#import "ConscienceBody.h"
#import "ConscienceView.h"
#import "ConscienceModalViewController.h"
#import "ConscienceAccessoryViewController.h"
#import "ConscienceListViewController.h"
#import "ConscienceActionViewController.h"
#import "DilemmaListViewController.h"
#import "ConscienceAsset.h"
#import "ConscienceHelpViewController.h"
#import "ReportPieViewController.h"

@implementation ConscienceModalViewController

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];

	//appDelegate needed to retrieve CoreData Context, prefs used to save form state
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	prefs = [NSUserDefaults standardUserDefaults];

	/** @todo change hardcoded selection descriptions into localized strings */
	buttonImages = [[NSMutableDictionary alloc] init];
	buttonLabels = [[NSMutableDictionary alloc] init];
	screenTitles = [[NSArray alloc] initWithObjects:@"What do you need?", @"What would you like to change?", @"Morathology Campaigns", @"Which Setting would you like to change?", @" ", @"Which feature?", @"What would you like to color?",  @"Which Accessory type?", @"What information?", nil];
	
	currentState = 0;

	//Set visuals to invisible on load to make them fade into view	
	thoughtModalArea.alpha = 0;

	/** @todo determine better screen loading method */
	NSArray *tempButtonImages = [[NSArray alloc] initWithObjects:@"icon-customization.png", @"icon-rank.png", @"icon-piechart.png", @" ",nil];
	[buttonImages setObject:tempButtonImages forKey:@"0"];
	[tempButtonImages release];

	NSArray *tempButtonLabels = [[NSArray alloc] initWithObjects:@"Greenroom", @"Morathology", @"Moral Report", @" ", nil];
	[buttonLabels setValue:tempButtonLabels forKey:@"0"];
	[tempButtonLabels release];
	
	tempButtonImages = [[NSArray alloc] initWithObjects:@"icon-features.png", @"icon-palette.png", @"icon-accessories.png", @" ",nil];
	[buttonImages setValue:tempButtonImages forKey:@"1"];
	[tempButtonImages release];
	
	tempButtonLabels = [[NSArray alloc] initWithObjects:@"Western", @"Atlantic", @"Coming Sooner!", @"Coming Soon!", nil];
	[buttonLabels setValue:tempButtonLabels forKey:@"2"];
	[tempButtonLabels release];
	
	tempButtonImages = [[NSArray alloc] initWithObjects:@"icon-placesani1.png", @"icon-placesani2.png", @"icon-placesani3.png", @"icon-placesani4.png",nil];
	[buttonImages setValue:tempButtonImages forKey:@"2"];
	[tempButtonImages release];
	
	tempButtonLabels = [[NSArray alloc] initWithObjects:@"Features", @"Colors", @"Accessories", @" ", nil];
	[buttonLabels setValue:tempButtonLabels forKey:@"1"];
	[tempButtonLabels release];
    
	tempButtonImages = [[NSArray alloc] initWithObjects:@"icon-resetapp.png", @" ", @" ", @" ",nil];
	[buttonImages setValue:tempButtonImages forKey:@"3"];
	[tempButtonImages release];
	
	tempButtonLabels = [[NSArray alloc] initWithObjects:@"Reset Application", @" ", @" ", @" ", nil];
	[buttonLabels setValue:tempButtonLabels forKey:@"3"];
	[tempButtonLabels release];	
	
	tempButtonImages = [[NSArray alloc] initWithObjects:@"icon-eye.png", @"icon-symbol.png", @"icon-mouth.png", @"icon-bubble.png",nil];
	[buttonImages setValue:tempButtonImages forKey:@"5"];
	[tempButtonImages release];
	
	tempButtonLabels = [[NSArray alloc] initWithObjects:@"Eye", @"Face", @"Mouth", @"Bubble", nil];
	[buttonLabels setValue:tempButtonLabels forKey:@"5"];
	[tempButtonLabels release];
	
	tempButtonImages = [[NSArray alloc] initWithObjects:@"icon-eye.png", @"icon-brow.png", @"icon-bubble.png", @"icon-none.png",nil];
	[buttonImages setValue:tempButtonImages forKey:@"6"];
	[tempButtonImages release];
	
	tempButtonLabels = [[NSArray alloc] initWithObjects:@"Eye", @"Brow", @"Bubble", @" ", nil];
	[buttonLabels setValue:tempButtonLabels forKey:@"6"];
	[tempButtonLabels release];	
    	
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	//Add User Conscience to view
	[thoughtModalArea addSubview:appDelegate.userConscienceView];
	
	//Flip Conscience direction if facing left
	if (appDelegate.userConscienceView.directionFacing == kDirectionFacingLeft) {
		
		[UIView beginAnimations:@"conscienceFlipper" context:nil];
		[UIView setAnimationDuration:0.25];
	
		[UIView setAnimationBeginsFromCurrentState:YES];
		appDelegate.userConscienceView.alpha = 0;
		[UIView setAnimationDelegate:appDelegate.userConscienceView]; // self is a view controller
		[UIView setAnimationDidStopSelector:@selector(removeConscienceInvisibility)];
	
		[UIView commitAnimations];
	}
	
	//Move Conscience to Lower left screen to emulate thought bubble
//	CGPoint centerPoint = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY);
//	
    
    //Move Conscience to center of boxes
	CGPoint centerPoint = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY);
    appDelegate.userConscienceView.center = centerPoint;
    
	[UIView beginAnimations:@"FadeInView" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	thoughtModalArea.alpha = 1;
//    appDelegate.userConscienceView.alpha = 1;
//	
//	appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(kConscienceLargeSizeX, kConscienceLargeSizeY);
//
//	appDelegate.userConscienceView.center = centerPoint;
//	
	[UIView commitAnimations];
//
//	[appDelegate.userConscienceView setNeedsDisplay];
    
    [UIView beginAnimations:@"conscienceHide" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationBeginsFromCurrentState:NO];
    appDelegate.userConscienceView.alpha = 0;
    
    //    appDelegate.userConscienceView.center = centerPoint;
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(moveConscienceToBottom)];
    
    [UIView commitAnimations];
    
    
    //Determine if previous UIViewController is requesting to reset the home screen
    NSObject *homeResetCheck = [prefs objectForKey:@"conscienceModalReset"];
    
    if (homeResetCheck != nil) {
        
        [prefs  removeObjectForKey:@"conscienceModalReset"];
        currentState = 0;
    }
    
    [self changeSelectionScreen];
	 
}

-(void)viewDidAppear:(BOOL)animated {
    
    [UIView beginAnimations:@"conscienceHide" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationBeginsFromCurrentState:NO];
    appDelegate.userConscienceView.alpha = 0;
    
    //    appDelegate.userConscienceView.center = centerPoint;
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(moveConscienceToBottom)];
    
    [UIView commitAnimations];
    
}

#pragma mark - UI Interaction

-(void) moveConscienceToBottom{
    
    //Move Conscience to center of boxes
	CGPoint centerPoint = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY);
    appDelegate.userConscienceView.center = centerPoint;
    
    [UIView beginAnimations:@"conscienceRestore" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    appDelegate.userConscienceView.alpha = 1;
    appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(kConscienceLargeSizeX, kConscienceLargeSizeY);
    
    [UIView commitAnimations];
    
}

/**
Implementation:  Determines which view was requested by User, changes currentState of screen for subsequent view changes.
Determines if current screen should change or if another UIViewController needs to be loaded.
 */
- (IBAction) selectChoice:(id) sender{

	//Determine which button was pushed
	//Change options accordingly

	if ([sender isKindOfClass:[UIButton class]]) {
		UIButton *senderButton = sender;
		int choiceIndex = senderButton.tag;

		switch (choiceIndex){
			case 0:currentState = 1;[self changeSelectionScreen];break;
//			case 1:[self selectController:choiceIndex];break;
			case 1:currentState = 2;[self changeSelectionScreen];break;
			case 2:[self selectController:choiceIndex];break;
			case 3:currentState = 4;[self changeSelectionScreen];break;
			case 4:currentState = 5;[self changeSelectionScreen];break;
			case 5:currentState = 6;[self changeSelectionScreen];break;
			case 6:[self selectController:choiceIndex];break;
			case 7:currentState = 8;[self changeSelectionScreen];break;
//			case 8:currentState = 9;[self changeSelectionScreen];break;
//			case 9:currentState = 10;[self changeSelectionScreen];break;
//			case 10:currentState = 11;[self changeSelectionScreen];break;			
//			case 11:currentState = 12;[self changeSelectionScreen];break;			
			case 8:[self selectController:choiceIndex];break;
			case 9:[self selectController:choiceIndex];break;
//			case 10:[self selectController:choiceIndex];break;			
//			case 11:[self selectController:choiceIndex];break;
			case 12:/*[self selectController:choiceIndex];*/break;
			case 20:[self selectController:choiceIndex];break;
			case 21:[self selectController:choiceIndex];break;
			case 22:[self selectController:choiceIndex];break;
			case 23:[self selectController:choiceIndex];break;
			case 24:[self selectController:choiceIndex];break;
			case 25:[self selectController:choiceIndex];break;
			case 26:[self selectController:choiceIndex];break;					
			default:break;
		}
		
	}
	
}

/**
Implementation:  Set the Status message at top of screen and the image and label of each button.  Button tags are updated to reflect new version of the screen.
 */
- (void) changeSelectionScreen{

	//Change buttons and status bar for appropriate requested screen
	statusMessage1.text = (NSString *)[screenTitles objectAtIndex:currentState];

	//Set button image and names, set tags for screen derivation
	NSString *buttonImageName = (NSString *)[[buttonImages objectForKey:[NSString stringWithFormat:@"%d", currentState]] objectAtIndex:0];
	NSString *buttonLabel = (NSString *)[[buttonLabels objectForKey:[NSString stringWithFormat:@"%d", currentState]] objectAtIndex:0];
	[button1 setBackgroundImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal]; 
	[labelButton1 setTitle:buttonLabel forState: UIControlStateNormal];
	button1.tag = currentState*4;
	labelButton1.tag = currentState*4;

	buttonImageName = (NSString *)[[buttonImages objectForKey:[NSString stringWithFormat:@"%d", currentState]] objectAtIndex:1];
	buttonLabel = (NSString *)[[buttonLabels objectForKey:[NSString stringWithFormat:@"%d", currentState]] objectAtIndex:1];
	[button2 setBackgroundImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal]; 
	[labelButton2 setTitle:buttonLabel forState: UIControlStateNormal];
	button2.tag = currentState*4 + 1;
	labelButton2.tag = currentState*4 + 1;

	buttonImageName = (NSString *)[[buttonImages objectForKey:[NSString stringWithFormat:@"%d", currentState]] objectAtIndex:2];
	buttonLabel = (NSString *)[[buttonLabels objectForKey:[NSString stringWithFormat:@"%d", currentState]] objectAtIndex:2];
	[button3 setBackgroundImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal]; 
	[labelButton3 setTitle:buttonLabel forState: UIControlStateNormal];
	button3.tag = currentState*4 + 2;
	labelButton3.tag = currentState*4 + 2;

	buttonImageName = (NSString *)[[buttonImages objectForKey:[NSString stringWithFormat:@"%d", currentState]] objectAtIndex:3];
	buttonLabel = (NSString *)[[buttonLabels objectForKey:[NSString stringWithFormat:@"%d", currentState]] objectAtIndex:3];
	[button4 setBackgroundImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal]; 
	[labelButton4 setTitle:buttonLabel forState: UIControlStateNormal];
	button4.tag = currentState*4 + 3;
	labelButton4.tag = currentState*4 + 3;

}

/**
Implementation:  Determines which UIViewController was requested by User.  Loads correct UIViewController and sets its required fields.
@todo refactor to more intelligently select correct View Controller
 */
- (void) selectController:(int) controllerID{
	
	BOOL isListViewControllerNeeded = FALSE;
	BOOL isDilemmaViewControllerNeeded = FALSE;
	int requestedAccessorySlot = 0;
	int requestedCampaign = 0;
	
	//Determine if a new view controller has been requested
	if (controllerID > 0) {

		switch (controllerID) {
			case 2:{
				ReportPieViewController *reportPieViewCont = [[ReportPieViewController alloc] initWithNibName:@"ReportPieView" bundle:[NSBundle mainBundle]];
				[prefs setBool:TRUE forKey:@"reportIsGood"];
                
				[self.navigationController pushViewController:reportPieViewCont animated:NO];
                
				[reportPieViewCont release];

			}
				break;
			case 6:{
				ConscienceAccessoryViewController *conscienceAccessoryCont = [[ConscienceAccessoryViewController alloc] initWithNibName:@"ConscienceAccessoryView" bundle:[NSBundle mainBundle]];
                
				[self.navigationController pushViewController:conscienceAccessoryCont animated:NO];
				[conscienceAccessoryCont release];
			}
				break;
                
			case 8:requestedCampaign=1;isDilemmaViewControllerNeeded = TRUE;break;
			case 9:requestedCampaign=2;isDilemmaViewControllerNeeded = TRUE;break;
			case 10:requestedCampaign=3;isDilemmaViewControllerNeeded = TRUE;break;
			case 11:requestedCampaign=4;isDilemmaViewControllerNeeded = TRUE;break;                
			case 12:[self removeUserData];break;                
			case 20:requestedAccessorySlot = 4;isListViewControllerNeeded = TRUE;break;
			case 21:requestedAccessorySlot = 5;isListViewControllerNeeded = TRUE;break;
			case 22:requestedAccessorySlot = 6;isListViewControllerNeeded = TRUE;break;
			case 23:requestedAccessorySlot = 10;isListViewControllerNeeded = TRUE;break;
			case 24:requestedAccessorySlot = 7;isListViewControllerNeeded = TRUE;break;
			case 25:requestedAccessorySlot = 8;isListViewControllerNeeded = TRUE;break;
			case 26:requestedAccessorySlot = 9;isListViewControllerNeeded = TRUE;break;
			default:
				break;
		}
	}	

	//Present a list of choices for accessories	
	if (isListViewControllerNeeded) {

		ConscienceListViewController *conscienceListCont = [[ConscienceListViewController alloc] initWithNibName:@"ConscienceListView" bundle:[NSBundle mainBundle]];
		[conscienceListCont setAccessorySlot:requestedAccessorySlot];
		[self.navigationController pushViewController:conscienceListCont animated:NO];
		[conscienceListCont release];
	}

	//Present a DilemmaListViewController
	if (isDilemmaViewControllerNeeded) {

		//Determine if User has completed the first Campaign
		//If not, present help view.
		if((requestedCampaign == 2) && ![[appDelegate userCollection] containsObject:@"asse-rank2b"]) {

        NSString *helpTitleName =[[NSString alloc] initWithFormat:@"Help%@1Title2",NSStringFromClass([self class])];
        NSString *helpTextName =[[NSString alloc] initWithFormat:@"Help%@1Text2",NSStringFromClass([self class])];
        
        NSArray *titles = [[NSArray alloc] initWithObjects:
                           NSLocalizedString(helpTitleName,@"Title for Help Screen"), nil];
        NSArray *texts = [[NSArray alloc] initWithObjects:NSLocalizedString(helpTextName,@"Text for Help Screen"), nil];
        
        ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] initWithNibName:@"ConscienceHelpView" bundle:[NSBundle mainBundle]];
        conscienceHelpViewCont.helpTitles = titles;
        conscienceHelpViewCont.helpTexts = texts;
        conscienceHelpViewCont.isConscienceOnScreen = TRUE;
        
        [self presentModalViewController:conscienceHelpViewCont animated:NO];
        [helpTitleName release];
        [helpTextName release];
        [titles release];
        [texts release];
        [conscienceHelpViewCont release];

			
		} else {

		DilemmaListViewController *dilemmaListViewCont = [[DilemmaListViewController alloc] initWithNibName:@"DilemmaListView" bundle:[NSBundle mainBundle]];

		[prefs setInteger:requestedCampaign forKey:@"dilemmaCampaign"];

		[self.navigationController pushViewController:dilemmaListViewCont animated:NO];
		[dilemmaListViewCont release];
		}
	}
}

/**
Implementation: Revert Conscience to homescreen position, dismiss UIViewController
 */
- (void) returnConscience {
		//Return Conscience to Home location and resize it
		//Fade view controller from view

		[UIView beginAnimations:@"ReplaceConscience" context:nil];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationBeginsFromCurrentState:YES];
		thoughtModalArea.alpha = 0;
		appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
		
		
		[UIView commitAnimations];
		
		//Delay actual dismissal in order to show Conscience and fade animations
		SEL selector = @selector(dismissModalViewControllerAnimated:);
		
		NSMethodSignature *signature = [UIViewController instanceMethodSignatureForSelector:selector];
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
		[invocation setSelector:selector];
		
		BOOL timerBool = NO;
		
		//Set the arguments
		[invocation setTarget:self];
		[invocation setArgument:&timerBool atIndex:2];
		[NSTimer scheduledTimerWithTimeInterval:0.5 invocation:invocation repeats:NO];

}

/**
Implementation: Determine what type of dismissal is appropriate depending on version of the View.  May pop UIViewController from stack
 */
-(void)dismissThoughtModal:(id)sender{
	
	BOOL dismissModal = FALSE;
	
	//Determine if screen is at home state.
	//If so, dismiss modal controller entirely
	//Otherwise change screen state ot requested state.
	switch (currentState){
		case 0:dismissModal = TRUE;break;
		case 1:currentState = 0;[self changeSelectionScreen];break;
		case 2:currentState = 0;[self changeSelectionScreen];break;
		case 3:currentState = 0;[self changeSelectionScreen];break;
		case 4:currentState = 0;[self changeSelectionScreen];break;
		case 5:currentState = 1;[self changeSelectionScreen];break;			
		case 6:currentState = 1;[self changeSelectionScreen];break;			
		case 7:currentState = 1;[self changeSelectionScreen];break;			
		case 8:currentState = 1;[self changeSelectionScreen];break;			
		case 12:currentState = 1;[self changeSelectionScreen];break;			
		default:break;
	}
	
	//User has requested removal of entire screen
	//Return application to state prior to modal controller request
	if (dismissModal) {
		
        [self returnConscience];

	}
	
}

/**
 Implementation: Signals User desire to return to ConscienceModalViewController
 */
-(IBAction)returnToHome:(id)sender{
	
    [self returnConscience];
    
}

#pragma mark -
#pragma mark Data Manipulation

/**
VERSION 2.0 FEATURE
Implementation:  Delete entire UserData persistentStore.  Must recreate default UserData entries.
@see Utility
 */
- (void)removeUserData {
        
    NSObject *boolCheck = [prefs objectForKey:@"isReadyToRemove"];
    BOOL isReadyToRemove;
    
    if (boolCheck != nil) {
        isReadyToRemove = [prefs boolForKey:@"isReadyToRemove"];
    }else {
        isReadyToRemove = FALSE;
    }
    
    if (isReadyToRemove) {
        
        //Delete all User data
        /** @todo figure out deletion */
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        //Retrieve readwrite Documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *userData =  [documentsDirectory stringByAppendingPathComponent:@"UserData.sqlite"];
        NSURL *storeURL = [NSURL fileURLWithPath:userData];
        
        NSPersistentStoreCoordinator *currentCoordinator = [context persistentStoreCoordinator];
        
        NSPersistentStore *readWriteStore = [currentCoordinator persistentStoreForURL:storeURL];
        
        NSError *error = nil;
        //    @try {
        [[context persistentStoreCoordinator] removePersistentStore:readWriteStore error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:readWriteStore.URL.path error:&error];
        //    }
        //    @catch (NSException *exception) {
        
        //    }
        
        NSLog(@"removing");
        [prefs removeObjectForKey:@"isReadyToRemove"];
    } else {
        
        NSString *helpTitleName =[[NSString alloc] initWithFormat:@"Help%@1Title1",NSStringFromClass([self class])];
        NSString *helpTextName =[[NSString alloc] initWithFormat:@"Help%@1Text1",NSStringFromClass([self class])];
        
        NSArray *titles = [[NSArray alloc] initWithObjects:
                           NSLocalizedString(helpTitleName,@"Title for Help Screen"), nil];
        NSArray *texts = [[NSArray alloc] initWithObjects:NSLocalizedString(helpTextName,@"Text for Help Screen"), nil];
        
        ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] initWithNibName:@"ConscienceHelpView" bundle:[NSBundle mainBundle]];
        conscienceHelpViewCont.helpTitles = titles;
        conscienceHelpViewCont.helpTexts = texts;
        conscienceHelpViewCont.isConscienceOnScreen = TRUE;
        
        [self presentModalViewController:conscienceHelpViewCont animated:NO];
        [helpTitleName release];
        [helpTextName release];
        [titles release];
        [texts release];
        [conscienceHelpViewCont release];
        
        [prefs setBool:TRUE forKey:@"isReadyToRemove"];    
        
    }
    
    id placeholderID = nil;
    
    [self dismissThoughtModal:placeholderID];

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
	[buttonImages release];
	[buttonLabels release];
	[screenTitles release];
	[super dealloc];
}

@end
