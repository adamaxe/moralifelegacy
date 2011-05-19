/**
Implementation: Presents a series of updated screens to User prompting the User to select one or the other.
Allows for backwards perusal to reread certain parts of entry as long as choice hasn't been made.
Commits choice to UserData, updates ethicals, adds reward to MoraLifeAppDelegate::userCollection
 
@class DilemmaViewController DilemmaViewController.h
 */

#import "DilemmaViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ConscienceBody.h"
#import "ConscienceAccessories.h"
#import "ConscienceMind.h"
#import "ConscienceView.h"
#import "ConscienceActionViewController.h"
#import "ConscienceDeckViewController.h"
#import "ConscienceAsset.h"
#import "ConscienceBuilder.h"
#import "Dilemma.h"
#import "Character.h"
#import "Moral.h"
#import "UserDilemma.h"
#import "UserCollectable.h"
#import "ReferencePerson.h"
#import "ReferenceAsset.h"
#import "UserChoice.h"
#import "UserCharacter.h"

@implementation DilemmaViewController

#pragma mark -
#pragma mark ViewController Lifecycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
		//Create appDelegate and CD context for Conscience and data
		appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
        prefs = [NSUserDefaults standardUserDefaults];
		context = [appDelegate managedObjectContext];
        
		//Setup default values
        reward1 = [[NSMutableString alloc] init];
        reward2 = [[NSMutableString alloc] init];
        
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Instantiate Conscience facets for use throughout class
    antagonistConscienceBody = [[ConscienceBody alloc] init];
    antagonistConscienceAccessories = [[ConscienceAccessories alloc] init];
    antagonistConscienceMind = [[ConscienceMind alloc] init];
	
    [self loadDilemma];
    
    isChoiceA = FALSE;

}

-(void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
	
	screen1View.hidden = TRUE;
	screen1View.alpha = 0;
	versusImage.alpha = 0;
	
    //Build vs. image animation
    versusImage.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(6.0f, 6.0f), CGAffineTransformMakeRotation(M_PI * -1));

	rewardView.alpha = 0;
	rewardView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(6.0f, 6.0f), CGAffineTransformMakeRotation(M_PI * -1));
    
	[thoughtModalArea addSubview:appDelegate.userConscienceView];
	
	CGPoint centerPoint = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY);
	
    //Animate vs. image and Consciences
	[UIView beginAnimations:@"MoveConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(kConscienceLargeSizeX, kConscienceLargeSizeY);
    
	screen1View.alpha = 1;
	
	screen1View.hidden = FALSE;
	versusImage.alpha = 1;
	versusImage.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    
	appDelegate.userConscienceView.center = centerPoint;
	
	[UIView commitAnimations];
	
	[appDelegate.userConscienceView setNeedsDisplay];
	
}

#pragma mark -
#pragma mark User View Interaction

/**
Implementation: Determine which screen user is own and determine if Dilemma is ready to be committed.
 */
- (IBAction) selectChoice:(id) sender{
	
	//Determine which button was pushed
	//Change options accordingly
	
    BOOL isReadyToCommit = FALSE;
    
	if ([sender isKindOfClass:[UIButton class]]) {
		UIButton *senderButton = sender;
		int choiceIndex = senderButton.tag;
		
        if (choiceIndex == 6) {
            [moralSelectedImage setImage:moral1ChoiceImage.image];
            [moralSelectedChoiceLabel setText:moral1ChoiceLabel.text];

            isChoiceA = TRUE;
            isReadyToCommit = TRUE;
        } else if (choiceIndex == 7) {
            [moralSelectedImage setImage:moral2ChoiceImage.image];
            [moralSelectedChoiceLabel setText:moral2ChoiceLabel.text];

            isChoiceA = FALSE;
            isReadyToCommit = TRUE;

        }
        
        if (isReadyToCommit) {
            
            [self commitDilemma];
        }
        
		[self changeScreen:choiceIndex];
		
	}
	
	
}

/**
Implementation: Hide or show a screen depending upon which page the User currently resides.
Show reward views once User has completed dilemma and refuse access to previous screen versions.
 */
-(void)changeScreen:(int) screenVersion {
    
	UIView *viewSelection;
	int buttonFactor = 0;
	
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
		
	/** @bug determine why screen2 doesn't fade */
	//Depending upon which screen is requested
	//Setup variables to hide views, change Next/Previous button and move Conscience
	switch (screenVersion){
		case 0:	[self.navigationController popViewControllerAnimated:NO];
				break;
		case 1:viewSelection = screen1View;buttonFactor = 0;break;
		case 2:viewSelection = screen2View;buttonFactor = 1;break;
		case 3:viewSelection = screen3View;buttonFactor = 2;break;
		case 4:viewSelection = screen4View;buttonFactor = 3;break;
		case 5:viewSelection = screen5View;buttonFactor = 4;nextButton.hidden = TRUE;break;	
		case 6:viewSelection = screen6View;buttonFactor = 5;nextButton.hidden = FALSE;previousButton.hidden = TRUE;break;
		case 7:viewSelection = screen6View;buttonFactor = 5;nextButton.hidden = FALSE;previousButton.hidden = TRUE;break;            
		case 8:[self.navigationController popViewControllerAnimated:NO];break;
		default:break;
			
	}
	
	//Change the active view except in the case of dismissing the entire ViewController
	if (screenVersion > 0 && screenVersion <= 7) {

		//Animated changes to the ViewController
		//Show/Hide relevant subview
		//Move Conscience to appropriate place on screen
		[UIView beginAnimations:@"ScreenChange" context:nil];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationBeginsFromCurrentState:YES];
	
		viewSelection.alpha = 1;
		viewSelection.hidden = FALSE;

		[UIView commitAnimations];
		
		[dilemmaText flashScrollIndicators];
		[choiceText1 flashScrollIndicators];
		[choiceText2 flashScrollIndicators];

        //Change Button tag in order to determine which "screen" is active
		nextButton.tag = 2 + buttonFactor;
		previousButton.tag = buttonFactor;
        
		//Delay appearance of score to draw attention
		if ((screenVersion == 6) || (screenVersion == 7)) {
			
            nextButton.tag = 8;
            
            

            [UIView beginAnimations:@"RewardChange" context:nil];
			[UIView setAnimationDuration:1];
			[UIView setAnimationBeginsFromCurrentState:YES];
			
            rewardView.alpha = 1;
            rewardView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            
			[UIView commitAnimations];
            
            
			[UIView beginAnimations:@"ScoreChange" context:nil];
			[UIView setAnimationDuration:3];
			[UIView setAnimationBeginsFromCurrentState:YES];
			
			moralRewardLabel.alpha = 1;            
			
			[UIView commitAnimations];
			
		}
		
	}

}

/**
 Implementation: Signals User desire to return to ConscienceModalViewController
 */
-(IBAction)returnToHome:(id)sender{

    [prefs setBool:TRUE forKey:@"conscienceModalReset"];
	[self.navigationController popToRootViewControllerAnimated:NO];
    
}

#pragma mark -
#pragma mark Data Manipulation

/**
Implementation: Load requested dilemma, load into iVar for use throughout UIViewController.
Construct antagonist Conscience
@todo refactor into multiple functions
 */
-(void) loadDilemma{
    
	NSError *outError;
    
	NSString *restoreDilemmaKey = [prefs objectForKey:@"dilemmaKey"];
    
	/** @todo determine no dilemma case */
	if (restoreDilemmaKey != nil) {
		[prefs removeObjectForKey:@"dilemmaKey"];
	}

	//Retrieve Dilemma
	NSEntityDescription *entityDilemmaDesc = [NSEntityDescription entityForName:@"Dilemma" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDilemmaDesc];
    
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"nameDilemma == %@", restoreDilemmaKey];
    
	[request setPredicate:pred];
    
	NSArray *objects = [context executeFetchRequest:request error:&outError];

	if ([objects count] == 0) {
		NSLog(@"No dilemma matches");
	} else {
    
		//Populate relevante dilemma information
		currentDilemma = [objects objectAtIndex:0];
		[currentDilemma retain];
		surroundingsBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [currentDilemma surrounding]]];
		[dilemmaTitle setText:[currentDilemma displayNameDilemma]];
		[dilemmaTitleText setText:[dilemmaTitle text]];
		[dilemmaText setText:[currentDilemma dilemmaText]];
		[choiceText1 setText:[currentDilemma choiceA]];
		[choiceText2 setText:[currentDilemma choiceB]];
        
		NSString *moral1Text = [[NSString alloc] initWithString:[[currentDilemma moralChoiceA] displayNameMoral]];
		NSString *moral2Text = [[NSString alloc] initWithString:[[currentDilemma moralChoiceB] displayNameMoral]];
		UIImage *moral1ImageFull = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [[currentDilemma moralChoiceA] imageNameMoral]]];
		UIImage *moral2ImageFull = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [[currentDilemma moralChoiceB] imageNameMoral]]];
        
		moral1Image.image = moral1ImageFull;
		moral2Image.image = moral2ImageFull;
		[dilemmaMoralLabel1 setText:moral1Text];
      	[dilemmaMoralLabel2 setText:moral2Text];
		[moral1ChoiceLabel setText:moral1Text];
      	[moral2ChoiceLabel setText:moral2Text];
        
		moral1ChoiceImage.image = moral1ImageFull;
		moral2ChoiceImage.image = moral2ImageFull;
        
		moral1ButtonImage.image = moral1ImageFull;
		moral2ButtonImage.image = moral2ImageFull;
        
		[selectionButton1 setTitle:moral1Text forState:UIControlStateNormal];
		[selectionButton2 setTitle:moral2Text forState:UIControlStateNormal];
        
		[moral1Text release];
		[moral2Text release];
        
		[reward1 appendString:[currentDilemma rewardADilemma]];
		[reward2 appendString:[currentDilemma rewardBDilemma]];
        
		//Create antagonist Conscience
		antagonistConscienceBody.eyeColor = [[currentDilemma antagonist] eyeColor];
		antagonistConscienceBody.browColor = [[currentDilemma antagonist] browColor];
		antagonistConscienceBody.bubbleColor = [[currentDilemma antagonist] bubbleColor];
		antagonistConscienceBody.age = [[[currentDilemma antagonist] ageCharacter] intValue];
		antagonistConscienceBody.bubbleType = [[[currentDilemma antagonist] bubbleType] intValue];
		antagonistConscienceBody.symbolName = [[currentDilemma antagonist] faceCharacter];
		antagonistConscienceBody.eyeName = [[currentDilemma antagonist] eyeCharacter];
		antagonistConscienceBody.mouthName = [[currentDilemma antagonist] mouthCharacter];
		antagonistConscienceAccessories.primaryAccessory = [[currentDilemma antagonist] accessoryPrimaryCharacter];
		antagonistConscienceAccessories.secondaryAccessory = [[currentDilemma antagonist] accessorySecondaryCharacter];
		antagonistConscienceAccessories.topAccessory = [[currentDilemma antagonist] accessoryTopCharacter];
		antagonistConscienceAccessories.bottomAccessory = [[currentDilemma antagonist] accessoryBottomCharacter];
        
		[antagonistConscienceMind setMood:[[currentDilemma moodDilemma] floatValue]];
		[antagonistConscienceMind setEnthusiasm:[[currentDilemma enthusiasmDilemma] floatValue]];
        
		//Call conscience construction
		[ConscienceBuilder buildConscience:antagonistConscienceBody];
        
		//Add Conscience to view
		antagonistConscienceView = [[ConscienceView alloc] initWithFrame:CGRectMake(kConscienceAntagonistX, kConscienceAntagonistY, kConscienceAntagonistWidth, kConscienceAntagonistHeight) withBody:antagonistConscienceBody withAccessories:antagonistConscienceAccessories withMind:antagonistConscienceMind];
        
		antagonistConscienceView.tag = kConscienceAntagonistViewTag;
		antagonistConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
		antagonistConscienceView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
		[antagonistConscienceView setUserInteractionEnabled:FALSE];
		[antagonistConscienceView.conscienceBubbleView setNeedsDisplay];
        
		[thoughtModalArea addSubview:antagonistConscienceView];
        
		[antagonistConscienceView setNeedsDisplay];
		[antagonistConscienceView release];
	}
    
	[request release];
}

/**
Implementation: Determine which choice was selected.
Determine if Moral was already rewarded and add if it wasn't.  Update otherwise.
Add UserChoice to UserData and append it with key to remove from ChoiceListViewController.  Dilemma must affect User's Moral Report.
Add reward ConscienceAsset or ReferenceAsset to MoraLifeAppDelegate::userCollection.
Calculate changes to User's ethicals.  Limit to 999.
@todo refactor into multiple functions
 */
-(void)commitDilemma{
    
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
        
    NSString *dilemmaKey = [NSString stringWithFormat:@"%@%@", currentDTS, [currentDilemma nameDilemma]];
    UserDilemma *dilemmaChoice = [NSEntityDescription insertNewObjectForEntityForName:@"UserDilemma" inManagedObjectContext:context];
    
    [dilemmaChoice setEntryShortDescription:[currentDilemma nameDilemma]];
    [dilemmaChoice setEntryCreationDate:[NSDate date]];
    [dilemmaChoice setEntryKey:dilemmaKey];
    NSString *moralKey;
    
    if (isChoiceA) {
        moralKey = [[currentDilemma moralChoiceA] nameMoral];
    } else {
        moralKey = [[currentDilemma moralChoiceB] nameMoral];       
    }
    
    [dilemmaChoice setEntryLongDescription:moralKey];
    
    [dilemmaChoice setEntryIsGood:[NSNumber numberWithBool:isChoiceA]];
    
    //See if moral has been rewarded before
    //Cannot assume that first instance of UserChoice implies no previous reward
    if ([appDelegate.userCollection containsObject:moralKey]) {
        
		NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserCollectable" inManagedObjectContext:context];
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		[request setEntity:entityAssetDesc];
        
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"collectableName == %@", moralKey];
		[request setPredicate:pred];
        
		NSArray *objects = [context executeFetchRequest:request error:&outError];
		UserCollectable *currentUserCollectable = [objects objectAtIndex:0];
        
		//Increase the moral's value
		float moralIncrease = [[currentUserCollectable collectableValue] floatValue];
        
		if (moralIncrease >= 99.0) {
			moralIncrease = 99.0;
		} else {
			moralIncrease += 1.0;
		}
        
		[currentUserCollectable setValue:[NSNumber numberWithFloat:moralIncrease] forKey:@"collectableValue"];
        
		[request release];
        
	} else {
        
		//Create a new moral reward
		UserCollectable *currentUserCollectable = [NSEntityDescription insertNewObjectForEntityForName:@"UserCollectable" inManagedObjectContext:context];
        
		[currentUserCollectable setCollectableCreationDate:[NSDate date]];
		[currentUserCollectable setCollectableKey:dilemmaKey];
		[currentUserCollectable setCollectableName:moralKey];
		[currentUserCollectable setCollectableValue:[NSNumber numberWithFloat:1.0]];
        
		[context assignObject:currentUserCollectable toPersistentStore:readWriteStore];
        
		[appDelegate.userCollection addObject:moralKey];
        
	}
    
	//Determine which reward should be given
	NSMutableString *selectedReward = [[NSMutableString alloc] init];
    
	if (isChoiceA) {
		[selectedReward appendString:reward1];
	} else {
		[selectedReward appendString:reward2];
	}

	//Determine type of reward given    
	if ([selectedReward rangeOfString:kCollectableEthicals].location != NSNotFound) {
		//Ethicals are rewarded, process
		[selectedReward deleteCharactersInRange:[selectedReward rangeOfString:kCollectableEthicals]];
		[moralSelectedRewardLabel setText:[NSString stringWithString:@"Ethicals!"]];        
	} else if ([selectedReward rangeOfString:@"figu-"].location != NSNotFound) {
        
		//ReferencePerson rewarded, process, use large moralRewardImage
		[ethicalRewardLabel setAlpha:0];
        
		NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"ReferencePerson" inManagedObjectContext:context];
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		[request setEntity:entityAssetDesc];
        
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"nameReference == %@", selectedReward];
		[request setPredicate:pred];
        
		NSArray *objects = [context executeFetchRequest:request error:&outError];
		ReferencePerson *currentPersonReward = [objects objectAtIndex:0];
		[moralSelectedRewardLabel setText:[NSString stringWithString:[currentPersonReward displayNameReference]]];

		[rewardImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [currentPersonReward imageNameReference]]]];
        
		UserCollectable *currentUserCollectable = [NSEntityDescription insertNewObjectForEntityForName:@"UserCollectable" inManagedObjectContext:context];
        
		[currentUserCollectable setCollectableCreationDate:[NSDate date]];
		[currentUserCollectable setCollectableKey:[NSString stringWithFormat:@"%@%@", currentDTS, selectedReward]];
		[currentUserCollectable setCollectableName:selectedReward];
        
		[context assignObject:currentUserCollectable toPersistentStore:readWriteStore];
        
		[appDelegate.userCollection addObject:selectedReward];
		[request release];

	} else if ([selectedReward rangeOfString:@"asse-"].location != NSNotFound) {
      
		//ConscienceAsset rewarded, process, use small moralRewardImage
		[ethicalRewardLabel setAlpha:0];
        
		NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"ReferenceAsset" inManagedObjectContext:context];
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		[request setEntity:entityAssetDesc];
        
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"nameReference == %@", selectedReward];
		[request setPredicate:pred];
        
		NSArray *objects = [context executeFetchRequest:request error:&outError];
		ReferenceAsset *currentAssetReward = [objects objectAtIndex:0];
		[moralSelectedRewardLabel setText:[NSString stringWithString:[currentAssetReward displayNameReference]]];
        
		[rewardImageSmall setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-sm.png", [currentAssetReward imageNameReference]]]];
        
		UserCollectable *currentUserCollectable = [NSEntityDescription insertNewObjectForEntityForName:@"UserCollectable" inManagedObjectContext:context];
        
		[currentUserCollectable setCollectableCreationDate:[NSDate date]];
		[currentUserCollectable setCollectableKey:[NSString stringWithFormat:@"%@%@", currentDTS, selectedReward]];
		[currentUserCollectable setCollectableName:selectedReward];
        
		[context assignObject:currentUserCollectable toPersistentStore:readWriteStore];
        
		[appDelegate.userCollection addObject:selectedReward];
		[request release];
	}
    
	//Reward ethicals
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserCollectable" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
    
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"collectableName == %@", kCollectableEthicals];
	[request setPredicate:pred];
    
	NSArray *objects = [context executeFetchRequest:request error:&outError];
	[request release];

	UserCollectable *currentUserCollectable = [objects objectAtIndex:0];
    
	//Increase the moral's value
	int ethicalIncrease = [[currentUserCollectable collectableValue] intValue];

	[moralRewardLabel setText:[NSString stringWithString:@"+1"]];
	[ethicalRewardLabel setText:[NSString stringWithFormat:@"+%dε", [selectedReward intValue]]];
    
	//Limit total ethicals to 999
	//@todo make constant
	if (ethicalIncrease >= 999) {
		ethicalIncrease = 999;
	} else {
		ethicalIncrease += [selectedReward intValue];
	}
    
	[currentUserCollectable setValue:[NSNumber numberWithInt:ethicalIncrease] forKey:@"collectableValue"];
        
	[selectedReward release];
    
	[context assignObject:dilemmaChoice toPersistentStore:readWriteStore];
	[context save:&outError];
    
	if (outError != nil) {
		NSLog(@"save error:%@", outError);
	}
    
	//Create a User Choice so that User's Moral report is affected
	//Prefix with dile- on a User prohibited field to ensure that entry is never shown on ConscienceListViewController
	UserChoice *currentUserChoice = [NSEntityDescription insertNewObjectForEntityForName:@"UserChoice" inManagedObjectContext:context];
    
	[currentUserChoice setEntryCreationDate:[NSDate date]];
	[context assignObject:currentUserChoice toPersistentStore:readWriteStore];
    
	NSMutableString *moralType = [[NSMutableString alloc] initWithString:@""];
    
	//Determine Moral to go along with UserChoice
	if (isChoiceA) {
		[moralType appendString:[[currentDilemma moralChoiceA] shortDescriptionMoral]];
	} else {
		[moralType appendString:[[currentDilemma moralChoiceB] shortDescriptionMoral]];
	}

	//Account for weight calculation, virtue = +, vice = -    
	BOOL isGood = FALSE;
	if ([moralType isEqualToString:@"Virtue"]) {
		isGood = TRUE;
	}

	[moralType release];
    
	//Commit UserChoice
	[currentUserChoice setEntryShortDescription:[currentDilemma nameDilemma]];
	[currentUserChoice setEntryLongDescription:@""];
	[currentUserChoice setEntrySeverity:[NSNumber numberWithFloat:1]];
	[currentUserChoice setEntryModificationDate:[NSDate date]];
	[currentUserChoice setEntryKey:dilemmaKey];
	[currentUserChoice setChoiceMoral:moralKey];
	[currentUserChoice setChoiceJustification:@""];
	[currentUserChoice setChoiceInfluence:[NSNumber numberWithInt:1]];
	[currentUserChoice setEntryIsGood:[NSNumber numberWithBool:isGood]];
	[currentUserChoice setChoiceConsequences:@""];

	if (isGood) {
		[currentUserChoice setChoiceWeight:[NSNumber numberWithFloat:0.2]];  
	} else {
		[currentUserChoice setChoiceWeight:[NSNumber numberWithFloat:-0.2]];  
	}
    
    /** @todo refactor into ConscienceMind
     */
    float newMood = appDelegate.userConscienceMind.mood + 0.5;
    float newEnthusiasm = appDelegate.userConscienceMind.enthusiasm + 0.5;
    
    if (newMood > 90) {
        appDelegate.userConscienceMind.mood = 10.0;
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
    
    NSEntityDescription *entityMindDesc = [NSEntityDescription entityForName:@"UserCharacter" inManagedObjectContext:context];
    NSFetchRequest *requestCharacter = [[NSFetchRequest alloc] init];
    [requestCharacter setEntity:entityMindDesc];
    
    NSArray *objectCharacter = [context executeFetchRequest:requestCharacter error:&outError];
    UserCharacter *currentUserCharacter = [objectCharacter objectAtIndex:0];
    
    [currentUserCharacter setCharacterMood:[NSNumber numberWithFloat:newMood]];    
    [currentUserCharacter setCharacterEnthusiasm:[NSNumber numberWithFloat:newEnthusiasm]];

	[context save:&outError];
    
	if (outError != nil) {
        NSLog(@"save error:%@", outError);
	}
    
    [requestCharacter release];
    
	[context reset];
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
    
    [currentDilemma release];
	[antagonistConscienceBody release];
	[antagonistConscienceAccessories release];
	[antagonistConscienceMind release];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[reward1 release];
	[reward2 release];
    
    [super dealloc];

}


@end
