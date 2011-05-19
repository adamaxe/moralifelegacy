/**
Conscience Interaction dilemma screen.  View for Conscience asking User moral question.

@class DilemmaViewController
@see ConscienceListViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/9/2010
@file
 */

#import <CoreData/CoreData.h>

@class MoraLifeAppDelegate, ConscienceView, ConscienceBody, ConscienceAccessories, ConscienceMind, Dilemma;

@interface DilemmaViewController : UIViewController {

	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */

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

	IBOutlet UILabel *dilemmaTitle;		/**< title of Dilemma */
	IBOutlet UILabel *dilemmaTitleText;		/**< 2nd viewing of title of Dilemma */
	IBOutlet UITextView *dilemmaText;		/**< dilemma presented to User */
	IBOutlet UILabel *dilemmaMoralLabel1;	/**< MoralA associated with dilemma */
	IBOutlet UILabel *dilemmaMoralLabel2;	/**< MoralB associated with dilemma */
	IBOutlet UITextView *choiceText1;		/**< MoralA description */
	IBOutlet UITextView *choiceText2;		/**< MoralB description */
	IBOutlet UIButton *previousButton;		/**< return to previous page in dilemma */
	IBOutlet UIButton *nextButton;		/**< proceed to next page in dilemma */
	IBOutlet UIButton *selectionButton1;	/**< select Moral A */
	IBOutlet UIButton *selectionButton2;	/**< select Moral B */
	
	Dilemma *currentDilemma;			/**< information about the dilemma */

	IBOutlet ConscienceView *antagonistConscienceView;		/**< onscreen Conscience character */
	ConscienceBody *antagonistConscienceBody;				/**< onscreen Conscience body parts */
	ConscienceAccessories *antagonistConscienceAccessories;	/**< onscreen Conscience accessories */
	ConscienceMind *antagonistConscienceMind;				/**< onscreen Conscience mental state */

	NSMutableString *reward1;		/**< reward for choosing ChoiceA */
	NSMutableString *reward2;		/**< reward for choosing ChoiceB */
    
	BOOL isChoiceA;				/**< is ChoiceA selected */
}

/**
Accepts User input to change the presently displayed UIView and possibly commit Choice
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)selectChoice:(id)sender;

/**
Accepts User input to return to ConscienceModalViewController
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)returnToHome:(id)sender;

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