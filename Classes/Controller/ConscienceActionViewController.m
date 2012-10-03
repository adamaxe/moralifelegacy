/**
Implementation:  UIViewController changes state of UI depending upon which stage in the questioning is the User.  Determines if User possesses what is requested before giving them reward.
@todo get rid of currentDilemma leak
@class ConscienceActionViewController ConscienceActionViewController.h
@see ConscienceListViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/9/2010
@file
 */

#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "ConscienceBody.h"
#import "ConscienceAccessories.h"
#import "ConscienceMind.h"
#import "ConscienceView.h"
#import "ConscienceActionViewController.h"
#import "ConscienceDeckViewController.h"
#import "ConscienceAsset.h"
#import "ConscienceBuilder.h"
#import "DilemmaDAO.h"
#import "Character.h"
#import "Moral.h"
#import "UserDilemmaDAO.h"
#import "UserCollectableDAO.h"
#import "ReferencePersonDAO.h"
#import "ReferenceAssetDAO.h"
#import "UserCharacterDAO.h"
#import "UserChoiceDAO.h"
#import "ViewControllerLocalization.h"

@interface ConscienceActionViewController () <ViewControllerLocalization> {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
    
	IBOutlet UIImageView *surroundingsBackground;		/**< background image provided by dilemma */
	IBOutlet UIImageView *moral1Image;				/**< initial Moral image decoration */
	IBOutlet UIImageView *moralSelectedImage;			/**< image of Moral on reward */
	IBOutlet UIImageView *rewardCard;				/**< card image on rewardView */
	IBOutlet UIImageView *rewardImage;				/**< actual image of reward (large) */
	IBOutlet UIImageView *rewardImageSmall;			/**< actual image of reward (small) */
	IBOutlet UILabel *moral1ChoiceLabel;			/**< moral text name */
	IBOutlet UIImageView *moral1ChoiceImage;			/**< moral decoration */
	IBOutlet UILabel *moralSelectedChoiceLabel;		/**< completed action title */
	IBOutlet UILabel *moralSelectedRewardLabel;		/**< completed reward description */
	IBOutlet UILabel *moralRewardLabel;				/**< increase to specific moral */
	IBOutlet UILabel *moralScoreLabel;				/**< score next to moral image */
	IBOutlet UILabel *ethicalRewardLabel;			/**< ethicals text if ethicals rewarded */
    
	//Views for progression of Dilemma
	IBOutlet UIView *thoughtModalArea;		/**< area in which Conscience floats */
	IBOutlet UIView *screen1View;			/**< intro screen */
	IBOutlet UIView *screen2View;			/**< explanation of issue */
	IBOutlet UIView *screen3View;			/**< explanation of request */
	IBOutlet UIView *screen4View;			/**< reward screen */
	IBOutlet UIView *rewardView;			/**< reward card containing decorations */
    
	IBOutlet UILabel *dilemmaTitle;				/**< 1st title of Dilemma */
	IBOutlet UILabel *dilemmaTitleText;				/**< 2nd viewing of title of Dilemma */
	IBOutlet UITextView *introText;				/**< first text introduction */
	IBOutlet UITextView *dilemmaText;				/**< dilemma presented to User */
	IBOutlet UILabel *dilemmaMoralLabel1;			/**< moral associated with dilemma */
	IBOutlet UITextView *choiceText1;				/**< instructions for User */
	IBOutlet UIButton *previousButton;				/**< return to previous view in dilemma */
	IBOutlet UIButton *nextButton;				/**< proceed to next view in dilemma */
	
	Dilemma *currentDilemma;					/**< information about the dilemma */
	NSMutableString *dilemmaName;           /**< name of dilemma used for record retention */
	NSMutableString *moralAName;            /**< name of Moral A */
	NSMutableString *moralADescription;     /**< description of Moral A */
    
	/** @todo rename into logical names */
	NSMutableString *reward1;						/**< request for current dilemma */
	NSMutableString *reward2;    					/**< reward for answering choice */
	NSString *actionKey;							/**< pkey for choice entry into Core Data */
	BOOL isRequirementOwned;					/**< does User have key necessary to pass */
}

/**
 Load the dilemma's details from SystemData
 */
-(void)loadDilemma;

/**
 Change the active UIView within the UIViewController
 @param screenVersion intDesignating which version of screen to display
 */
-(void)changeScreen:(int) screenVersion;

/**
 Commit User's choice to UserData
 */
-(void)commitDilemma;

@end

@implementation ConscienceActionViewController

#pragma mark -
#pragma mark ViewController Lifecycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
		//Create appDelegate and CD context for Conscience and data
		appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
		prefs = [NSUserDefaults standardUserDefaults];
		context = [appDelegate.moralModelManager readWriteManagedObjectContext];
                
		//Setup default values
		reward1 = [[NSMutableString alloc] init];
		reward2 = [[NSMutableString alloc] init];
		dilemmaName = [[NSMutableString alloc] init];
		moralAName = [[NSMutableString alloc] init];
		moralADescription = [[NSMutableString alloc] init];
		isRequirementOwned = FALSE;
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Get relevant dilemma information
	[self loadDilemma];
    [self localizeUI];    
        
}

-(void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
	
	screen1View.hidden = TRUE;
	screen1View.alpha = 0;
    
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
    
	appDelegate.userConscienceView.center = centerPoint;
	
	[UIView commitAnimations];
	
	[appDelegate.userConscienceView setNeedsDisplay];
	
}

#pragma mark -
#pragma mark UI Interaction

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
		
      	[moralSelectedImage setImage:moral1ChoiceImage.image];
		[moralSelectedChoiceLabel setText:moral1ChoiceLabel.text];
            
		if (choiceIndex == 4) {

            	isReadyToCommit = TRUE;
		} 
        
		if (isReadyToCommit) {
            
            	[self commitDilemma];
		}
        
		[self changeScreen:choiceIndex];
	}
	
}

/**
Implementation: Hide or show a screen depending upon which version the User currently resides.
If User doesn't possess what is required to pass action, deny completion
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
		case 4:viewSelection = screen4View;buttonFactor = 3;[previousButton setHidden:TRUE];break;
		case 5:[self.navigationController popViewControllerAnimated:NO];break;
		default:break;
			
	}
    

    //Change the active view except in the case of dismissing the entire ViewController
    if (screenVersion > 0 && screenVersion <= 4) {
        
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
        
		//Change Button tag in order to determine which "screen" is active
		nextButton.tag = 2 + buttonFactor;
		previousButton.tag = buttonFactor;

		/** @todo determine new collection checking for non-dilemma entries */
		//Determine if User is in possession of requirement for success
		if (screenVersion == 3){

//			//Ensure that User must enter in a new choice after reading Dilemma
//			BOOL isRewardAllowed = FALSE;
//
//			NSString *restoreRequirement = [prefs objectForKey:@"firstTimeRequirement"];
//			if (restoreRequirement != nil) {
//				[prefs removeObjectForKey:@"firstTimeRequirement"];
//				isRewardAllowed = TRUE;
//			} else {
//				[prefs setBool:FALSE forKey:@"firstTimeRequirement"];
//			}
//
//			if(!isRequirementOwned && !isRewardAllowed){
            if(!isRequirementOwned){

				//Skip the reward screen as requirement has not been met
				nextButton.tag = 5;
				previousButton.tag = 2;
			}
		}
        
		//Delay appearance of score to draw attention
		if (screenVersion == 4) {
			
	            nextButton.tag = 5;
            
			//Spin reward card onto screen
      	      [UIView beginAnimations:@"RewardChange" context:nil];
			[UIView setAnimationDuration:1];
			[UIView setAnimationBeginsFromCurrentState:YES];
			
	            rewardView.alpha = 1;
      	      rewardView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            
			[UIView commitAnimations];
            
			//Show moral reward fade            
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
#pragma mark Data manipulation

/**
Implementation: Load requested dilemma, load into iVar for use throughout UIViewController.
Construct antagonist Conscience
@todo refactor into multiple functions
 */
-(void) loadDilemma{
        
	NSString *restoreDilemmaKey = [prefs objectForKey:@"dilemmaKey"];
    
	/** @todo determine no dilemma case */
	if (restoreDilemmaKey != nil) {
		[prefs removeObjectForKey:@"dilemmaKey"];
	}
    
    DilemmaDAO *currentDilemmaDAO = [[DilemmaDAO alloc] initWithKey:restoreDilemmaKey];
    currentDilemma = [currentDilemmaDAO read:@""];
    
	if (currentDilemma) {

        [dilemmaName setString:[currentDilemma nameDilemma]];
        [moralAName setString:[[currentDilemma moralChoiceA] nameMoral]];
        [moralADescription setString:[[currentDilemma moralChoiceA] shortDescriptionMoral]];

		surroundingsBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [currentDilemma surrounding]]];
		
		//Setup relevant dilemma text
		[introText setText:[currentDilemma choiceB]];
		[dilemmaTitle setText:[currentDilemma displayNameDilemma]];
		[dilemmaTitleText setText:[dilemmaTitle text]];
		[dilemmaText setText:[currentDilemma dilemmaText]];
		[choiceText1 setText:[currentDilemma choiceA]];
        
		NSString *moral1Text = [[NSString alloc] initWithString:[[currentDilemma moralChoiceA] displayNameMoral]];

		//Add moral image with .png to support iOS 3
		UIImage *moral1ImageFull = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [[currentDilemma moralChoiceA] imageNameMoral]]];
	
		BOOL keyIsMoral = FALSE;
		//Determine if criteria for success is going to be
		if ([[currentDilemma rewardADilemma] isEqualToString:[currentDilemma rewardBDilemma]]) {
			actionKey = [[NSString alloc] initWithString:[[currentDilemma moralChoiceA] nameMoral]];
			keyIsMoral = TRUE;
		} else {
			actionKey = [[NSString alloc] initWithString:[currentDilemma rewardADilemma]];
		}

		//Determine if User is in possession of item/moral needed to pass Action
		if(keyIsMoral) {

			//Determine if User has requirement to pass
            
            UserChoiceDAO *currentUserChoiceDAO = [[UserChoiceDAO alloc] initWithKey:@""];

			NSPredicate *userChoicePred = [NSPredicate predicateWithFormat:@"(choiceMoral == %@) AND (NOT entryKey contains[cd] %@)", actionKey, @"dile-"];
    
			[currentUserChoiceDAO setPredicates:@[userChoicePred]];
       
			if ([currentUserChoiceDAO count] == 0) {
				isRequirementOwned = FALSE;
			} else {
				isRequirementOwned = TRUE;
			}
            

		} else {
		
			if ([[appDelegate userCollection] containsObject:actionKey]) {
				isRequirementOwned = TRUE;
			} else {
				isRequirementOwned = FALSE;
			}
		}
        
                
		moral1Image.image = moral1ImageFull;
		[dilemmaMoralLabel1 setText:moral1Text];
		[moral1ChoiceLabel setText:moral1Text];
        
		moral1ChoiceImage.image = moral1ImageFull;
        
        
		[reward1 appendString:[currentDilemma rewardADilemma]];
		[reward2 appendString:[currentDilemma rewardBDilemma]];
        
        //Instantiate Conscience facets for use throughout class    
        ConscienceBody *antagonistConscienceBody = [[ConscienceBody alloc] init];
        ConscienceAccessories *antagonistConscienceAccessories = [[ConscienceAccessories alloc] init];
        ConscienceMind *antagonistConscienceMind = [[ConscienceMind alloc] init];
        
		//Assign antagonist Conscience
		antagonistConscienceBody.eyeColor = [[currentDilemma antagonist] eyeColor];
		antagonistConscienceBody.browColor = [[currentDilemma antagonist] browColor];
		antagonistConscienceBody.bubbleColor = [[currentDilemma antagonist] bubbleColor];
		antagonistConscienceBody.bubbleType = [[[currentDilemma antagonist] bubbleType] intValue];
		antagonistConscienceBody.age = [[[currentDilemma antagonist] ageCharacter] intValue];
		antagonistConscienceBody.symbolName = [[currentDilemma antagonist] faceCharacter];
		antagonistConscienceBody.eyeName = [[currentDilemma antagonist] eyeCharacter];
		antagonistConscienceBody.mouthName = [[currentDilemma antagonist] mouthCharacter];
        if (![[[currentDilemma antagonist] accessoryPrimaryCharacter] isEqualToString:@""]) {
            antagonistConscienceAccessories.primaryAccessory = [[currentDilemma antagonist] accessoryPrimaryCharacter];
        }
        if (![[[currentDilemma antagonist] accessorySecondaryCharacter] isEqualToString:@""]) {
            antagonistConscienceAccessories.secondaryAccessory = [[currentDilemma antagonist] accessorySecondaryCharacter];
        }
        if (![[[currentDilemma antagonist] accessoryTopCharacter] isEqualToString:@""]) {
            antagonistConscienceAccessories.topAccessory = [[currentDilemma antagonist] accessoryTopCharacter];
        }
        if (![[[currentDilemma antagonist] accessoryBottomCharacter] isEqualToString:@""]) {            
            antagonistConscienceAccessories.bottomAccessory = [[currentDilemma antagonist] accessoryBottomCharacter];
        }        
		[antagonistConscienceMind setMood:[[currentDilemma moodDilemma] floatValue]];
		[antagonistConscienceMind setEnthusiasm:[[currentDilemma enthusiasmDilemma] floatValue]];
        
		[ConscienceBuilder buildConscience:antagonistConscienceBody];
        
		ConscienceView *antagonistConscienceView = [[ConscienceView alloc] initWithFrame:CGRectMake(kConscienceAntagonistX, kConscienceAntagonistY, kConscienceAntagonistWidth, kConscienceAntagonistHeight) withBody:antagonistConscienceBody withAccessories:antagonistConscienceAccessories withMind:antagonistConscienceMind];
        
		antagonistConscienceView.tag = kConscienceAntagonistViewTag;
		antagonistConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
		antagonistConscienceView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
		[antagonistConscienceView setUserInteractionEnabled:FALSE];
		[antagonistConscienceView.conscienceBubbleView setNeedsDisplay];
        
		[thoughtModalArea addSubview:antagonistConscienceView];
        
		[antagonistConscienceView setNeedsDisplay];
        
	}
	
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
    //Construct Unique Primary Key from dtstamp to millisecond
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];	
    
    NSString *currentDTS = [dateFormatter stringFromDate:[NSDate date]];
    
    
    NSString *dilemmaKey = [NSString stringWithFormat:@"%@%@", currentDTS, dilemmaName];
    UserDilemmaDAO *currentUserDilemmaDAO = [[UserDilemmaDAO alloc] init];
    
    UserDilemma *currentUserDilemma = [currentUserDilemmaDAO create];
    
    [currentUserDilemma setEntryShortDescription:dilemmaName];
    [currentUserDilemma setEntryCreationDate:[NSDate date]];
    [currentUserDilemma setEntryKey:dilemmaKey];
    NSString *moralKey = [[NSString alloc] initWithString:moralAName];
        
    [currentUserDilemma setEntryLongDescription:moralKey];
    
    [currentUserDilemma setEntryIsGood:@TRUE];
    
    [currentUserDilemmaDAO update];
    
    UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:@""];
    //See if moral has been rewarded before
    //Cannot assume that first instance of UserChoice implies no previous reward
    if ([appDelegate.userCollection containsObject:moralKey]) {
        
        UserCollectable *currentUserCollectable = [currentUserCollectableDAO read:moralKey];
        
        //Increase the moral's value
        float moralIncrease = [[currentUserCollectable collectableValue] floatValue];
        
        if (moralIncrease >= 99.0) {
            moralIncrease = 99.0;
        } else {
            moralIncrease += 1.0;
        }
        
        [currentUserCollectable setValue:@(moralIncrease) forKey:@"collectableValue"];
        
    } else {
        
        //Create a new moral reward
        
        UserCollectable *currentUserCollectable = [currentUserCollectableDAO create];
        
        [currentUserCollectable setCollectableCreationDate:[NSDate date]];
        [currentUserCollectable setCollectableKey:dilemmaKey];
        [currentUserCollectable setCollectableName:moralKey];
        [currentUserCollectable setCollectableValue:@1.0f];
                
        [appDelegate.userCollection addObject:moralKey];
        
        [currentUserCollectableDAO update];
        
    }
    
	//
	NSMutableString *selectedReward = [[NSMutableString alloc] initWithString:reward2]; 
    
	//Determine if reward is ethicals or a Reference/ConscienceAsset
	//@todo localize reward
	if ([selectedReward rangeOfString:kCollectableEthicals].location != NSNotFound) {
		[selectedReward deleteCharactersInRange:[selectedReward rangeOfString:kCollectableEthicals]];
		[moralSelectedRewardLabel setText:@"Have some Ethicals!"];
        
	} else if ([selectedReward rangeOfString:@"figu-"].location != NSNotFound) {

		//Reward is Referenceperson, do not show Ethical label
		[ethicalRewardLabel setAlpha:0];
        
        ReferencePersonDAO *currentPersonDAO = [[ReferencePersonDAO alloc] initWithKey:selectedReward];
        
        ReferencePerson *currentPerson = [currentPersonDAO read:@""];
        
        [moralSelectedRewardLabel setText:[NSString stringWithString:currentPerson.displayNameReference]];
        
		[rewardImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", currentPerson.imageNameReference]]];

                
		UserCollectable *currentUserCollectable = [currentUserCollectableDAO create];
        
		[currentUserCollectable setCollectableCreationDate:[NSDate date]];
		[currentUserCollectable setCollectableKey:[NSString stringWithFormat:@"%@%@", currentDTS, selectedReward]];
		[currentUserCollectable setCollectableName:selectedReward];
                
		[appDelegate.userCollection addObject:selectedReward];
        
	} else if ([selectedReward rangeOfString:@"asse-"].location != NSNotFound) {

		//Reward is ConscienceAsset, do not show Ethical label
		[ethicalRewardLabel setAlpha:0];
        
        ReferenceAssetDAO *currentReferenceDAO = [[ReferenceAssetDAO alloc] initWithKey:selectedReward];
        ReferenceAsset *currentReference = [currentReferenceDAO read:@""];
        
		[moralSelectedRewardLabel setText:[NSString stringWithString:currentReference.displayNameReference]];
        
		[rewardImageSmall setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-sm.png", currentReference.imageNameReference]]];
        
        
		UserCollectable *currentUserCollectable = [currentUserCollectableDAO create];
        
		[currentUserCollectable setCollectableCreationDate:[NSDate date]];
		[currentUserCollectable setCollectableKey:[NSString stringWithFormat:@"%@%@", currentDTS, selectedReward]];
		[currentUserCollectable setCollectableName:selectedReward];
                
		[appDelegate.userCollection addObject:selectedReward];
	}
    
	//Update User's ethicals
    currentUserCollectableDAO.predicates = @[[NSPredicate predicateWithFormat:@"collectableName == %@", kCollectableEthicals]];
	UserCollectable *currentUserCollectable = [currentUserCollectableDAO read:@""];
    
	//Increase the moral's value
	int ethicalIncrease = [[currentUserCollectable collectableValue] intValue];
    
	[moralRewardLabel setText:@"+1"];

	//If reward was NOFAIL, add 5 ethicals
	if([selectedReward isEqualToString:@""]){
		[selectedReward setString:@"5"];
	}

    //Append epsilon character
	[ethicalRewardLabel setText:[NSString stringWithFormat:@"+%dε", [selectedReward intValue]]];
    
	//Set limit to amount of Ethicals User can earn
	//@todo make constant
	if (ethicalIncrease >= 999) {
		ethicalIncrease = 999;
	} else {
		ethicalIncrease += [selectedReward intValue];
	}
    
	[currentUserCollectable setValue:@(ethicalIncrease) forKey:@"collectableValue"];
    
    

    [currentUserCollectableDAO update];
	//Create a User Choice so that User's Moral report is affected
	//Prefix with dile- on a User prohibited field to ensure that entry is never shown on ConscienceListViewController
    
    UserChoiceDAO *currentUserChoiceDAO = [[UserChoiceDAO alloc] initWithKey:@""];
	UserChoice *currentUserChoice = [currentUserChoiceDAO create];
    
	[currentUserChoice setEntryCreationDate:[NSDate date]];
    
	NSMutableString *moralType = [[NSMutableString alloc] initWithString:moralADescription];
        
	BOOL isGood = FALSE;
    
	if ([moralType isEqualToString:@"Virtue"]) {
		isGood = TRUE;
	}	
    

	//Commit UserChoice    
	[currentUserChoice setEntryShortDescription:dilemmaName];
	[currentUserChoice setEntryLongDescription:@""];
	[currentUserChoice setEntrySeverity:@1.0f];
	[currentUserChoice setEntryModificationDate:[NSDate date]];
	[currentUserChoice setEntryKey:dilemmaKey];
	[currentUserChoice setChoiceMoral:moralKey];
	[currentUserChoice setChoiceJustification:@""];
	[currentUserChoice setChoiceInfluence:@1];
	[currentUserChoice setEntryIsGood:@(isGood)];
	[currentUserChoice setChoiceConsequences:@""];
    
	if (isGood) {
		[currentUserChoice setChoiceWeight:@0.2f];  
	} else {
		[currentUserChoice setChoiceWeight:@-0.2f];  
	}
    
    [currentUserChoiceDAO update];
    
    /** @todo refactor into ConscienceMind
     */
    float newMood = appDelegate.userConscienceMind.mood + 0.5;
    float newEnthusiasm = appDelegate.userConscienceMind.enthusiasm + 0.5;
    
    if (newMood > 90) {
        appDelegate.userConscienceMind.mood = 90.0;
    } else if (newMood < 10) {
        appDelegate.userConscienceMind.mood = 10.0;
    } else {
        appDelegate.userConscienceMind.mood = newMood;        
    }
    
    if (newEnthusiasm > 90) {
        appDelegate.userConscienceMind.enthusiasm = 90.0;
    } else if (newEnthusiasm < 0) {
        appDelegate.userConscienceMind.enthusiasm = 10.0;
    } else {
        appDelegate.userConscienceMind.enthusiasm = newEnthusiasm;        
    }
    
    UserCharacterDAO *currentUserCharacterDAO = [[UserCharacterDAO alloc] init];
    UserCharacter *currentUserCharacter = [currentUserCharacterDAO read:@""];
    [currentUserCharacter setCharacterMood:@(newMood)];    
    [currentUserCharacter setCharacterEnthusiasm:@(newEnthusiasm)];   
    
    [currentUserCharacterDAO update];
    
    
    
}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint", @"Hint for previous button");
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",@"Label for previous button");

    nextButton.accessibilityHint = NSLocalizedString(@"NextButtonHint", @"Hint for next button");
	nextButton.accessibilityLabel =  NSLocalizedString(@"NextButtonLabel",@"Label for next button");

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
