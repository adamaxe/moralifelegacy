/**
Implementation:  User can accept the choice: ConscienceAsset added to ConscienceBody/ConscienceAccessories and MoraLifeAppDelegate::userCollection, ethicals subtracted from MoraLifeAppDelegate::userCollection, conscienceView being updated and User returned to ConscienceModalViewController.
User can cancel entire Accessory workflow: return to ConscienceViewController.
User can return to the previous screen:  return to ConscienceListViewController to select another ConscienceAsset.
 
@class ConscienceAcceptViewController ConscienceAcceptViewController.h
 */

#import "ConscienceAcceptViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ConscienceView.h"
#import "ConscienceAccessories.h"
#import "ConscienceBuilder.h"
#import "ConscienceAsset.h"
#import "ConscienceBody.h"
#import "ConscienceView.h"
#import "ConscienceMind.h"
#import "UserCharacter.h"
#import "Moral.h"
#import "UserCollectable.h"
#import "ViewControllerLocalization.h"

@interface ConscienceAcceptViewController () <ViewControllerLocalization> {
    
	MoraLifeAppDelegate *appDelegate;	/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;	/**< Core Data context */
	
	NSString *currentFeature;           /**< filename of ConscienceAsset image */
    NSMutableString *resetFeature;
    
	IBOutlet UIImageView *moralImageView;			/**< image of ConscienceAsset::relatedMoral */
	IBOutlet UIView *thoughtModalArea;				/**< area in which user ConscienceView can float */
	IBOutlet UIView *consciencePlayground;			/**< area in which custom ConscienceView can float */
	IBOutlet UILabel *currentFundsLabel;			/**< display of User's current ethicals */
	IBOutlet UILabel *accessoryNameLabel;			/**< name of ConscienceAsset */
	IBOutlet UILabel *accessoryDescriptionLabel;	/**< description of ConscienceAsset */
	IBOutlet UILabel *accessoryCostLabel;			/**< cost of ConscienceAsset */
	IBOutlet UILabel *insufficientEthicalsLabel;	/**< insufficient ethicals notification */
    
	IBOutlet UIButton *buyButton;					/**< button used to accept new ConscienceAsset */
	IBOutlet UIButton *backButton;					/**< button used to reject new ConscienceAsset */
    
    IBOutlet UIButton *previousButton;              /**< button used to cancel choice workflow */
 	int currentFunds;		/**< current amount of ethicals from MoraLifeAppDelegate::userCollection */
	int assetCost;		/**< cost of ConscienceAsset */
    
	BOOL isOwned;		/**< is ConscienceAsset already owned by User */
	
}

/**
 Accepts User input to return to ConscienceModalViewController
 */
-(void)dismissAcceptModal;

/**
 Accepts User input to return to ConscienceModalViewController
 */
-(void)returnToHome;

/**
 Retrieve how many ethicals User currently has from MoraLifeAppDelegate::userCollection.
 */
-(void)retrieveCurrentFunds;

/**
 Subtract cost of ConscienceAsset from MoraLifeAppDelegate::userCollection.
 */
-(void)processCollection;

/**
 Commit the choice of ConscienceAsset to ConscienceView.
 */
-(void)saveConscience;

@end

@implementation ConscienceAcceptViewController

@synthesize assetSelection;
@synthesize accessorySlot;

#pragma mark -
#pragma mark ViewController lifecycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {

		//Create appDelegate and CD context for Conscience and data
		appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
        prefs = [NSUserDefaults standardUserDefaults];
		context = [appDelegate.moralModelManager managedObjectContext];
        
        resetFeature = [[NSMutableString alloc] init];
        
		//Setup default values
		currentFunds = 0;
		assetCost = 0;
		isOwned = FALSE;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	/** 
	@todo utilize consistent localization string references 
	@todo convert localization of all UIViewControllers into protocol
	*/

	//Set ownership boolean
	if ([appDelegate.userCollection containsObject:assetSelection]){
		isOwned = TRUE;
	}

	// current ConscienceAsset under review for purchase
	ConscienceAsset *assetReview;
	NSString *assetFileName;
    
    [insufficientEthicalsLabel setHidden:TRUE];
	
	//Get current amount of ethicals for display and purchase logic
	[self retrieveCurrentFunds];
	[currentFundsLabel setText:[NSString stringWithFormat:@"%dε", currentFunds]];
    
	/** @todo extract and make function */
	//Retrieve ConscienceAsset from SystemData
	NSError *outError;
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"ConscienceAsset" inManagedObjectContext:context];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
	
	//Find requested ConscienceAsset from User input
	NSPredicate *pred;
	pred = [NSPredicate predicateWithFormat:@"nameReference like %@", assetSelection];
	[request setPredicate:pred];
		
	NSArray *objects = [context executeFetchRequest:request error:&outError];
	
	if ([objects count] == 0) {
		NSLog(@"No matches");
        assetFileName = [[NSString alloc] initWithString:@"acc-nothing"];
        
	} else {
		
		//Retrieve ConscienceAsset
		assetReview = [objects objectAtIndex:0];
                
		//Set UI labels
		[accessoryNameLabel setText:[assetReview displayNameReference]];
		[accessoryDescriptionLabel setText:[assetReview shortDescriptionReference]];        
		assetCost = [[assetReview costAsset] intValue];
        
		//If ConscienceAsset is already owned, change verbiage of UI
		if (isOwned) {
			[accessoryCostLabel setText:@"Owned!"];
			[[buyButton titleLabel] setText:@"Use"];
		} else {
            	[accessoryCostLabel setText:[NSString stringWithFormat:@"Cost: %dε", assetCost]];
	            [[buyButton titleLabel] setText:@"Buy"];
		}
        
		//Set UI image of Moral
		[moralImageView setImage:[UIImage imageNamed:[[assetReview relatedMoral] imageNameMoral]]];

        assetFileName = [[NSString alloc] initWithString:[assetReview imageNameReference]];

	}
	
	[request release];
	//End CoreData Retrieval
	
	//Save image name for when ConscienceAsset is no longer retained
	/** @todo determine if Conscience update can be refactored */
	currentFeature = [[NSString alloc] initWithString:assetFileName];
    [assetFileName release];
    
    //Add requested ConscienceAsset to duplicate ConscienceView for review
	switch (accessorySlot) {
		case 0:{[resetFeature setString:appDelegate.userConscienceAccessories.topAccessory];appDelegate.userConscienceAccessories.topAccessory = currentFeature;}break;
		case 1:{[resetFeature setString:appDelegate.userConscienceAccessories.primaryAccessory];appDelegate.userConscienceAccessories.primaryAccessory = currentFeature;}break;
		case 2:{[resetFeature setString:appDelegate.userConscienceAccessories.bottomAccessory];appDelegate.userConscienceAccessories.bottomAccessory = currentFeature;}break;
		case 3:{[resetFeature setString:appDelegate.userConscienceAccessories.secondaryAccessory];appDelegate.userConscienceAccessories.secondaryAccessory = currentFeature;}break;
		case 4:{[resetFeature setString:appDelegate.userConscienceBody.eyeName];appDelegate.userConscienceBody.eyeName = currentFeature;}break;
		case 5:{[resetFeature setString:appDelegate.userConscienceBody.symbolName];appDelegate.userConscienceBody.symbolName = currentFeature;}break;
		case 6:{[resetFeature setString:appDelegate.userConscienceBody.mouthName];appDelegate.userConscienceBody.mouthName = currentFeature;}break;
		case 7:{[resetFeature setString:appDelegate.userConscienceBody.eyeColor];appDelegate.userConscienceBody.eyeColor = currentFeature;}break;
		case 8:{[resetFeature setString:appDelegate.userConscienceBody.browColor];appDelegate.userConscienceBody.browColor = currentFeature;}break;
		case 9:{[resetFeature setString:appDelegate.userConscienceBody.bubbleColor];appDelegate.userConscienceBody.bubbleColor = currentFeature;}break;
		case 10:{
            [resetFeature setString:[NSString stringWithFormat:@"%d", appDelegate.userConscienceBody.bubbleType]];
            
            NSString *bubbleType = [currentFeature substringFromIndex:11];
            appDelegate.userConscienceBody.bubbleType = [bubbleType intValue];

        }break;            
		default: break;
	}
	
    if ((accessorySlot > 3) && (accessorySlot < 7)) {
        [ConscienceBuilder buildConscience:appDelegate.userConscienceBody];

    }
    
    [self localizeUI];    

}

-(void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];

	//Add User's actual Conscience to lower-left of screen
	[consciencePlayground addSubview:appDelegate.userConscienceView];
	[appDelegate.userConscienceView setNeedsDisplay];

	//Inform/restrict User's ability to actually purchase ConscienceAsset
	//Flash assetCost is ConscienceAsset is unbuyable
	if ((assetCost > currentFunds) && !isOwned) {
		[buyButton setHidden:TRUE];
        [insufficientEthicalsLabel setHidden:FALSE];
        
		[backButton setCenter:CGPointMake(backButton.center.x-50, backButton.center.y)];
		[accessoryCostLabel setTextColor:[UIColor colorWithRed:200.0/255.0 green:25.0/255.0 blue:2.0/255.0 alpha:1]];
        
		[UIView beginAnimations:@"PulseCost" context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationBeginsFromCurrentState:TRUE];
		[UIView setAnimationRepeatCount:5.0];
		[UIView setAnimationRepeatAutoreverses:TRUE];        

		[accessoryCostLabel setAlpha:0.5];
		[accessoryCostLabel setTransform:CGAffineTransformMakeScale(1.20f, 1.20f)];
        
		[UIView commitAnimations];
    }
		
    [UIView beginAnimations:@"conscienceHide" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    appDelegate.userConscienceView.alpha = 0;
    appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    
    //    appDelegate.userConscienceView.center = centerPoint;
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(moveConscienceToCenter)];
    
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark UI Interaction

-(void) moveConscienceToCenter{
    
    //Move Conscience to center of boxes
	CGPoint centerPoint = CGPointMake(160, 160);
    appDelegate.userConscienceView.center = centerPoint;
    
    [UIView beginAnimations:@"conscienceRestore" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    appDelegate.userConscienceView.alpha = 1;
    appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
    
    [UIView commitAnimations];
    
}

/**
Implementation: Signals User desire to commit the ConscienceAsset to persistence.  Actual ConscienceView updated done in this function.  Returns User to different UIViewControllers depending upon User choice.
 */
-(IBAction)acceptThoughtModal:(id)sender{
	
	//Test to ensure that sender is a UIButton
	if ([sender isKindOfClass:[UIButton class]]) {

		//Retrieve buttons tag to verify which button was pressed
		UIButton *senderButton = sender;
		int choiceIndex = senderButton.tag;

		//User has elected to buy ConscienceAsset
		//Return User to Home screen after transaction		
		if (choiceIndex < 1){
            
            /** 
             @bug determine timer start/stop issue
		*/
                            
			//Save choices to persistence
      	    [self saveConscience];
            
			//If ConscienceAsset is not already owned, add ConscienceAsset as UserCollectable and adjust User's funds
	        if (!isOwned) {
                
                [self processCollection];
            }

            [UIView beginAnimations:@"conscienceHide" context:nil];
            [UIView setAnimationDuration:0.25];
            
            [UIView setAnimationBeginsFromCurrentState:YES];
            appDelegate.userConscienceView.alpha = 0;
            appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            
            //    appDelegate.userConscienceView.center = centerPoint;
            [UIView setAnimationDelegate:self]; // self is a view controller
            [UIView setAnimationDidStopSelector:@selector(returnToHome)];
                            
            [UIView commitAnimations];
		} else {
            
//            [appDelegate.userConscienceView stopTimers];

            switch (accessorySlot) {
                case 0:appDelegate.userConscienceAccessories.topAccessory = resetFeature;break;
                case 1:appDelegate.userConscienceAccessories.primaryAccessory = resetFeature;break;
                case 2:appDelegate.userConscienceAccessories.bottomAccessory = resetFeature;break;
                case 3:appDelegate.userConscienceAccessories.secondaryAccessory = resetFeature;break;
                case 4:appDelegate.userConscienceBody.eyeName = resetFeature;break;
                case 5:appDelegate.userConscienceBody.symbolName = resetFeature;break;
                case 6:appDelegate.userConscienceBody.mouthName = resetFeature;break;
                case 7:appDelegate.userConscienceBody.eyeColor = resetFeature;break;
                case 8:appDelegate.userConscienceBody.browColor = resetFeature;break;
                case 9:appDelegate.userConscienceBody.bubbleColor = resetFeature;break;
                case 10:appDelegate.userConscienceBody.bubbleType = [resetFeature intValue];break;                    
                default: break;
            }
            
            if ((accessorySlot > 3) && (accessorySlot < 7)) {
                [ConscienceBuilder buildConscience:appDelegate.userConscienceBody];
                
            }
                        
            [UIView beginAnimations:@"conscienceHide" context:nil];
            [UIView setAnimationDuration:0.25];
            
            [UIView setAnimationBeginsFromCurrentState:YES];
            appDelegate.userConscienceView.alpha = 0;
            appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            
            //    appDelegate.userConscienceView.center = centerPoint;
            [UIView setAnimationDelegate:self]; // self is a view controller
            
            if (senderButton.tag < 2) {
                [UIView setAnimationDidStopSelector:@selector(dismissAcceptModal)];
            } else {
                [UIView setAnimationDidStopSelector:@selector(returnToHome)];
                
            }    
            
            [UIView commitAnimations];
            
            
        }
	}
	
}

/**
 Implementation: Pop UIViewController from stack
 */
-(void)dismissAcceptModal{
    
    [self.navigationController popViewControllerAnimated:FALSE];
    
}

/**
 Implementation: Signals User desire to return to previous ConscienceListViewController
 */
-(void)returnToHome{
    
    [prefs setBool:TRUE forKey:@"conscienceModalReset"];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}

#pragma mark -
#pragma mark Data Manipulation

/**
Implementation: Internal function to retrieve how many ethicals User currently has from MoraLifeAppDelegate::userCollection.
 */
-(void)retrieveCurrentFunds{
    
    NSError *outError;
    NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserCollectable" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityAssetDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"collectableName == %@", kCollectableEthicals];
    [request setPredicate:pred];
    
    NSArray *objects = [context executeFetchRequest:request error:&outError];
    [request release];
    
    UserCollectable *currentUserCollectable = [objects objectAtIndex:0];
    
    //Increase the moral's value
    int ethicals = [[currentUserCollectable collectableValue] intValue];
    
    currentFunds = ethicals;
    
}

/**
Implementation: Commits the ConscienceAsset to persistence framework.
 */
-(void)saveConscience{
	
    NSError *outError = nil;

	//Retrieve User's UserCharacter		
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserCharacter" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
        
	NSArray *objects = [context executeFetchRequest:request error:&outError];
	UserCharacter *currentUserCharacter = [objects objectAtIndex:0];
        
	[request release];
    
	//Assign current ConscienceAsset to UserCharacter
	switch (accessorySlot) {
		case 0:[currentUserCharacter setCharacterAccessoryTop:currentFeature];break;
		case 1:[currentUserCharacter setCharacterAccessoryPrimary:currentFeature];break;
		case 2:[currentUserCharacter setCharacterAccessoryBottom:currentFeature];break;
		case 3:[currentUserCharacter setCharacterAccessorySecondary:currentFeature];break;
		case 4:[currentUserCharacter setCharacterEye:currentFeature];break;
		case 5:[currentUserCharacter setCharacterFace:currentFeature];break;
		case 6:[currentUserCharacter setCharacterMouth:currentFeature];break;
		case 7:[currentUserCharacter setCharacterEyeColor:currentFeature];break;
		case 8:[currentUserCharacter setCharacterBrowColor:currentFeature];break;
		case 9:[currentUserCharacter setCharacterBubbleColor:currentFeature];break;
		case 10:[currentUserCharacter setCharacterBubbleType:[NSNumber numberWithInt:[currentFeature intValue]]];break;
		default: break;
	}
    
    /** @todo refactor into ConscienceMind
     */
    float newMood = appDelegate.userConscienceMind.mood + 1;
    float newEnthusiasm = appDelegate.userConscienceMind.enthusiasm + 1;
    
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

    //Setup a transient expression for Conscience in response to entry
    //UserDefault will be picked up by ConscienceViewController
    [prefs setFloat:(85) forKey:@"transientMind"];
    
    [currentUserCharacter setCharacterMood:[NSNumber numberWithFloat:newMood]];    
    [currentUserCharacter setCharacterEnthusiasm:[NSNumber numberWithFloat:newEnthusiasm]];

    
	[context save:&outError];
	
	if (outError != nil) {
		NSLog(@"save error:%@", outError);
	}
	
	[context reset];

}

/**
Implementation: Changes MoraLifeAppDelegate::userCollection.  Subtract cost from ethicals and add ConscienceAsset as a collectable.  
 */
-(void)processCollection{
    
	NSError *outError;
	//Retrieve readwrite Documents directory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *userData =  [documentsDirectory stringByAppendingPathComponent:@"UserData.sqlite"];
	NSURL *storeURL = [NSURL fileURLWithPath:userData];
    
	id readWriteStore = [[context persistentStoreCoordinator] persistentStoreForURL:storeURL];
    
	//Construct Unique Primary Key from dtstamp to millisecond
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];	
    
	NSString *currentDTS = [dateFormatter stringFromDate:[NSDate date]];
    
	[dateFormatter release];
    
	//Create a new UserCollectable
	//It has already been determined to not exist in MoraLifeAppDelegate::userCollection, no need to test
	UserCollectable *currentUserAssetCollectable = [NSEntityDescription insertNewObjectForEntityForName:@"UserCollectable" inManagedObjectContext:context];
    
	[currentUserAssetCollectable setCollectableCreationDate:[NSDate date]];
	[currentUserAssetCollectable setCollectableKey:[NSString stringWithFormat:@"%@%@", currentDTS, assetSelection]];
	[currentUserAssetCollectable setCollectableName:assetSelection];

	//Store ConscienceAsset as a UserCollectable into UserData
	[context assignObject:currentUserAssetCollectable toPersistentStore:readWriteStore];
    
	//Check to see if ConscienceAsset has already been collected
	if (!isOwned){
		[appDelegate.userCollection addObject:assetSelection];
	}
    
	//Retrieve User's ethicals
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserCollectable" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
    
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"collectableName == %@", kCollectableEthicals];
	[request setPredicate:pred];
    
	NSArray *objects = [context executeFetchRequest:request error:&outError];
	[request release];
    
    //Update User's ethicals
	UserCollectable *currentUserCollectable = [objects objectAtIndex:0];
    
	int ethicals = [[currentUserCollectable collectableValue] intValue];
    
	ethicals -= assetCost;

	if (ethicals < 0) {
		ethicals = 0;
	}
    
	//Save User's new ethicals    
	[currentUserCollectable setValue:[NSNumber numberWithInt:ethicals] forKey:@"collectableValue"];
        
	[context save:&outError];

}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {

    buyButton.accessibilityHint = NSLocalizedString(@"ConscienceAcceptBuyButtonHint", @"Hint for buy button");
	buyButton.accessibilityLabel =  NSLocalizedString(@"ConscienceAcceptBuyButtonLabel",@"Label for buy button");

    backButton.accessibilityHint = NSLocalizedString(@"ConscienceAcceptBackButtonHint", @"Hint for back button");
	backButton.accessibilityLabel =  NSLocalizedString(@"ConscienceAcceptBackButtonLabel",@"Label for back button");    
    
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint", @"Hint for previous button");
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",@"Label for previous button");

}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [previousButton release];
    previousButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {

	[currentFeature release];
    [resetFeature release];
	[assetSelection release];
    [previousButton release];
	[super dealloc];

}

@end