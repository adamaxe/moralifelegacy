/**
Implementation:  Each UIViewController can request Conscience to modally explain something to User.
Calling UIViewController much present NSArray of page titles, texts, and BOOL telling whether or not Conscience is already on screen.
 
@class ConscienceHelpViewController ConscienceHelpViewController.h
 */

#import "MoraLifeAppDelegate.h"
#import "ConscienceHelpViewController.h"
#import "ConscienceView.h"
#import "ViewControllerLocalization.h"

@interface ConscienceHelpViewController () <ViewControllerLocalization> {
	
	MoraLifeAppDelegate *appDelegate;			/**< delegate for application level callbacks */
    
	IBOutlet UIView *thoughtModalArea;			/**< area in which Conscience floats */
    
	IBOutlet UIView *screen1View;				/**< 1st possible help page */
	IBOutlet UIView *screen2View;				/**< 2nd possible help page */
	IBOutlet UIView *screen3View;				/**< 3rd possible help page */
	IBOutlet UIView *screen4View;				/**< 4th possible help page */
	IBOutlet UIView *screen5View;				/**< 5th possible help page */
	IBOutlet UIView *screen6View;				/**< 6th possible help page */
    
	IBOutlet UILabel *helpTitle;			/**< title of each page*/
	IBOutlet UITextView *helpText;		/**< text of each page*/
	IBOutlet UIButton *previousButton;		/**< return to previous page */
	IBOutlet UIButton *nextButton;		/**< proceed to next page */
	
}

/**
 Animate the back or previous button to show User if more text is available.
 
 @param isPrevious BOOL which determines which button to animate
 */
-(void)animateCorrectButton:(BOOL)isPrevious;

/**
 Change the active UIView within the UIViewController
 @param screenVersion intDesignating which version of screen to display
 */
-(void)changeScreen:(int) screenVersion;

/**
 Commit User's choice to UserData
 @param id Object which requested method
 */
-(void)dismissThoughtModal:(id)sender;

@end

@implementation ConscienceHelpViewController

#pragma mark -
#pragma mark ViewController lifecycle

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _viewControllerClassName = [[NSString alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//appDelegate needed to reference Conscience and to get Core Data Context and prefs to save state
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	CGPoint centerPoint = CGPointMake(kConscienceOffscreenBottomX, kConscienceOffscreenBottomY);
	[thoughtModalArea addSubview:appDelegate.userConscienceView];
	appDelegate.userConscienceView.center = centerPoint;	
    
    [self localizeUI];    
	
}

-(void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
    
    if (![self.viewControllerClassName isEqualToString:@""]) {

        NSMutableArray *helpTitleNames = [[NSMutableArray alloc] init];
        NSMutableArray *helpTextNames = [[NSMutableArray alloc] init];    
        
        for (int i = 0; i < 6; i++) {
            [helpTitleNames addObject:[NSString stringWithFormat:@"Help%@%dTitle%d", _viewControllerClassName, _helpVersion, i+1]];
            [helpTextNames addObject:[NSString stringWithFormat:@"Help%@%dText%d", _viewControllerClassName, _helpVersion, i+1]];
        }
        
        NSMutableArray *helpAllTitles = [[NSMutableArray alloc] init];
        NSMutableArray *helpAllTexts = [[NSMutableArray alloc] init];    
        
        for (int i = 0; i < 6; i++) {
            NSString *tempTitle = [[NSString alloc] initWithString:NSLocalizedString([helpTitleNames objectAtIndex:i],@"Title for Help Screen")];
            NSString *tempText = [[NSString alloc] initWithString:NSLocalizedString([helpTextNames objectAtIndex:i],@"Text for Help Screen")];
            
            if (![tempText isEqualToString:[helpTextNames objectAtIndex:i]]) {
                [helpAllTexts addObject:tempText];
            }
            
            if (![tempTitle isEqualToString:[helpTitleNames objectAtIndex:i]]) {
                [helpAllTitles addObject:tempTitle];
            }
            [tempText release];
            [tempTitle release];
        }
        
        _helpTitles = [[NSArray alloc] initWithArray:helpAllTitles];
        _helpTexts = [[NSArray alloc] initWithArray:helpAllTexts];
        
        [helpTitleNames release];
        [helpTextNames release];
        [helpAllTitles release];
        [helpAllTexts release];
    }

	//Create NSArray of help screens.  Populate them programattically
	NSArray *viewsArray = [[NSArray alloc] initWithObjects:screen1View, screen2View, screen3View, screen4View, screen5View, screen6View, nil];
	int counter = 0;
    
	for (NSString *helpTextIterate in _helpTitles) {
        
		//Create content dynamically and iterate through possible screens
		CGRect labelFrame = CGRectMake(38, 37, 240, 35);
		UILabel* label = [[UILabel alloc] initWithFrame: labelFrame];
		[label setText:helpTextIterate];
		[label setTextAlignment:UITextAlignmentCenter];
		[label setTextColor: [UIColor colorWithRed:0.0/255.0 green:176.0/255.0 blue:0.0/255.0 alpha:1]];
		[label setFont:[UIFont boldSystemFontOfSize:24.0]];
		[label setMinimumFontSize:8.0];
		[label setNumberOfLines:1];
		[label setAdjustsFontSizeToFitWidth:TRUE];
		[label setShadowColor:[UIColor darkGrayColor]];
		[label setShadowOffset:CGSizeMake(0, -1)];
		[[viewsArray objectAtIndex:counter] addSubview:label];
		[label release];
		
		CGRect textViewFrame = CGRectMake(40, 80, 240, 258);
		UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
		[textView setTextAlignment:UITextAlignmentCenter];
		[textView setText:[_helpTexts objectAtIndex:counter]];
		[textView setTextColor:[UIColor grayColor]];
		[textView setFont:[UIFont systemFontOfSize:18.0]];
		[textView flashScrollIndicators];
		[label setShadowColor:[UIColor darkGrayColor]];
		[label setShadowOffset:CGSizeMake(0, 1)];        
		[textView setEditable:FALSE];
		[[viewsArray objectAtIndex:counter] addSubview:textView];
        
		[textView release];
        
		counter++;
	}
	
	[viewsArray release];    
    
    
	[thoughtModalArea addSubview:appDelegate.userConscienceView];
	
	CGPoint centerPoint = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY);
	
	screen1View.hidden = TRUE;
	screen1View.alpha = 0;
	
	[UIView beginAnimations:@"BottomUpConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
	thoughtModalArea.alpha = 1;
	appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(kConscienceLargeSizeX, kConscienceLargeSizeY);

	//Determine if Conscience is already on screen
	if (!_isConscienceOnScreen) {
		appDelegate.userConscienceView.center = centerPoint;
	}
   	
	screen1View.alpha = 1;
	screen1View.hidden = FALSE;
	
	[UIView commitAnimations];
	
	//This center point is not redundant if Conscience is already onscreen
	appDelegate.userConscienceView.center = centerPoint;
	[appDelegate.userConscienceView setNeedsDisplay];
    
	[self changeScreen:1];
}

#pragma mark -
#pragma mark UI interaction

/**
Implementation: Ensure that actual button wishes to call changeScreen
 */
- (IBAction) selectChoice:(id) sender{
	
	//Determine which button was pushed
	//Change options accordingly
	
	if ([sender isKindOfClass:[UIButton class]]) {
		UIButton *senderButton = sender;
		int choiceIndex = senderButton.tag;
		
		[self changeScreen:choiceIndex];
		
	}
	
}

/**
 Implementation: Signals User desire to return to ConscienceModalViewController
 */
-(IBAction)returnToHome:(id)sender{
	
    id placeholderID = nil;
    
	[self dismissThoughtModal:placeholderID];
    
}

/**
Implementation: Hide or show a screen depending upon which page the User currently resides.
Show reward views once User has completed dilemma and refuse access to previous screen versions.
 */
-(void)changeScreen:(int) screenVersion {

    //TODO: Refactor screenViews to dynamic builds
	UIView *viewSelection;
	int buttonFactor = 0;
	
	id placeHolder = @"";
	
	//Hide all the screens.  Show them one at a time.
	screen1View.hidden = TRUE;
	screen1View.alpha = 0;
	screen2View.hidden = TRUE;
	screen2View.alpha = 0;
	screen3View.hidden = TRUE;
	screen3View.alpha = 0;
	screen4View.hidden = TRUE;
	screen4View.alpha = 0;
	screen5View.hidden = TRUE;
	screen5View.alpha = 0;
	screen6View.hidden = TRUE;
	screen6View.alpha = 0;	
	nextButton.hidden = FALSE;			
	previousButton.hidden = FALSE;
	
	//Depending upon which screen is requested
	//Setup variables to hide views, change Next/Previous button and move Conscience
	switch (screenVersion){
		case 0:	[self dismissThoughtModal:placeHolder];
			break;
		case 1:viewSelection = screen1View;
			buttonFactor = 0;
			break;
		case 2:viewSelection = screen2View;
			buttonFactor = 1;
			break;
		case 3:viewSelection = screen3View;
			buttonFactor = 2;
			break;
		case 4:viewSelection = screen4View;
			buttonFactor = 3;
			break;
		case 5:viewSelection = screen5View;
			buttonFactor = 4;
			break;	
		case 6:viewSelection = screen6View;
			buttonFactor = 5;
			break;
		case 7: //[self.navigationController popViewControllerAnimated:NO];
			break;
		default:break;
			
	}

	//Change the active view except in the case of dismissing the entire ViewController
	if (screenVersion > 0 && screenVersion < 7) {
		
		//Animated changes to the ViewController
		//Show/Hide relevant subview
		//Move Conscience to appropriate place on screen
		[UIView beginAnimations:@"ScreenChange" context:nil];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationBeginsFromCurrentState:YES];
		
		viewSelection.alpha = 1;
		viewSelection.hidden = FALSE;
		
		[UIView commitAnimations];
		
		//Change Button tag in order to determine which "screen" is active
		nextButton.tag = 2 + buttonFactor;
		previousButton.tag = buttonFactor;
	}
    
    int screenMaximum = [_helpTitles count];
	
	//Animate button that User should use
	if (screenVersion >= screenMaximum){
		nextButton.hidden = TRUE;
		[self animateCorrectButton:TRUE];
        previousButton.tag = 0;
	} else {
		[self animateCorrectButton:FALSE];
	}
}

/**
Implementation:  Animate the fading button to get User to see that they should either dismiss the view or continue to more help pages.
 */
-(void)animateCorrectButton:(BOOL)isPrevious{
    
    [UIView beginAnimations:@"AnimateNext" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationRepeatCount:5];
    [UIView setAnimationRepeatAutoreverses:TRUE];        
    
    if (isPrevious) {
        previousButton.alpha = 0.5;
    } else {
        nextButton.alpha = 0.5;
    }
    
    [UIView commitAnimations];
}

/**
Implementation:  Return Conscience graphically to place before requesting help.  Pop UIViewController from stack
 */
-(void)dismissThoughtModal:(id)sender{
	
	//Return Conscience to Home location and resize it
	//Fade view controller from view
	[UIView beginAnimations:@"ReplaceConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
//	thoughtModalArea.alpha = 0;

	//If Conscience wasn't on screen, place it offscreen, otherwise place it centrally.
	if (!_isConscienceOnScreen) {
		appDelegate.userConscienceView.center = CGPointMake(kConscienceOffscreenBottomX, kConscienceOffscreenBottomY);
        appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
	} else {
        appDelegate.userConscienceView.center = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY);
	}
	
	nextButton.hidden = TRUE;
	previousButton.hidden = TRUE;
	screen1View.alpha = 0;
	
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

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint", @"Hint for previous button");
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",@"Label for previous button");
    
    nextButton.accessibilityHint = NSLocalizedString(@"NextButtonHint", @"Hint for next button");
	nextButton.accessibilityLabel =  NSLocalizedString(@"NextButtonLabel",@"Label for next button");
    
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
    [_viewControllerClassName release];
    [_helpTitles release];
    [_helpTexts release];

    [super dealloc];

}


@end
