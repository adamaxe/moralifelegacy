/**
Implementation:  Retrieve ReferenceAsset, ConscienceAsset or Moral from SystemData.
Determine which fields and UI elements should be presented depending up on Reference type.  Populate form and allow additional interaction elements.
 
@class ReferenceDetailViewController ReferenceDetailViewController.h
 */

#import "ReferenceDetailViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "ConscienceAssetDAO.h"
#import "ReferenceAssetDAO.h"
#import "ReferencePersonDAO.h"
#import "ReferenceBeliefDAO.h"
#import "MoralDAO.h"
#import "ReferenceTextDAO.h"
#import "ConscienceHelpViewController.h"
#import "UserCollectable.h"

@interface ReferenceDetailViewController () {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
	
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

- (void)viewDidLoad {
	[super viewDidLoad];

	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	context = [appDelegate.moralModelManager readWriteManagedObjectContext];
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
    
    NSArray *titles = [[NSArray alloc] initWithObjects:
                       NSLocalizedString(helpTitleName,@"Title for Help Screen"), nil];
    
    ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
    

    NSString *quoteFormatted = [[NSString alloc] initWithString:[referenceQuote stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];
    
    NSArray *texts = [[NSArray alloc] initWithObjects:quoteFormatted, nil];
    [quoteFormatted release];

    
    [conscienceHelpViewCont setHelpTitles:titles];
    [conscienceHelpViewCont setHelpTexts:texts];
    [conscienceHelpViewCont setIsConscienceOnScreen:FALSE];
    
    [helpTitleName release];
    [titles release];
    [texts release];
    
    [self presentModalViewController:conscienceHelpViewCont animated:NO];
    [conscienceHelpViewCont release];
	
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
	[combinedDate release];

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
	[detailImageName release];
	
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
    
    NSError *outError;
    
    NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserCollectable" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityAssetDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"collectableName == %@", referenceKey];
    [request setPredicate:pred];
    
    NSArray *objects = [context executeFetchRequest:request error:&outError];
    
    if ([objects count] == 0) {
        NSLog(@"No collection");
    } else {

        UserCollectable *currentUserCollectable = [objects objectAtIndex:0];
        
        [cardNumberLabel setText:[NSString stringWithFormat:@"%d", [[currentUserCollectable collectableValue] intValue]]];

    }

    [request release];
}

/**
Implementation: Retrieve reference from SystemData based upon type passed from ReferenceListViewController.
Must know type of NSManagedObject in order to fetch.  Determine which UI elements are available to each type of Reference.
  */
 -(void) retrieveReference{
    
	hasQuote = TRUE;
	hasLink = TRUE;
     
     id currentDAO;
    
	//Determine which type of reference was requested
	//Show/Hide Quote button
	switch (referenceType){
		case 0:
			self.title = NSLocalizedString(@"ReferenceDetailScreenAccessoriesTitle",@"Title for Accessories Button");
            currentDAO = [[ConscienceAssetDAO alloc] initWithKey:referenceKey];
			hasQuote = FALSE;
			hasLink = FALSE;
			break;
		case 1:
			self.title = NSLocalizedString(@"ReferenceDetailScreenBeliefsTitle",@"Title for Beliefs Button");
            currentDAO = [[ReferenceBeliefDAO alloc] initWithKey:referenceKey];
			break;
		case 2:
			self.title = NSLocalizedString(@"ReferenceDetailScreenBooksTitle",@"Title for Books Button");
            currentDAO = [[ReferenceTextDAO alloc] initWithKey:referenceKey];
			break;
		case 3:
			self.title = NSLocalizedString(@"ReferenceDetailScreenPeopleTitle",@"Title for People Button");
            currentDAO = [[ReferencePersonDAO alloc] initWithKey:referenceKey];
			break;
		case 4:
			self.title = NSLocalizedString(@"ReferenceDetailScreenMoralsTitle",@"Title for Moral Button");
            currentDAO = [[MoralDAO alloc] initWithKey:referenceKey];
			hasQuote = FALSE;
			break;
		default:
			self.title = NSLocalizedString(@"ReferenceDetailScreenDefaultTitle",@"Title for Default Screen");
            currentDAO = [[ReferenceAssetDAO alloc] initWithKey:referenceKey];
			break;
	}

     //Balance releases in case of no Reference		
    referenceName = [[NSString alloc] initWithString:[currentDAO readDisplayName:@""]];
    referencePicture = [[NSString alloc] initWithString:[currentDAO readImageName:@""]];
    referenceShortDescription = [[NSString alloc] initWithString:[currentDAO readShortDescription:@""]];
//    referenceDeathDate = [[NSMutableString alloc] initWithString:@"0"];
//    referenceOrigin =  [[NSString alloc] init];
//    referenceOrientation = [[NSString alloc] initWithString:@""];
//    referenceMoral = [[NSString alloc] initWithString:@""];
//    referenceQuote = [[NSString alloc] initWithString:@""];

     if ([currentDAO respondsToSelector:@selector(readSubtitle:)]) {
         referenceLongDescription = [[NSString alloc] initWithString:[currentDAO readSubtitle:@""]];
     } else {
         referenceLongDescription = [[NSString alloc] initWithString:[currentDAO readLongDescription:@""]];
     }

     if ([currentDAO respondsToSelector:@selector(readLink:)]) {
         referenceReferenceURL = [[NSString alloc] initWithString:[currentDAO readLink:@""]];
     } else {
         referenceReferenceURL = [[NSMutableString alloc] initWithString:@""];            
     }
     
     if ([currentDAO respondsToSelector:@selector(readOriginYear:)]) {
         referenceDate = [[NSMutableString alloc] initWithString:[[currentDAO readOriginYear:@""] stringValue]];
     } else {
         referenceDate = [[NSMutableString alloc] initWithString:@"0"];
     }		
     
     if ([currentDAO respondsToSelector:@selector(readOriginLocation:)]) {
         
         if ([currentDAO readOriginLocation:@""] == nil) {
             referenceOrigin = [[NSMutableString alloc] initWithString:@""];
         } else {
             referenceOrigin = [[NSMutableString alloc] initWithString:[currentDAO readOriginLocation:@""]];
         }
         
     } else {
         referenceOrigin = [[NSMutableString alloc] initWithString:@""];
     }	
     
     if ([currentDAO respondsToSelector:@selector(readDeathYear:)]) {
         referenceDeathDate = [[NSMutableString alloc] initWithString:[[currentDAO readDeathYear:@""] stringValue]];
     } else {
         referenceDeathDate = [[NSMutableString alloc] initWithString:@"0"];
     }
     
     if ([currentDAO respondsToSelector:@selector(readOrientation:)]) {
         referenceOrientation = [[NSString alloc] initWithString:[currentDAO readOrientation:@""]];
     } else {
         referenceOrientation = [[NSString alloc] initWithString:@""];
     }
     
     if ([currentDAO respondsToSelector:@selector(readQuote:)]) {
         referenceQuote = [[NSString alloc] initWithString:[currentDAO readQuote:@""]];
     } else {
         referenceQuote = [[NSString alloc] initWithString:@""];
     }
     

     if ([currentDAO respondsToSelector:@selector(readMoralKey:)]) {
         MoralDAO *currentMoralDAO = [[MoralDAO alloc] initWithKey:[currentDAO readMoralKey:@""]];
                                   
         if (currentMoralDAO) {
             referenceMoral = [[NSString alloc] initWithString:[currentMoralDAO readImageName:@""]];
             
             if (![currentDAO isKindOfClass:ReferencePersonDAO.class]) {

                 [referenceOrigin release];
                 referenceOrigin = [[NSString alloc] initWithFormat:@"+%d %@", [[currentDAO readMoralValue:@""] intValue], [currentMoralDAO readDisplayName:@""]];
             }
             
         } else {
             referenceMoral = [[NSString alloc] initWithString:@""];
         }
         
         [currentMoralDAO release];
     } else {
         referenceMoral = [[NSString alloc] initWithString:@""];
     }
     		
     [currentDAO release];
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
	

    [referenceQuote release];
	[referenceName release];
	[referenceDate release];    
	[referenceDeathDate release];    
	[referenceMoral release];
	[referenceOrientation release];
	[referenceLongDescription release];
	[referenceShortDescription release];
	[referenceReferenceURL release];
	[referencePicture release];
	[referenceOrigin release];
    
    [super dealloc];

}


@end
