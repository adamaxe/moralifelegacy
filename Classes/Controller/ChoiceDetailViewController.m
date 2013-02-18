/**
Implementation: User can input three additional pieces of information that will affect calculation of the Moral Weight of the Choice.
Data is pulled from NSUserDefaults in order to take advantage of built-in state retention.  No CD calls are needed as User will not commit from this screen.
 
@class ChoiceDetailViewController ChoiceDetailViewController.h
*/

#import "ChoiceDetailViewController.h"
#import "StructuredTextField.h"
#import "ConscienceHelpViewController.h"
#import "ViewControllerLocalization.h"
#import "UIViewController+Screenshot.h"
#import "UIFont+Utility.h"

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

@property (nonatomic) ConscienceHelpViewController *conscienceHelpViewController;

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

    justificationLabel.font = [UIFont fontForTextLabels];
    [justificationLabel setShadowColor:[UIColor whiteColor]];
    [justificationLabel setShadowOffset:CGSizeMake(0, 1)];
    consequencesLabel.font = [UIFont fontForTextLabels];
    [consequencesLabel setShadowColor:[UIColor whiteColor]];
    [consequencesLabel setShadowOffset:CGSizeMake(0, 1)];
    influenceLabel.font = [UIFont fontForTextLabels];
    [influenceLabel setShadowColor:[UIColor whiteColor]];
    [influenceLabel setShadowOffset:CGSizeMake(0, 1)];

	//Set maximum lengths for User-entry to textfields
	justificationTextField.delegate = self;
	justificationTextField.maxLength = MLChoiceTextFieldLength;
	consequencesTextField.delegate = self;
	consequencesTextField.maxLength = MLChoiceTextFieldLength;

	[influenceSlider setThumbImage:[UIImage imageNamed:@"button-circle-down.png"] forState:UIControlStateNormal];
	[influenceSlider setThumbImage:[UIImage imageNamed:@"button-circle-down.png"] forState:UIControlStateHighlighted];

	//Setting to determine if details are being cancelled
	isChoiceCancelled = FALSE;

    self.navigationItem.hidesBackButton = YES;

    UIBarButtonItem *choiceBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(popToHome)];
    [self.navigationItem setLeftBarButtonItem:choiceBarButton];

	//Prevent keypress level changes over maxlength of field
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitTextField:) name: UITextFieldTextDidChangeNotification object:activeField];

    ConscienceHelpViewController *conscienceHelpViewController = [[ConscienceHelpViewController alloc] init];
    conscienceHelpViewController.viewControllerClassName = NSStringFromClass([self class]);
    conscienceHelpViewController.isConscienceOnScreen = FALSE;
    self.conscienceHelpViewController = conscienceHelpViewController;

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

    influenceImageView.alpha = 0;
    influenceButton.alpha = 0;
    cloudImageView.alpha = 0;

}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.5 animations:^{

        influenceImageView.alpha = 1;
        influenceButton.alpha = 1;
        cloudImageView.alpha = 1;
        
    }];

    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];

}


-(void) viewWillDisappear:(BOOL)animated{
	
    [super viewWillDisappear:animated];
    
	[self saveChoice];
		
}

- (void)popToHome {

    [self.navigationController popToRootViewControllerAnimated:TRUE];
    
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
        
        self.conscienceHelpViewController.numberOfScreens = 1;
        self.conscienceHelpViewController.screenshot = [self takeScreenshot];

		[self presentModalViewController:self.conscienceHelpViewController animated:NO];
        
        [prefs setBool:FALSE forKey:@"firstChoiceDetailEntry"];
        
    }
}

- (void)changeInfluenceLabel:(int)influenceAsInt {
    [UIView animateWithDuration:0.25 animations:^{
        influenceLabel.alpha = 0.0;
    }completion:^(BOOL finished){
        [influenceLabel setText:(NSString *)influenceLabelDescriptions[influenceAsInt-1]];
        influenceLabel.accessibilityLabel = influenceLabel.text;

        [UIView animateWithDuration:0.25 animations:^{
            influenceLabel.alpha = 1.0;
        }];

    }];
}

/**
Implementation: change the influence value and update the influence Label
 */
-(IBAction)influenceChange:(id) sender{
	
	//Ensure that sender is the right input
	if ([sender isKindOfClass:[UISlider class]]) {

		UISlider *slider = (UISlider *) sender;
		int influenceAsInt = (int)(slider.value);

        BOOL isInfluenceLabelIncorrect = ![influenceLabel.text isEqualToString:influenceLabelDescriptions[influenceAsInt - 1]];

        if (isInfluenceLabelIncorrect && (influenceAsInt <= 5 && influenceAsInt >= 1)){

            [self changeInfluenceLabel:influenceAsInt];
        }
	}
	
}

/**
Implementation: pop UIViewController from current navigationController
 */
-(IBAction)doneTapped:(id) sender{

    [self saveChoice];
    //Return to previous view by popping current view off navigation controller
    [self.navigationController popViewControllerAnimated:YES];

}

/**
 Implementation: remove NSUserDefault state information, set Cancel flag, pop UIViewController from current navigationController
 */
-(IBAction)cancelTapped {

    [self cancelChoice];

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)saveChoice {
    
    if (!isChoiceCancelled) {
                
        if (![justificationTextField.text isEqualToString:@""]) {
            [prefs setObject:justificationTextField.text forKey:@"choiceJustification"];    
        }
        
        if (![consequencesTextField.text isEqualToString:@""]) {
            
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
    
    self.conscienceHelpViewController.screenshot = [self takeScreenshot];

    self.conscienceHelpViewController.numberOfScreens = 2;
    [self presentModalViewController:self.conscienceHelpViewController animated:NO];
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
	[self setTitle:NSLocalizedString(@"ChoiceDetailsScreenTitle",nil)];
    
	//Retrieve localized done button string
	//Set localization for UI elements, accessors are utilized in order to format text correctly (fit text)
	[justificationLabel setText:NSLocalizedString(@"ChoiceDetailsScreenJustificationLabel",nil)];
	justificationTextField.accessibilityHint = NSLocalizedString(@"ChoiceDetailsScreenJustificationHint",nil);
	justificationTextField.accessibilityLabel =  NSLocalizedString(@"ChoiceDetailsScreenJustificationLabel",nil);
    
	[consequencesLabel setText:NSLocalizedString(@"ChoiceDetailsScreenConsequenceLabel",nil)];
	consequencesTextField.accessibilityHint = NSLocalizedString(@"ChoiceDetailsScreenConsequenceHint",nil);
	consequencesTextField.accessibilityLabel =  NSLocalizedString(@"ChoiceDetailsScreenConsequenceLabel",nil);
    
    influenceSlider.accessibilityHint = NSLocalizedString(@"ChoiceDetailsScreenInfluenceHint",nil);
    influenceSlider.accessibilityLabel = NSLocalizedString(@"ChoiceDetailsScreenInfluenceLabel",nil);
    
    influenceButton.accessibilityHint = NSLocalizedString(@"ChoiceDetailsScreenInfluenceButtonHint",nil);
    influenceButton.accessibilityLabel = NSLocalizedString(@"ChoiceDetailsScreenInfluenceButtonLabel",nil);
    
	//Retrieve localized influence description strings
    [influenceLabel setText:NSLocalizedString(@"ChoiceDetailsScreenInfluenceLabel",nil)];
	influenceLabelDescriptions = @[NSLocalizedString(@"ChoiceDetailsScreenInfluenceLabel1",nil), NSLocalizedString(@"ChoiceDetailsScreenInfluenceLabel2",nil), NSLocalizedString(@"ChoiceDetailsScreenInfluenceLabel3",nil), NSLocalizedString(@"ChoiceDetailsScreenInfluenceLabel4",nil), NSLocalizedString(@"ChoiceDetailsScreenInfluenceLabel5",nil)];
    
	[doneButton setTitle:NSLocalizedString(@"ChoiceDetailsScreenDoneButtonTitleLabel",nil) forState:UIControlStateNormal];
	[doneButton setTitle:NSLocalizedString(@"ChoiceDetailsScreenDoneButtonTitleLabel",nil) forState:UIControlStateHighlighted];
	doneButton.accessibilityHint = NSLocalizedString(@"ChoiceDetailsScreenDoneButtonHint",nil);	
	doneButton.accessibilityLabel = NSLocalizedString(@"ChoiceDetailsScreenDoneButtonLabel",nil);	
    
	[cancelButton setTitle:NSLocalizedString(@"ChoiceDetailsScreenCancelButtonTitleLabel",nil) forState:UIControlStateNormal];
	[cancelButton setTitle:NSLocalizedString(@"ChoiceDetailsScreenCancelButtonTitleLabel",nil) forState:UIControlStateHighlighted];
	cancelButton.accessibilityHint = NSLocalizedString(@"ChoiceDetailsScreenCancelButtonHint",nil);	
	cancelButton.accessibilityLabel = NSLocalizedString(@"ChoiceDetailsScreenCancelButtonLabel",nil);	
    [justificationTextField setPlaceholder:NSLocalizedString(@"ChoiceDetailsScreenJustificationText",nil)];
    [consequencesTextField setPlaceholder:NSLocalizedString(@"ChoiceDetailsScreenConsequenceText",nil)];

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