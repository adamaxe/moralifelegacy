/**
Implementation:  Retrieve ReferenceAsset, ConscienceAsset or Moral from SystemData.
Determine which fields and UI elements should be presented depending up on Reference type.  Populate form and allow additional interaction elements.
 
@class ReferenceDetailViewController ReferenceDetailViewController.h
 */

#import "ReferenceDetailViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "ReferenceModel.h"
#import "ConscienceHelpViewController.h"
#import "UserCollectableDAO.h"
#import "ViewControllerLocalization.h"

@interface ReferenceDetailViewController () <ViewControllerLocalization> {
    
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	
	IBOutlet UIButton *wwwLinkButton;			/**< button to allow Safari access to more info */
	IBOutlet UIButton *quoteButton;			/**< button to push Quote modal window */
	
	IBOutlet UIImageView *referencePictureView;		/**< card surrounding reference image */
	IBOutlet UIImageView *referenceSmallPictureView;	/**< card surrounding reference image */
	IBOutlet UIImageView *moralPictureView;             	/**< moral image referencing asset's moral value*/
	IBOutlet UIImageView *cardView;             	/**< moral image referencing asset's moral value*/
	IBOutlet UILabel *referenceNameLabel;			/**< reference name */
	IBOutlet UILabel *referenceDateLabel;			/**< reference date of birth/construction/publishment */
	IBOutlet UILabel *referenceOriginLabel;			/**< reference's place of creation/birth/construction */
	IBOutlet UILabel *referenceShortDescriptionLabel;	/**< text to appear under reference name */
	IBOutlet UILabel *cardNumberLabel;                  	/**< text to appear over card */
	IBOutlet UITextView *referenceLongDescriptionTextView;	 /**< detailed reference text */
    
	int referenceType;			/**< which type of reference is being presented */
	bool hasQuote;				/**< does reference have a quote */
	bool hasLink;				/**< does reference have an external link */
	
	NSString *referenceName;			/**< display name of Reference */
	NSString *referenceKey;				/**< reference pkey */
	NSMutableString *referenceDate;		/**< reference origin date */
	NSMutableString *referenceDeathDate;	/**< reference death date */
	NSString *referencePicture;			/**< picture of reference */
	NSString *referenceReferenceURL;		/**< URL of external reference text */
	NSString *referenceShortDescription;	/**< description of reference */
	NSString *referenceLongDescription;		/**< detailed account of reference */
	NSString *referenceOrigin;			/**< place of reference origin */
    
	NSString *referenceOrientation;
	NSString *referenceMoral; 			/**< moral assigned to reference */
	NSString *referenceQuote;			/**< quote by or referencing reference */
    
}

@property (nonatomic, strong) ReferenceModel *referenceModel;   /**< Model to handle data/business logic */

/**
 Create a date view for a reference
 */
-(void)createDateView;

/**
 Take data from UserData and populate fields and UI
 */
-(void)populateReferenceScreen;

/**
 Retrieve userCollection to determine what value the assets have
 */
-(void)retrieveCollection;

/**
 Retrieve reference from SystemData
 */
-(void)retrieveReference;

@end

@implementation ReferenceDetailViewController

#pragma mark -
#pragma mark ViewController Lifecycle

- (id)initWithModel:(ReferenceModel *)referenceModel {
    self = [super init];

    if (self) {
        self.referenceModel = referenceModel;
    }

    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	prefs = [NSUserDefaults standardUserDefaults];		
    
	if ([self.title length] == 0) {
		self.title = NSLocalizedString(@"ReferenceDetailScreenTitle",@"Title for Reference Detail Screen");
	}
    
	referenceKey = [prefs objectForKey:@"referenceKey"];
	referenceType = [prefs integerForKey:@"referenceType"];
    
	if (referenceKey != nil) {
		[prefs removeObjectForKey:@"referenceKey"];		
	}else{
        referenceKey = @"";
	}
    
	[self retrieveReference];
	[self populateReferenceScreen];
	[referenceLongDescriptionTextView flashScrollIndicators];
    [self localizeUI];

}

-(void) viewWillDisappear:(BOOL)animated{	

    if (referenceKey != nil) {
        
        if (![referenceKey isEqualToString:@""]) {
            [prefs setObject:referenceKey forKey:@"referenceKey"];    
        }
        
        [prefs setInteger:referenceType forKey:@"referenceType"];

    }

}

#pragma mark -
#pragma mark UI Interaction

/**
Implementation: Show Conscience thoughtbubble containing Quote
 */
-(IBAction)showReferenceData:(id)sender{
		
	// Create the root view controller for the navigation controller
	// The new view controller configures a Cancel and Done button for the
	// navigation bar.
    
    NSString *helpTitleName =[[NSString alloc] initWithFormat:@"Help%@1Title1",NSStringFromClass([self class])];
    
    NSArray *titles = @[NSLocalizedString(helpTitleName,@"Title for Help Screen")];
    
    ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
    

    NSString *quoteFormatted = [[NSString alloc] initWithString:[referenceQuote stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];
    
    NSArray *texts = @[quoteFormatted];

    
    [conscienceHelpViewCont setHelpTitles:titles];
    [conscienceHelpViewCont setHelpTexts:texts];
    [conscienceHelpViewCont setIsConscienceOnScreen:FALSE];
    
    
    [self presentModalViewController:conscienceHelpViewCont animated:NO];
	
}

/**
Implementation: Launch MobileSafari with reference's URL
 */
-(IBAction)showExternalURL:(id)sender{

	NSURL *url = [NSURL URLWithString:referenceReferenceURL];
	
	if (![[UIApplication sharedApplication] openURL:url])
		
		NSLog(@"%@%@",@"Failed to open url:",[url description]);	
	
}

/**
Implementation: Dismiss view.
 */
-(IBAction)dismissReferenceModal:(id)sender{
	
	[self dismissModalViewControllerAnimated:YES];
		
}

/**
Implementation: Determine whether death is applicable, create span and determine era
 */
- (void) createDateView {
    
  if ([referenceDeathDate isEqualToString:@"0"]) {
		[referenceDeathDate setString:@""];
	} else if ([referenceDeathDate characterAtIndex:0] == '-') {
		
		[referenceDeathDate setString:[referenceDeathDate substringFromIndex:1]];
		[referenceDeathDate appendString:@"BCE"];
		
	}	
	
	if ([referenceDate isEqualToString:@"0"]) {
		[referenceDate setString:@""];
	} else if ([referenceDate characterAtIndex:0] == '-') {
		
		[referenceDate setString:[referenceDate substringFromIndex:1]];
		[referenceDate appendString:@"BCE"];
		
	}
    
    NSString *combinedDate = [[NSString alloc] initWithFormat:@"%@-%@", referenceDate, referenceDeathDate];
	
	[referenceDateLabel setText:combinedDate];

}

/**
Implementation: Determine which type of image to show to User in reference card.  Figures get the full frame.
 */
-(void) populateReferenceScreen{
	
	NSMutableString *detailImageName = [[NSMutableString alloc] initWithString:referencePicture];

	if (referenceType < 3) {
		[detailImageName appendString:@"-sm.png"];
		referenceSmallPictureView.image = [UIImage imageNamed:[NSString stringWithString:detailImageName]];
	} else if (referenceType == 4) {
		[detailImageName appendString:@".png"];
		referenceSmallPictureView.image = [UIImage imageNamed:[NSString stringWithString:detailImageName]];
		[self retrieveCollection];
	}  else {
		[detailImageName appendString:@".jpg"];
		referencePictureView.image = [UIImage imageNamed:[NSString stringWithString:detailImageName]];
	}

	[moralPictureView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", referenceMoral]]];
	
	[referenceNameLabel setText:referenceName];
	[referenceOriginLabel setText:referenceOrigin];
	[referenceShortDescriptionLabel setText:referenceShortDescription];
	[referenceLongDescriptionTextView setText:referenceLongDescription];
	
	if (referenceType > 0) {
		[self createDateView];
	} else {
		[referenceDateLabel setText:@""];
	}
	
	//Adjust onscreen buttons for available data
	if (!hasQuote) {
		
		quoteButton.hidden = TRUE;
		
		if (hasLink) {
			
			wwwLinkButton.center = CGPointMake(167, wwwLinkButton.center.y);
		}

	} else {
		quoteButton.hidden = FALSE;
	}
	
	//Adjust onscreen buttons for available data
	if (!hasLink) {
		
		wwwLinkButton.hidden = TRUE;
		
		if (hasLink) {
			
			quoteButton.center = CGPointMake(167, quoteButton.center.y);
		}
		
	} else {
		wwwLinkButton.hidden = FALSE;
	}
	
}	

#pragma mark -
#pragma mark Data Manipulation

/**
Implementation: Find value of reference from UserCollection in case of Morals
 */
-(void)retrieveCollection {
    
    UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:referenceKey];
    
    UserCollectable *currentUserCollectable = [currentUserCollectableDAO read:@""];
    
    [cardNumberLabel setText:[NSString stringWithFormat:@"%d", [[currentUserCollectable collectableValue] intValue]]];

}

/**
Implementation: Retrieve reference from SystemData based upon type passed from ReferenceListViewController.
Must know type of NSManagedObject in order to fetch.  Determine which UI elements are available to each type of Reference.
  */
 -(void) retrieveReference{

     self.referenceModel.referenceType = referenceType;
     self.referenceModel.referenceKey = referenceKey;

     hasLink = self.referenceModel.hasLink;
     hasQuote = self.referenceModel.hasQuote;
     
     referenceName = [[NSString alloc] initWithString:self.referenceModel.references[0]];
     referencePicture = [[NSString alloc] initWithString:self.referenceModel.icons[0]];
     referenceShortDescription = [[NSString alloc] initWithString:self.referenceModel.details[0]];
     referenceLongDescription = [[NSString alloc] initWithString:self.referenceModel.longDescriptions[0]];
     referenceReferenceURL = [[NSString alloc] initWithString:self.referenceModel.links[0]];
     referenceDate = [[NSMutableString alloc] initWithFormat:@"%@",(NSNumber *)self.referenceModel.originYears[0]];
     referenceOrigin = [[NSString alloc] initWithString:self.referenceModel.originLocations[0]];
     referenceQuote = [[NSString alloc] initWithString:self.referenceModel.quotes[0]];
     referenceDeathDate = [[NSMutableString alloc] initWithFormat:@"%@",(NSNumber *)self.referenceModel.endYears[0]];
     referenceOrientation = [[NSMutableString alloc] initWithString:self.referenceModel.orientations[0]];
     referenceMoral = [[NSString alloc] initWithString:self.referenceModel.relatedMorals[0]];
     		
}


#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {

	wwwLinkButton.accessibilityHint = NSLocalizedString(@"ReferenceDetailScreenWwwLinkButtonHint",@"Hint for WWW button");
	wwwLinkButton.accessibilityLabel = NSLocalizedString(@"ReferenceDetailScreenWwwLinkButtonLabel",@"Label for WWW button");

	quoteButton.accessibilityHint = NSLocalizedString(@"ReferenceDetailScreenQuoteButtonHint",@"Hint for Quote button");
	quoteButton.accessibilityLabel = NSLocalizedString(@"ReferenceDetailScreenQuoteButtonLabel",@"Label for Quote button");

	referenceLongDescriptionTextView.accessibilityHint = NSLocalizedString(@"ReferenceDetailScreenLongDescriptionTextViewHint",@"Hint for Reference textView");
	referenceLongDescriptionTextView.accessibilityIdentifier =  NSLocalizedString(@"ReferenceDetailScreenLongDescriptionTextViewLabel",@"Label for Reference textView");

    referenceNameLabel.accessibilityHint = NSLocalizedString(@"ReferenceDetailScreenReferenceNameLabelHint",@"Hint for Moral Reference button");
	referenceNameLabel.accessibilityIdentifier = NSLocalizedString(@"ReferenceDetailScreenReferenceNameLabelLabel",@"Label for Moral Reference button");
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
