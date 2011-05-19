/**
Deck of Cards screen.  

Secondary screen for selecting morality/asset cards.
 
@class ConscienceDeckViewController
@see ConscienceListViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/30/2010
@file
 */

@interface ConscienceDeckViewController : UIViewController {
	
	NSArray *cardStates;			/**< store selected state of card */
	
	IBOutlet UIView *deckView;		/**< ui of deck of cards */
	
	//Card buttons
	IBOutlet UIButton *card1Button;	
	IBOutlet UIButton *card2Button;
	IBOutlet UIButton *card3Button;	
	IBOutlet UIButton *card4Button;
	IBOutlet UIButton *card5Button;	
	IBOutlet UIButton *card6Button;
	
	//Moral labels on cards
	IBOutlet UILabel *card1MoralLabel;
	IBOutlet UILabel *card2MoralLabel;
	IBOutlet UILabel *card3MoralLabel;
	IBOutlet UILabel *card4MoralLabel;
	IBOutlet UILabel *card5MoralLabel;
	IBOutlet UILabel *card6MoralLabel;
	
	//Current Moral scores on cards
	IBOutlet UILabel *card1MoralScore;
	IBOutlet UILabel *card2MoralScore;
	IBOutlet UILabel *card3MoralScore;
	IBOutlet UILabel *card4MoralScore;
	IBOutlet UILabel *card5MoralScore;
	IBOutlet UILabel *card6MoralScore;
	
	//Moral images on cards
	IBOutlet UIImageView *card1MoralImage;
	IBOutlet UIImageView *card2MoralImage;
	IBOutlet UIImageView *card3MoralImage;
	IBOutlet UIImageView *card4MoralImage;
	IBOutlet UIImageView *card5MoralImage;
	IBOutlet UIImageView *card6MoralImage;

	//Card tops designating selection status
	IBOutlet UIImageView *card1CardTop;
	IBOutlet UIImageView *card2CardTop;
	IBOutlet UIImageView *card3CardTop;
	IBOutlet UIImageView *card4CardTop;
	IBOutlet UIImageView *card5CardTop;
	IBOutlet UIImageView *card6CardTop;
	
}

/**
Accept User input to flip card from selected to deselected state
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)cardToggle:(id)sender;

/**
Dismiss entire UIViewController
 */
-(void)dismissThoughtModal:(id)sender;

@end
