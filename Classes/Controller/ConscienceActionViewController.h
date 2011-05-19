/**
Conscience Interaction action screen.  View controller for Consciences interacting with each other.

Last screen in Conscience Interaction Workflow.  Allows the User to take a request from antagonist and fulfill it.

@class ConscienceActionViewController
@see ConscienceListViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/9/2010
@file
 */

#import <CoreData/CoreData.h>

//@class MoraLifeAppDelegate, ConscienceView, ConscienceBody, ConscienceAccessories, ConscienceMind, Dilemma;
@class MoraLifeAppDelegate, Dilemma;

@interface ConscienceActionViewController : UIViewController {

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
	
//	IBOutlet ConscienceView *antagonistConscienceView;		/**< onscreen Conscience character */
//	ConscienceBody *antagonistConscienceBody;				/**< onscreen Conscience body parts */
//	ConscienceAccessories *antagonistConscienceAccessories;	/**< onscreen Conscience accessories */
//	ConscienceMind *antagonistConscienceMind;				/**< onscreen Conscience mental state */
    
	/** @todo rename into logical names */
	NSMutableString *reward1;						/**< request for current dilemma */
	NSMutableString *reward2;    						/**< reward for answering choice */
	NSString *actionKey;							/**< pkey for choice entry into Core Data */
}

/**
Accepts User input to change the presently displayed UIView and possibly commit Choice

@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)selectChoice:(id)sender;

/**
Accepts User input to return to ConscienceModalViewController
 */
-(IBAction)returnToHome:(id)sender;

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