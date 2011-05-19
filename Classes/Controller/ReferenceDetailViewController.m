/**
Implementation:  Retrieve ReferenceAsset, ConscienceAsset or Moral from SystemData.
Determine which fields and UI elements should be presented depending up on Reference type.  Populate form and allow additional interaction elements.
 
@class ReferenceDetailViewController ReferenceDetailViewController.h
 */

#import "ReferenceDetailViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ConscienceAsset.h"
#import "ReferencePerson.h"
#import "ReferenceReport.h"
#import "ReferenceBelief.h"
#import "ReferenceText.h"
#import "ConscienceView.h"
#import "ConscienceAccessories.h"
#import "ConscienceBody.h"
#import "ConscienceBuilder.h"
#import "UserCharacter.h"
#import "Moral.h"
#import "ConscienceHelpViewController.h"
#import "UserCollectable.h"

@implementation ReferenceDetailViewController

#pragma mark -
#pragma mark ViewController Lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];

	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	context = [appDelegate managedObjectContext];
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
    
    ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] initWithNibName:@"ConscienceHelpView" bundle:[NSBundle mainBundle]];
    

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
	[referenceOriginLabel setText:referenceOrigin];
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
    
	//Begin CoreData Retrieval
	NSError *outError;
	
	NSEntityDescription *entityAssetDesc;
	hasQuote = TRUE;
	hasLink = TRUE;
    
	//Determine which type of reference was requested
	//Show/Hide Quote button
	switch (referenceType){
		case 0:
			self.title = NSLocalizedString(@"ReferenceDetailScreenAccessoriesTitle",@"Title for Accessories Button");
			entityAssetDesc = [NSEntityDescription entityForName:@"ConscienceAsset" inManagedObjectContext:context];
			hasQuote = FALSE;
			hasLink = FALSE;
			break;
		case 1:
			self.title = NSLocalizedString(@"ReferenceDetailScreenBeliefsTitle",@"Title for Beliefs Button");
			entityAssetDesc = [NSEntityDescription entityForName:@"ReferenceBelief" inManagedObjectContext:context];
			break;
		case 2:
			self.title = NSLocalizedString(@"ReferenceDetailScreenBooksTitle",@"Title for Books Button");
			entityAssetDesc = [NSEntityDescription entityForName:@"ReferenceText" inManagedObjectContext:context];
			break;
		case 3:
			self.title = NSLocalizedString(@"ReferenceDetailScreenPeopleTitle",@"Title for People Button");
			entityAssetDesc = [NSEntityDescription entityForName:@"ReferencePerson" inManagedObjectContext:context];
			break;
		case 4:
			self.title = NSLocalizedString(@"ReferenceDetailScreenMoralsTitle",@"Title for Moral Button");
			entityAssetDesc = [NSEntityDescription entityForName:@"Moral" inManagedObjectContext:context];
			hasQuote = FALSE;
			break;
		case 5:
			self.title = NSLocalizedString(@"ReferenceDetailScreenReportsTitle",@"Title for Reports Screen");
			entityAssetDesc = [NSEntityDescription entityForName:@"ReferenceReport" inManagedObjectContext:context];
			hasQuote = FALSE;
			hasLink = FALSE;
			break;
		default:
			self.title = NSLocalizedString(@"ReferenceDetailScreenDefaultTitle",@"Title for Default Screen");
			entityAssetDesc = [NSEntityDescription entityForName:@"ReferenceAsset" inManagedObjectContext:context];			
			break;
	}
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];

	//Determine if inherited NSManagedObject is ReferenceAsset or just Moral
	if (referenceType != 4) {
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"nameReference like %@", referenceKey];
		[request setPredicate:pred];
	} else {
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"nameMoral like %@", referenceKey];
		[request setPredicate:pred];
	}
	
	NSArray *referenceObjects = [context executeFetchRequest:request error:&outError];
	[request release];

	if ([referenceObjects count] == 0) {

		//Balance releases in case of no Reference		
		referenceName = [[NSString alloc] init];
		referencePicture = [[NSString alloc] init];
		referenceShortDescription = [[NSString alloc] init];
		referenceLongDescription = [[NSString alloc] init];
		referenceReferenceURL = [[NSString alloc] init];
		referenceDate = [[NSMutableString alloc] initWithString:@"0"];
		referenceDeathDate = [[NSMutableString alloc] initWithString:@"0"];
		referenceOrigin =  [[NSString alloc] init];
		referenceOrientation = [[NSString alloc] initWithString:@""];
		referenceMoral = [[NSString alloc] initWithString:@""];
		referenceQuote = [[NSString alloc] initWithString:@""];

	} else {
		        
		//Ensure that each reference text is available to current reference
		if ([[referenceObjects objectAtIndex:0] respondsToSelector:@selector(displayNameReference)]) {

			referenceName = [[NSString alloc] initWithString:[[referenceObjects objectAtIndex:0] displayNameReference]];
            referencePicture = [[NSString alloc] initWithString:[[referenceObjects objectAtIndex:0] imageNameReference]];
            referenceShortDescription = [[NSString alloc] initWithString:[[referenceObjects objectAtIndex:0] shortDescriptionReference]];
            referenceLongDescription = [[NSString alloc] initWithString:[[referenceObjects objectAtIndex:0] longDescriptionReference]];		
		} else {
            
            referenceName = [[NSString alloc] initWithString:[[referenceObjects objectAtIndex:0] displayNameMoral]];
            referencePicture = [[NSString alloc] initWithString:[[referenceObjects objectAtIndex:0] imageNameMoral]];
            referenceShortDescription = [[NSString alloc] initWithString:[[referenceObjects objectAtIndex:0] shortDescriptionMoral]];
            
            NSString *tempDescription = [[NSString alloc] initWithFormat:@"%@\n\nSynonyms: %@", [[referenceObjects objectAtIndex:0] definitionMoral], [[referenceObjects objectAtIndex:0] longDescriptionMoral]];
	        referenceLongDescription = [[NSString alloc] initWithString:tempDescription];
            [tempDescription release];
            
      	}
		
		//** @todo move deathyear logic to ReferenceText subclass as transient property
		//Must account for subclass differences
		if ([[referenceObjects objectAtIndex:0] respondsToSelector:@selector(linkReference)]) {
			
			referenceReferenceURL = [[NSMutableString alloc] initWithString:[[referenceObjects objectAtIndex:0] linkReference]];
		} else if ([[referenceObjects objectAtIndex:0] respondsToSelector:@selector(linkMoral)]) {
			
			referenceReferenceURL = [[NSMutableString alloc] initWithString:[[referenceObjects objectAtIndex:0] linkMoral]];
			
		} else {
			referenceReferenceURL = [[NSMutableString alloc] initWithString:@""];
		}
		
		if ([[referenceObjects objectAtIndex:0] respondsToSelector:@selector(originYear)]) {
			referenceDate = [[NSMutableString alloc] initWithString:[[[referenceObjects objectAtIndex:0] originYear] stringValue]];
		} else {
			referenceDate = [[NSMutableString alloc] initWithString:@"0"];
		}		
		
		if ([[referenceObjects objectAtIndex:0] respondsToSelector:@selector(originLocation)]) {
			
			if ([[referenceObjects objectAtIndex:0] originLocation] == nil) {
				referenceOrigin = [[NSMutableString alloc] initWithString:@""];
			} else {
				referenceOrigin = [[NSMutableString alloc] initWithString:[[referenceObjects objectAtIndex:0] originLocation]];
			}
			
		} else {
			referenceOrigin = [[NSMutableString alloc] initWithString:@""];
		}	
		
		if ([[referenceObjects objectAtIndex:0] respondsToSelector:@selector(deathYearPerson)]) {
			referenceDeathDate = [[NSMutableString alloc] initWithString:[[[referenceObjects objectAtIndex:0] deathYearPerson] stringValue]];
		} else {
			referenceDeathDate = [[NSMutableString alloc] initWithString:@"0"];
		}
        
		if ([[referenceObjects objectAtIndex:0] respondsToSelector:@selector(orientationAsset)]) {
			referenceOrientation = [[NSString alloc] initWithString:[[referenceObjects objectAtIndex:0] orientationAsset]];
		} else {
			referenceOrientation = [[NSString alloc] initWithString:@""];
		}
        
		if ([[referenceObjects objectAtIndex:0] respondsToSelector:@selector(quotePerson)]) {
			referenceQuote = [[NSString alloc] initWithString:[[referenceObjects objectAtIndex:0] quotePerson]];
		} else {
			referenceQuote = [[NSString alloc] initWithString:@""];
		}
        
        
		if ([[referenceObjects objectAtIndex:0] respondsToSelector:@selector(relatedMoral)]) {
			Moral *relatedMoral = [[referenceObjects objectAtIndex:0] relatedMoral];
			if (relatedMoral != nil) {
				referenceMoral = [[NSString alloc] initWithString:[relatedMoral imageNameMoral]];
			} else {
				referenceMoral = [[NSString alloc] initWithString:@""];
			}

		}else {
			referenceMoral = [[NSString alloc] initWithString:@""];
		}
		
	}	
	
	/** @todo append death date by determining if object responds to DeathYear */
    
	//End CoreData Retrieval
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
