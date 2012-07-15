/**
Implementation:  Allows User to enter in Choice data.  Commits data to UserData.  
Allows access to ChoiceModalViewController to select Virtue/Vice and ChoiceDetailViewController for extended entries.
Affects UserConscience by increasing/decreasing mood/enthusiasm.
 
@class ChoiceViewController ChoiceViewController.h
 */

#import "ChoiceViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "ConscienceMind.h"
#import "ChoiceDetailViewController.h"
#import "ChoiceModalViewController.h"
#import "StructuredTextField.h"
#import "MoralDAO.h"
#import "UserCharacterDAO.h"
#import "UserChoiceDAO.h"
#import "ConscienceHelpViewController.h"
#import "ReferenceDetailViewController.h"
#import "UserCollectableDAO.h"
#import "ChoiceHistoryViewController.h"
#import "ViewControllerLocalization.h"

@interface ChoiceViewController () <ViewControllerLocalization> {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
	
	IBOutlet UILabel *severityLabel;					/**< UILabel for UISlider of choice's severity */
	IBOutlet UIImageView *moralImageView;				/**< moral image */
	IBOutlet UIImageView *backgroundImageView;			/**< background image */
	IBOutlet UIImageView *descriptionInnerShadow;			/**< faux inner drop shadow for UITextView */
	IBOutlet UIView *choiceParametersView;				/**< UIView for hiding top parameters for keyboard */
	IBOutlet UIView *choiceDescriptionView;				/**< UIView for shifting bottom parameter for keyboard */
	
	IBOutlet UIButton *hideKeyboardButton;				/**< done button for UITextView keyboard dismissal */
	IBOutlet UIButton *doneButton;					/**< done button for ViewController dismissal */
	IBOutlet UIButton *cancelButton;					/**< cancel button for ViewController dismissal and entry deletion*/
	IBOutlet UIButton *moralButton;					/**< moral button list selection for ViewController dismissal */
	IBOutlet UIButton *moralReferenceButton;				/**< moral button which selects moral reference */
    
    IBOutlet UIButton *moralHistoryButton;  /**< moral history button which selects previous entries */
	IBOutlet StructuredTextField *choiceTextField;			/**< overloaded text field for choice title */
	IBOutlet UITextView *descriptionTextView;				/**< UITextView for choice's extended description */
	IBOutlet UISlider *severitySlider;					/**< UISlider for choice's severity */
    
	StructuredTextField *activeField;					/** temporary overloaded text field for determining active field */
	
	NSMutableArray *severityLabelDescriptions;				/** list of localized severity descriptions */
	
	BOOL isVirtue;							/** determine if screen shown is virtue or vice */
	BOOL isChoiceFinished;						/** determine if choice is complete */
	
	UserChoice *currentUserChoice;				/** nsmanagedobject of current choice */
	NSMutableString *choiceKey;						/** string to hold primary key of current choice */
	NSString *moralKey;						/** string to hold primary key of current moral */
    
}

/**
 Shift UI elements to move UITextView to top of screen to accomodate keyboard
 */
-(void)animateOptionChange:(int)viewNumber;

/**
 Called from custom Done button to return UI back to normal
 */
-(void)hideKeyboard;

/**
 Prevent User from entering more text than field allows
 */
-(void)limitTextField:(NSNotification *)note;

/**
 Actually commits data to UserData from User request
 */
-(void)commitDataToUserData;

/**
 Add designated amount to User's amount of ethicals
 */
-(void)increaseEthicals;


@end

@implementation ChoiceViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    
	/** @bug fix slider bar in iOS3*/
    
	//appDelegate needed to pass information from modal views (virtues/vices) to primary view
	//and to get Core Data Context and prefs to save state
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	prefs = [NSUserDefaults standardUserDefaults];
	context = [appDelegate.moralModelManager readWriteManagedObjectContext];
    
    choiceKey = [[NSMutableString alloc] init];
    
	if (!isChoiceFinished) {
		isChoiceFinished = FALSE;
	}
    
    //choiceTextField is a custom StructuredTextField with max length.
    choiceTextField.delegate = self;
    choiceTextField.maxLength = kChoiceTextFieldLength;
    descriptionTextView.delegate = self;

	//Place inner shadow around flat UITextView
	[descriptionInnerShadow setImage:[UIImage imageNamed:@"textview-innershadow.png"]];
    
	[severitySlider setThumbImage:[UIImage imageNamed:@"button-circle-down.png"] forState:UIControlStateNormal];
	[severitySlider setThumbImage:[UIImage imageNamed:@"button-circle-down.png"] forState:UIControlStateHighlighted];
    
	//Prevent keypress level changes over maxlength of field
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitTextField:) name: UITextFieldTextDidChangeNotification object:activeField];
    
	//Create input for requesting ChoiceDetailViewController
//	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showChoiceDetailEntry)];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ChoiceScreenDetailsLabel",@"Hint for Details Label") style:UIBarButtonItemStyleBordered target:self action:@selector(showChoiceDetailEntry)];
	
	self.navigationItem.rightBarButtonItem = barButtonItem;
	[barButtonItem release];
    
    hideKeyboardButton = [UIButton buttonWithType: UIButtonTypeCustom];
    hideKeyboardButton.frame = CGRectMake(250, 480, 74, 39);
    hideKeyboardButton.alpha = 0;
    
    [hideKeyboardButton setBackgroundImage:[UIImage imageNamed:@"button-normal-down.png"] forState: UIControlStateNormal];
    [hideKeyboardButton setBackgroundImage:[UIImage imageNamed:@"button-normal-down.png"] forState: UIControlStateHighlighted];	
    [hideKeyboardButton addTarget: self action:@selector(hideKeyboard) forControlEvents: UIControlEventTouchUpInside];
    [[hideKeyboardButton titleLabel] setShadowColor:[UIColor blackColor]];
    [[hideKeyboardButton titleLabel] setShadowOffset:CGSizeMake(0, -1)];
    
    [self.view addSubview: hideKeyboardButton];
    
    severityLabelDescriptions = [[NSMutableArray alloc] init];    
        
	//User can back out of Choice Entry screen and state will be saved
	//However, user should not be able to select a virtue, and then select a vice for entry
	NSObject *boolCheck = [prefs objectForKey:@"entryIsGood"];
	
	if (boolCheck != nil) {
		isVirtue = [prefs boolForKey:@"entryIsGood"];
		
	}else {
		isVirtue = TRUE;
	}
    
	
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
    [self localizeUI];
    
	//Restore state of prior view if applicable	
	NSString *restoreShortDescription = [prefs objectForKey:@"entryShortDescription"];
	NSString *restoreLongDescription = [prefs objectForKey:@"entryLongDescription"];
	NSString *restoreChoiceKey = [prefs objectForKey:@"entryKey"];
    
	float restoreSeverity = [prefs floatForKey:@"entrySeverity"];
	
	if (restoreShortDescription != nil) {
		choiceTextField.text = restoreShortDescription;
		[prefs removeObjectForKey:@"entryShortDescription"];
		
	}
	
	if (restoreLongDescription != nil) {
		descriptionTextView.text = restoreLongDescription;
		[prefs removeObjectForKey:@"entryLongDescription"];
        
	}
	
	if (restoreChoiceKey != nil) {
		[choiceKey setString:restoreChoiceKey];
		[prefs removeObjectForKey:@"entryKey"];
	}else {
		[choiceKey setString:@""];
	}
    
	if (restoreSeverity > 0) {
		severitySlider.value = restoreSeverity;
        
	}
	
	if (restoreSeverity < 0) {
		severitySlider.value = restoreSeverity * -1;
	}
    
	[self severityChange:severitySlider];
	
	[prefs removeObjectForKey:@"entrySeverity"];
    
	[prefs removeObjectForKey:@"entryIsGood"];
    
	moralKey = [prefs objectForKey:@"moralKey"];
    
	//Retrieve moralKey from ChoiceModalView and populate buttons
	if (moralKey != nil) {
		
		NSString *moralName = [[NSString alloc] initWithString:[prefs objectForKey:@"moralName"]];
		NSString *moralImage = [[NSString alloc] initWithString:[prefs objectForKey:@"moralImage"]];
		
		[moralButton setTitle:moralName forState:UIControlStateNormal];
		
		NSMutableString *moralImageName = [[NSMutableString alloc] initWithString:moralImage];
		[moralImageName appendString:@".png"];
        		
		[moralImageView setImage:[UIImage imageNamed:moralImageName]];
		
		[moralImageName release];
		[moralName release];
		[moralImage release];
        
	}
    
	//Set moral and cloud image to invisible, so viewDidAppear can make them fade in
	[moralReferenceButton setAlpha:0];
	[moralImageView setAlpha:0];
	
}

-(void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
	
	//Save current state of form unless choice is finished
	if (!isChoiceFinished) {
		
		//Do not save default help text
		NSString *defaultTextFieldText = NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenChoice%dLabel", isVirtue]), @"Label for Choice Textfield");
		
		NSString *defaultTextViewText = NSLocalizedString(@"ChoiceScreenDescription", @"Label for Description Textview");
        
		if (![choiceTextField.text isEqualToString:@""] && ![choiceTextField.text isEqualToString:defaultTextFieldText]) {
			[prefs setObject:choiceTextField.text forKey:@"entryShortDescription"];    
		}
        
		if (![descriptionTextView.text isEqualToString:@""] && ![descriptionTextView.text isEqualToString:defaultTextViewText]) {
            
			[prefs setObject:descriptionTextView.text forKey:@"entryLongDescription"];    		
		}
        
		//Save off entries to NSUserDefaults
		[prefs setObject:choiceKey forKey:@"entryKey"];
		[prefs setFloat:severitySlider.value forKey:@"entrySeverity"];
		[prefs setBool:isVirtue forKey:@"entryIsGood"];
	}
	
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

	//Present Moral image as a fade in to provide distinction between Conscience elements and User entry elements
	[UIView beginAnimations:@"showMoralImage" context:nil];
	[UIView setAnimationDuration:0.5];
	[moralReferenceButton setAlpha:1];
	[moralImageView setAlpha:1];
	[UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];


}

#pragma mark -
#pragma mark UI Interaction

/**
Implementation: Show an initial help screen if this is the User's first use of the screen.  Set a User Default after help screen is presented.  Launch a ConscienceHelpViewController and populate a localized help message.
*/
-(void)showInitialHelpScreen {
    
    //If this is the first time that the app, then show the intro
    NSObject *firstChoiceEntryCheck = [prefs objectForKey:@"firstChoiceEntry"];
    
    if (firstChoiceEntryCheck == nil) {
        
        ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
        [conscienceHelpViewCont setViewControllerClassName:NSStringFromClass([self class])];        
		[conscienceHelpViewCont setIsConscienceOnScreen:FALSE];
        [conscienceHelpViewCont setHelpVersion:0];
		[self presentModalViewController:conscienceHelpViewCont animated:NO];
		[conscienceHelpViewCont release];
        
        [prefs setBool:FALSE forKey:@"firstChoiceEntry"];
        
    }
}

/**
Implementation: Present ChoiceDetailViewController to User from UINavigationBar button
 */
-(void) showChoiceDetailEntry{
	
	//Allow User to enter in more specific details
	ChoiceDetailViewController *choiceDetailViewCont = [[ChoiceDetailViewController alloc] init];
	
	[self.navigationController pushViewController:choiceDetailViewCont animated:YES];
	[choiceDetailViewCont release];
	
}

/**
Implementation: Set Choice Severity and reflect change in UI
 */
-(IBAction)severityChange:(id) sender{
	
	//Change severity labels to reflect good or bad choice.
	if ([sender isKindOfClass:[UISlider class]]) {
        
		UISlider *slider = (UISlider *) sender;
		int severityAsInt = (int)(slider.value);
        
		[severityLabel setText:(NSString *)[severityLabelDescriptions objectAtIndex:severityAsInt-1]];
		severityLabel.accessibilityLabel = severityLabel.text;
        
	}
	
}

/**
Implementation: Present ChoiceModalViewController to all User to enter in Choice Moral
 */
-(IBAction)showChoiceModal:(id)sender {
		
	// Create the root view controller for the navigation controller
	// The new view controller configures a Cancel and Done button for the
	// navigation bar.
	ChoiceModalViewController *virtueViceViewController = [[ChoiceModalViewController alloc] init];

	[moralReferenceButton setAlpha:0];
	[moralImageView setAlpha:0];
    	
	[prefs setBool:isVirtue forKey:@"entryIsGood"];
        
	[self presentModalViewController:virtueViceViewController animated:NO];
	
	// The navigation controller is now owned by the current view controller
	// and the root view controller is owned by the navigation controller,
	// so both objects should be released to prevent over-retention.
	[virtueViceViewController release];
	
}

/**
 Implementation: Present ChoiceHistoryViewController to all User to enter in previous choice
 */
-(IBAction)showHistoryModal:(id)sender {
    
	// Create the root view controller for the navigation controller
	// The new view controller configures a Cancel and Done button for the
	// navigation bar.
	ChoiceHistoryViewController *historyViewController = [[ChoiceHistoryViewController alloc] init];
    
	[moralReferenceButton setAlpha:0];
	[moralImageView setAlpha:0];
    
	[prefs setBool:isVirtue forKey:@"entryIsGood"];
    
	[self presentModalViewController:historyViewController animated:NO];
	
	// The navigation controller is now owned by the current view controller
	// and the root view controller is owned by the navigation controller,
	// so both objects should be released to prevent over-retention.
	[historyViewController release];
	
}

/**
Implementation: Present ConscienceHelpViewController that shows User extended definition of Moral selected.
 */
-(IBAction)selectMoralReference:(id) sender{
    
	//If User has selected a Moral, display the extended description.  Otherwise, ask them to fill in Moral.
	if (moralKey != nil) {
        
        ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
        
        //Create help text and controller for presentation	
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        NSMutableArray *texts = [[NSMutableArray alloc] init];        
        
        MoralDAO *currentMoralDAO = [[MoralDAO alloc] initWithKey:moralKey];
        Moral *currentMoral = [currentMoralDAO read:@""];
        
        [titles addObject:currentMoral.displayNameMoral];
        [texts addObject:[NSString stringWithFormat:@"%@\n\nSynonym(s): %@", currentMoral.definitionMoral, currentMoral.longDescriptionMoral]];

        [currentMoralDAO release];

        //Set help title and verbiage
        [conscienceHelpViewCont setHelpTitles:titles];
        [conscienceHelpViewCont setHelpTexts:texts];
        [conscienceHelpViewCont setIsConscienceOnScreen:FALSE];
        
        [titles release];
        [texts release];   
        
        [self presentModalViewController:conscienceHelpViewCont animated:NO];
        [conscienceHelpViewCont release];
        
	} else {
     
        ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
        [conscienceHelpViewCont setViewControllerClassName:NSStringFromClass([self class])];        
        [conscienceHelpViewCont setIsConscienceOnScreen:FALSE];
        [conscienceHelpViewCont setHelpVersion:3];
        [self presentModalViewController:conscienceHelpViewCont animated:NO];
        [conscienceHelpViewCont release];

	}
    

}

/**
Implementation:  Determine if commit is possible.  If not, present ConscienceHelpViewController to alert User to issue.
@todo simplify help strings and controllers
 */
-(IBAction)commitChoice:(id) sender{
	
	BOOL isReadyToCommit = FALSE;
    
	//If user hasn't typed anything in, prompt them
	NSString *choiceFirst = choiceTextField.text;
    
	//Do not save default help text
	NSString *defaultTextFieldText = NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenChoice%dLabel", isVirtue]), @"Label for Choice Textfield");
    
	if ([choiceFirst isEqualToString:@""] || [choiceFirst isEqualToString:defaultTextFieldText]) {

        ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
        [conscienceHelpViewCont setViewControllerClassName:NSStringFromClass([self class])];        
		[conscienceHelpViewCont setIsConscienceOnScreen:FALSE];
        [conscienceHelpViewCont setHelpVersion:1];
		[self presentModalViewController:conscienceHelpViewCont animated:NO];
		[conscienceHelpViewCont release];

	} else {
		isReadyToCommit = TRUE;
	}
    
	//If user hasn't selected a Moral, prompt them
	NSString *choiceMoral = [prefs objectForKey:@"moralKey"];
    
	if (isReadyToCommit) {
        
        if (choiceMoral == nil){
            
            ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
            [conscienceHelpViewCont setViewControllerClassName:NSStringFromClass([self class])];        
            [conscienceHelpViewCont setIsConscienceOnScreen:FALSE];
            [conscienceHelpViewCont setHelpVersion:2];
            [self presentModalViewController:conscienceHelpViewCont animated:NO];
            [conscienceHelpViewCont release];
            
            isReadyToCommit = FALSE;
        }
		
	}
    
	if (isReadyToCommit) {
		//Request calculations and context save
		[self commitDataToUserData];
	}
}

/**
Implementation: Cancel all choice attributes, delete NSUserDefault values, dismiss view.
 */
-(IBAction)cancelChoice:(id) sender{
	
    /** @bug fix leak from ChoiceListViewController
     only happens in case of previous entry
     */
    
	//Notify viewWillDisappear not to save state
	isChoiceFinished = TRUE;
	
	//Clear fields
	choiceTextField.text = @"";
	descriptionTextView.text = @"";
	severitySlider.value = 0;
	moralButton.titleLabel.text = @"";
	
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
	[prefs removeObjectForKey:@"choiceKey"];	    
	
	//Remove Moral state information
	[prefs removeObjectForKey:@"moralKey"];
	[prefs removeObjectForKey:@"moralName"];
	[prefs removeObjectForKey:@"moralImage"];
	
	[self.navigationController popViewControllerAnimated:TRUE];
    
}

#pragma mark -
#pragma mark Custom UI animations

/**
Implementation: Shift UITextView up to top of screen, hide elements underneath, present a button to cancel keyboard
 */
- (void)animateOptionChange:(int)viewNumber{
    
	[UIView beginAnimations:@"advancedAnimations" context:nil];
	[UIView setAnimationDuration:0.2];
	
	// move the UITextView up, hide rest of parameters
	CGRect descriptionFrame = choiceDescriptionView.frame; 
	if (viewNumber == 0) {
		choiceParametersView.alpha = 1.0;
		descriptionFrame.origin.y += 145;
	}else {
		choiceParametersView.alpha = 0.0;		
		descriptionFrame.origin.y -= 145;
	}
	choiceDescriptionView.frame = descriptionFrame;
	[UIView commitAnimations];
    
}

/**
Implementation: Resign first responder and return the views to original locations.
 */
-(void)hideKeyboard
{
	[self animateOptionChange:0];
    
	[hideKeyboardButton setAlpha:0];
	[descriptionTextView resignFirstResponder];
}

#pragma mark -
#pragma mark TextField/View delegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	[theTextField resignFirstResponder];
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{	
	//Do not display done button if TextField is active
	if (activeField == nil) {
        
		//Re-arrange view
		[self animateOptionChange:1];
        
        CGRect hideKeyboardButtonFrame = hideKeyboardButton.frame; 
        hideKeyboardButtonFrame.origin.y -= 275;           
        
        //Float Done button up from bottom
		[UIView beginAnimations:@"doneButtonAnimation" context:nil];
		[UIView setAnimationDuration:0.5];
        hideKeyboardButton.frame = hideKeyboardButtonFrame;
		hideKeyboardButton.alpha = 1;
		[UIView commitAnimations];
        
	}
    
	//If text in view is default, then clear it
	if ([textView.text isEqualToString:NSLocalizedString(@"ChoiceScreenDescription",@"Label for Choice TextView")]) {
		textView.text = @"";
		
	}
	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = (StructuredTextField *) textField;

    //Determine which default text is being utilized.
    NSString *defaultText = NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenChoice%dLabel", isVirtue]), @"Label for Choice Textfield");
    
	//If text in field is default, then clear it
	if ([activeField.text isEqualToString:defaultText]) {
		activeField.text = @"";
		
	}
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    //Do not display done button if TextField is active
	if (activeField == nil) {
        
        CGRect hideKeyboardButtonFrame = hideKeyboardButton.frame; 
        hideKeyboardButtonFrame.origin.y += 275;        

        //Float Done button up from bottom
		[UIView beginAnimations:@"doneButtonAnimation" context:nil];
		[UIView setAnimationDuration:0.5];
        hideKeyboardButton.frame = hideKeyboardButtonFrame;

        hideKeyboardButton.alpha = 0;
		[UIView commitAnimations];
        
	}
    
	[descriptionTextView resignFirstResponder];
	
	return YES;
}


- (void)limitTextField:(NSNotification *)note {
    
	if ([[activeField text] length] > activeField.maxLength) {
        [activeField setText:[[activeField text] substringToIndex:activeField.maxLength]];
    }
}

#pragma mark -
#pragma mark Data Manipulation
/**
Implementation: Compile all of the relevant data from ChoiceModalViewController and ChoiceDetailViewController.  Calculate changes, commit to Core Data
@todo refactor into multiple functions
 */
-(void)commitDataToUserData {
    
    id placeHolderID = nil;
    int choiceWeightFilledFields = 1;
    
    NSString *choiceJustification = [prefs objectForKey:@"choiceJustification"];
    int choiceInfluence = [prefs integerForKey:@"choiceInfluence"];
    NSString *choiceConsequences = [prefs objectForKey:@"choiceConsequence"];
    NSString *choiceLongDescription = descriptionTextView.text;
    
    NSString *defaultTextViewText = NSLocalizedString(@"ChoiceScreenDescription", @"Label for Choice Textfield");
    
    if (![choiceLongDescription isEqualToString:@""] && ![choiceLongDescription isEqualToString:defaultTextViewText]) {
        choiceWeightFilledFields++;
    } else {
        choiceLongDescription = @"";
    }

    //Retrieve information from ChoiceDetail
    if (choiceJustification == nil) {
        choiceJustification = @"";
    } else {
        choiceWeightFilledFields++;
    }
	
    if (choiceConsequences == nil) {
        choiceConsequences = @"";
    } else {
        choiceWeightFilledFields++;
    }
	
    if (choiceInfluence == 0) {
        choiceInfluence = 1;
    } else {
        choiceWeightFilledFields++;
    }

    //Construct Unique Primary Key from dtstamp to millisecond
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];	
	
    NSString *currentDTS = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter release];
		
    BOOL isNewChoice = TRUE;

    if (![choiceKey isEqualToString:@""]) {
        
        isNewChoice = FALSE;
    }else {
        [choiceKey setString:[NSString stringWithFormat:@"%@%@", currentDTS, [moralKey lowercaseString]]];
    }
    
    float severityConversion = severitySlider.value;
	
    if (!isVirtue) {
        severityConversion *= -1;
        choiceWeightFilledFields *= -1;
    }
    
    float choiceCalculatedWeight = 0;
    choiceCalculatedWeight = (choiceWeightFilledFields/2 + severityConversion) * choiceInfluence;
    
    UserChoiceDAO *currentUserChoiceDAO = [[UserChoiceDAO alloc] initWithKey:choiceKey];

    
    //Save the choice record to CoreData
    //Affect Conscience too
    if (isNewChoice) {
        currentUserChoice = [currentUserChoiceDAO create];
        
        [currentUserChoice setEntryCreationDate:[NSDate date]];
        
        //Setup a transient expression for Conscience in response to entry
        //UserDefault will be picked up by ConscienceViewController
        [prefs setFloat:((severityConversion * 10.0) + 50) forKey:@"transientMind"];
        
        /** @todo refactor into ConscienceMind
         */
        float newMood = appDelegate.userConscienceMind.mood + choiceCalculatedWeight/3;
        float newEnthusiasm = appDelegate.userConscienceMind.enthusiasm + choiceWeightFilledFields/2;
        
        if (newMood > 90) {
            appDelegate.userConscienceMind.mood = 90.0;
        } else if (newMood < 10) {
            appDelegate.userConscienceMind.mood = 10.0;
        } else {
            appDelegate.userConscienceMind.mood = newMood;        
        }
        
        if (newEnthusiasm > 90) {
            appDelegate.userConscienceMind.enthusiasm = 90.0;
        } else if (newEnthusiasm < 10) {
            appDelegate.userConscienceMind.enthusiasm = 10.0;
        } else {
            appDelegate.userConscienceMind.enthusiasm = newEnthusiasm;        
        }
        
        UserCharacterDAO *currentUserCharacterDAO = [[UserCharacterDAO alloc] init];
        UserCharacter *currentUserCharacter = [currentUserCharacterDAO read:@""];
        
        [currentUserCharacter setCharacterMood:[NSNumber numberWithFloat:newMood]];    
        [currentUserCharacter setCharacterEnthusiasm:[NSNumber numberWithFloat:newEnthusiasm]];    
        
        [currentUserCharacterDAO update];
        
        [currentUserCharacterDAO release];
        
        //See if moral has been rewarded before
        //Cannot assume that first instance of UserChoice implies no previous reward
        if ([appDelegate.userCollection containsObject:moralKey]) {
            
            UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:moralKey];

            UserCollectable *currentUserCollectable = [currentUserCollectableDAO read:@""];
                        
            [currentUserCollectableDAO release];
            //Increase the moral's value
            float moralIncrease = [[currentUserCollectable collectableValue] floatValue];
            
            if (moralIncrease >= 99.0) {
                moralIncrease = 99.0;
            } else {
               moralIncrease += 1.0;
            }
            
            [currentUserCollectable setValue:[NSNumber numberWithFloat:moralIncrease] forKey:@"collectableValue"];
            
        } else {
            
            UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:@""];
         
            //Create a new moral reward
            UserCollectable *currentUserCollectable = [currentUserCollectableDAO create];
            
            [currentUserCollectable setCollectableCreationDate:[NSDate date]];
            [currentUserCollectable setCollectableKey:choiceKey];
            [currentUserCollectable setCollectableName:moralKey];
            [currentUserCollectable setCollectableValue:[NSNumber numberWithFloat:1.0]];
                        
            [appDelegate.userCollection addObject:moralKey];
            
            [currentUserCollectableDAO update];
            [currentUserCollectableDAO release];

        }
        
        [self increaseEthicals];
        
    }else {        
        currentUserChoice = [currentUserChoiceDAO read:@""];
        
    }
	
    [currentUserChoice setEntryShortDescription:choiceTextField.text];
    [currentUserChoice setEntryLongDescription:choiceLongDescription];
    [currentUserChoice setEntrySeverity:[NSNumber numberWithFloat:severityConversion]];
    [currentUserChoice setEntryModificationDate:[NSDate date]];
    [currentUserChoice setEntryKey:choiceKey];
    [currentUserChoice setChoiceMoral:moralKey];
    [currentUserChoice setChoiceJustification:choiceJustification];
    [currentUserChoice setChoiceInfluence:[NSNumber numberWithInt:choiceInfluence]];
    [currentUserChoice setEntryIsGood:[NSNumber numberWithBool:isVirtue]];
    [currentUserChoice setChoiceConsequences:choiceConsequences];
    [currentUserChoice setChoiceWeight:[NSNumber numberWithFloat:choiceCalculatedWeight]];    
	
    [currentUserChoiceDAO update];
	
    [currentUserChoiceDAO release];
    
    //invalidate rest of session
    [self cancelChoice:placeHolderID];
}

/**
Implementation: Retrieve current amount of ethicals, add 5 currently
@todo determine if static reward is needed
 */
-(void)increaseEthicals{
    
    UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:kCollectableEthicals];
    
    //Update User's ethicals
    UserCollectable *currentUserCollectable = [currentUserCollectableDAO read:@""];
    [currentUserCollectableDAO release];
    
    int ethicals = [[currentUserCollectable collectableValue] intValue];
    
    ethicals += 5;
    
    if (ethicals > 999) {
        ethicals = 999;
    }
    
    //Save User's new ethicals    
    [currentUserCollectable setValue:[NSNumber numberWithInt:ethicals] forKey:@"collectableValue"];
    
}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    
	[doneButton setTitle:NSLocalizedString(@"ChoiceScreenDoneButtonTitleLabel",@"Title Label for Done button") forState:UIControlStateNormal];
	[doneButton setTitle:NSLocalizedString(@"ChoiceScreenDoneButtonTitleLabel",@"Title Label for Done button") forState:UIControlStateHighlighted];
	doneButton.accessibilityHint = NSLocalizedString(@"ChoiceScreenDoneButtonHint",@"Hint for Done button");	
	doneButton.accessibilityLabel = NSLocalizedString(@"ChoiceScreenDoneButtonLabel",@"Label for Done button");	
    
	[cancelButton setTitle:NSLocalizedString(@"ChoiceScreenCancelButtonTitleLabel",@"Title Label for Cancel button") forState:UIControlStateNormal];
	[cancelButton setTitle:NSLocalizedString(@"ChoiceScreenCancelButtonTitleLabel",@"Title Label for Cancel button") forState:UIControlStateHighlighted];
	cancelButton.accessibilityHint = NSLocalizedString(@"ChoiceScreenCancelButtonHint",@"Hint for Cancel button");	
	cancelButton.accessibilityLabel = NSLocalizedString(@"ChoiceScreenCancelButtonLabel",@"Label for Cancel button");	
    
	choiceTextField.accessibilityHint = NSLocalizedString(@"ChoiceScreenChoiceTextFieldHint",@"Hint for Choice textField");
	choiceTextField.accessibilityLabel =  NSLocalizedString(@"ChoiceScreenChoiceTextFieldLabel",@"Label for Choice textField");
    
    moralReferenceButton.accessibilityHint = NSLocalizedString(@"ChoiceScreenMoralReferenceButtonHint",@"Hint for Moral Reference button");	
	moralReferenceButton.accessibilityLabel = NSLocalizedString(@"ChoiceScreenMoralReferenceButtonLabel",@"Label for Moral Reference button");	
    
    moralHistoryButton.accessibilityHint = NSLocalizedString(@"ChoiceScreenMoralHistoryButtonHint",@"Hint for Moral History button");	
	moralHistoryButton.accessibilityLabel = NSLocalizedString(@"ChoiceScreenMoralHistoryButtonLabel",@"Label for Moral History button");	
    
    
	descriptionTextView.accessibilityHint =  NSLocalizedString(@"ChoiceScreenDescriptionTextViewHint",@"Hint for Description textField");
	descriptionTextView.accessibilityLabel =  NSLocalizedString(@"ChoiceScreenDescriptionTextViewLabel",@"Label for Description textField");
    
    severitySlider.accessibilityHint = NSLocalizedString(@"ChoiceScreenSeverityHint",@"Hint for Severity slider");
	severitySlider.accessibilityLabel =  NSLocalizedString(@"ChoiceScreenSeverityLabel",@"Label for Severity slider");
    NSMutableString *localString = [NSString stringWithFormat:@"ChoiceScreen%dTitle", isVirtue];
    
    //Change Title of screen to reflect good or bad choice
    [self setTitle:NSLocalizedString(localString, @"Title for Choice screen")];
    [severityLabel setText:NSLocalizedString(@"ChoiceScreenSeverityLabel",@"Hint for Details Label")];
    
    severityLabel.accessibilityHint = NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenSeverityLabel%dHint", isVirtue]), @"Hint for Severity Label");
    severitySlider.accessibilityHint =  NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenSeverity%dHint", isVirtue]), @"Hint for Severity Slider");
    severitySlider.accessibilityLabel =  NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenSeverity%dLabel", isVirtue]), @"Label for Severity Slider");		
    
    //Populate severity arrays for descriptions to reflect good or bad choice
    //Localized string are keyed to accept the isVirtue BOOL as an int (Virtue = 1, Vice = 0)
    [severityLabelDescriptions removeAllObjects];
    [severityLabelDescriptions addObject:NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenSeverityLabel%da", isVirtue]), @"Label for Severity Level 1")]; 
    [severityLabelDescriptions addObject:NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenSeverityLabel%db", isVirtue]), @"Label for Severity Level 2")];
    [severityLabelDescriptions addObject:NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenSeverityLabel%dc", isVirtue]), @"Label for Severity Level 3")];
    [severityLabelDescriptions addObject:NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenSeverityLabel%dd", isVirtue]), @"Label for Severity Level 4")];
    [severityLabelDescriptions addObject:NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenSeverityLabel%de", isVirtue]), @"Label for Severity Level 5")];    

	[choiceTextField setText:NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenChoice%dLabel", isVirtue]), @"Label for Choice Textfield")];
    
	[moralButton setTitle:NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenMoral%dLabel", isVirtue]), @"Label for Moral Button") forState:UIControlStateNormal];
	moralButton.accessibilityHint = NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenMoral%dHint", isVirtue]), @"Hint for Moral Button");
	moralButton.accessibilityLabel = NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenMoral%dLabel", isVirtue]), @"Label for Moral Button");
	[descriptionTextView setText:NSLocalizedString(([NSString stringWithFormat:@"ChoiceScreenDescription", isVirtue]), @"Label for Description Textview")];
    
    [hideKeyboardButton setTitle:NSLocalizedString(@"ChoiceScreenDoneButtonTitleLabel",@"Title Label for Done button") forState: UIControlStateNormal];
    [hideKeyboardButton setTitle:NSLocalizedString(@"ChoiceScreenDoneButtonTitleLabel",@"Title Label for Done button") forState: UIControlStateHighlighted];    


}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	NSLog(@"about to fail");
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [moralHistoryButton release];
    moralHistoryButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [choiceKey release];
	[[NSNotificationCenter defaultCenter] removeObserver:self name: UITextFieldTextDidChangeNotification object:activeField];
    [moralHistoryButton release];
    [severityLabelDescriptions release];
	[super dealloc];
}


@end