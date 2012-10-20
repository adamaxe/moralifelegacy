/**
Implementation: List cardviews of UserCollectable.  Allows User to select a selection of cards for use.
 
@class ConscienceDeckViewController ConscienceDeckViewController.h
 */

#import "ConscienceDeckViewController.h"

/**
 Tag Numbers for webViews in order to reference them
 */
typedef enum {
	kDeckCard1ButtonTag = 3024,
	kDeckCard2ButtonTag = 3025,
	kDeckCard3ButtonTag = 3026,
	kDeckCard4ButtonTag = 3027,
	kDeckCard5ButtonTag = 3028,
	kDeckCard6ButtonTag = 3029
} deckCard;

@interface ConscienceDeckViewController () {
	
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
 Dismiss entire UIViewController
 */
-(void)dismissThoughtModal:(id)sender;

@end

@implementation ConscienceDeckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//[cardStates initWithObjects:<#(id)firstObj#>

	[card1MoralImage setImage:[UIImage imageNamed:@"card-compassion.png"]];
	[card1MoralLabel setText:@"Compassion"];
	[card1MoralScore setText:@"15"];
	[card2MoralImage setImage:[UIImage imageNamed:@"card-honesty.png"]];
	[card2MoralLabel setText:@"Honesty"];
	[card2MoralScore setText:@"25"];
	[card3MoralImage setImage:[UIImage imageNamed:@"card-fellowship.png"]];
	[card3MoralLabel setText:@"Fellowship"];
	[card3MoralScore setText:@"15"];
	[card4MoralImage setImage:[UIImage imageNamed:@"card-charity.png"]];
	[card4MoralLabel setText:@"Charity"];
	[card4MoralScore setText:@"25"];
	[card5MoralImage setImage:[UIImage imageNamed:@"card-justice.png"]];
	[card5MoralLabel setText:@"Justice"];
	[card5MoralScore setText:@"5"];
	[card6MoralImage setImage:[UIImage imageNamed:@"card-patience.png"]];
	[card6MoralLabel setText:@"Patience"];
	[card6MoralScore setText:@"26"];

}


#pragma mark -
#pragma mark UI Interaction

/**
Implementation: Pop UIViewController from stack
 */
-(void)dismissThoughtModal:(id)sender{
	
	[self.navigationController popViewControllerAnimated:NO];	
	
}

/**
Implementation: Determine if card is selected or not, then flip it to opposite state 
 */
-(IBAction)cardToggle:(id)sender{
	
	//Move the text in the button to mimic the decrease in height
	if ([sender isKindOfClass:[UIButton class]]) {
		UIButton *mlButton = sender;
				
		UIImageView *cardTopSelected = (UIImageView *)[deckView viewWithTag:mlButton.tag - 1000];
		[cardTopSelected setImage:[UIImage imageNamed:@"cardtop-user.png"]];
		/*
		if (mlButton.tag == kDeckCard1ButtonTag) {
			[card1MoralImage setImage:[UIImage imageNamed:@"card-compassion.png"]];
			[card1MoralLabel setText:@"CompassionPushed"];
			[card1MoralScore setText:@"45"];			
		}
		*/
		
		
	}

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
