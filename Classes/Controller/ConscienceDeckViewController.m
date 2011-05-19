/**
Implementation: List cardviews of UserCollectable.  Allows User to select a selection of cards for use.
 
@class ConscienceDeckViewController ConscienceDeckViewController.h
 */

#import "ConscienceDeckViewController.h"

@implementation ConscienceDeckViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
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


- (void)dealloc {
    [super dealloc];
}


@end
