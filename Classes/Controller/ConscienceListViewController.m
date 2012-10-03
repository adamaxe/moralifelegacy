/**
Implementation:  UIViewController lists ConscienceAssets available for purchase.
List determines what is owned, affordable and too expensive.  Selection restrictions and visual cues are applied.
List is searchable by name, asset type, cost and description
User can filter list by only things that are affordable to currentFunds.
 
@class ConscienceListViewController ConscienceListViewController.h
 */

#import "ConscienceListViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "ConscienceView.h"
#import "ConscienceAcceptViewController.h"
#import "ConscienceAsset.h"
#import "UserCollectableDAO.h"
#import "ConscienceHelpViewController.h"
#import "ViewControllerLocalization.h"
#import "ConscienceAssetDAO.h"

@interface ConscienceListViewController () <ViewControllerLocalization> {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
    
	NSMutableArray *searchedData;			/**< array for matched data from User search */
    
	NSMutableArray *choices;			/**< unfiltered list of assets */
	NSMutableArray *choiceIDs;			/**< unfiltered list of asset pkeys */
	NSMutableArray *choiceCosts;			/**< unfiltered list of asset costs */
	NSMutableArray *choiceSubtitles;		/**< unfiltered list of asset descriptions */
	NSMutableArray *choiceImages;			/**< unfiltered list of asset images */
	
	NSMutableArray *dataSource;             /**< array for filtering raw data without having to re-query */
	NSMutableArray *tableData;              /**< array for filtering data displayed in table populated from dataSource */
	NSMutableArray *tableDataImages;		/**< array for filtering data images */
	NSMutableArray *tableDataDetails;		/**< array for filtering data details */
	NSMutableArray *tableDataKeys;          /**< array for filtering data primary keys */
	NSMutableArray *tableDataCosts;         /**< array for filtering item cost */
    
	IBOutlet UITableView *choicesTableView;	/**< tableview of choices */
    IBOutlet UIButton *previousButton;
    
	IBOutlet UIView *thoughtModalArea;			/**< area in which user ConscienceView can float */
	IBOutlet UIButton *fundsButton;			/**< allow User to filter only affordable choices */
	IBOutlet UILabel *listType;			/**< show which view is active */    
	
	IBOutlet UISearchBar *accessorySearchBar;		/**< ui element for limiting choices in table */
    
	int currentFunds;						/**< amount of ethicals possessed */
    BOOL isLessThanCost;					/**< is User requesting to show only affordable options */
    int searchViewFilter;                    /**< which view to show */
}

/**
 Retrieve all available ConscienceAssets
 */
-(void)retrieveAllSelections;

/**
 Retrieve amount of ethicals available to User (money)
 */
-(void)retrieveCurrentFunds;

@end

@implementation ConscienceListViewController

#pragma mark - 
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    
	//Set default filtering to show all ConscienceAssets
	isLessThanCost = FALSE;
    searchViewFilter = 0;

	//appDelegate needed to retrieve CoreData Context, prefs used to save form state
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	prefs = [NSUserDefaults standardUserDefaults];
	context = [appDelegate.moralModelManager readWriteManagedObjectContext];
    
	//Create search bar
	accessorySearchBar.barStyle = UIBarStyleBlack;
	accessorySearchBar.delegate = self;
	accessorySearchBar.showsCancelButton = NO;
	choicesTableView.delegate = self;
	choicesTableView.dataSource = self;
	        
	//Retrieve User's money and all available ConscienceAssets
	[self retrieveCurrentFunds];
	[self retrieveAllSelections];
    
    [listType setText:@"All"];

	//Display available ethicals to User
	[fundsButton setTitle:[NSString stringWithFormat:@"%dε", currentFunds] forState:UIControlStateNormal];
    
    [self localizeUI];    
    
}

-(void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];

	//Add Conscience to lower-left screen
	[thoughtModalArea addSubview:appDelegate.userConscienceView];
	CGPoint centerPoint = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY);
	appDelegate.userConscienceView.center = centerPoint;    
	[UIView beginAnimations:@"MoveConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(kConscienceLargeSizeX, kConscienceLargeSizeY);
//	appDelegate.userConscienceView.center = centerPoint;
    appDelegate.userConscienceView.alpha = 1;
	[UIView commitAnimations];
	
	[appDelegate.userConscienceView setNeedsDisplay];
    
	[choicesTableView reloadData];
	
}


-(void)viewDidAppear:(BOOL)animated {
    
	//Present help screen after a split second
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];
}

#pragma mark - 
#pragma mark UI Interaction

/**
 Implementation: Show an initial help screen if this is the User's first use of the screen.  Set a User Default after help screen is presented.  Launch a ConscienceHelpViewController and populate a localized help message.
 */
-(void)showInitialHelpScreen {
    
    //If this is the first time that the app, then show the intro
    NSObject *firstConscienceListCheck = [prefs objectForKey:@"firstConscienceList"];
    
    if (firstConscienceListCheck == nil) {
        
        ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
        [conscienceHelpViewCont setViewControllerClassName:NSStringFromClass([self class])];        
		[conscienceHelpViewCont setIsConscienceOnScreen:TRUE];
        [conscienceHelpViewCont setHelpVersion:0];
		[self presentModalViewController:conscienceHelpViewCont animated:NO];

        [prefs setBool:FALSE forKey:@"firstConscienceList"];
        
    }
}


/**
Implementation: Cycle between affordable and all Conscience Asset listings.  Change set filter for table data refresh.
 */
-(IBAction)filterByCost:(id)sender{
    
	UISearchBar *blankSearch = [[UISearchBar alloc] init];

	//Cycle button state
	if (isLessThanCost) {
		isLessThanCost = FALSE;
	} else {
		isLessThanCost = TRUE;
	}

    //Change UILabel to reflect what is available in the list
    if (searchViewFilter < 1) {
        [listType setText:@"Owned"];
        searchViewFilter++;
    } else if (searchViewFilter < 2) {
        [listType setText:@"Affordable"];
        searchViewFilter++;
    } else {
        searchViewFilter = 0;
        [listType setText:@"All"];

    }
    
	//Show all entries    
	[self searchBar:blankSearch textDidChange:@" "];            

}

/**
Implementation: Pop UIViewController from stack
 */
-(IBAction)dismissThoughtModal:(id)sender{
    
	//[self dismissModalViewControllerAnimated:NO];
	[self.navigationController popViewControllerAnimated:FALSE];
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
Implementation: Retrieve all available ConscienceAssets, and then populate a working set of data containers upon which to filter.
 */
- (void) retrieveAllSelections{
    
    ConscienceAssetDAO *currentAssetDAO = [[ConscienceAssetDAO alloc] init];
    
    NSMutableArray *predicateArguments = [[NSMutableArray alloc] init];
    
	//Determine which type of ConscienceAsset is requested	
	switch (_accessorySlot) {
		case 0:
			[predicateArguments addObject:@"top"];
			break;
		case 1:
			[predicateArguments addObject:@"primary"];
            [predicateArguments addObject:@"side"];
			break;
		case 2:
			[predicateArguments addObject:@"bottom"];
			break;
		case 3:
			[predicateArguments addObject:@"secondary"];
            [predicateArguments addObject:@"side"];
			break;
		case 4:
			[predicateArguments addObject:@"eye"];
			break;
		case 5:
			[predicateArguments addObject:@"face"];
			break;
		case 6:
			[predicateArguments addObject:@"mouth"];
			break;
		case 7:
			[predicateArguments addObject:@"eyecolor"];
			break;
		case 8:
			[predicateArguments addObject:@"browcolor"];
			break;
		case 9:
			[predicateArguments addObject:@"bubblecolor"];
			break;	
		case 10:
			[predicateArguments addObject:@"bubbletype"];
			break;            
		default:
			break;
	}
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orientationAsset in %@", predicateArguments];

    NSArray *predicateArray = @[predicate];
    
	NSSortDescriptor* sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"shortDescriptionReference" ascending:YES];
	NSSortDescriptor* sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"displayNameReference" ascending:YES];
	NSArray* sortDescriptors = @[sortDescriptor1, sortDescriptor2];
    
	[currentAssetDAO setPredicates:predicateArray];
    [currentAssetDAO setSorts:sortDescriptors];
    
    
    NSArray *assets = [currentAssetDAO readAll];
    int numberOfAssets = [assets count];
    
	//Create raw result sets
	choices = [[NSMutableArray alloc] initWithCapacity:numberOfAssets];
	choiceImages = [[NSMutableArray alloc] initWithCapacity:numberOfAssets];
	choiceSubtitles = [[NSMutableArray alloc] initWithCapacity:numberOfAssets];
	choiceIDs = [[NSMutableArray alloc] initWithCapacity:numberOfAssets];
	choiceCosts = [[NSMutableArray alloc] initWithCapacity:numberOfAssets];
    
    
    for (ConscienceAsset *match in assets){
        
        [choiceIDs addObject:match.nameReference];
        [choices addObject:match.displayNameReference];
        [choiceImages addObject:match.imageNameReference];
        [choiceCosts addObject:match.costAsset];
        
        //Determine if item is already owned, display owned, or cost if unowned
        //@todo localize
        if ([appDelegate.userCollection containsObject:match.nameReference]){
            [choiceSubtitles addObject:[NSString stringWithFormat:@"Owned! - %@", match.shortDescriptionReference]];
        } else {
            [choiceSubtitles addObject:[NSString stringWithFormat:@"%dε - %@", [match.costAsset intValue], match.shortDescriptionReference]];
        }
        
    }
    

	//End CoreData Retrieval
	
	//Populate searchable data sets with raw results
	dataSource = [[NSMutableArray alloc] initWithArray:choices];
	searchedData = [[NSMutableArray alloc]init];
	tableData = [[NSMutableArray alloc]initWithArray:dataSource];
	tableDataImages = [[NSMutableArray alloc]initWithArray:choiceImages];
	tableDataDetails = [[NSMutableArray alloc]initWithArray:choiceSubtitles];
	tableDataKeys = [[NSMutableArray alloc]initWithArray:choiceIDs];
	tableDataCosts = [[NSMutableArray alloc]initWithArray:choiceCosts];

}

/**
Implementation: Retrieve User's current ethicals from UserData
 */
-(void)retrieveCurrentFunds{
    
    UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] init];
    currentUserCollectableDAO.predicates = @[[NSPredicate predicateWithFormat:@"collectableName == %@", kCollectableEthicals]];
    UserCollectable *currentUserCollectable = [currentUserCollectableDAO read:@""];
    
    //Set current ethicals for UIViewController
    currentFunds = [[currentUserCollectable collectableValue] intValue];
        

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
	return [tableData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"accessoryChoices";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
    
	//Get image filename and append icon suffix (for iOS3)
	NSMutableString *rowImageName = [[NSMutableString alloc] initWithString:tableDataImages[indexPath.row]];
    [rowImageName appendString:@"-sm"];
    
    UIImage *rowImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:rowImageName ofType:@"png"]];
    [[cell imageView] setImage:rowImage];
    
	//Determine if User can actually equip ConscienceAsset by testing if enough ethicals are present, or it's already owned
	//Adjust visual cues accordingly
	if(([tableDataCosts[indexPath.row] floatValue] <= currentFunds) || ([tableDataDetails[indexPath.row] rangeOfString:@"Owned"].location != NSNotFound)){
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:176.0/255.0 blue:0.0/255.0 alpha:1];
        
	}else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.detailTextLabel.textColor = [UIColor colorWithRed:200.0/255.0 green:25.0/255.0 blue:2.0/255.0 alpha:1];
	}
    
	//Configure cell text
	[[cell textLabel] setText:tableData[indexPath.row]];
	[[cell textLabel] setFont:[UIFont systemFontOfSize:12.0]];
	[[cell textLabel] setNumberOfLines:1];
	[[cell textLabel] setAdjustsFontSizeToFitWidth:TRUE];

	//Configure cell subtitle text
	[cell.detailTextLabel setText:tableDataDetails[indexPath.row]];
	[cell.detailTextLabel setFont:[UIFont systemFontOfSize:12.0]];
	[cell.detailTextLabel setNumberOfLines:1];
	[cell.detailTextLabel setAdjustsFontSizeToFitWidth:TRUE];
	[cell.detailTextLabel setMinimumFontSize:8.0];    
        	
	return cell;
}


#pragma mark -
#pragma mark UISearchBar delegate methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar’s cancel button while in edit mode
	searchBar.showsCancelButton = YES;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	// flush the previous search content
	//[tableData removeAllObjects];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	searchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	//Remove all data that belongs to previous search
	[tableData removeAllObjects];
	[tableDataImages removeAllObjects];
	[tableDataDetails removeAllObjects];
	[tableDataKeys removeAllObjects];
	[tableDataCosts removeAllObjects];

	//Remove all entries once User starts typing
	if([searchText isEqualToString:@""] || searchText==nil){
		[choicesTableView reloadData];
		return;
	}

	//Flag to indicate ConscienceAsset was found	
	BOOL isFound = FALSE;
  
	//Spin through datasource looking for match on requested search text
	NSInteger counter = 0;
	for(NSString *name in dataSource)
	{
		@autoreleasepool {
        
		//Convert both searches to lowercase and compare search string to name in various elements of data
			NSRange searchRange = [[name lowercaseString] rangeOfString:[searchText lowercaseString]];
			NSRange searchRangeDetails = [[choiceSubtitles[counter] lowercaseString] rangeOfString:[searchText lowercaseString]];
        		
			//A match was found
			if(searchRange.location != NSNotFound)
			{
            isFound = TRUE;
				
			} else if(searchRangeDetails.location != NSNotFound){
            isFound = TRUE;

			} 
              
        //Is User requesting to only see affordable entries
			if (searchViewFilter > 0) {
            
				if (isFound) {
                
                if (searchViewFilter == 1) {
                    if([choiceSubtitles[counter] rangeOfString:@"Owned"].location != NSNotFound){
                        isFound = TRUE;
                    } else {
                        isFound = FALSE;
                    }
                                        
                } else {
                    if((currentFunds >= [choiceCosts[counter] intValue])  || ([choiceSubtitles[counter] rangeOfString:@"Owned"].location != NSNotFound)){
                        isFound = TRUE;
                    } else {
                        isFound = FALSE;
                    }
                    
                }

				}
            
			}

			if (isFound) {
				[tableData addObject:name];
				[tableDataImages addObject:choiceImages[counter]];
				[tableDataDetails addObject:choiceSubtitles[counter]];
				[tableDataKeys addObject:choiceIDs[counter]];
				[tableDataCosts addObject:choiceCosts[counter]];
			}
			
			isFound = FALSE;
			counter++;
		}
	}
	
	[choicesTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isLessThanCost = FALSE;
    searchViewFilter = 0;
    
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
	[tableData removeAllObjects];
	[tableDataImages removeAllObjects];
	[tableDataDetails removeAllObjects];
	[tableDataKeys removeAllObjects];
	[tableDataCosts removeAllObjects];
    
	[tableData addObjectsFromArray:dataSource];
	[tableDataImages addObjectsFromArray:choiceImages];
	[tableDataDetails addObjectsFromArray:choiceSubtitles];
	[tableDataKeys addObjectsFromArray:choiceIDs];
	[tableDataCosts addObjectsFromArray:choiceCosts];	
    
	@try{
		[choicesTableView reloadData];
	}
	@catch(NSException *e){
	}
	[searchBar resignFirstResponder];
	searchBar.text = @"";
}


// called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	//Create next view to accept, review or reject purchase	
	ConscienceAcceptViewController *conscienceAcceptCont = [[ConscienceAcceptViewController alloc] init];
                
	NSMutableString *selectedRow = [NSMutableString stringWithString:tableDataKeys[indexPath.row]];

	//Alert following ConscienceAcceptViewController to type and key of requested ConscienceAsset
	[conscienceAcceptCont setAssetSelection:selectedRow];
	[conscienceAcceptCont setAccessorySlot:_accessorySlot];
		
	[self.navigationController pushViewController:conscienceAcceptCont animated:NO];
        
}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint", @"Hint for previous button");
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",@"Label for previous button");
        
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    previousButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
	choices = nil;
	choiceImages = nil;
	choiceImages = nil;
	choiceSubtitles = nil;	
	choiceCosts = nil;
}

@end