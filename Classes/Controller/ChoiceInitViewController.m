/**
Implementation:  UIViewController allows subsequent screen selection, controls button animation and resets choices by clearing NSUserDefaults.
 
@class ChoiceInitViewController ChoiceInitViewController.h
*/

#import "ChoiceInitViewController.h"
#import "ChoiceListViewController.h"
#import "ChoiceViewController.h"
#import "LuckViewController.h"
#import "LuckListViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ConscienceHelpViewController.h"

@implementation ChoiceInitViewController

#pragma mark -
#pragma mark View lifecycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		//Create appDelegate and referebce NSUserDefaults for Conscience and serialized state retention
		appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
		prefs = [NSUserDefaults standardUserDefaults];
		
		//Array to hold button names for random animations
		buttonNames = [[NSArray alloc] initWithObjects:@"choicegood", @"choicebad", @"luckgood", @"luckbad", @"choicelist", @"lucklist", nil];

	}
    
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];

	//Retrieve localized view title string
	/** 
	@todo utilize consistent localization string references 
	@todo convert localization of all UIViewControllers into protocol
	*/
	[self setTitle:NSLocalizedString(@"ChoiceInitScreenTitle",@"Title for Choice Home Screen")];
	self.accessibilityLabel = NSLocalizedString(@"ChoiceInitScreenLabel",@"Label for Choice Home Screen");
	self.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenHint",@"Hint for Choice Home Screen");

	//Set localized Button Titles.  Do no do this in init, XIB is not loaded until viewDidLoad
	[goodChoiceLabelButton setTitle:NSLocalizedString(@"ChoiceInitScreenChoiceGoodLabel",@"Label for Good Choice Button") forState: UIControlStateNormal];
	[badChoiceLabelButton setTitle:NSLocalizedString(@"ChoiceInitScreenChoiceBadLabel",@"Label for Bad Choice Button") forState: UIControlStateNormal];
	[choiceListLabelButton setTitle:NSLocalizedString(@"ChoiceInitScreenChoiceListLabel",@"Label for Choice List Button") forState: UIControlStateNormal];
	goodChoiceLabelButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceGoodHint",@"Hint for Good Choice Button");
	badChoiceLabelButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceBadHint",@"Hint for Bad Choice Button");
	choiceListLabelButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceListHint",@"Hint for Choice List Button");		

	goodChoiceButton.accessibilityLabel = NSLocalizedString(@"ChoiceInitScreenChoiceGoodLabel",@"Label for Good Choice Button");
	badChoiceButton.accessibilityLabel = NSLocalizedString(@"ChoiceInitScreenChoiceBadLabel",@"Label for Bad Choice Button");
	choiceListButton.accessibilityLabel = NSLocalizedString(@"ChoiceInitScreenChoiceListLabel",@"Label for Choice List Button");
	goodChoiceButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceGoodHint",@"Hint for Good Choice Button");
	badChoiceButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceBadHint",@"Hint for Bad Choice Button");
	choiceListButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenChoiceListHint",@"Hint for Choice List Button");
	
	[goodLuckLabelButton setTitle:NSLocalizedString(@"ChoiceInitScreenLuckGoodLabel",@"Label for Good Luck Button") forState: UIControlStateNormal];
	[badLuckLabelButton setTitle:NSLocalizedString(@"ChoiceInitScreenLuckBadLabel",@"Label for Bad Luck Button") forState: UIControlStateNormal];
	[luckListLabelButton setTitle:NSLocalizedString(@"ChoiceInitScreenLuckListLabel",@"Label for Luck List Button") forState: UIControlStateNormal];
	goodLuckLabelButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenLuckGoodHint",@"Hint for Good Luck Button");
	badLuckLabelButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenLuckBadHint",@"Hint for Bad Luck Button");
	luckListLabelButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenLuckListHint",@"Hint for Luck List Button");		
	
	goodLuckButton.accessibilityLabel = NSLocalizedString(@"ChoiceInitScreenLuckGoodLabel",@"Label for Good Luck Button");
	badLuckButton.accessibilityLabel = NSLocalizedString(@"ChoiceInitScreenLuckBadLabel",@"Label for Bad Luck Button");
	luckListButton.accessibilityLabel = NSLocalizedString(@"ChoiceInitScreenLuckListLabel",@"Label for Luck List Button");
	goodLuckButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenLuckGoodHint",@"Hint for Good Luck Button");
	badLuckButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenLuckBadHint",@"Hint for Bad Luck Button");
	luckListButton.accessibilityHint = NSLocalizedString(@"ChoiceInitScreenLuckListHint",@"Hint for Luck List Button");
	
}

- (void) viewWillAppear:(BOOL)animated{

	//Setup repeating NSTimer to make the buttons animate randomly
	[self refreshButtons];
	buttonTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(refreshButtons) userInfo:nil repeats:YES];

}

-(void)viewDidAppear:(BOOL)animated {
    
    [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];
    
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
        
		NSString *helpTitleName =[[NSString alloc] initWithFormat:@"Help%@0Title1",NSStringFromClass([self class])];
		NSString *helpTextName =[[NSString alloc] initWithFormat:@"Help%@0Text1",NSStringFromClass([self class])];
        
		NSArray *titles = [[NSArray alloc] initWithObjects:
                           NSLocalizedString(helpTitleName,@"Title for Help Screen"), nil];
		NSArray *texts = [[NSArray alloc] initWithObjects:NSLocalizedString(helpTextName,@"Text for Help Screen"), nil];
        
		ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] initWithNibName:@"ConscienceHelpView" bundle:[NSBundle mainBundle]];
        
		[conscienceHelpViewCont setHelpTitles:titles];
		[conscienceHelpViewCont setHelpTexts:texts];
		[conscienceHelpViewCont setIsConscienceOnScreen:FALSE];
        
		[helpTitleName release];
		[helpTextName release];
		[titles release];
		[texts release];
		
		[self presentModalViewController:conscienceHelpViewCont animated:NO];
		[conscienceHelpViewCont release];
        
        [prefs setBool:FALSE forKey:@"firstChoice"];
        
    }
}

/**
Implementation: A single view controller is utilized for both Good and Bad choices.  A boolean controls which version of the view controller is presented to User.
 */
- (IBAction) selectChoiceType:(id) sender{

	BOOL isGood = TRUE;
	BOOL isChoice = TRUE;
	BOOL isList = FALSE;
	
	//Set boolean to determine which version of screen to present
	if ([sender isKindOfClass:[UIButton class]]) {
		UIButton *senderButton = sender;
		int choiceIndex = senderButton.tag;
		
		switch (choiceIndex){
			case 0:isGood = TRUE;break;
			case 1:isGood = FALSE;break;
			case 2:isChoice = TRUE;isList = TRUE;break;				
			case 3:isGood = TRUE;isChoice = FALSE;break;
			case 4:isGood = FALSE;isChoice = FALSE;break;				
			case 5:isChoice = FALSE;isList = TRUE;break;
			default:break;
		}
		
	}
	
	//User can back out of Choice Entry screen and state will be saved
	//unless a new choice is requested
	/** @todo refactor into new function */
	
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
	
		//Create subsequent view controller to be pushed onto stack, determine if choice or luck
		if (isChoice) {
			ChoiceViewController *choiceCont = [[ChoiceViewController alloc] initWithNibName:@"ChoiceView" bundle:[NSBundle mainBundle]];
			//Push view onto stack	
			[self.navigationController pushViewController:choiceCont animated:YES];
			[choiceCont release];
		} else {
			LuckViewController *luckCont = [[LuckViewController alloc] initWithNibName:@"LuckView" bundle:[NSBundle mainBundle]];
			//Push view onto stack	
			[self.navigationController pushViewController:luckCont animated:YES];
			[luckCont release];
		}
	} else {
	
		//Create subsequent view controller to be pushed onto stack, determine if choice or luck
		if (isChoice) {
			ChoiceListViewController *choiceListCont = [[ChoiceListViewController alloc] initWithNibName:@"ChoiceListView" bundle:[NSBundle mainBundle]];
			[self.navigationController pushViewController:choiceListCont animated:YES];
			[choiceListCont release];
		} else {
			LuckListViewController *luckListCont = [[LuckListViewController alloc] initWithNibName:@"LuckListView" bundle:[NSBundle mainBundle]];
			[self.navigationController pushViewController:luckListCont animated:YES];
			[luckListCont release];
		}
	}
	
}

#pragma mark -
#pragma mark Custom UI animations
/**
Implementation: Only animate at most 4 buttons at a time.  Otherwise, too visually distracting
 */
- (void) refreshButtons{

    //Determine which set of four buttons will be animated
	[self buttonAnimate:[NSNumber numberWithInt:arc4random()%6]];
	[self buttonAnimate:[NSNumber numberWithInt:arc4random()%6]];
	[self buttonAnimate:[NSNumber numberWithInt:arc4random()%6]];
	[self buttonAnimate:[NSNumber numberWithInt:arc4random()%6]];
}

/**
Implementation: Build animated UIImage from sequential icon files
 */
- (void) buttonAnimate:(NSNumber *) buttonNumber{
	
    //Get button image base filename
	NSString *iconFileName = [NSString stringWithFormat:@"icon-%@ani", [buttonNames objectAtIndex: [buttonNumber intValue]]];

    //Build 4 frames of animation for selected button
	UIImage *iconani1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@1.png", iconFileName]];
	UIImage *iconani2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@2.png", iconFileName]];
	UIImage *iconani3 = [UIImage imageNamed:[NSString stringWithFormat:@"%@3.png", iconFileName]];
	UIImage *iconani4 = [UIImage imageNamed:[NSString stringWithFormat:@"%@4.png", iconFileName]];

    //Setup placeholder for image setup
	UIImage *iconBlank = [UIImage imageNamed:@""];
	
    //Build physical animation in UIImageView
	UIImageView *animation1 = [[UIImageView alloc] init];
	animation1.frame = CGRectMake(0,0,75,75);
	
	NSArray *images = [[NSArray alloc] initWithObjects:iconani1, iconani2, iconani3, iconani4, nil];
	animation1.animationImages = images;
	[images release];

    //Determine which button to animate
	switch ([buttonNumber intValue]){
		case 0: [goodChoiceButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[goodChoiceButton addSubview:animation1];break;
		case 1: [badChoiceButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[badChoiceButton addSubview:animation1];break;
		case 2: [goodLuckButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[goodLuckButton addSubview:animation1];break;
		case 3: [badLuckButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[badLuckButton addSubview:animation1];break;
		case 4: [choiceListButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[choiceListButton addSubview:animation1];break;
		case 5: [luckListButton setBackgroundImage:iconBlank forState:UIControlStateNormal];[luckListButton addSubview:animation1];break;
		default:break;
	}
	
	animation1.animationDuration = 0.75;
	animation1.animationRepeatCount = 1;
	[animation1 startAnimating];
	
	[animation1 release];
	
	//Reset button after animation, delay slightly to allow animation to catchup
	[self performSelector:@selector(buttonAnimationDone:) withObject:buttonNumber afterDelay:0.70];
	
}

/**
Implementation: Return the button's icon to default after animation finishes
 */
- (void) buttonAnimationDone:(NSNumber *) buttonNumber{
	
    //Return button to default state
	NSString *iconFileName = [NSString stringWithFormat:@"icon-%@ani1.png", [buttonNames objectAtIndex:[buttonNumber intValue]]];

	switch ([buttonNumber intValue]){
		case 0: [goodChoiceButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 1: [badChoiceButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 2: [goodLuckButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 3: [badLuckButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 4: [choiceListButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		case 5: [luckListButton setBackgroundImage:[UIImage imageNamed:iconFileName] forState:UIControlStateNormal];break;
		default:break;
	}
}

#pragma mark -
#pragma mark Memory Management

-(void) viewWillDisappear:(BOOL)animated {

	//Turn off button animations
	[buttonTimer invalidate];
	buttonTimer = nil;
	
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


- (void)dealloc {
	[buttonNames release];
	[super dealloc];

}


@end