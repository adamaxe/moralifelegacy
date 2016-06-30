/**
Implementation:  UIViewController lists ConscienceAssets available for purchase.
List determines what is owned, affordable and too expensive.  Selection restrictions and visual cues are applied.
List is searchable by name, asset type, cost and description
User can filter list by only things that are affordable to currentFunds.
 
@class ConscienceListViewController ConscienceListViewController.h
 */

#import "ConscienceListViewController.h"
#import "ConscienceAcceptViewController.h"
#import "UserCollectableDAO.h"
#import "ConscienceAssetDAO.h"
#import "AccessoryTableViewCell.h"
#import "UIColor+Utility.h"

@interface ConscienceListViewController () <ViewControllerLocalization> {
    
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */

	IBOutlet UITableView *choicesTableView;	/**< tableview of choices */
    IBOutlet UIButton *previousButton;
    IBOutlet UIView *searchArea;			/**< area in which search bubble appears */
	IBOutlet UIView *thoughtModalArea;			/**< area in which user ConscienceView can float */
	IBOutlet UIButton *fundsButton;			/**< allow User to filter only affordable choices */
	IBOutlet UILabel *listType;			/**< show which view is active */

	IBOutlet UISearchBar *accessorySearchBar;		/**< ui element for limiting choices in table */

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


	int currentFunds;						/**< amount of ethicals possessed */
    BOOL isLessThanCost;					/**< is User requesting to show only affordable options */
    int searchViewFilter;                    /**< which view to show */
}

@property (nonatomic) IBOutlet UIImageView *previousScreen;

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

    self.previousScreen.image = _screenshot;
    accessorySearchBar.placeholder = NSLocalizedString(@"SearchBarPlaceholderText", nil);

	//Set default filtering to show all ConscienceAssets
	isLessThanCost = FALSE;
    searchViewFilter = 0;

	prefs = [NSUserDefaults standardUserDefaults];
    
	//Create search bar
	accessorySearchBar.barStyle = UIBarStyleBlack;
	accessorySearchBar.delegate = self;
	accessorySearchBar.showsCancelButton = NO;
	choicesTableView.delegate = self;
	choicesTableView.dataSource = self;
	        
	//Retrieve User's money and all available ConscienceAssets
	[self retrieveCurrentFunds];
	[self retrieveAllSelections];
    
    listType.text = @"All";

	//Display available ethicals to User
	[fundsButton setTitle:[NSString stringWithFormat:@"%dε", currentFunds] forState:UIControlStateNormal];
    
    [self localizeUI];    
    
}

-(void) viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];

    [fundsButton setTitleColor:[UIColor moraLifeChoiceGreen] forState:UIControlStateNormal];
	//Add Conscience to lower-left screen
	[thoughtModalArea addSubview:_userConscience.userConscienceView];
	CGPoint centerPoint = CGPointMake(MLConscienceLowerLeftX, MLConscienceLowerLeftY);
	_userConscience.userConscienceView.center = centerPoint;    
	[UIView beginAnimations:@"MoveConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	_userConscience.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(MLConscienceLargeSizeX, MLConscienceLargeSizeY);
    _userConscience.userConscienceView.alpha = 1;
	[UIView commitAnimations];
	
	[_userConscience.userConscienceView setNeedsDisplay];
    
	[choicesTableView reloadData];

    choicesTableView.contentInset = UIEdgeInsetsMake(15.0, 0.0, 0.0, 0.0);
    accessorySearchBar.frame = CGRectMake(0, 0, searchArea.frame.size.width, searchArea.frame.size.height);
	
}


-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
	//Present help screen after a split second
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];
}

-(void)setScreenshot:(UIImage *)screenshot {
    if (_screenshot != screenshot) {
        _screenshot = screenshot;
        self.previousScreen.image = screenshot;
    }
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

        ConscienceHelpViewController *conscienceHelpViewController = [[ConscienceHelpViewController alloc] initWithConscience:_userConscience];
        conscienceHelpViewController.viewControllerClassName = NSStringFromClass([self class]);
		conscienceHelpViewController.isConscienceOnScreen = TRUE;
        conscienceHelpViewController.numberOfScreens = 1;
        conscienceHelpViewController.screenshot = [self prepareScreenForScreenshot];
		[self presentModalViewController:conscienceHelpViewController animated:NO];

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
        listType.text = @"Owned";
        searchViewFilter++;
    } else if (searchViewFilter < 2) {
        listType.text = @"Affordable";
        searchViewFilter++;
    } else {
        searchViewFilter = 0;
        listType.text = @"All";

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
 Implementation: Signals User desire to return to ConscienceViewController
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
    
    ConscienceAssetDAO *currentAssetDAO = [[ConscienceAssetDAO alloc] initWithKey:@"" andModelManager:_modelManager];
    
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
    
	currentAssetDAO.predicates = predicateArray;
    currentAssetDAO.sorts = sortDescriptors;
    
    
    NSArray *assets = [currentAssetDAO readAll];
    int numberOfAssets = assets.count;
    
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
        if ([_userConscience.conscienceCollection containsObject:match.nameReference]){
            [choiceSubtitles addObject:[NSString stringWithFormat:@"Owned! - %@", match.shortDescriptionReference]];
        } else {
            NSString *assetCost = [NSString stringWithFormat:@"%@ε", ((match.costAsset).intValue < 0) ? @"∞ " : match.costAsset];
            [choiceSubtitles addObject:[NSString stringWithFormat:@"%@ - %@", assetCost, match.shortDescriptionReference]];
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
    
    UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:@"" andModelManager:_modelManager];
    currentUserCollectableDAO.predicates = @[[NSPredicate predicateWithFormat:@"collectableName == %@", MLCollectableEthicals]];
    UserCollectable *currentUserCollectable = [currentUserCollectableDAO read:@""];
    
    //Set current ethicals for UIViewController
    currentFunds = currentUserCollectable.collectableValue.intValue;
        

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
	return tableData.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	AccessoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccessoryTableViewCell class])];

	if (cell == nil) {
      	cell = [[AccessoryTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([AccessoryTableViewCell class])];
	}
    
	//Get image filename and append icon suffix (for iOS3)
	NSMutableString *rowImageName = [[NSMutableString alloc] initWithString:tableDataImages[indexPath.row]];
    [rowImageName appendString:@"-sm"];
    
    UIImage *rowImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:rowImageName ofType:@"png"]];
    cell.accessoryImage = rowImage;
    
	//Determine if User can actually equip ConscienceAsset by testing if enough ethicals are present, or it's already owned
	//Adjust visual cues accordingly
    float cellCost = [tableDataCosts[indexPath.row] floatValue];
    BOOL isAvailableForPurchase = (cellCost <= currentFunds) && (cellCost > 0);
    cell.isAffordable = (isAvailableForPurchase || ([tableDataDetails[indexPath.row] rangeOfString:@"Owned"].location != NSNotFound));

	cell.textLabel.text = tableData[indexPath.row];
	cell.detailTextLabel.text = tableDataDetails[indexPath.row];

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
			NSRange searchRange = [name.lowercaseString rangeOfString:searchText.lowercaseString];
			NSRange searchRangeDetails = [[choiceSubtitles[counter] lowercaseString] rangeOfString:searchText.lowercaseString];
        		
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
	ConscienceAcceptViewController *conscienceAcceptController = [[ConscienceAcceptViewController alloc] initWithModelManager:_modelManager andConscience:_userConscience];
                
	NSMutableString *selectedRow = [NSMutableString stringWithString:tableDataKeys[indexPath.row]];

	//Alert following ConscienceAcceptViewController to type and key of requested ConscienceAsset
	conscienceAcceptController.assetSelection = selectedRow;
	conscienceAcceptController.accessorySlot = _accessorySlot;

    [UIView animateWithDuration:0.5 animations:^{
        _userConscience.userConscienceView.alpha = 0;
    }completion:^(BOOL finished) {

        conscienceAcceptController.screenshot = [self prepareScreenForScreenshot];
        [self.navigationController pushViewController:conscienceAcceptController animated:NO];
    }];
        
}

#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint",nil);
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",nil);
        
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

@end
