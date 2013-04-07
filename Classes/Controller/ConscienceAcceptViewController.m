/**
Implementation:  User can accept the choice: ConscienceAsset added to ConscienceBody/ConscienceAccessories and userCollection, ethicals subtracted from userCollection, conscienceView being updated and User returned to ConscienceViewController.
User can cancel entire Accessory workflow: return to HomeViewController.
User can return to the previous screen:  return to ConscienceListViewController to select another ConscienceAsset.
 
@class ConscienceAcceptViewController ConscienceAcceptViewController.h
 */

#import "ConscienceAcceptViewController.h"
#import "ConscienceAccessories.h"
#import "ConscienceBuilder.h"
#import "ConscienceAssetDAO.h"
#import "UserCharacterDAO.h"
#import "ConscienceBody.h"
#import "ConscienceView.h"
#import "ConscienceMind.h"
#import "Moral.h"
#import "UserCollectableDAO.h"
#import "UIColor+Utility.h"

@interface ConscienceAcceptViewController () <ViewControllerLocalization> {
    
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */

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
 	int currentFunds;		/**< current amount of ethicals from userCollection */
	int assetCost;          /**< cost of ConscienceAsset */

	BOOL isOwned;		/**< is ConscienceAsset already owned by User */
	
}

@property (nonatomic) IBOutlet UIImageView *previousScreen;

/**
 Accepts User input to return to ConscienceViewController
 */
-(void)dismissAcceptModal;

/**
 Accepts User input to return to ConscienceViewController
 */
-(void)returnToHome;

/**
 Retrieve how many ethicals User currently has from userCollection.
 */
-(void)retrieveCurrentFunds;

/**
 Subtract cost of ConscienceAsset from userCollection.
 */
-(void)processCollection;

/**
 Commit the choice of ConscienceAsset to ConscienceView.
 */
-(void)saveConscience;

@end

@implementation ConscienceAcceptViewController

#pragma mark -
#pragma mark ViewController lifecycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
-(id)initWithModelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience {

    if (self = [super initWithModelManager:modelManager andConscience:userConscience]) {

        prefs = [NSUserDefaults standardUserDefaults];
        
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
    self.previousScreen.image = self.screenshot;

	/** 
	@todo utilize consistent localization string references 
	@todo convert localization of all UIViewControllers into protocol
	*/

	//Set ownership boolean
	if ([_userConscience.conscienceCollection containsObject:self.assetSelection]){
		isOwned = TRUE;
	}

	// current ConscienceAsset under review for purchase
	NSString *assetFileName;
    
    [insufficientEthicalsLabel setHidden:TRUE];
	
	//Get current amount of ethicals for display and purchase logic
	[self retrieveCurrentFunds];
	[currentFundsLabel setText:[NSString stringWithFormat:@"%dε", currentFunds]];
    
    ConscienceAssetDAO *currentAssetDAO = [[ConscienceAssetDAO alloc] initWithKey:self.assetSelection andModelManager:_modelManager];
    ConscienceAsset *currentAsset = [currentAssetDAO read:@""];
    
    //Set UI labels
    [accessoryNameLabel setText:currentAsset.displayNameReference];
    [accessoryDescriptionLabel setText:currentAsset.shortDescriptionReference];        
    assetCost = [currentAsset.costAsset intValue];
        
    //Set UI image of Moral
    [moralImageView setImage:[UIImage imageNamed:currentAsset.relatedMoral.imageNameMoral]];

    assetFileName = [[NSString alloc] initWithString:currentAsset.imageNameReference];
	
	//Save image name for when ConscienceAsset is no longer retained
	/** @todo determine if Conscience update can be refactored */
	currentFeature = [[NSString alloc] initWithString:assetFileName];
    
    //Add requested ConscienceAsset to duplicate ConscienceView for review
	switch (self.accessorySlot) {
		case 0:{[resetFeature setString:_userConscience.userConscienceAccessories.topAccessory];_userConscience.userConscienceAccessories.topAccessory = currentFeature;}break;
		case 1:{[resetFeature setString:_userConscience.userConscienceAccessories.primaryAccessory];_userConscience.userConscienceAccessories.primaryAccessory = currentFeature;}break;
		case 2:{[resetFeature setString:_userConscience.userConscienceAccessories.bottomAccessory];_userConscience.userConscienceAccessories.bottomAccessory = currentFeature;}break;
		case 3:{[resetFeature setString:_userConscience.userConscienceAccessories.secondaryAccessory];_userConscience.userConscienceAccessories.secondaryAccessory = currentFeature;}break;
		case 4:{[resetFeature setString:_userConscience.userConscienceBody.eyeName];_userConscience.userConscienceBody.eyeName = currentFeature;}break;
		case 5:{[resetFeature setString:_userConscience.userConscienceBody.symbolName];_userConscience.userConscienceBody.symbolName = currentFeature;}break;
		case 6:{[resetFeature setString:_userConscience.userConscienceBody.mouthName];_userConscience.userConscienceBody.mouthName = currentFeature;}break;
		case 7:{[resetFeature setString:_userConscience.userConscienceBody.eyeColor];_userConscience.userConscienceBody.eyeColor = currentFeature;}break;
		case 8:{[resetFeature setString:_userConscience.userConscienceBody.browColor];_userConscience.userConscienceBody.browColor = currentFeature;}break;
		case 9:{[resetFeature setString:_userConscience.userConscienceBody.bubbleColor];_userConscience.userConscienceBody.bubbleColor = currentFeature;}break;
		case 10:{
            [resetFeature setString:[NSString stringWithFormat:@"%d", _userConscience.userConscienceBody.bubbleType]];
            
            NSString *bubbleType = [currentFeature substringFromIndex:11];
            _userConscience.userConscienceBody.bubbleType = [bubbleType intValue];

        }break;            
		default: break;
	}
	
    if ((self.accessorySlot > 3) && (self.accessorySlot < 7)) {
        [ConscienceBuilder buildConscience:_userConscience.userConscienceBody];

    }

    [backButton setTitleColor:[UIColor moraLifeChoiceRed] forState:UIControlStateNormal];
    [insufficientEthicalsLabel setTextColor:[UIColor moraLifeChoiceRed]];
    [buyButton setTitleColor:[UIColor moraLifeChoiceGreen] forState:UIControlStateNormal];
    [currentFundsLabel setTextColor:[UIColor moraLifeChoiceGreen]];
    [accessoryNameLabel setTextColor:[UIColor moraLifeChoiceBlue]];
    [accessoryNameLabel setShadowColor:[UIColor moraLifeChoiceGray]];

    [self localizeUI];    

}

-(void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];

	//Add User's actual Conscience to lower-left of screen
	[consciencePlayground addSubview:_userConscience.userConscienceView];
	[_userConscience.userConscienceView setNeedsDisplay];

    [accessoryCostLabel setTextColor:[UIColor moraLifeChoiceGreen]];
    
	//Inform/restrict User's ability to actually purchase ConscienceAsset
	//Flash assetCost is ConscienceAsset is unbuyable
	if (((assetCost > currentFunds) || (assetCost < 0)) && !isOwned) {
		[buyButton setHidden:TRUE];
        [insufficientEthicalsLabel setHidden:FALSE];
        
		[backButton setCenter:CGPointMake(backButton.center.x-50, backButton.center.y)];
		[accessoryCostLabel setTextColor:[UIColor moraLifeChoiceRed]];

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
    _userConscience.userConscienceView.alpha = 0;
    _userConscience.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    
    [UIView setAnimationDelegate:self]; // self is a view controller
    [UIView setAnimationDidStopSelector:@selector(moveConscienceToCenter)];
    
    [UIView commitAnimations];
}

-(void)setScreenshot:(UIImage *)screenshot {
    if (_screenshot != screenshot) {
        _screenshot = screenshot;
        self.previousScreen.image = screenshot;
    }
}

#pragma mark -
#pragma mark UI Interaction

-(void) moveConscienceToCenter{
    
    //Move Conscience to center of boxes
	CGPoint centerPoint = CGPointMake(160, 160);
    _userConscience.userConscienceView.center = centerPoint;
    
    [UIView beginAnimations:@"conscienceRestore" context:nil];
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationBeginsFromCurrentState:YES];
    _userConscience.userConscienceView.alpha = 1;
    _userConscience.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
    
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
                                        
			//Save choices to persistence
      	    [self saveConscience];
            
			//If ConscienceAsset is not already owned, add ConscienceAsset as UserCollectable and adjust User's funds
	        if (!isOwned) {
                
                [self processCollection];
            }

            [UIView beginAnimations:@"conscienceHide" context:nil];
            [UIView setAnimationDuration:0.25];
            
            [UIView setAnimationBeginsFromCurrentState:YES];
            _userConscience.userConscienceView.alpha = 0;
            _userConscience.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            
            [UIView setAnimationDelegate:self]; // self is a view controller
            [UIView setAnimationDidStopSelector:@selector(returnToHome)];
                            
            [UIView commitAnimations];
		} else {
            
            switch (self.accessorySlot) {
                case 0:_userConscience.userConscienceAccessories.topAccessory = resetFeature;break;
                case 1:_userConscience.userConscienceAccessories.primaryAccessory = resetFeature;break;
                case 2:_userConscience.userConscienceAccessories.bottomAccessory = resetFeature;break;
                case 3:_userConscience.userConscienceAccessories.secondaryAccessory = resetFeature;break;
                case 4:_userConscience.userConscienceBody.eyeName = resetFeature;break;
                case 5:_userConscience.userConscienceBody.symbolName = resetFeature;break;
                case 6:_userConscience.userConscienceBody.mouthName = resetFeature;break;
                case 7:_userConscience.userConscienceBody.eyeColor = resetFeature;break;
                case 8:_userConscience.userConscienceBody.browColor = resetFeature;break;
                case 9:_userConscience.userConscienceBody.bubbleColor = resetFeature;break;
                case 10:_userConscience.userConscienceBody.bubbleType = [resetFeature intValue];break;                    
                default: break;
            }
            
            if ((self.accessorySlot > 3) && (self.accessorySlot < 7)) {
                [ConscienceBuilder buildConscience:_userConscience.userConscienceBody];
                
            }
                        
            [UIView beginAnimations:@"conscienceHide" context:nil];
            [UIView setAnimationDuration:0.25];
            
            [UIView setAnimationBeginsFromCurrentState:YES];
            _userConscience.userConscienceView.alpha = 0;
            _userConscience.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            
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
Implementation: Internal function to retrieve how many ethicals User currently has from userCollection.
 */
-(void)retrieveCurrentFunds{
    
    UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:@"" andModelManager:_modelManager];
    currentUserCollectableDAO.predicates = @[[NSPredicate predicateWithFormat:@"collectableName == %@", MLCollectableEthicals]];
    UserCollectable *currentUserCollectable = [currentUserCollectableDAO read:@""];

    //Increase the moral's value
    int ethicals = [[currentUserCollectable collectableValue] intValue];
    
    currentFunds = ethicals;
    
    
}

/**
Implementation: Commits the ConscienceAsset to persistence framework.
 */
-(void)saveConscience{
	
	//Retrieve User's UserCharacter		
    UserCharacterDAO *currentUserCharacterDAO = [[UserCharacterDAO alloc] initWithKey:@"" andModelManager:_modelManager];
    UserCharacter *currentUserCharacter = [currentUserCharacterDAO read:@""];
        
	//Assign current ConscienceAsset to UserCharacter
	switch (self.accessorySlot) {
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
		case 10:[currentUserCharacter setCharacterBubbleType:@([currentFeature intValue])];break;
		default: break;
	}
    
    /** @todo refactor into ConscienceMind
     */
    float newMood = _userConscience.userConscienceMind.mood + 1;
    float newEnthusiasm = _userConscience.userConscienceMind.enthusiasm + 1;
    
    if (newMood > 90) {
        _userConscience.userConscienceMind.mood = 90.0;
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

    //Setup a transient expression for Conscience in response to entry
    //UserDefault will be picked up by HomeViewController
    [prefs setFloat:(85) forKey:@"transientMind"];
    
    [currentUserCharacter setCharacterMood:@(newMood)];    
    [currentUserCharacter setCharacterEnthusiasm:@(newEnthusiasm)];

    [currentUserCharacterDAO update];
    
}

/**
Implementation: Changes userCollection.  Subtract cost from ethicals and add ConscienceAsset as a collectable.
 */
-(void)processCollection{
        
	//Construct Unique Primary Key from dtstamp to millisecond
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];	
    
	NSString *currentDTS = [dateFormatter stringFromDate:[NSDate date]];
    
    
	//Create a new UserCollectable
	//It has already been determined to not exist in userCollection, no need to test

    UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:@"" andModelManager:_modelManager];
    
    //Create a new moral reward
    UserCollectable *currentUserAssetCollectable = [currentUserCollectableDAO create];
	
    [currentUserAssetCollectable setCollectableCreationDate:[NSDate date]];
	[currentUserAssetCollectable setCollectableKey:[NSString stringWithFormat:@"%@%@", currentDTS, self.assetSelection]];
	[currentUserAssetCollectable setCollectableName:self.assetSelection];
    
	//Check to see if ConscienceAsset has already been collected
	if (!isOwned){
		[_userConscience.conscienceCollection addObject:self.assetSelection];
	}
    
	//Retrieve User's ethicals
    
    //Update User's ethicals
    currentUserCollectableDAO.predicates = @[[NSPredicate predicateWithFormat:@"collectableName == %@", MLCollectableEthicals]];
	UserCollectable *currentUserCollectable = [currentUserCollectableDAO read:@""];
    
	int ethicals = [[currentUserCollectable collectableValue] intValue];
    
	ethicals -= assetCost;

	if (ethicals < 0) {
		ethicals = 0;
	}
    
	//Save User's new ethicals    
	[currentUserCollectable setValue:@(ethicals) forKey:@"collectableValue"];
        
    [currentUserCollectableDAO update];
}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {

    //If ConscienceAsset is already owned, change verbiage of UI
    if (isOwned) {
        [accessoryCostLabel setText:NSLocalizedString(@"ConscienceAcceptCostButtonOwnedLabel",nil)];
        buyButton.accessibilityHint = NSLocalizedString(@"ConscienceAcceptBuyButtonUseHint",nil);
        buyButton.accessibilityLabel = NSLocalizedString(@"ConscienceAcceptBuyButtonUseLabel",nil);
        [buyButton.titleLabel setText:NSLocalizedString(@"ConscienceAcceptBuyButtonUseLabel",nil)];
    } else {
        NSString *assetCostString = [NSString stringWithFormat:@"%d", assetCost];
        NSString *actualAssetCost = [NSString stringWithFormat:@"%@ε", (assetCost < 0) ? @"∞ " : assetCostString];
        [accessoryCostLabel setText:[NSString stringWithFormat:@"Cost: %@", actualAssetCost]];
        buyButton.accessibilityHint = NSLocalizedString(@"ConscienceAcceptBuyButtonBuyHint",nil);
        buyButton.accessibilityLabel = NSLocalizedString(@"ConscienceAcceptBuyButtonBuyLabel",nil);
        [buyButton.titleLabel setText:NSLocalizedString(@"ConscienceAcceptBuyButtonBuyLabel",nil)];
    }

    backButton.accessibilityHint = NSLocalizedString(@"ConscienceAcceptBackButtonHint",nil);
	backButton.accessibilityLabel =  NSLocalizedString(@"ConscienceAcceptBackButtonLabel",nil);    
    
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint",nil);
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",nil);

}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    previousButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end