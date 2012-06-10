/**
Implementation:  Provide UI for entering in a Luck.  Commits data to UserData.  
 
@class LuckViewController LuckViewController.h
 */

#import "LuckViewController.h"
#import "MoraLifeAppDelegate.h"
#import "StructuredTextField.h"
#import "UserLuck.h"
#import "ConscienceHelpViewController.h"

@interface LuckViewController () {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
    
	IBOutlet UILabel *severityLabel;					/**< UILabel for UISlider of luck's severity */
	IBOutlet UILabel *luckLabel;						/**< UILabel for UISlider of luck's severity */
	IBOutlet UIImageView *luckImageView;				/**< luck image */
	IBOutlet UIImageView *cloudImageView;				/**< luck image */
	IBOutlet UIImageView *backgroundImageView;			/**< background image */
	IBOutlet UIImageView *descriptionInnerShadow;			/**< faux inner drop shadow for UITextView */
	IBOutlet UIView *luckParametersView;				/**< UIView for hiding top parameters for keyboard */
	IBOutlet UIView *luckDescriptionView;				/**< UIView for shifting bottom parameter for keyboard */
	
	IBOutlet UIButton *hideKeyboardButton;					/**< done button for UITextView keyboard dismissal */
	IBOutlet UIButton *doneButton;						/**< done button for ViewController dismissal */
	IBOutlet UIButton *cancelButton;						/**< cancel button for ViewController dismissal and entry deletion*/
	
	IBOutlet StructuredTextField *luckTextField;			/**< overloaded text field for luck's title */
	IBOutlet UITextView *descriptionTextView;				/**< UITextView for luck's extended description */
	IBOutlet UISlider *severitySlider;						/**< UISlider for luck's severity */
	
	StructuredTextField *activeField;						/** temporary overloaded text field for determining active field */
	
	NSArray *luckSeverityLabelDescriptions;				/** list of positive localized severity descriptions */
	
	BOOL isGood;											/** determine if screen shown is good or bad */
	BOOL isLuckFinished;									/** determine if choice is complete */
	
	UserLuck *currentUserLuck;								/** nsmanagedobject of current luck */
	NSString *luckKey;										/** string to hold primary key of current luck */
	
}

/**
 Present a customized Done UIButton on top of the UITextView for data entry.
 */
-(void)presentDoneButton;

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

@end

@implementation LuckViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//appDelegate needed to pass information from modal views (virtues/vices) to primary view
	//and to get Core Data Context
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	prefs = [NSUserDefaults standardUserDefaults];
	context = [appDelegate.moralModelManager managedObjectContext];
    
	[self setTitle:NSLocalizedString(@"LuckScreenTitle",@"Title for Luck screen")];
	self.accessibilityLabel = NSLocalizedString(@"LuckScreenLabel",@"Label for Luck Screen");
	self.accessibilityHint = NSLocalizedString(@"LuckScreenHint",@"Hint for Luck Screen");			
    
	if (!isLuckFinished) {
		isLuckFinished = FALSE;
	}
    
	//User can back out of Luck Entry screen and state will be saved
	//However, user should not be able to select a virtue, and then select a vice for entry
	
	NSObject *boolCheck = [prefs objectForKey:@"entryIsGood"];
	
	if (boolCheck != nil) {
		isGood = [prefs boolForKey:@"entryIsGood"];
	}else {
		isGood = TRUE;
	}
	
	//Change Title of screen to reflect good or bad luck
	[self setTitle:NSLocalizedString(([NSString stringWithFormat:@"LuckScreen%dTitle", isGood]), @"Title for Luck screen")];
	severityLabel.accessibilityHint = NSLocalizedString(([NSString stringWithFormat:@"LuckScreenSeverityLabel1Hint", isGood]), @"Hint for Severity Label");
	severitySlider.accessibilityHint =  NSLocalizedString(([NSString stringWithFormat:@"LuckScreenSeverity1Hint", isGood]), @"Hint for Severity Slider");
	severitySlider.accessibilityLabel =  NSLocalizedString(([NSString stringWithFormat:@"LuckScreenSeverity1Label", isGood]), @"Label for Severity Slider");		
	
	//Populate severity arrays for descriptions to reflect good or bad luck
	luckSeverityLabelDescriptions = [[NSArray alloc] initWithObjects:NSLocalizedString(([NSString stringWithFormat:@"LuckScreenSeverityLabel%da", isGood]), @"Label for Severity Level 1"), 
                                     NSLocalizedString(([NSString stringWithFormat:@"LuckScreenSeverityLabel%db", isGood]), @"Label for Severity Level 2"), 
                                     NSLocalizedString(([NSString stringWithFormat:@"LuckScreenSeverityLabel%dc", isGood]), @"Label for Severity Level 3"), 
                                     NSLocalizedString(([NSString stringWithFormat:@"LuckScreenSeverityLabel%dd", isGood]), @"Label for Severity Level 4"), 
                                     NSLocalizedString(([NSString stringWithFormat:@"LuckScreenSeverityLabel%de", isGood]), @"Label for Severity Level 5"), nil];
	
	[doneButton setTitle:NSLocalizedString(@"LuckScreenDoneButtonTitleLabel",@"Title Label for Done button") forState:UIControlStateNormal];	
	[doneButton setTitle:NSLocalizedString(@"LuckScreenDoneButtonTitleLabel",@"Title Label for Done button") forState:UIControlStateHighlighted];	
	doneButton.accessibilityHint = NSLocalizedString(@"LuckScreenDoneButtonHint",@"Hint for Done button");	
	doneButton.accessibilityLabel = NSLocalizedString(@"LuckScreenDoneButtonLabel",@"Label for Done button");	
	
	[cancelButton setTitle:NSLocalizedString(@"LuckScreenCancelButtonTitleLabel",@"Title Label for Cancel button") forState:UIControlStateNormal];	
	[cancelButton setTitle:NSLocalizedString(@"LuckScreenCancelButtonTitleLabel",@"Title Label for Cancel button") forState:UIControlStateHighlighted];		
	cancelButton.accessibilityHint = NSLocalizedString(@"LuckScreenCancelButtonHint",@"Hint for Cancel button");	
	cancelButton.accessibilityLabel = NSLocalizedString(@"LuckScreenCancelButtonLabel",@"Label for Cancel button");	
	
	//luckTextField is a custom StructuredTextField with max length.
	luckTextField.delegate = self;
	luckTextField.maxLength = kLuckTextFieldLength;
	luckTextField.accessibilityHint = NSLocalizedString(@"LuckScreenLuckTextFieldHint",@"Hint for Luck textField");
	luckTextField.accessibilityLabel =  NSLocalizedString(@"LuckScreenLuckTextFieldLabel",@"Label for Luck textField");
	descriptionTextView.delegate = self;
	descriptionTextView.accessibilityHint =  NSLocalizedString(@"LuckScreenDescriptionTextViewHint",@"Hint for Description textField");
	descriptionTextView.accessibilityLabel =  NSLocalizedString(@"LuckScreenDescriptionTextViewLabel",@"Label for Description textField");
	
	//Place inner shadow around flat UITextView
	[descriptionInnerShadow setImage:[UIImage imageNamed:@"textview-innershadow.png"]];
	
	[severitySlider setThumbImage:[UIImage imageNamed:@"button-circle-down.png"] forState:UIControlStateNormal];
	[severitySlider setThumbImage:[UIImage imageNamed:@"button-circle-down.png"] forState:UIControlStateHighlighted];
	
	//Prevent keypress level changes over maxlength of field
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(limitTextField:) name: UITextFieldTextDidChangeNotification object:activeField];
    
    
	[luckImageView setAlpha:0];
	[cloudImageView setAlpha:0];
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	NSMutableString *luckImageName = [[NSMutableString alloc] init];	
    
	[luckTextField setText:NSLocalizedString(([NSString stringWithFormat:@"LuckScreenLuck%dLabel", isGood]), @"Label for Luck Textfield")];
	[luckLabel setText:NSLocalizedString(([NSString stringWithFormat:@"LuckScreenKey%dLabel", isGood]), @"Label for Luck Image")];
	luckImageView.accessibilityHint = NSLocalizedString(([NSString stringWithFormat:@"LuckScreenLuck%dHint", isGood]), @"Hint for Luck Image");
	[descriptionTextView setText:NSLocalizedString(@"LuckScreenDescription", @"Label for Description Textview")];
	
	if (isGood) {
		[luckImageName appendString:kLuckImageNameGood];
	}else {
		[luckImageName appendString:kLuckImageNameBad];
	}
	
	[luckImageName appendString:@".png"];
	[luckImageView setImage:[UIImage imageNamed:luckImageName]];
	[luckImageName release];
	
	//Restore state of prior view if applicable	
	NSString *restoreShortDescription = [prefs objectForKey:@"entryShortDescription"];
	NSString *restoreLongDescription = [prefs objectForKey:@"entryLongDescription"];
	NSString *restoreLuckKey = [prefs objectForKey:@"entryKey"];
	
	float restoreSeverity = [prefs floatForKey:@"entrySeverity"];
	
	if (restoreShortDescription != nil) {
		[luckTextField setText:restoreShortDescription];
		[prefs removeObjectForKey:@"entryShortDescription"];
		
	}
	
	if (restoreLongDescription != nil) {
		[descriptionTextView setText:restoreLongDescription];
		[prefs removeObjectForKey:@"entryLongDescription"];
		
	}
	
	if (restoreLuckKey != nil) {
		luckKey = restoreLuckKey;
		[prefs removeObjectForKey:@"entryKey"];
		
	}else {
		luckKey = @"";
	}
	
	/** @bug fix leak in luckKey possibly */
	[luckKey retain];
	
	if (restoreSeverity > 0) {
		severitySlider.value = restoreSeverity;
		
	}
	
	if (restoreSeverity < 0) {
		severitySlider.value = restoreSeverity * -1;
	}
	
	[self severityChange:severitySlider];
	
	[prefs removeObjectForKey:@"entrySeverity"];
	
	[prefs removeObjectForKey:@"entryIsGood"];
	
}

-(void) viewWillDisappear:(BOOL)animated{
	
	//Save current state of form unless luck is finished
	if (!isLuckFinished) {
		
		//Do not save default help text
		NSString *defaultTextFieldText = NSLocalizedString(([NSString stringWithFormat:@"LuckScreenLuck%dLabel", isGood]), @"Label for Luck Textfield");
		
		NSString *defaultTextViewText = NSLocalizedString(@"LuckScreenDescription", @"Label for Description Textview");
		
		if (![luckTextField.text isEqualToString:@""] && ![luckTextField.text isEqualToString:defaultTextFieldText]) {
			[prefs setObject:luckTextField.text forKey:@"entryShortDescription"];    
		}
		
		if (![descriptionTextView.text isEqualToString:@""] && ![descriptionTextView.text isEqualToString:defaultTextViewText]) {
			
			[prefs setObject:descriptionTextView.text forKey:@"entryLongDescription"];    		
		}
		
		//Save off entries to FS
		[prefs setObject:luckKey forKey:@"entryKey"];
		[luckKey release];
		[prefs setFloat:severitySlider.value forKey:@"entrySeverity"];
		[prefs setBool:isGood forKey:@"entryIsGood"];
	}
	
}

-(void)viewDidAppear:(BOOL)animated {

	//Present Lucky/Unlucky designation as a thought bubble
	[UIView beginAnimations:@"showLuckImage" context:nil];
	[UIView setAnimationDuration:0.5];
	[luckImageView setAlpha:1];
	[cloudImageView setAlpha:1];
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark UI Interaction

/**
Implementation: Set Choice Severity and reflect change in UI
 */
-(IBAction)severityChange:(id) sender{
	
	//Change severity labels to reflect good or bad luck.
	if ([sender isKindOfClass:[UISlider class]]) {
		
		UISlider *slider = (UISlider *) sender;
		int severityAsInt = (int)(slider.value);
		
		[severityLabel setText:(NSString *)[luckSeverityLabelDescriptions objectAtIndex:severityAsInt-1]];
		severityLabel.accessibilityLabel = severityLabel.text;
		
	}
	
}

/**
Implementation:  Determine if commit is possible.  If not, present ConscienceHelpViewController to alert User to issue.
@todo simplify help strings and controllers
 */
-(IBAction)commitLuck:(id) sender{
		
	//If user hasn't selected a Moral, prompt them
	NSString *luckFirst = luckTextField.text;
	
	//Do not save default help text
	NSString *defaultTextFieldText = NSLocalizedString(([NSString stringWithFormat:@"LuckScreenLuck%dLabel", isGood]), @"Label for Luck Textfield");
    
	if ([luckFirst isEqualToString:@""] || [luckFirst isEqualToString:defaultTextFieldText]) {
        
		NSString *helpTitleName =[[NSString alloc] initWithFormat:@"Help%@1Title1",NSStringFromClass([self class])];
      	NSString *helpTextName =[[NSString alloc] initWithFormat:@"Help%@1Text1",NSStringFromClass([self class])];
        
		NSArray *titles = [[NSArray alloc] initWithObjects: NSLocalizedString(helpTitleName,@"Title for Help Screen"), nil];
		NSArray *texts = [[NSArray alloc] initWithObjects:NSLocalizedString(helpTextName,@"Text for Help Screen"), nil];
        
		ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
		conscienceHelpViewCont.helpTitles = titles;
		conscienceHelpViewCont.helpTexts = texts;
		conscienceHelpViewCont.isConscienceOnScreen = FALSE;
		
		[self presentModalViewController:conscienceHelpViewCont animated:NO];
		[helpTitleName release];
		[helpTextName release];
		[titles release];
		[texts release];
		[conscienceHelpViewCont release];
		
	}else { 
		[self commitDataToUserData];
	}
}

/**
Implementation: Cancel all choice attributes, delete NSUserDefault values, dismiss view.
 */
-(IBAction)cancelLuck:(id) sender{
	
	//Notify viewWillDisappear not to save state
	isLuckFinished = TRUE;
	
	//Clear fields
	[luckTextField setText:@""];
	[descriptionTextView setText:@""];
	[severitySlider setValue:0];
	
	//Remove all state information
	[prefs removeObjectForKey:@"entryShortDescription"];
	[prefs removeObjectForKey:@"entryLongDescription"];
	[prefs removeObjectForKey:@"entryKey"];
	[prefs removeObjectForKey:@"entrySeverity"];
	[prefs removeObjectForKey:@"entryIsGood"];
	
	[self.navigationController popViewControllerAnimated:TRUE];
	
}

#pragma mark -
#pragma mark Custom UI animations

/**
Implementation: Enter key in UITextView only inputs CRLF.  A separate button is needed to resignFirstResponder.
 */
- (void)presentDoneButton{
	
	//Do not display done button if TextField is active
	if (activeField == nil) {
		
		//Re-arrange view
		[self animateOptionChange:1];
		
		hideKeyboardButton = [UIButton buttonWithType: UIButtonTypeCustom];
		hideKeyboardButton.frame = CGRectMake(250, 480, 74, 39);
		hideKeyboardButton.alpha = 0;
		[hideKeyboardButton setTitle:@"Done" forState: UIControlStateNormal];
		[hideKeyboardButton setBackgroundImage:[UIImage imageNamed:@"button-normal-down.png"] forState: UIControlStateNormal];
		[hideKeyboardButton setBackgroundImage:[UIImage imageNamed:@"button-normal-down.png"] forState: UIControlStateHighlighted];	
		[hideKeyboardButton addTarget: self action:@selector(hideKeyboard) forControlEvents: UIControlEventTouchUpInside];
		
		[UIView beginAnimations:@"doneButtonAnimation" context:nil];
		[UIView setAnimationDuration:0.5];
		[self.view addSubview: hideKeyboardButton];
		hideKeyboardButton.frame = CGRectMake(250, 205, 74, 39);
		hideKeyboardButton.alpha = 1;
		[UIView commitAnimations];
		
	}
	
}

/**
Implementation: Shift UITextView up to top of screen, hide elements underneath, present a button to cancel keyboard
 */
- (void)animateOptionChange:(int)viewNumber{
	
	[UIView beginAnimations:@"advancedAnimations" context:nil];
	[UIView setAnimationDuration:0.2];
	
	// move the UITextView up, hide rest of parameters
	CGRect descriptionFrame = luckDescriptionView.frame; 
	if (viewNumber == 0) {
		luckParametersView.alpha = 1.0;
		descriptionFrame.origin.y += 145;
	}else {
		luckParametersView.alpha = 0.0;		
		descriptionFrame.origin.y -= 145;
	}
	luckDescriptionView.frame = descriptionFrame;
	[UIView commitAnimations];
	
}

/**
Implementation: Resign first responder and return the views to original locations.
 */
-(void)hideKeyboard
{
	[self animateOptionChange:0];
	
	[hideKeyboardButton removeFromSuperview];
	[descriptionTextView resignFirstResponder];
}

#pragma mark -
#pragma mark Data Manipulation

/**
Implementation: Compile all of the relevant data from fields.  Calculate changes, commit to Core Data
 */
-(void)commitDataToUserData {
    
    id placeHolderID = nil;
    
	//Retrieve readwrite Documents directory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *userData =  [documentsDirectory stringByAppendingPathComponent:@"UserData.sqlite"];
	NSURL *storeURL = [NSURL fileURLWithPath:userData];
		
	id readWriteStore = [[context persistentStoreCoordinator] persistentStoreForURL:storeURL];
		
	NSError *outError = nil;
		
	//Construct Unique Primary Key from dtstamp to millisecond
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];	
		
	NSString *currentDTS = [dateFormatter stringFromDate:[NSDate date]];
		
	[dateFormatter release];
        
	BOOL isNewLuck = TRUE;
		
	//if (luckKey != nil) {
	if (luckKey != @"") {
		isNewLuck = FALSE;
	}else {
		luckKey = [NSString stringWithFormat:@"%@%@", currentDTS, [luckLabel.text lowercaseString]];
	}
		
	float severityConversion = severitySlider.value;
		
	if (!isGood) {
		severityConversion *= -1;
	}
		
	//Save the luck record to CoreData
	if (isNewLuck) {
		currentUserLuck = [NSEntityDescription insertNewObjectForEntityForName:@"UserLuck" inManagedObjectContext:context];
	}else {
		NSError *outError;
			
		NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserLuck" inManagedObjectContext:context];
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		[request setEntity:entityAssetDesc];
			
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"entryKey == %@", luckKey];
		[request setPredicate:pred];
		
		NSArray *objects = [context executeFetchRequest:request error:&outError];
		currentUserLuck = [objects objectAtIndex:0];
		
		[request release];
	}
		
	[currentUserLuck setEntryShortDescription:luckTextField.text];
       
	NSString *luckLongDescription = descriptionTextView.text;
        
	NSString *defaultTextViewText = NSLocalizedString(@"LuckScreenDescription", @"Label for Luck Textfield");
        
	if ([luckLongDescription isEqualToString:@""] || [luckLongDescription isEqualToString:defaultTextViewText]) {
		luckLongDescription = @"";
	} 
        
	[currentUserLuck setEntryLongDescription:luckLongDescription];
	[currentUserLuck setEntrySeverity:[NSNumber numberWithFloat:severityConversion]];

	if (isNewLuck) {
		[currentUserLuck setEntryCreationDate:[NSDate date]];
	}

	[currentUserLuck setEntryModificationDate:[NSDate date]];
	[currentUserLuck setEntryKey:luckKey];
	[currentUserLuck setEntryIsGood:[NSNumber numberWithBool:isGood]];
       
	if (isNewLuck) {
		[context assignObject:currentUserLuck toPersistentStore:readWriteStore];
	}
		
	[context save:&outError];
		
	if (outError != nil) {
		NSLog(@"save error:%@", outError);
	}
		
	[context reset];
		
	//invalidate rest of session
	[self cancelLuck:placeHolderID];
}

#pragma mark -
#pragma mark TextField/View delegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	[theTextField resignFirstResponder];
	
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{	
	[self presentDoneButton];
	
	//If text in view is default, then clear it
	if ([textView.text isEqualToString:NSLocalizedString(@"LuckScreenDescription",@"Label for Luck TextView")]) {
		[textView setText:@""];
		
	}
	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = (StructuredTextField *) textField;
	NSString *defaultText = NSLocalizedString(([NSString stringWithFormat:@"LuckScreenLuck%dLabel", isGood]), @"Label for Luck Textfield");
	
	//If text in field is default, then clear it
	if ([activeField.text isEqualToString:defaultText]) {
		[activeField setText:@""];
	}
    	
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
	
	[descriptionTextView resignFirstResponder];
	
	return YES;
}

- (void)limitTextField:(NSNotification *)note {
    
	if ([[activeField text] length] > activeField.maxLength) {
        [activeField setText:[[activeField text] substringToIndex:activeField.maxLength]];
    }
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name: UITextFieldTextDidChangeNotification object:activeField];
	[luckSeverityLabelDescriptions release];
    [super dealloc];
}


@end