/**
Implementation:  Each UIViewController can request Conscience to modally explain something to User.
Calling UIViewController much present NSArray of page titles, texts, and BOOL telling whether or not Conscience is already on screen.
 
@class ConscienceHelpViewController ConscienceHelpViewController.h
 */

#import "MoraLifeAppDelegate.h"
#import "ConscienceHelpViewController.h"
#import "ConscienceView.h"
#import "ViewControllerLocalization.h"
#import "UIColor+Utility.h"

@interface ConscienceHelpViewController () <ViewControllerLocalization> {
	
	MoraLifeAppDelegate *appDelegate;			/**< delegate for application level callbacks */
    
	IBOutlet UIView *thoughtModalArea;			/**< area in which Conscience floats */
    
	IBOutlet UIButton *previousButton;		/**< return to previous page */
	IBOutlet UIButton *nextButton;		/**< proceed to next page */

	UILabel *helpTitle;			/**< title of each page*/
	IBOutlet UITextView *helpText;		/**< text of each page*/

}

@property (nonatomic) IBOutlet UIImageView *previousScreen;
@property (nonatomic) IBOutlet UIView *helpContentView;


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
        appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
        _viewControllerClassName = [[NSString alloc] init];
		//Create content dynamically and iterate through possible screens

		helpTitle = [[UILabel alloc] initWithFrame:CGRectZero];
		[helpTitle setTextAlignment:UITextAlignmentCenter];
		[helpTitle setTextColor: [UIColor moraLifeChoiceGreen]];
		[helpTitle setFont:[UIFont boldSystemFontOfSize:24.0]];
		[helpTitle setMinimumFontSize:8.0];
		[helpTitle setNumberOfLines:1];
		[helpTitle setAdjustsFontSizeToFitWidth:TRUE];
		[helpTitle setShadowColor:[UIColor darkGrayColor]];
		[helpTitle setShadowOffset:CGSizeMake(0, 1)];
		[self.view addSubview:helpTitle];

		[helpText flashScrollIndicators];
        helpText.contentInset = UIEdgeInsetsMake(15.0, 0.0, 0.0, 0.0);

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	//appDelegate needed to reference Conscience and to get Core Data Context and prefs to save state
	CGPoint centerPoint = CGPointMake(MLConscienceOffscreenBottomX, MLConscienceOffscreenBottomY);
	[thoughtModalArea addSubview:appDelegate.userConscienceView];
	appDelegate.userConscienceView.center = centerPoint;

    [self localizeUI];
	
}

-(void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];

    helpTitle.frame = CGRectMake(38, 37, 240, 35);
    self.helpContentView.alpha = 0.0;

    previousButton.alpha = 1.0;
    nextButton.alpha = 1.0;

    if (!_helpTexts.count) {

        NSMutableArray *helpTitleNames = [[NSMutableArray alloc] init];
        NSMutableArray *helpTextNames = [[NSMutableArray alloc] init];    

        for (int i = 0; i < 6; i++) {
            [helpTitleNames addObject:[NSString stringWithFormat:@"Help%@%dTitle%d", _viewControllerClassName, self.numberOfScreens - 1, i+1]];
            [helpTextNames addObject:[NSString stringWithFormat:@"Help%@%dText%d", _viewControllerClassName, self.numberOfScreens - 1, i+1]];
        }
        
        NSMutableArray *helpAllTitles = [[NSMutableArray alloc] init];
        NSMutableArray *helpAllTexts = [[NSMutableArray alloc] init];    
        
        for (int i = 0; i < 6; i++) {
            NSString *tempTitle = [[NSString alloc] initWithString:NSLocalizedString(helpTitleNames[i],nil)];
            NSString *tempText = [[NSString alloc] initWithString:NSLocalizedString(helpTextNames[i],nil)];
            
            if (![tempText isEqualToString:helpTextNames[i]]) {
                [helpAllTexts addObject:tempText];
            }
            
            if (![tempTitle isEqualToString:helpTitleNames[i]]) {
                [helpAllTitles addObject:tempTitle];
            }
        }
        
        _helpTitles = [[NSArray alloc] initWithArray:helpAllTitles];
        _helpTexts = [[NSArray alloc] initWithArray:helpAllTexts];
        
    }
	
	[thoughtModalArea addSubview:appDelegate.userConscienceView];

	CGPoint centerPoint = CGPointMake(MLConscienceLowerLeftX, MLConscienceLowerLeftY);

    helpTitle.hidden = TRUE;
	helpTitle.alpha = 0;
    helpText.hidden = TRUE;
    helpText.alpha = 0;
	
	[UIView beginAnimations:@"BottomUpConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];

    self.helpContentView.alpha = 1.0;
	appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(MLConscienceLargeSizeX, MLConscienceLargeSizeY);

	//Determine if Conscience is already on screen
	if (!_isConscienceOnScreen) {
		appDelegate.userConscienceView.center = centerPoint;
	}

	[UIView commitAnimations];

	//This center point is not redundant if Conscience is already onscreen
	appDelegate.userConscienceView.center = centerPoint;
	[appDelegate.userConscienceView setNeedsDisplay];
    
	[self changeScreen:1];
}

-(void)setScreenshot:(UIImage *)screenshot {
    if (_screenshot != screenshot) {
        _screenshot = screenshot;
        self.previousScreen.image = screenshot;
    }
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
	id placeHolder = @"";
    int buttonFactor = 0;
	
	nextButton.hidden = FALSE;
	previousButton.hidden = FALSE;

	//Show the title and text except in the case of dismissing the entire ViewController
	if (screenVersion > 0) {
        buttonFactor = screenVersion - 1;

        [UIView animateWithDuration:0.25 animations:^{

            helpTitle.alpha = 0;
            helpText.alpha = 0;

        } completion:^(BOOL finished) {
            helpTitle.hidden = FALSE;
            helpText.hidden = FALSE;
            helpTitle.text = _helpTitles[screenVersion - 1];
            helpText.text = _helpTexts[screenVersion - 1];

            [UIView animateWithDuration:0.5 animations:^{
                helpTitle.alpha = 1;
                helpText.alpha = 1;
            }];
        }];

		//Change Button tag in order to determine which "screen" is active
		nextButton.tag = 2 + buttonFactor;
		previousButton.tag = buttonFactor;
	} else {
        [self dismissThoughtModal:placeHolder];
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

	//If Conscience wasn't on screen, place it offscreen, otherwise place it centrally.
	if (!_isConscienceOnScreen) {
		appDelegate.userConscienceView.center = CGPointMake(MLConscienceOffscreenBottomX, MLConscienceOffscreenBottomY);
        appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
	} else {
        appDelegate.userConscienceView.center = CGPointMake(MLConscienceLowerLeftX, MLConscienceLowerLeftY);
	}
    self.helpContentView.alpha = 0.0;

	helpTitle.alpha = 0;
    helpText.alpha = 0;
    nextButton.hidden = TRUE;
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

    _helpTitles = @[];
    _helpTexts = @[];
}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint",nil);
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",nil);
    
    nextButton.accessibilityHint = NSLocalizedString(@"NextButtonHint",nil);
	nextButton.accessibilityLabel =  NSLocalizedString(@"NextButtonLabel",nil);
    
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




@end
