/**
Implementation: Present a menu of options to User.
Determine what information needs to be passed to subsequent UIViewController depending upon User Choice.
User selection causes selectChoice to be called which sets the currentState variable to which version of the screen should be presented.
 
@class ConscienceViewController ConscienceViewController.h
 */

#import "ConscienceViewController.h"
#import "ConscienceAccessoryViewController.h"
#import "ConscienceListViewController.h"
#import "DilemmaListModel.h"
#import "DilemmaListViewController.h"
#import "ReportPieViewController.h"
#import "ReportPieModel.h"
#import "UIColor+Utility.h"

@interface ConscienceViewController () {
    
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
    
	NSMutableDictionary *buttonLabels;		/**< various button labels for the screens of UI */
	NSMutableDictionary *buttonImages;		/**< various button image filenames for the screens of UI */
	NSArray *screenTitles;				/**< various screen titles for the pages of UI */

	IBOutlet UIView *thoughtModalArea;		/**< area in which user ConscienceView can float */
	IBOutlet UIImageView *thoughtBubble;	/**< thought bubble surrounding choices */
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

@property (nonatomic) IBOutlet UIImageView *previousScreen;

/**
 Makes selection choices reappear 
 */
- (void) refreshSelectionChoices;

/**
 Changes the display of the UIViewController without additional XIB load
 */
-(void)changeSelectionScreen;

/**
 Accepts User input to change the state of the screen.
 @param controllerID int of UIViewController to be selected
 */
-(void)selectController:(int) controllerID;

@end

@implementation ConscienceViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

    self.previousScreen.image = self.screenshot;
    thoughtBubble.alpha = 0;

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
	tempButtonLabels = @[@"Orientation", @"Atlantic", @"Eastern", @"Coming Soon!"];
	[buttonLabels setValue:tempButtonLabels forKey:@"2"];
	
	tempButtonImages = @[@"icon-places1.png", @"icon-places2.png", @"icon-places3.png", @"icon-places4.png"];
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
    
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint",nil);
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",nil);

    [statusMessage1 setTextAlignment:UITextAlignmentCenter];
    [statusMessage1 setTextColor: [UIColor moraLifeChoiceGreen]];
    statusMessage1.font = [UIFont fontForConscienceHeader];

    [statusMessage1 setMinimumFontSize:8.0];
    [statusMessage1 setNumberOfLines:1];
    [statusMessage1 setAdjustsFontSizeToFitWidth:TRUE];

    [labelButton1 setTitleColor:[UIColor moraLifeChoiceBlue] forState:UIControlStateNormal];
    [labelButton1 setTitleShadowColor:[UIColor moraLifeChoiceGray] forState:UIControlStateNormal];
    [labelButton2 setTitleColor:[UIColor moraLifeChoiceBlue] forState:UIControlStateNormal];
    [labelButton2 setTitleShadowColor:[UIColor moraLifeChoiceGray] forState:UIControlStateNormal];
    [labelButton3 setTitleColor:[UIColor moraLifeChoiceBlue] forState:UIControlStateNormal];
    [labelButton3 setTitleShadowColor:[UIColor moraLifeChoiceGray] forState:UIControlStateNormal];
    [labelButton4 setTitleColor:[UIColor moraLifeChoiceBlue] forState:UIControlStateNormal];
    [labelButton4 setTitleShadowColor:[UIColor moraLifeChoiceGray] forState:UIControlStateNormal];

}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];

	//Add User Conscience to view
    [self.view addSubview:_userConscience.userConscienceView];
    //Move Conscience to center of boxes
	CGPoint centerPoint = CGPointMake(MLConscienceLowerLeftX, MLConscienceLowerLeftY);
    _userConscience.userConscienceView.center = centerPoint;

    //Determine if previous UIViewController is requesting to reset the home screen
    NSObject *homeResetCheck = [prefs objectForKey:@"conscienceModalReset"];
    
    if (homeResetCheck != nil) {
        
        [prefs  removeObjectForKey:@"conscienceModalReset"];
        currentState = 0;
    }


}

-(void)viewDidAppear:(BOOL)animated {

    thoughtModalArea.alpha = 0.0;

	CGPoint centerPoint = CGPointMake(MLConscienceLowerLeftX, MLConscienceLowerLeftY);

    [UIView beginAnimations:@"conscienceRestore" context:nil];
    [UIView setAnimationDuration:0.25];

    [UIView setAnimationBeginsFromCurrentState:YES];
    _userConscience.userConscienceView.alpha = 1;
    _userConscience.userConscienceView.center = centerPoint;

    _userConscience.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(MLConscienceLargeSizeX, MLConscienceLargeSizeY);
    thoughtModalArea.alpha = 1.0;
    thoughtBubble.alpha = 1.0;
    [UIView commitAnimations];

    //Call refreshSelectionChoices directly in order to avoid double fade-in
    [self refreshSelectionChoices];

	//Present help screen after a split second
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_userConscience.userConscienceView removeFromSuperview];
}

-(void)setScreenshot:(UIImage *)screenshot {
    if (_screenshot != screenshot) {
        _screenshot = screenshot;
        self.previousScreen.image = screenshot;
    }
}

#pragma mark - UI Interaction

/**
 Implementation: Show an initial help screen if this is the User's first use of the screen.  Set a User Default after help screen is presented.  Launch a ConscienceHelpViewController and populate a localized help message.
 */
-(void)showInitialHelpScreen {
    
    //If this is the first time that the app, then show the intro
    NSObject *firstConscienceModalCheck = [prefs objectForKey:@"firstConscienceModal"];
    
    if (firstConscienceModalCheck == nil) {
        
		_conscienceHelpViewController.isConscienceOnScreen = TRUE;
        _conscienceHelpViewController.numberOfScreens = 1;
        _conscienceHelpViewController.screenshot = [self prepareScreenForScreenshot];
		[self presentModalViewController:_conscienceHelpViewController animated:NO];
        
        [prefs setBool:FALSE forKey:@"firstConscienceModal"];
        
    }
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
//			case 3:currentState = 4;[self changeSelectionScreen];break;
			case 4:currentState = 5;[self changeSelectionScreen];break;
			case 5:currentState = 6;[self changeSelectionScreen];break;
			case 6:[self selectController:choiceIndex];break;
//			case 7:currentState = 8;[self changeSelectionScreen];break;
//			case 8:currentState = 9;[self changeSelectionScreen];break;
//			case 9:currentState = 10;[self changeSelectionScreen];break;
//			case 10:currentState = 11;[self changeSelectionScreen];break;			
//			case 11:currentState = 12;[self changeSelectionScreen];break;			
			case 8:[self selectController:choiceIndex];break;
			case 9:[self selectController:choiceIndex];break;
			case 10:[self selectController:choiceIndex];break;			
			case 11:[self selectController:choiceIndex];break;
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

- (void) refreshSelectionChoices{
    
    //Change buttons and status bar for appropriate requested screen
	statusMessage1.text = (NSString *)screenTitles[currentState];

    NSArray *buttonArray = @[button1, button2, button3, button4];
    NSArray *labelArray = @[labelButton1, labelButton2, labelButton3, labelButton4];

	//Set button image and names, set tags for screen derivation    
    for (int i = 0; i < 4; i++) {
        UIButton *currentButton = buttonArray[i];
        UIButton *currentLabelButton = labelArray[i];

        NSString *buttonImageName = (NSString *)buttonImages[[NSString stringWithFormat:@"%d", currentState]][i];
        NSString *buttonLabel = (NSString *)buttonLabels[[NSString stringWithFormat:@"%d", currentState]][i];
        [currentButton setBackgroundImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
        [currentLabelButton setTitle:buttonLabel forState: UIControlStateNormal];
        currentButton.tag = currentState*4 + i;
        currentLabelButton.tag = currentState*4 + i;

        currentButton.accessibilityLabel = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dLabel", currentButton.tag]),nil);
        currentButton.accessibilityHint = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dHint", currentButton.tag]),nil);
        currentLabelButton.accessibilityLabel = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dLabel", currentLabelButton.tag]),nil);
        currentLabelButton.accessibilityHint = NSLocalizedString(([NSString stringWithFormat:@"ConscienceModalScreenButton%dHint", currentLabelButton.tag]),nil);
    }

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
    [UIView setAnimationDidStopSelector:@selector(refreshSelectionChoices)];

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
	MLRequestedMorathologyAdventure requestedCampaign = MLRequestedMorathologyAdventure0;
	
	//Determine if a new view controller has been requested
	if (controllerID > 0) {

		switch (controllerID) {
			case 2:{
                ReportPieModel *reportPieModel = [[ReportPieModel alloc] initWithModelManager:_modelManager];
				ReportPieViewController *reportPieViewCont = [[ReportPieViewController alloc] initWithModel:reportPieModel modelManager:_modelManager andConscience:_userConscience];
                reportPieViewCont.screenshot = [self prepareScreenForScreenshot];
				[prefs setBool:TRUE forKey:@"reportIsGood"];
                
				[self.navigationController pushViewController:reportPieViewCont animated:NO];

			}
				break;
			case 6:{
				ConscienceAccessoryViewController *conscienceAccessoryController = [[ConscienceAccessoryViewController alloc] initWithModelManager:_modelManager andConscience:_userConscience];
                [UIView animateWithDuration:0.5 animations:^{
                    _userConscience.userConscienceView.alpha = 0;
                }completion:^(BOOL finished) {

                    conscienceAccessoryController.screenshot = [self prepareScreenForScreenshot];
                    [self.navigationController pushViewController:conscienceAccessoryController animated:NO];
                }];

			}
				break;
                
			case 8:requestedCampaign=MLRequestedMorathologyAdventure1;isDilemmaViewControllerNeeded = TRUE;break;
			case 9:requestedCampaign=MLRequestedMorathologyAdventure2;isDilemmaViewControllerNeeded = TRUE;break;
			case 10:requestedCampaign=MLRequestedMorathologyAdventure3;isDilemmaViewControllerNeeded = TRUE;break;
			case 11:requestedCampaign=MLRequestedMorathologyAdventure4;isDilemmaViewControllerNeeded = TRUE;break;
			case 12:break;                
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

		ConscienceListViewController *conscienceListController = [[ConscienceListViewController alloc] initWithModelManager:_modelManager andConscience:_userConscience];
		[conscienceListController setAccessorySlot:requestedAccessorySlot];
        [UIView animateWithDuration:0.5 animations:^{
            _userConscience.userConscienceView.alpha = 0;
        }completion:^(BOOL finished) {

            conscienceListController.screenshot = [self prepareScreenForScreenshot];
            [self.navigationController pushViewController:conscienceListController animated:NO];
        }];

	}

	//Present a DilemmaListViewController
	if (isDilemmaViewControllerNeeded) {

        NSString *adventureRequirement;
		//Determine if User has completed the first Campaign
		//If not, present help view.
        switch (requestedCampaign) {
            case MLRequestedMorathologyAdventure1:
                adventureRequirement = @"ethical";
                break;
            case MLRequestedMorathologyAdventure2:
                adventureRequirement = @"asse-rank2b";
                break;
            case MLRequestedMorathologyAdventure3:
                adventureRequirement = @"asse-rank4";
                break;
            case MLRequestedMorathologyAdventure4:
                adventureRequirement = @"asse-rank10";
                break;
            default:
                break;
        }
        
        BOOL campaignRejected = ![[_userConscience conscienceCollection] containsObject:adventureRequirement];

		if(campaignRejected){
            
            _conscienceHelpViewController.isConscienceOnScreen = TRUE;
            _conscienceHelpViewController.numberOfScreens = 3;
            _conscienceHelpViewController.screenshot = [self prepareScreenForScreenshot];
            [self presentModalViewController:_conscienceHelpViewController animated:NO];
			
        } else {

            DilemmaListModel *dilemmaListModel = [[DilemmaListModel alloc] initWithModelManager:_modelManager andDefaults:prefs andCurrentCampaign:requestedCampaign];
            DilemmaListViewController *dilemmaListViewController = [[DilemmaListViewController alloc] initWithModel:dilemmaListModel modelManager:_modelManager andConscience:_userConscience];

            dilemmaListViewController.screenshot = [self prepareScreenForScreenshot];

            [prefs setInteger:requestedCampaign forKey:@"dilemmaCampaign"];

            [self.navigationController pushViewController:dilemmaListViewController animated:NO];
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
		_userConscience.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _userConscience.userConscienceView.alpha = 0;
		
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
 Implementation: Signals User desire to return to ConscienceViewController
 */
-(IBAction)returnToHome:(id)sender{
	
    [self returnConscience];
    
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
