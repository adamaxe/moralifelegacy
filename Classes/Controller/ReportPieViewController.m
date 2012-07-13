/**
Implementation:  Present a GraphView of piechart type with accompanying data descriptors.
 
@class ReportPieViewController ReportPieViewController.h
 */

#import "ReportPieViewController.h"
#import "GraphView.h"
#import "UserChoiceDAO.h"
#import "MoralDAO.h"
#import "ConscienceView.h"
#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "ConscienceHelpViewController.h"
#import "ViewControllerLocalization.h"

@interface ReportPieViewController () <ViewControllerLocalization> {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
    
	NSMutableDictionary *reportValues;		/**< */
	NSMutableDictionary *moralDisplayNames;	/**< names to be displayed on list */
	NSMutableDictionary *moralImageNames;	/**< image file names for Moral */
	NSMutableDictionary *moralColors;		/**< text color associated with Moral */
    
	NSString *reportName;				/**< label for name of the report */
	float runningTotal;				/**< total of Moral Weight for calculation purposes */
	IBOutlet UIView *thoughtModalArea;
    
	NSMutableArray *pieColors;		/**< all Moral colors in order */
	NSMutableArray *pieValues;		/**< all degrees of circle in order */
	NSMutableArray *reportNames;		
	NSMutableArray *moralNames;
    
	BOOL isGood;		/**< is current view for Virtues or Vices */
	BOOL isAscending;		/**< current order type */
	BOOL isAlphabetical;	/**< current sort type */
	
	IBOutlet UIImageView *moralType;		/**< image to depict current status of view (Virtue/Vice) */
	IBOutlet UIButton *moralTypeButton;		/**< button to switch between Virtue/Vice */
	IBOutlet UIButton *moralSortButton;		/**< button to toggle sort type (Name/Weight) */
	IBOutlet UIButton *moralOrderButton;		/**< button to toggle order type (Asc/Des) */
    IBOutlet UIButton *previousButton;
	IBOutlet UITableView *reportTableView;	/**< table to house results */
    IBOutlet UILabel *moralTypeLabel;       /**< is report virtue or vice */
}

/**
 Retrieve all User entered Morals
 */
- (void) retrieveChoices;
//- (void) generatePieColors;

/**
 Convert UserData into graphable data, create a GraphView
 */
- (void) generateGraph;

@end

@implementation ReportPieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //appDelegate needed to retrieve CoreData Context, prefs used to save form state
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	context = [appDelegate.moralModelManager readWriteManagedObjectContext];
	prefs = [NSUserDefaults standardUserDefaults];
        
    isGood = TRUE;
    isAlphabetical = FALSE;
    isAscending = FALSE;
            
    reportValues = [[NSMutableDictionary alloc] init];
    moralDisplayNames = [[NSMutableDictionary alloc] init];
    moralImageNames = [[NSMutableDictionary alloc] init];
    moralColors = [[NSMutableDictionary alloc] init];
    pieValues = [[NSMutableArray alloc] init];
    pieColors = [[NSMutableArray alloc] init];
    reportNames = [[NSMutableArray alloc] init];
    moralNames = [[NSMutableArray alloc] init];
    
    [self generateGraph];
    
    [self localizeUI];    

}

-(void)viewDidAppear:(BOOL)animated {
    
	//Present help screen after a split second
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    //Position Conscience in lower-left of screen
    CGPoint centerPoint = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY);

    //Add User Conscience to view
    [self.view addSubview:appDelegate.userConscienceView];
    
    appDelegate.userConscienceView.center = centerPoint;

    
}

#pragma mark -
#pragma mark UI Interaction

/**
 Implementation: Show an initial help screen if this is the User's first use of the screen.  Set a User Default after help screen is presented.  Launch a ConscienceHelpViewController and populate a localized help message.
 */
-(void)showInitialHelpScreen {
    
    //If this is the first time that the app, then show the intro
    NSObject *firstPieCheck = [prefs objectForKey:@"firstPie"];
    
    if (firstPieCheck == nil) {
        
        ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
        [conscienceHelpViewCont setViewControllerClassName:NSStringFromClass([self class])];        
		[conscienceHelpViewCont setIsConscienceOnScreen:TRUE];
        [conscienceHelpViewCont setHelpVersion:0];
		[self presentModalViewController:conscienceHelpViewCont animated:NO];
		[conscienceHelpViewCont release];
        
        [prefs setBool:FALSE forKey:@"firstPie"];
        
    }
}


/**
Implementation: Based upon User input, set flags for Moral type (Virtue/Vice), Sort Type (Name/Percentage) and Order Type (Asc/Des)
 */
-(IBAction)switchGraph:(id) sender{

	//Set boolean to determine which version of screen to present
	if ([sender isKindOfClass:[UIButton class]]) {
		
        UIButton *senderButton = sender;
		int choiceIndex = senderButton.tag;
        
        switch (choiceIndex) {
            case 0:{    
                if (isGood) {
                    isGood = FALSE;
                    [moralType setImage:[UIImage imageNamed:@"acc-pri-weapon-trident-sm.png"]];
                    [moralTypeLabel setText:@"Vice"];
                } else {
                    isGood = TRUE;
                    [moralType setImage:[UIImage imageNamed:@"acc-top-halo-sm.png"]];
                    [moralTypeLabel setText:@"Virtue"];                
                }
            } break;
            case 1:{    
                if (isAlphabetical) {
                    isAlphabetical = FALSE;
                    [moralSortButton setTitle:@"%" forState: UIControlStateNormal];
                } else {
                    isAlphabetical = TRUE;
                    [moralSortButton setTitle:@"A" forState: UIControlStateNormal];
                }
            }
                break;
            case 2:{    
                if (isAscending) {
                    isAscending = FALSE;
                    [moralOrderButton setTitle:@"Des" forState: UIControlStateNormal];
                } else {
                    isAscending = TRUE;
                    [moralOrderButton setTitle:@"Asc" forState: UIControlStateNormal];
                    
                }
            }
                break;                 
            default:
                break;
        }

        [self generateGraph];
    
    }
}

/**
Implementation: Pop UIViewController from navigation stack
 */
-(IBAction)returnToHome:(id) sender{
	
	[self.navigationController popViewControllerAnimated:NO];
	
}

#pragma mark -
#pragma mark Data Manipulation

/**
Implementation: Retrieve all UserChoice entries, retrieve Morals for each, build color for each Moral
 */
- (void) retrieveChoices{
	
	//Reset data    
 	[reportValues removeAllObjects];
	[moralDisplayNames removeAllObjects];
	[moralImageNames removeAllObjects];
	[pieColors removeAllObjects];
	[pieValues removeAllObjects];
	[reportNames removeAllObjects];
	[moralNames removeAllObjects];
    
    UserChoiceDAO *currentUserChoiceDAO = [[UserChoiceDAO alloc] initWithKey:@""];
    
	//Retrieve virtue or vice
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"entryIsGood == %@", [NSNumber numberWithBool:isGood]];
	currentUserChoiceDAO.predicates = [NSArray arrayWithObject:pred];
	
	NSArray *objects = [currentUserChoiceDAO readAll];
    
	if ([objects count] > 0) {
        
		float currentValue = 0.0;
        
		//Iterate through every UserChoice combining each entry
		for (UserChoice *match in objects){
            
			NSNumber *choiceWeightTemp = [reportValues objectForKey:[match choiceMoral]];
      
			//See if a Choice has already been entered for particular Moral      
            	if (choiceWeightTemp != nil) {
            	   	currentValue = [choiceWeightTemp floatValue];
            	} else {
	                	currentValue = 0.0;
            	}
//            	currentValue = [[reportValues objectForKey:[match choiceMoral]] floatValue];

			//Keep running of absolute value of Morals for percentage calculation
			//Vices are stored as negative
	            runningTotal += fabsf([[match choiceWeight] floatValue]);
      	      currentValue += fabsf([[match choiceWeight] floatValue]);

	            [reportValues setValue:[NSNumber numberWithFloat:currentValue] forKey:[match choiceMoral]];

            NSString *value = [match choiceMoral];            
            MoralDAO *currentMoralDAO = [[MoralDAO alloc] initWithKey:value];
            Moral *currentMoral = [currentMoralDAO read:@""];
            
            NSString *moralDisplayName = [[NSString alloc] initWithString:currentMoral.displayNameMoral];
            NSString *moralName = [[NSString alloc] initWithString:value];
            NSString *moralImageName = [[NSString alloc] initWithString:currentMoral.imageNameMoral];
            NSString *moralColor = [[NSString alloc] initWithString:currentMoral.colorMoral];            
            
            [currentMoralDAO release];
            
            //Moral color stored as hex, must convert to CGColorRef
            NSScanner *fillColorScanner = [[NSScanner alloc] initWithString:moralColor];
            
            unsigned fillColorInt;
            
            [fillColorScanner scanHexInt:&fillColorInt]; 
            
            //Bitshift each position to get 1-255 value
            //Divide value by 255 to get CGColorRef compatible value
            CGFloat red   = ((fillColorInt & 0xFF0000) >> 16) / 255.0f;
            CGFloat green = ((fillColorInt & 0x00FF00) >>  8) / 255.0f;
            CGFloat blue  =  (fillColorInt & 0x0000FF) / 255.0f;
            
            UIColor *moralColorTemp = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0];
            
            [moralDisplayNames setValue:moralDisplayName forKey:moralName];
            [moralImageNames setValue:moralImageName forKey:moralName];
            [moralColors setValue:moralColorTemp forKey:moralName];
            
            [moralColorTemp release];
            [fillColorScanner release];
            
            [moralDisplayName release];
            [moralName release];
            [moralImageName release];
            [moralColor release];

	        }
		
	}
	
	[currentUserChoiceDAO release];
	
}

/**
Implementation:  Transform UserData entries of all Virtues/Vices into summation of weights for each Moral.
Sum each summation of Moral into total of Virtue/Vice, then calculate percentage of each entry as percentage of whole
Convert percentage to degrees out of 360.  Send values and colors to GraphView
@todo needs to be optimized.  Don't generate sorted and reversed keys without need.  Check for empty first.
 */
- (void) generateGraph {
	//Reset running total before getting Choices
	runningTotal = 0.0;
    
	//Get all choices
	[self retrieveChoices];
	    
	float moralPercentage = 0.0;
    
	//Create raw, sorted and reversed versions of the keys for sorting/ordering options
	NSArray *reportKeys = [reportValues allKeys];
	NSArray *sortedPercentages = [reportValues keysSortedByValueUsingSelector:@selector(compare:)];
	NSArray* reversedPercentages = [[sortedPercentages reverseObjectEnumerator] allObjects];

	NSArray *sortedKeys = [reportKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	NSArray *reversedKeys = [[sortedKeys reverseObjectEnumerator] allObjects];

	NSArray *iteratorArray;
    
	//Determine sorting and ordering
	if (isAlphabetical) {
        
		if (isAscending) {
	            iteratorArray = reversedKeys;
      	} else {
			iteratorArray = sortedKeys;
		}
	} else {
		if (isAscending) {
            	iteratorArray = sortedPercentages;
      	} else {
	            iteratorArray = reversedPercentages;
		}
	}
    
	//Iterate through every User selection
	for (NSString *moralInstance in iteratorArray) {

		//Determine percentage of each entry in regards to every entry
      	moralPercentage = ([[reportValues valueForKey:moralInstance] floatValue]/runningTotal);

		//Convert percentage to degrees
		[pieValues addObject:[NSNumber numberWithFloat:(moralPercentage * 360)]];

		//Add report names for relation to table
		[reportNames addObject:[NSString stringWithFormat:@"%@: %.2f%%", [moralDisplayNames objectForKey:moralInstance], moralPercentage * 100]];
        
		[pieColors addObject:[moralColors objectForKey:moralInstance]];

		//Don't add Moral if it already exists in the display list        
		if (![moralNames containsObject:moralInstance]) {
			[moralNames addObject:moralInstance];
		}

	}
    
	//Account for no User entries
	if ([iteratorArray count] == 0) {

		if (isGood) {
			[reportNames addObject:@"No Moral Entries!"];
		} else {
			[reportNames addObject:@"No Immoral Entries!"];
		}
        
		[pieColors addObject:[UIColor redColor]];
	}
    

	//Create blank pie chart
	GraphView *graph = [[GraphView alloc] initWithFrame:CGRectMake(0.0, 0.0, 240, 240)];

	//Populate Graph with entries    
	[graph setPieValues:pieValues];
	[graph setPieColors:pieColors];

	//Add new graph to view
	[thoughtModalArea addSubview:graph];
	[graph release];
    
	//Refresh tableview with new data
	[reportTableView reloadData];

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [reportNames count];

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *cellIdentifier = @"Reports";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
		
    }
	
	[[cell textLabel] setText:[reportNames objectAtIndex:indexPath.row]];
    
    [[cell textLabel] setTextColor:[pieColors objectAtIndex:indexPath.row]];
    [[cell textLabel] setShadowColor:[UIColor lightGrayColor]];
    [[cell textLabel] setShadowOffset:CGSizeMake(1, 1)];

    [[cell textLabel] setFont:[UIFont systemFontOfSize:18.0]];
    [[cell textLabel] setNumberOfLines:1];
    [[cell textLabel] setAdjustsFontSizeToFitWidth:TRUE];
    
    if ([moralNames count] > 0) {
        
        NSMutableString *rowImageName = [[NSMutableString alloc] initWithString:[moralImageNames objectForKey:[moralNames objectAtIndex:indexPath.row]]];
        [rowImageName appendString:@".png"];
        [[cell imageView] setImage:[UIImage imageNamed:rowImageName]];
        [rowImageName release];
        
    } else {
        [[cell imageView] setImage:[UIImage imageNamed:@"card-doubt.png"]];
        [[cell textLabel] setTextAlignment:UITextAlignmentCenter];

    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
    return cell;
}


#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    
    NSString *titleName =[[NSString alloc] initWithFormat:@"%@",NSStringFromClass([self class])];
    
    [self setTitle:NSLocalizedString(([NSString stringWithFormat:@"%@%dTitle", titleName, isGood]), @"Title For View Controller")];
    [moralTypeLabel setText:@"Virtue"];                
    [titleName release];
    
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint", @"Hint for previous button");
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",@"Label for previous button");
    
    moralTypeButton.accessibilityHint = NSLocalizedString(@"ReportScreenMoralTypeButtonHint", @"Hint for moralTypeButton");
	moralTypeButton.accessibilityLabel =  NSLocalizedString(@"ReportScreenMoralTypeButtonLabel",@"Label for moralTypeButton");

    moralSortButton.accessibilityHint = NSLocalizedString(@"ReportScreenMoralSortButtonHint", @"Hint for moralSortButton");
	moralSortButton.accessibilityLabel =  NSLocalizedString(@"ReportScreenMoralSortButtonLabel",@"Label for moralSortButton");

    moralOrderButton.accessibilityHint = NSLocalizedString(@"ReportScreenMoralOrderButtonHint", @"Hint for moralOrderButton");
	moralOrderButton.accessibilityLabel =  NSLocalizedString(@"ReportScreenMoralOrderButtonLabel",@"Label for moralOrderButton");
    
}


#pragma mark -
#pragma mark Memory Management

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

    [reportValues release];
    [moralDisplayNames release];
    [moralImageNames release];
    [moralColors release];
    [pieColors release];
    [pieValues release];
    [reportNames release];
    [moralNames release];
    
    [previousButton release];
    [super dealloc];


}


@end
