/**
Implementation: Present a menu of options to User.
Determine what information needs to be passed to subsequent UIViewController depending upon User Choice.
User selection causes selectChoice to be called which sets the currentState variable to which version of the screen should be presented.
 
@class ConscienceModalViewController ConscienceModalViewController.h
 */

#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
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
#import "ReportPieModel.h"

@interface ConscienceModalViewController () {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
    
	NSMutableDictionary *buttonLabels;		/**< various button labels for the screens of UI */
	NSMutableDictionary *buttonImages;		/**< various button image filenames for the screens of UI */
	NSArray *screenTitles;				/**< various screen titles for the pages of UI */
	
	IBOutlet UIView *thoughtModalArea;		/**< area in which user ConscienceView can float */
	IBOutlet UILabel *statusMessage1;		/**< title at top of screen */
	IBOutlet UIButton *labelButton1;		/**< label button for menu choice button 1 */
	IBOutlet UIButton *labelButton2;		/**< label button for menu choice button 2 */
	IBOutlet UIButton *labelButton3;		/**< label button for menu choice button 3 */
	IBOutlet UIButton *labelButton4;		/**< label button for menu choice button 4 */
	IBOutlet UIButton *button1;			/**< image button for menu choice button 1 */
	IBOutlet UIButton *button2;			/**< image button for menu choice button 2 */
	IBOutlet UIButton *button3;			/**< image button for menu choice button 3 */
	IBOutlet UIButton *button4;			/**< image button for menu choice button 4 */
	
    IBOutlet UIButton *previousButton;  /**< button for previous screen */
	int currentState;					/**< current state of the screen (which button names, etc.) */
}

/**
 Implementation:  Ensure Conscience is placed correctly.
 */
-(void) moveConscienceToBottom;

/**
 Makes selection choices reappear 
 */
- (void) showSelectionChoices;

/**
 Changes the display of the UIViewController without additional XIB load
 */
-(void)changeSelectionScreen;

/**
 Accepts User input to change the state of the screen.
 @param controllerID int of UIViewController to be selected
 */
-(void)selectController:(int) controllerID;

/**
 VERSION 2.0 FEATURE
 Allows the deletion of all User content.
 @todo implement delete capability
 */
-(void)removeUserData;

@end

@implementation ConscienceModalViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	//appDelegate needed to retrieve CoreData Context, prefs used to save form state
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	prefs = [NSUserDefaults standardUserDefaults];

	/** @todo change hardcoded selection descriptions into localized strings */
	buttonImages = [[NSMutableDictionary alloc] init];
	buttonLabels = [[NSMutableDictionary alloc] init];
	screenTitles = @[@"What do you need?", @"What would you like to change?", @"Morathology Adventures", @"Which Setting would you like to change?", @" ", @"Which feature?", @"What would you like to color?",  @"Which Accessory type?", @"What information?"];
	
	currentState = 0;

	//Set visuals to invisible on load to make them fade into view	
	thoughtModalArea.alpha = 0;

	/** @todo determine better screen loading method */
	NSArray *tempButtonImages = @[@"icon-customization.png", @"icon-rank.png", @"icon-piechart.png", @" "];
	buttonImages[@"0"] = tempButtonImages;

	NSArray *tempButtonLabels = @[@"Commissary", @"Morathology", @"Moral Report", @" "];
	[buttonLabels setValue:tempButtonLabels forKey:@"0"];
	
	tempButtonImages = @[@"icon-features.png", @"icon-palette.png", @"icon-accessories.png", @" "];
	[buttonImages setValue:tempButtonImages forKey:@"1"];
	
	tempButtonLabels = @[@"Orientation", @"Atlantic", @"Coming Soon!", @"Coming Soon!"];
	[buttonLabels setValue:tempButtonLabels forKey:@"2"];
	
	tempButtonImages = @[@"icon-placesani1.png", @"icon-placesani2.png", @"icon-placesani3.png", @"icon-placesani4.png"];
	[buttonImages setValue:tempButtonImages forKey:@"2"];
	
	tempButtonLabels = @[@"Features", @"Colors", @"Accessories", @" "];
	[buttonLabels setValue:tempButtonLabels forKey:@"1"];
    
	tempButtonImages = @[@"icon-resetapp.png", @" ", @" ", @" "];
	[buttonImages setValue:tempButtonImages forKey:@"3"];
	
	tempButtonLabels = @[@"Reset Application", @" ", @" ", @" "];
	[buttonLabels setValue:tempButtonLabels forKey:@"3"];
	
	tempButtonImages = @[@"icon-eye.png", @"icon-symbol.png", @"icon-mouth.png", @"icon-bubble.png"];
	[buttonImages setValue:tempButtonImages forKey:@"5"];
	
	tempButtonLabels = @[@"Eye", @"Face", @"Mouth", @"Bubble"];
	[buttonLabels setValue:tempButtonLabels forKey:@"5"];
	
	tempButtonImages = @[@"icon-eye.png", @"icon-brow.png", @"icon-bubble.png", @"icon-none.png"];
	[buttonImages setValue:tempButtonImages forKey:@"6"];
	
	tempButtonLabels = @[@"Eye", @"Brow", @"Bubble", @" "];
	[buttonLabels setValue:tempButtonLabels forKey:@"6"];
    
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint", @"Hint for previous button");
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",@"Label for previous button");

 
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	//Add User Conscience to view
    [self.view addSubview:appDelegate.userConscienceView];
	
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
    
    //Move Conscience to center of boxes
	CGPoint centerPoint = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY);
    appDelegate.userConscienceView.center = centerPoint;
    
	[UIView beginAnimations:@"FadeInView" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	thoughtModalArea.alpha = 1;

	[UIView commitAnimations];
    
    [UIView beginAnimations:@"conscienceHide" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationBeginsFromCurrentState:NO];
    appDelegate.userConscienceView.alpha = 0;
    
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(moveConscienceToBottom)];
    
    [UIView commitAnimations];
    
    
    //Determine if previous UIViewController is requesting to reset the home screen
    NSObject *homeResetCheck = [prefs objectForKey:@"conscienceModalReset"];
    
    if (homeResetCheck != nil) {
        
        [prefs  removeObjectForKey:@"conscienceModalReset"];
        currentState = 0;
    }
    
    //Call showSelectionChoices directly in order to avoid double fade-in
    [self showSelectionChoices];
	 
}

-(void)viewDidAppear:(BOOL)animated {
    
    [UIView beginAnimations:@"conscienceHide" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationBeginsFromCurrentState:NO];
    appDelegate.userConscienceView.alpha = 0;
    
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(moveConscienceToBottom)];
    
    [UIView commitAnimations];
    
	//Present help screen after a split second
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];
}

#pragma mark - UI Interaction

/**
 Implementation: Show an initial help screen if this is the User's first use of the screen.  Set a User Default after help screen is presented.  Launch a ConscienceHelpViewController and populate a localized help message.
 */
-(void)showInitialHelpScreen {
    
    //If this is the first time that the app, then show the intro
    NSObject *firstConscienceModalCheck = [prefs objectForKey:@"firstConscienceModal"];
    
    if (firstConscienceModalCheck == nil) {
        
		ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
        [conscienceHelpViewCont setViewControllerClassName:NSStringFromClass([self class])];        
		[conscienceHelpViewCont setIsConscienceOnScreen:TRUE];
        [conscienceHelpViewCont setHelpVersion:0];
		[self presentModalViewController:conscienceHelpViewCont animated:NO];
        
        [prefs setBool:FALSE forKey:@"firstConscienceModal"];
        
    }
}

/**
Implementation:  Sometimes the Conscience can be put in the wrong section of the screen depending upon screen prior to this one. 
  We must ensure that the Conscience doesn't take up the whole screen.
*/
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

- (void) showSelectionChoices{
    
    //Change buttons and status bar for appropriate requested screen
	statusMessage1.text = (NSString *)screenTitles[currentState];
    
	//Set button image and names, set tags for screen derivation
	NSString *buttonImageName = (NSString *)buttonImages[[NSString stringWithFormat:@"%d", currentState]][0];
	NSString *buttonLabel = (NSString *)buttonLabels[[NSString stringWithFormat:@"%d", currentState]][0];
	[button1 setBackgroundImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal]; 
	[labelButton1 setTitle:buttonLabel forState: UIControlStateNormal];
	button1.tag = currentState*4;
	labelButton1.tag = currentState*4;
    
    button1.accessibilityLabel = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dLabel", button1.tag]), @"Label for Menu Button 1");
	button1.accessibilityHint = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dHint", button1.tag]), @"Hint for Menu Button 1");
    labelButton1.accessibilityLabel = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dLabel", labelButton1.tag]), @"Label for Menu Button 1");
	labelButton1.accessibilityHint = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dHint", labelButton1.tag]), @"Hint for Menu Button 1");

    
	buttonImageName = (NSString *)buttonImages[[NSString stringWithFormat:@"%d", currentState]][1];
	buttonLabel = (NSString *)buttonLabels[[NSString stringWithFormat:@"%d", currentState]][1];
	[button2 setBackgroundImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal]; 
	[labelButton2 setTitle:buttonLabel forState: UIControlStateNormal];
	button2.tag = currentState*4 + 1;
	labelButton2.tag = currentState*4 + 1;

    button2.accessibilityLabel = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dLabel", button2.tag]), @"Label for Menu Button 2");
	button2.accessibilityHint = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dHint", button2.tag]), @"Hint for Menu Button 2");
    labelButton2.accessibilityLabel = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dLabel", labelButton2.tag]), @"Label for Menu Button 2");
	labelButton2.accessibilityHint = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dHint", labelButton2.tag]), @"Hint for Menu Button 2");

    
	buttonImageName = (NSString *)buttonImages[[NSString stringWithFormat:@"%d", currentState]][2];
	buttonLabel = (NSString *)buttonLabels[[NSString stringWithFormat:@"%d", currentState]][2];
	[button3 setBackgroundImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal]; 
	[labelButton3 setTitle:buttonLabel forState: UIControlStateNormal];
	button3.tag = currentState*4 + 2;
	labelButton3.tag = currentState*4 + 2;
    
    button3.accessibilityLabel = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dLabel", button3.tag]), @"Label for Menu Button 3");
	button3.accessibilityHint = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dHint", button3.tag]), @"Hint for Menu Button 3");
    labelButton3.accessibilityLabel = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dLabel", labelButton3.tag]), @"Label for Menu Button 3");
	labelButton3.accessibilityHint = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dHint", labelButton3.tag]), @"Hint for Menu Button 3");
    
	buttonImageName = (NSString *)buttonImages[[NSString stringWithFormat:@"%d", currentState]][3];
	buttonLabel = (NSString *)buttonLabels[[NSString stringWithFormat:@"%d", currentState]][3];
	[button4 setBackgroundImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal]; 
	[labelButton4 setTitle:buttonLabel forState: UIControlStateNormal];
	button4.tag = currentState*4 + 3;
	labelButton4.tag = currentState*4 + 3;
    
    button4.accessibilityLabel = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dLabel", button4.tag]), @"Label for Menu Button 4");
	button4.accessibilityHint = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dHint", button4.tag]), @"Hint for Menu Button 4");
    labelButton4.accessibilityLabel = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dLabel", labelButton4.tag]), @"Label for Menu Button 4");
	labelButton4.accessibilityHint = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dHint", labelButton4.tag]), @"Hint for Menu Button 4");
    
    
    [UIView beginAnimations:@"ShowChoices" context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    thoughtModalArea.alpha = 1;
        
    [UIView commitAnimations];
}


/**
Implementation:  Set the Status message at top of screen and the image and label of each button.  Button tags are updated to reflect new version of the screen.
 */
- (void) changeSelectionScreen{
    
    [UIView beginAnimations:@"HideChoices" context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(showSelectionChoices)];

    thoughtModalArea.alpha = 0;    
    
    [UIView commitAnimations];

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
                ReportPieModel *reportPieModel = [[ReportPieModel alloc] init];
				ReportPieViewController *reportPieViewCont = [[ReportPieViewController alloc] initWithModel:reportPieModel];
				[prefs setBool:TRUE forKey:@"reportIsGood"];
                
				[self.navigationController pushViewController:reportPieViewCont animated:NO];
                

			}
				break;
			case 6:{
				ConscienceAccessoryViewController *conscienceAccessoryCont = [[ConscienceAccessoryViewController alloc] init];
                
				[self.navigationController pushViewController:conscienceAccessoryCont animated:NO];
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

		ConscienceListViewController *conscienceListCont = [[ConscienceListViewController alloc] init];
		[conscienceListCont setAccessorySlot:requestedAccessorySlot];
		[self.navigationController pushViewController:conscienceListCont animated:NO];
	}

	//Present a DilemmaListViewController
	if (isDilemmaViewControllerNeeded) {

		//Determine if User has completed the first Campaign
		//If not, present help view.
		if((requestedCampaign == 2) && ![[appDelegate userCollection] containsObject:@"asse-rank2b"]) {
            
            ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
            [conscienceHelpViewCont setViewControllerClassName:NSStringFromClass([self class])];        
            [conscienceHelpViewCont setIsConscienceOnScreen:TRUE];
            [conscienceHelpViewCont setHelpVersion:2];
            [self presentModalViewController:conscienceHelpViewCont animated:NO];
			
    } else {

		DilemmaListViewController *dilemmaListViewCont = [[DilemmaListViewController alloc] init];

		[prefs setInteger:requestedCampaign forKey:@"dilemmaCampaign"];

		[self.navigationController pushViewController:dilemmaListViewCont animated:NO];
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
        appDelegate.userConscienceView.alpha = 0;
		
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
        NSManagedObjectContext *context = [appDelegate.moralModelManager managedObjectContext];
        
        //Retrieve readwrite Documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
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
        
        ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
        [conscienceHelpViewCont setViewControllerClassName:NSStringFromClass([self class])];        
        [conscienceHelpViewCont setIsConscienceOnScreen:TRUE];
        [conscienceHelpViewCont setHelpVersion:1];
        [self presentModalViewController:conscienceHelpViewCont animated:NO];
        
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
    previousButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
