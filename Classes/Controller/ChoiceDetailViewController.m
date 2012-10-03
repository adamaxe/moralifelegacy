/**
Implementation: User can input three additional pieces of information that will affect calculation of the Moral Weight of the Choice.
Data is pulled from NSUserDefaults in order to take advantage of built-in state retention.  No CD calls are needed as User will not commit from this screen.
 
@class ChoiceDetailViewController ChoiceDetailViewController.h
*/

#import "ChoiceDetailViewController.h"
#import "StructuredTextField.h"
#import "ConscienceHelpViewController.h"
#import "ViewControllerLocalization.h"

@interface ChoiceDetailViewController () <ViewControllerLocalization> {
    
	NSUserDefaults *prefs;					/**< serialized user settings/state retention */
	
	IBOutlet UIImageView *influenceImageView;		/**< people image decorating influenceSlider */
	IBOutlet UIImageView *cloudImageView;		/**< cloud image decorating influenceSlider */
    
	IBOutlet UISlider *influenceSlider;         /**< Slider control dictating how many people were affected */
	IBOutlet UILabel *influenceLabel;           /**< Label that shows User amount of influence */
	IBOutlet UILabel *justificationLabel;       /**< Justification textField label */
	IBOutlet UILabel *consequencesLabel;        /**< Consequences textField label */
	NSArray *influenceLabelDescriptions;        /**< Array of NSLocalized Strings to display to User */
	
	IBOutlet UIButton *doneButton;		/**< Done Button */
	IBOutlet UIButton *cancelButton;		/**< Cancel Button */
	IBOutlet UIButton *influenceButton;		/**< Influence Button */	
    
	IBOutlet StructuredTextField *justificationTextField;	/**< Text field for User-entered justification */
	IBOutlet StructuredTextField *consequencesTextField;	/**< Text field for User-entered consequence */
	StructuredTextField *activeField;				/**< Temporary field designation for active field */
    
	BOOL isChoiceCancelled;		/**< is Choice being cancelled, don't save */
}

/**
 Limit a text field for each key press
 @param note NSNotification Allows system to check field length with every keypress
 */
-(void)limitTextField:(NSNotification *)note;

/**
 Saves the details.
 */
- (void)saveChoice;

/**
 Cancels the details.
 */
- (void)cancelChoice;


@end 

@implementation ChoiceDetailViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	//Reference serialized User state retention
	prefs = [NSUserDefaults standardUserDefaults];
    
	//Set maximum lengths for User-entry to textfields
	justificationTextField.delegate = self;
	justificationTextField.maxLength = kChoiceTextFieldLength;
	consequencesTextField.delegate = self;
	consequencesTextField.maxLength = kChoiceTextFieldLength;

	[influenceSlider setThumbImage:[UIImage imageNamed:@"button-circle-down.png"] forState:UIControlStateNormal];
	[influenceSlider setThumbImage:[UIImage imageNamed:@"button-circle-down.png"] forState:UIControlStateHighlighted];

	//Make slider decoration invisible so that fade-in is possible
	[influenceButton setAlpha:0];
	[influenceImageView setAlpha:0];
	[cloudImageView setAlpha:0];

	//Setting to determine if details are being cancelled
	isChoiceCancelled = FALSE;
	
	//Prevent keypress level changes over maxlength of field
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitTextField:) name: UITextFieldTextDidChangeNotification object:activeField];

    [self localizeUI];
}

-(void) viewWillAppear:(BOOL)animated{
	
    [super viewWillAppear:animated];

	
	//Restore state of prior view if applicable	
	NSString *restoreJustification = [prefs objectForKey:@"choiceJustification"];
	NSString *restoreConsequence = [prefs objectForKey:@"choiceConsequence"];
	float restoreInfluence = [prefs floatForKey:@"choiceInfluence"];
	
	if (restoreJustification != nil) {
		justificationTextField.text = restoreJustification;
		[prefs removeObjectForKey:@"choiceJustification"];
		
	}
	
	if (restoreConsequence != nil) {
		consequencesTextField.text = restoreConsequence;
		[prefs removeObjectForKey:@"choiceConsequence"];
		
	}
	
	if (restoreInfluence >= 0) {
		influenceSlider.value = restoreInfluence;
		[prefs removeObjectForKey:@"choiceInfluence"];
		
	}
	
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [UIView beginAnimations:@"showInfluenceImage" context:nil];
    [UIView setAnimationDuration:0.5];
    [influenceButton setAlpha:1];
    [influenceImageView setAlpha:1];
    [cloudImageView setAlpha:1];
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];

}


-(void) viewWillDisappear:(BOOL)animated{
	
    [super viewWillDisappear:animated];
    
	[self saveChoice];
		
}

#pragma mark -
#pragma mark UI Interaction

/**
 Implementation: Show an initial help screen if this is the User's first use of the screen.  Set a User Default after help screen is presented.  Launch a ConscienceHelpViewController and populate a localized help message.
 */
-(void)showInitialHelpScreen {
    
    //If this is the first time that the app, then show the initial help
    NSObject *firstChoiceEntryCheck = [prefs objectForKey:@"firstChoiceDetailEntry"];
    
    if (firstChoiceEntryCheck == nil) {
        
        ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
        [conscienceHelpViewCont setViewControllerClassName:NSStringFromClass([self class])];        
		[conscienceHelpViewCont setIsConscienceOnScreen:FALSE];
        [conscienceHelpViewCont setHelpVersion:0];
		[self presentModalViewController:conscienceHelpViewCont animated:NO];
        
        [prefs setBool:FALSE forKey:@"firstChoiceDetailEntry"];
        
    }
}

/**
Implementation: change the influence value and update the influence Label
 */
-(IBAction)influenceChange:(id) sender{
	
	//Ensure that sender is the right input
	if ([sender isKindOfClass:[UISlider class]]) {

		//Set influence
		UISlider *slider = (UISlider *) sender;
		int influenceAsInt =(int)(slider.value);

		//Change slider description to current localized value.	
		[influenceLabel setText:(NSString *)influenceLabelDescriptions[influenceAsInt-1]];
//        [influenceSlider setValue:influenceAsInt];
	}
	
}

/**
Implementation: pop UIViewController from current navigationController
 */
-(IBAction)doneTapped:(id) sender{
    
    [self saveChoice];
	//Return to previous view by popping current view off navigation controller	
	[self.navigationController popViewControllerAnimated:TRUE];
}

/**
 Implementation: remove NSUserDefault state information, set Cancel flag, pop UIViewController from current navigationController
 */
-(IBAction)cancelTapped {
    
    [self cancelChoice];
    
    [self.navigationController popViewControllerAnimated:TRUE];
    
}

- (void)saveChoice {
    
    if (!isChoiceCancelled) {
        
        //Do not save default help text
        NSString *defaultTextJustification = [[NSString alloc] initWithString:NSLocalizedString(@"ChoiceDetailsScreenJustificationText",@"Label for Justification Textfield")];
        NSString *defaultTextConsequences = [[NSString alloc] initWithString:NSLocalizedString(@"ChoiceDetailsScreenConsequenceText",@"Label for Consequence Textfield")];
        
        
        if (![justificationTextField.text isEqualToString:@""] && ![justificationTextField.text isEqualToString:defaultTextJustification]) {
            [prefs setObject:justificationTextField.text forKey:@"choiceJustification"];    
        }
        
        if (![consequencesTextField.text isEqualToString:@""] && ![consequencesTextField.text isEqualToString:defaultTextConsequences]) {
            
            [prefs setObject:consequencesTextField.text forKey:@"choiceConsequence"];    		
        }
        
        [prefs setFloat:influenceSlider.value forKey:@"choiceInfluence"];
        
        [prefs synchronize];
        
    }
}

- (void)cancelChoice {
    
	//Remove ChoiceDetail state information
    [prefs removeObjectForKey:@"choiceJustification"];
	[prefs removeObjectForKey:@"choiceConsequence"];
	[prefs removeObjectForKey:@"choiceInfluence"];	
	
	isChoiceCancelled = TRUE;
}


/**
 Implementation: Present ConscienceHelpViewController that shows User purpose of the Influence button.
 */
-(IBAction)selectInfluence:(id) sender{
    
    
    ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
    [conscienceHelpViewCont setViewControllerClassName:NSStringFromClass([self class])];        
    [conscienceHelpViewCont setIsConscienceOnScreen:FALSE];
    [conscienceHelpViewCont setHelpVersion:1];
    [self presentModalViewController:conscienceHelpViewCont animated:NO];
}

#pragma mark -
#pragma mark Text Field Delegate/Interaction
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	[theTextField resignFirstResponder];
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	//Setup active field for other callbacks, typecast to custom text field for max length property
	activeField = (StructuredTextField *) textField;
	
	//If text in field is default, then clear it	
	if (textField.tag > 0) {

		if ([activeField.text isEqualToString:NSLocalizedString(@"ChoiceDetailsScreenConsequenceText",@"Label for Consequence Textfield")]) {
			activeField.text = @"";
			
		}
		
	}else {
		if ([activeField.text isEqualToString:NSLocalizedString(@"ChoiceDetailsScreenJustificationText",@"Label for Justification Textfield")]) {
			activeField.text = @"";
			
		}
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

	//Reset active field
	activeField = nil;
	
}

/**
Implementation:  Truncate the field on each keypress if length is greater
 */
- (void)limitTextField:(NSNotification *)note {
    
	if ([[activeField text] length] > activeField.maxLength) {
		//If current length is greater, truncate
		[activeField setText:[[activeField text] substringToIndex:activeField.maxLength]];
    }
}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    
    //Retrieve localized view title string.  Do no do this in init, XIB is not loaded until viewDidLoad    
	[self setTitle:NSLocalizedString(@"ChoiceDetailsScreenTitle",@"Label for Choice Details Screen")];
    
	//Retrieve localized done button string
	//Set localization for UI elements, accessors are utilized in order to format text correctly (fit text)
	[justificationLabel setText:NSLocalizedString(@"ChoiceDetailsScreenJustificationLabel",@"Label for Justification textField")];
	justificationTextField.accessibilityHint = NSLocalizedString(@"ChoiceDetailsScreenJustificationHint",@"Hint for Justification textField");
	justificationTextField.accessibilityLabel =  NSLocalizedString(@"ChoiceDetailsScreenJustificationLabel",@"Label for Justification textField");
    
	[consequencesLabel setText:NSLocalizedString(@"ChoiceDetailsScreenConsequenceLabel",@"Label for Consequence textField")];
	consequencesTextField.accessibilityHint = NSLocalizedString(@"ChoiceDetailsScreenConsequenceHint",@"Hint for Consequence textField");
	consequencesTextField.accessibilityLabel =  NSLocalizedString(@"ChoiceDetailsScreenConsequenceLabel",@"Label for Consequence textField");
    
    influenceSlider.accessibilityHint = NSLocalizedString(@"ChoiceDetailsScreenInfluenceHint",@"Hint for Influence Slider");
    influenceSlider.accessibilityLabel = NSLocalizedString(@"ChoiceDetailsScreenInfluenceLabel",@"Label for Influence Slider");
    
    influenceButton.accessibilityHint = NSLocalizedString(@"ChoiceDetailsScreenInfluenceButtonHint",@"Hint for Influence Button");
    influenceButton.accessibilityLabel = NSLocalizedString(@"ChoiceDetailsScreenInfluenceButtonLabel",@"Label for Influence Button");
    
	//Retrieve localized influence description strings
    [influenceLabel setText:NSLocalizedString(@"ChoiceDetailsScreenInfluenceLabel",@"Label for Influence Slider")];
	influenceLabelDescriptions = @[NSLocalizedString(@"ChoiceDetailsScreenInfluenceLabel1",@"Label for Influence Level 1"), NSLocalizedString(@"ChoiceDetailsScreenInfluenceLabel2",@"Label for Influence Level 2"), NSLocalizedString(@"ChoiceDetailsScreenInfluenceLabel3",@"Label for Influence Level 3"), NSLocalizedString(@"ChoiceDetailsScreenInfluenceLabel4",@"Label for Influence Level 4"), NSLocalizedString(@"ChoiceDetailsScreenInfluenceLabel5",@"Label for Influence Level 5")];
    
	[doneButton setTitle:NSLocalizedString(@"ChoiceDetailsScreenDoneButtonTitleLabel",@"Title Label for Done button") forState:UIControlStateNormal];
	[doneButton setTitle:NSLocalizedString(@"ChoiceDetailsScreenDoneButtonTitleLabel",@"Title Label for Done button") forState:UIControlStateHighlighted];
	doneButton.accessibilityHint = NSLocalizedString(@"ChoiceDetailsScreenDoneButtonHint",@"Hint for Done button");	
	doneButton.accessibilityLabel = NSLocalizedString(@"ChoiceDetailsScreenDoneButtonLabel",@"Label for Done button");	
    
	[cancelButton setTitle:NSLocalizedString(@"ChoiceDetailsScreenCancelButtonTitleLabel",@"Title Label for Cancel button") forState:UIControlStateNormal];
	[cancelButton setTitle:NSLocalizedString(@"ChoiceDetailsScreenCancelButtonTitleLabel",@"Title Label for Cancel button") forState:UIControlStateHighlighted];
	cancelButton.accessibilityHint = NSLocalizedString(@"ChoiceDetailsScreenCancelButtonHint",@"Hint for Cancel button");	
	cancelButton.accessibilityLabel = NSLocalizedString(@"ChoiceDetailsScreenCancelButtonLabel",@"Label for Cancel button");	
    [justificationTextField setText:NSLocalizedString(@"ChoiceDetailsScreenJustificationText",@"Help Text for Justification Textfield")];
    [consequencesTextField setText:NSLocalizedString(@"ChoiceDetailsScreenConsequenceText",@"Help Text for Consequence Textfield")];

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
	[[NSNotificationCenter defaultCenter] removeObserver:self name: UITextFieldTextDidChangeNotification object:activeField];
}

@end