/**
Implementation: Presents a series of updated screens to User prompting the User to select one or the other.
Allows for backwards perusal to reread certain parts of entry as long as choice hasn't been made.
Commits choice to UserData, updates ethicals, adds reward to UserConscience::userCollection
 
@class DilemmaViewController DilemmaViewController.h
 */

#import "DilemmaViewController.h"
#import "ConscienceBody.h"
#import "ConscienceAccessories.h"
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
#import "UIColor+Utility.h"

typedef enum {
    MLViewToAnimateVersus,
    MLViewToAnimateReward
} MLViewToAnimate;

typedef enum {
    MLDilemmaTypeMoralChoice,
    MLDilemmaTypeInformation,
    MLDilemmaTypePurchase,
    MLDilemmaTypeMoralEntry
} MLDilemmaType;

@interface DilemmaViewController () <ViewControllerLocalization> {
    
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */

	IBOutlet UIImageView *surroundingsBackground;		/**< background image provided by dilemma */
	IBOutlet UIImageView *versusImage;				/**< animated versus decoration image */
	IBOutlet UIImageView *moral1Image;				/**< initial MoralA image decoration above vs. */
	IBOutlet UIImageView *moral2Image;				/**< initial MoralB image decoration below vs. */
	IBOutlet UIImageView *moral1ButtonImage;			/**< final MoralA selection button above "or" */
	IBOutlet UIImageView *moral2ButtonImage;			/**< final MoralB selection button above "or" */
	IBOutlet UIImageView *moralSelectedImage;			/**< final chosen Moral image decoration */
	IBOutlet UIImageView *rewardCard;				/**< card image on rewardView */
	IBOutlet UIImageView *rewardImage;				/**< actual image of reward (large) */
	IBOutlet UIImageView *rewardImageSmall;			/**< actual image of reward (small) */
	IBOutlet UILabel *moral1ChoiceLabel;			/**< MoralA text name */
	IBOutlet UILabel *moral2ChoiceLabel;			/**< MoralB text name */
	IBOutlet UIImageView *moral1ChoiceImage;			/**< MoralA decoration */
	IBOutlet UIImageView *moral2ChoiceImage;			/**< MoralB decoration */
	IBOutlet UILabel *moralSelectedChoiceLabel;		/**< completed moral title */
	IBOutlet UILabel *moralSelectedRewardLabel;		/**< completed reward description */
	IBOutlet UILabel *moralRewardLabel;				/**< increase to specific moral */
	IBOutlet UILabel *moralScoreLabel;				/**< score next to moral image */
	IBOutlet UILabel *ethicalRewardLabel;			/**< ethicals text if ethicals rewarded */
    
	//Views for progression of Dilemma
	IBOutlet UIView *thoughtModalArea;		/**< area in which Conscience floats */
	IBOutlet UIView *screen1View;			/**< intro screen with moral vs. moral */
	IBOutlet UIView *screen2View;			/**< description of dilemma */
	IBOutlet UIView *screen3View;			/**< description of Moral choice A */		
	IBOutlet UIView *screen4View;			/**< description of Moral choice B */
	IBOutlet UIView *screen5View;			/**< Moral section screen */
	IBOutlet UIView *screen6View;			/**< reward screen */
	IBOutlet UIView *rewardView;			/**< reward card containing decorations */
    
	IBOutlet UILabel *dilemmaTitle;         /**< title of Dilemma */
	IBOutlet UILabel *dilemmaTitleText;		/**< 2nd viewing of title of Dilemma */
	IBOutlet UITextView *introText;			/**< first text introduction */
	IBOutlet UITextView *dilemmaText;		/**< dilemma presented to User */
	IBOutlet UILabel *dilemmaMoralLabel1;	/**< MoralA associated with dilemma */
	IBOutlet UILabel *dilemmaMoralLabel2;	/**< MoralB associated with dilemma */
	IBOutlet UITextView *choiceText1;		/**< MoralA description */
	IBOutlet UITextView *choiceText2;		/**< MoralB description */
	IBOutlet UIButton *selectionButton1;	/**< select Moral A */
	IBOutlet UIButton *selectionButton2;	/**< select Moral B */
	IBOutlet UIButton *previousButton;		/**< return to previous page in dilemma */
	IBOutlet UIButton *nextButton;          /**< proceed to next page in dilemma */

	Dilemma *currentDilemma;                /**< information about the dilemma */
    NSMutableString *dilemmaName;          /**< name of dilemma used for record retention */
    NSMutableString *moralAName;            /**< name of Moral A */
    NSMutableString *moralBName;            /**< name of Moral B */
    NSMutableString *moralADescription;    /**< description of Moral A */
    NSMutableString *moralBDescription;    /**< description of Moral B */

	NSMutableString *reward1;               /**< reward for choosing ChoiceA */
	NSMutableString *reward2;               /**< reward for choosing ChoiceB */
	NSString *actionKey;					/**< pkey for choice entry into Core Data */

	BOOL isChoiceA;				/**< is ChoiceA selected */
	BOOL isRequirementOwned;	/**< does User have key necessary to pass */

}

@property (nonatomic) IBOutlet UIImageView *previousScreen;
@property (nonatomic) BOOL isAction;

- (void) animateViewDetail: (MLViewToAnimate) viewToAnimateIndex atBeginning: (BOOL) isBeginning;

/**
 Load the dilemma's details from SystemData
 */
-(void)loadDilemma;

/**
 Change the active UIView within the UIViewController
 @param screenVersion intDesignating which page of screen to display
 */
-(void)changeScreen:(int) screenVersion;

/**
 Commit User's choice to UserData
 */
-(void)commitDilemma;

@end

@implementation DilemmaViewController

#pragma mark -
#pragma mark ViewController Lifecycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil modelManager:modelManager andConscience:userConscience])) {

        self.isAction = ([nibNameOrNil isEqualToString:@"ConscienceActionView"]);

        prefs = [NSUserDefaults standardUserDefaults];

		//Setup default values
        reward1 = [[NSMutableString alloc] init];
        reward2 = [[NSMutableString alloc] init];
        dilemmaName = [[NSMutableString alloc] init];
        moralAName = [[NSMutableString alloc] init];
        moralBName = [[NSMutableString alloc] init];
        moralADescription = [[NSMutableString alloc] init];
        moralBDescription = [[NSMutableString alloc] init];
		isRequirementOwned = FALSE;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.previousScreen.image = self.screenshot;

	//Get relevant dilemma information
    [self loadDilemma];
    
    isChoiceA = self.isAction;

    [dilemmaTitle setFont:[UIFont fontForConscienceHeader]];
    [dilemmaTitle setNumberOfLines:1];
    [dilemmaTitle setAdjustsFontSizeToFitWidth:TRUE];
    [dilemmaTitle setTextColor:[UIColor moraLifeChoiceBlue]];

    [dilemmaTitleText setFont:[UIFont fontForConscienceHeader]];
    [dilemmaTitleText setNumberOfLines:1];
    [dilemmaTitleText setAdjustsFontSizeToFitWidth:TRUE];
    [dilemmaTitleText setTextColor:[UIColor moraLifeChoiceBlue]];

    [moralSelectedChoiceLabel setFont:[UIFont fontForConscienceHeader]];
    [moralSelectedChoiceLabel setNumberOfLines:1];
    [moralSelectedChoiceLabel setAdjustsFontSizeToFitWidth:TRUE];
    [moralSelectedChoiceLabel setTextColor:[UIColor moraLifeChoiceBlue]];

    ethicalRewardLabel.textColor = [UIColor moraLifeChoiceGreen];
    moralRewardLabel.textColor = [UIColor moraLifeChoiceGreen];
    moralSelectedRewardLabel.textColor = [UIColor moraLifeBrown];
    moral1ChoiceLabel.textColor = [UIColor moraLifeChoiceGreen];
    moral2ChoiceLabel.textColor = [UIColor moraLifeChoiceGreen];
    dilemmaMoralLabel1.textColor = [UIColor moraLifeChoiceGreen];
    dilemmaMoralLabel2.textColor = [UIColor moraLifeChoiceGreen];
    [selectionButton1 setTitleColor:[UIColor moraLifeChoiceGreen] forState:UIControlStateNormal];
    [selectionButton2 setTitleColor:[UIColor moraLifeChoiceGreen] forState:UIControlStateNormal];

    [self localizeUI];    

}

-(void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
	
	screen1View.hidden = TRUE;
	screen1View.alpha = 0;
	
    //Build vs. image animation
	versusImage.alpha = 0;    
    versusImage.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(6.0f, 6.0f), CGAffineTransformMakeRotation(M_PI * -1));

    [self animateViewDetail: MLViewToAnimateVersus atBeginning: TRUE];    

    rewardView.alpha = 0;
	rewardView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(6.0f, 6.0f), CGAffineTransformMakeRotation(M_PI * -1));

	[thoughtModalArea addSubview:_userConscience.userConscienceView];
	
	CGPoint centerPoint = CGPointMake(MLConscienceLowerLeftX, MLConscienceLowerLeftY);
	
    //Animate vs. image and Consciences
	[UIView beginAnimations:@"MoveConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	_userConscience.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(MLConscienceLargeSizeX, MLConscienceLargeSizeY);
    
	screen1View.alpha = 1;
	
	screen1View.hidden = FALSE;
    
    [self animateViewDetail: MLViewToAnimateVersus atBeginning: FALSE];
    
	_userConscience.userConscienceView.center = centerPoint;
	
	[UIView commitAnimations];
    
    [self animateViewDetail: MLViewToAnimateReward atBeginning: TRUE];    
	
	[_userConscience.userConscienceView setNeedsDisplay];
	
}

-(void)setScreenshot:(UIImage *)screenshot {
    if (_screenshot != screenshot) {
        _screenshot = screenshot;
        self.previousScreen.image = screenshot;
    }
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

        if (self.isAction) {
            [moralSelectedImage setImage:moral1ChoiceImage.image];
            [moralSelectedChoiceLabel setText:moral1ChoiceLabel.text];

            if ((choiceIndex == 4) && isRequirementOwned) {

            	isReadyToCommit = TRUE;
            }

            if (isReadyToCommit) {

            	[self commitDilemma];
            }

            if (self.isAction) {
                [self changeActionScreen:choiceIndex];
            } else {
                [self changeScreen:choiceIndex];
            }

        } else {

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
	
}

/**
Implementation: Hide or show a screen depending upon which page the User currently resides.
Show reward views once User has completed dilemma and refuse access to previous screen versions.
 */
-(void)changeActionScreen:(int) screenVersion {
    
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

            //Ensure that User must enter in a new choice after reading Dilemma
            BOOL isRewardAllowed = FALSE;

            NSString *restoreRequirement = [prefs objectForKey:@"firstTimeRequirement"];
            if (restoreRequirement != nil && restoreRequirement.boolValue) {
                [prefs removeObjectForKey:@"firstTimeRequirement"];
                isRewardAllowed = TRUE;
            } else {
                [prefs setBool:FALSE forKey:@"firstTimeRequirement"];
            }

            if(!isRequirementOwned && !isRewardAllowed){

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

            [self animateViewDetail: MLViewToAnimateReward atBeginning: FALSE];

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


- (void) animateViewDetail: (MLViewToAnimate) viewToAnimateIndex atBeginning: (BOOL) isBeginning {

    int animationType = arc4random()%4;
    CGAffineTransform viewAnimationTransform = CGAffineTransformIdentity;

    switch (animationType) {
        case 0:{
            viewAnimationTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(6.0f, 6.0f), CGAffineTransformMakeRotation(M_PI * -1));
        }
            break;
        case 1:{
            viewAnimationTransform = CGAffineTransformMakeTranslation(0, 400);
        }
            break;
        case 2:{
            viewAnimationTransform = CGAffineTransformMakeTranslation(400, 0);
        }
            break;
        case 3:{
            viewAnimationTransform = CGAffineTransformMakeTranslation(-400, 0);
        }
            break;
        default:
            break;
    }

    if (isBeginning) {

        switch (viewToAnimateIndex) {
            case MLViewToAnimateVersus: {
                versusImage.alpha = 0;
                versusImage.transform = viewAnimationTransform;

            }
                break;
            case MLViewToAnimateReward: {
                rewardView.alpha = 0;
                rewardView.transform = viewAnimationTransform;

            }
                break;
            default:
                break;
        }

    } else {

        switch (viewToAnimateIndex) {
            case MLViewToAnimateVersus: {
                //Animate vs. image and Consciences
                [UIView beginAnimations:@"Versus" context:nil];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationBeginsFromCurrentState:YES];
                versusImage.alpha = 1;
                versusImage.transform = CGAffineTransformIdentity;
                [UIView commitAnimations];

            }
                break;
            case MLViewToAnimateReward: {
                //Animate reward image
                [UIView beginAnimations:@"Reward" context:nil];
                [UIView setAnimationDuration:0.75];
                [UIView setAnimationBeginsFromCurrentState:YES];
                rewardView.alpha = 1;
                rewardView.transform = CGAffineTransformIdentity;
                [UIView commitAnimations];
            }
                break;
            default:
                break;
        }
        
    }
}

#pragma mark -
#pragma mark Data Manipulation

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

	//Retrieve Dilemma
    DilemmaDAO *currentDilemmaDAO = [[DilemmaDAO alloc] initWithKey:restoreDilemmaKey andModelManager:_modelManager];
    currentDilemma = [currentDilemmaDAO read:@""];
    
	if (currentDilemma) {    
		//Populate relevante dilemma information
        [dilemmaName setString:[currentDilemma nameDilemma]];
        [moralAName setString:[[currentDilemma moralChoiceA] nameMoral]];
        [moralBName setString:[[currentDilemma moralChoiceB] nameMoral]];
        [moralADescription setString:[[currentDilemma moralChoiceA] shortDescriptionMoral]];
        [moralBDescription setString:[[currentDilemma moralChoiceB] shortDescriptionMoral]];
		surroundingsBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [currentDilemma surrounding]]];

		//Setup relevant dilemma text
        [introText setText:[currentDilemma choiceB]];
		[dilemmaTitle setText:[currentDilemma displayNameDilemma]];
		[dilemmaTitleText setText:[dilemmaTitle text]];
		[dilemmaText setText:[currentDilemma dilemmaText]];
		[choiceText1 setText:[currentDilemma choiceA]];
		[choiceText2 setText:[currentDilemma choiceB]];
        
		NSString *moral1Text = [[NSString alloc] initWithString:[[currentDilemma moralChoiceA] displayNameMoral]];
		NSString *moral2Text = [[NSString alloc] initWithString:[[currentDilemma moralChoiceB] displayNameMoral]];
        
		UIImage *moral1ImageFull = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [[currentDilemma moralChoiceA] imageNameMoral]]];
		UIImage *moral2ImageFull = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [[currentDilemma moralChoiceB] imageNameMoral]]];

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
            UserChoiceDAO *currentUserChoicePreReqDAO = [[UserChoiceDAO alloc] initWithKey:@"" andModelManager:_modelManager];
			NSPredicate *userChoicePred = [NSPredicate predicateWithFormat:@"(choiceMoral == %@) AND (NOT entryKey contains[cd] %@)", actionKey, @"dile-"];

			[currentUserChoicePreReqDAO setPredicates:@[userChoicePred]];

			if ([currentUserChoicePreReqDAO count] == 0) {
				isRequirementOwned = FALSE;
			} else {
                NSTimeInterval secondsPast = -3600;
                NSDate *oneHourOld = [NSDate dateWithTimeInterval:secondsPast sinceDate:[NSDate date]];
                NSPredicate *userChoicePreReqPred = [NSPredicate predicateWithFormat:@"(entryCreationDate < %@)", oneHourOld];

                NSArray *possibleChoices = [currentUserChoicePreReqDAO readAll];
                NSArray *filteredArray = [possibleChoices filteredArrayUsingPredicate:userChoicePreReqPred];
                if (filteredArray.count > 0) {
                    isRequirementOwned = TRUE;
                } else {
                    _conscienceHelpViewController.isConscienceOnScreen = TRUE;
                    _conscienceHelpViewController.numberOfScreens = 1;
                    _conscienceHelpViewController.screenshot = [self takeScreenshot];
                    [self presentModalViewController:_conscienceHelpViewController animated:NO];
                    [self.navigationController popViewControllerAnimated:NO];
                }
			}

		} else {

			if ([[_userConscience conscienceCollection] containsObject:actionKey]) {
				isRequirementOwned = TRUE;
			} else {
				isRequirementOwned = FALSE;
			}
		}
        
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
        
		[reward1 appendString:[currentDilemma rewardADilemma]];
		[reward2 appendString:[currentDilemma rewardBDilemma]];

        //Instantiate Conscience facets for use throughout class
        ConscienceBody *antagonistConscienceBody = [[ConscienceBody alloc] init];
        ConscienceAccessories *antagonistConscienceAccessories = [[ConscienceAccessories alloc] init];
        ConscienceMind *antagonistConscienceMind = [[ConscienceMind alloc] init];        
        
        Character *character = [currentDilemma antagonist];
        
		//Create antagonist Conscience
		antagonistConscienceBody.eyeColor = [character eyeColor];
		antagonistConscienceBody.browColor = [character browColor];
		antagonistConscienceBody.bubbleColor = [character bubbleColor];
		antagonistConscienceBody.age = [[character ageCharacter] intValue];
		antagonistConscienceBody.bubbleType = [[character bubbleType] intValue];
		antagonistConscienceBody.symbolName = [character faceCharacter];
		antagonistConscienceBody.eyeName = [character eyeCharacter];
		antagonistConscienceBody.mouthName = [character mouthCharacter];

        if (![[character accessoryPrimaryCharacter] isEqualToString:@""]) {
            antagonistConscienceAccessories.primaryAccessory = [character accessoryPrimaryCharacter];
        }
        if (![[character accessorySecondaryCharacter] isEqualToString:@""]) {
            antagonistConscienceAccessories.secondaryAccessory = [character accessorySecondaryCharacter];
        }
        if (![[character accessoryTopCharacter] isEqualToString:@""]) {
            antagonistConscienceAccessories.topAccessory = [character accessoryTopCharacter];
        }
        if (![[character accessoryBottomCharacter] isEqualToString:@""]) {            
            antagonistConscienceAccessories.bottomAccessory = [character accessoryBottomCharacter];
        }
        
		[antagonistConscienceMind setMood:[[currentDilemma moodDilemma] floatValue]];
		[antagonistConscienceMind setEnthusiasm:[[currentDilemma enthusiasmDilemma] floatValue]];
        
		//Call conscience construction
		[ConscienceBuilder buildConscience:antagonistConscienceBody];
        
		//Add Conscience to view
		ConscienceView *antagonistConscienceView = [[ConscienceView alloc] initWithFrame:CGRectMake(MLConscienceAntagonistX, MLConscienceAntagonistY, MLConscienceAntagonistWidth, MLConscienceAntagonistHeight) withBody:antagonistConscienceBody withAccessories:antagonistConscienceAccessories withMind:antagonistConscienceMind];
        
		antagonistConscienceView.tag = MLConscienceAntagonistViewTag;
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
Add reward ConscienceAsset or ReferenceAsset to UserConscience::userCollection.
Calculate changes to User's ethicals.  Limit to 999.
@todo refactor into multiple functions
 */
-(void)commitDilemma{
            
    //Construct Unique Primary Key from dtstamp to millisecond
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];	
    
    NSString *currentDTS = [dateFormatter stringFromDate:[NSDate date]];
    
        
    NSString *dilemmaKey = [NSString stringWithFormat:@"%@%@", currentDTS, dilemmaName];
    UserDilemmaDAO *currentUserDilemmaDAO = [[UserDilemmaDAO alloc] initWithKey:@"" andModelManager:_modelManager];
    
    UserDilemma *currentUserDilemma = [currentUserDilemmaDAO create];
        
    [currentUserDilemma setEntryShortDescription:dilemmaName];
    [currentUserDilemma setEntryCreationDate:[NSDate date]];
    [currentUserDilemma setEntryKey:dilemmaKey];
    
    NSString *moralKey;
    
    if (isChoiceA) {
        moralKey = [[NSString alloc] initWithString:moralAName];
    } else {
        moralKey = [[NSString alloc] initWithString:moralBName];       
    }
    
    [currentUserDilemma setEntryLongDescription:moralKey];
    
    [currentUserDilemma setEntryIsGood:@(isChoiceA)];
    
    UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:@"" andModelManager:_modelManager];
    //See if moral has been rewarded before
    //Cannot assume that first instance of UserChoice implies no previous reward
    if ([_userConscience.conscienceCollection containsObject:moralKey]) {
        
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
                
		[_userConscience.conscienceCollection addObject:moralKey];

        [currentUserCollectableDAO update];

	}
    
	//Determine which reward should be given
	NSMutableString *selectedReward = [[NSMutableString alloc] init];
    
	if (isChoiceA && !self.isAction) {
		[selectedReward appendString:reward1];
	} else {
		[selectedReward appendString:reward2];
	}

	//Determine if reward is ethicals or a Reference/ConscienceAsset
	//@todo localize reward
	if ([selectedReward rangeOfString:MLCollectableEthicals].location != NSNotFound) {
		//Ethicals are rewarded, process
		[selectedReward deleteCharactersInRange:[selectedReward rangeOfString:MLCollectableEthicals]];
		[moralSelectedRewardLabel setText:@"Have some Ethicals!"];

	} else if ([selectedReward rangeOfString:@"figu-"].location != NSNotFound) {
        
		//ReferencePerson rewarded, process, use large moralRewardImage
		[ethicalRewardLabel setAlpha:0];
        
        ReferencePersonDAO *currentPersonDAO = [[ReferencePersonDAO alloc] initWithKey:selectedReward andModelManager:_modelManager];
        ReferencePerson *currentPerson = [currentPersonDAO read:@""];
        
        [moralSelectedRewardLabel setText:[NSString stringWithString:currentPerson.displayNameReference]];
        
		[rewardImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", currentPerson.imageNameReference]]];
        
		UserCollectable *currentUserCollectable = [currentUserCollectableDAO create];
        
		[currentUserCollectable setCollectableCreationDate:[NSDate date]];
		[currentUserCollectable setCollectableKey:[NSString stringWithFormat:@"%@%@", currentDTS, selectedReward]];
		[currentUserCollectable setCollectableName:selectedReward];
                
		[_userConscience.conscienceCollection addObject:selectedReward];

	} else if ([selectedReward rangeOfString:@"asse-"].location != NSNotFound) {
      
		//ConscienceAsset rewarded, process, use small moralRewardImage
		[ethicalRewardLabel setAlpha:0];
        
        ReferenceAssetDAO *currentReferenceDAO = [[ReferenceAssetDAO alloc] initWithKey:selectedReward andModelManager:_modelManager];
        ReferenceAsset *currentReference = [currentReferenceDAO read:@""];
        
		[moralSelectedRewardLabel setText:[NSString stringWithString:currentReference.displayNameReference]];
        
		[rewardImageSmall setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-sm.png", currentReference.imageNameReference]]];
        
                
		UserCollectable *currentUserCollectable = [currentUserCollectableDAO create];
        
		[currentUserCollectable setCollectableCreationDate:[NSDate date]];
		[currentUserCollectable setCollectableKey:[NSString stringWithFormat:@"%@%@", currentDTS, selectedReward]];
		[currentUserCollectable setCollectableName:selectedReward];
                
		[_userConscience.conscienceCollection addObject:selectedReward];
	}

	//Update User's ethicals
    currentUserCollectableDAO.predicates = @[[NSPredicate predicateWithFormat:@"collectableName == %@", MLCollectableEthicals]];
	UserCollectable *currentUserCollectable = [currentUserCollectableDAO read:@""];
    
	//Increase the moral's value
	int ethicalIncrease = [[currentUserCollectable collectableValue] intValue];

	[moralRewardLabel setText:@"+1"];

	//If reward was NOFAIL, add 5 ethicals
	if([selectedReward isEqualToString:@""]){
		[selectedReward setString:@"5"];
	}

    //Append epsilon character and change negative to infinity
	[ethicalRewardLabel setText:[NSString stringWithFormat:@"+%dε", [selectedReward intValue]]];
    
	//Set limit to amount of Ethicals User can earn
	//@todo make constant
    ethicalIncrease += [selectedReward intValue];
    
	[currentUserCollectable setCollectableValue:@(ethicalIncrease)];
        
    
    [currentUserDilemmaDAO update];
    [currentUserCollectableDAO update];
    
	//Create a User Choice so that User's Moral report is affected
	//Prefix with dile- on a User prohibited field to ensure that entry is never shown on ConscienceListViewController

    UserChoiceDAO *currentUserChoiceDAO = [[UserChoiceDAO alloc] initWithKey:@"" andModelManager:_modelManager];
	UserChoice *currentUserChoice = [currentUserChoiceDAO create];
    
	[currentUserChoice setEntryCreationDate:[NSDate date]];
    
	NSMutableString *moralType = [[NSMutableString alloc] initWithString:@""];
    
	//Determine Moral to go along with UserChoice
	if (isChoiceA) {
		[moralType appendString:moralADescription];
	} else {
		[moralType appendString:moralBDescription];
	}

	//Account for weight calculation, virtue = +, vice = -    
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
    float newMood = _userConscience.userConscienceMind.mood + 0.5;
    float newEnthusiasm = _userConscience.userConscienceMind.enthusiasm + 0.5;
    
    if (newMood > 90) {
        _userConscience.userConscienceMind.mood = 10.0;
    } else if (newMood < 10) {
        _userConscience.userConscienceMind.mood = 10.0;
    } else {
        _userConscience.userConscienceMind.mood = newMood;        
    }
    
    if (newEnthusiasm > 90) {
        _userConscience.userConscienceMind.enthusiasm = 90.0;
    } else if (newEnthusiasm < 10) {
        _userConscience.userConscienceMind.enthusiasm = 10.0;
    } else {
        _userConscience.userConscienceMind.enthusiasm = newEnthusiasm;        
    }
    
    UserCharacterDAO *currentUserCharacterDAO = [[UserCharacterDAO alloc] initWithKey:@"" andModelManager:_modelManager];
    UserCharacter *currentUserCharacter = [currentUserCharacterDAO read:@""];
    [currentUserCharacter setCharacterMood:@(newMood)];    
    [currentUserCharacter setCharacterEnthusiasm:@(newEnthusiasm)];
    
    [currentUserCharacterDAO update];
    
    
}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint",nil);
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",nil);
    
    nextButton.accessibilityHint = NSLocalizedString(@"NextButtonHint",nil);
	nextButton.accessibilityLabel =  NSLocalizedString(@"NextButtonLabel",nil);
    
}

@end
