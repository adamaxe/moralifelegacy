/**
Implementation:  Allow User to progress through story and build moral profile.
Prevent User from selecting Dilemmas/Action out of order.  Present selected choices.

@class DilemmaListViewController DilemmaListViewController.h
 */

#import "DilemmaListViewController.h"
#import "DilemmaViewController.h"
#import "DilemmaListModel.h"
#import "DilemmaTableViewCell.h"

@interface DilemmaListViewController () {
    
	NSUserDefaults *prefs;                  /**< serialized user settings/state retention */
	
	IBOutlet UITableView *dilemmaListTableView;  	/**< table referenced by IB */
    
	NSMutableArray *dataSource;				/**< array for storing of Choices populated from previous view*/
	NSMutableArray *tableData;				/**< array for stored data displayed in table populated from dataSource */
	NSMutableArray *tableDataImages;		/**< array for stored data images */
	NSMutableArray *tableDataDetails;		/**< array for stored data details */
	NSMutableArray *tableDataKeys;			/**< array for stored data primary keys */
    NSMutableArray *tableDataTypes;			/**< array for stored data primary keys */
    
	NSMutableArray *searchedData;			/**< array for matched data from User search */
    
	NSDictionary *userChoices;              /**< dictionary to hold Dilemmas already completed by User */
	NSDictionary *moralNames;		/**< dictionary to hold names of selected Morals */
    
    IBOutlet UIButton *previousButton;
	IBOutlet UISearchBar *dilemmaSearchBar;	/**< ui element for limiting choices in table */
	
	IBOutlet UIView *thoughtModalArea;
    int dilemmaCampaign;                    /**< current campaign to select correct dilemmas */
    
}

@property (nonatomic, strong) DilemmaListModel *dilemmaModel;   /**< Model to handle data/business logic */
@property (nonatomic) IBOutlet UIImageView *previousScreen;


/**
 Load Dilemma data from Core Data for table
 */
- (void) retrieveAllDilemmas;

/**
 Remove entries from tableview that don't correspond to being searched
 */
- (void)filterResults:(NSString *) searchText;


@end

@implementation DilemmaListViewController

#pragma mark -
#pragma mark View lifecycle

- (id)initWithModel:(DilemmaListModel *) dilemmaModel modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience {
    self = [super initWithModelManager:modelManager andConscience:userConscience];

    if (self) {
        self.dilemmaModel = dilemmaModel;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.previousScreen.image = self.screenshot;
    dilemmaSearchBar.placeholder = NSLocalizedString(@"SearchBarPlaceholderText", nil);

	prefs = [NSUserDefaults standardUserDefaults];
    
	//Setup permanent holders, table does not key on these, it keys on tabledata which is affected by searchbar
	//tabledatas are reloaded from these master arrays
	userChoices = [[NSDictionary alloc] init];
	moralNames = [[NSDictionary alloc] init];

    
	//Setup search bar information
	//Table actually pulls from these dynamically built arrays
	dilemmaSearchBar.barStyle = UIBarStyleBlack;
	dilemmaSearchBar.delegate = self;
	dilemmaListTableView.delegate = self;
	dilemmaListTableView.dataSource = self;
	
	dataSource = [[NSMutableArray alloc] init];
	searchedData = [[NSMutableArray alloc] init];
	tableData = [[NSMutableArray alloc] init];
	tableDataImages = [[NSMutableArray alloc] init];
	tableDataDetails = [[NSMutableArray alloc] init];
	tableDataKeys = [[NSMutableArray alloc] init];
	tableDataTypes = [[NSMutableArray alloc] init];
    
    [self localizeUI];

}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    
	[self retrieveAllDilemmas];
    
	//User may be returning from DilemmaView and will expect search filtered list
	NSString *searchString = [prefs objectForKey:@"searchTextDilemma"];	
	
	if (searchString != nil) {
		
		[prefs removeObjectForKey:@"searchTextDilemma"];
		[self filterResults:searchString];
		[dilemmaSearchBar setText:searchString];
		
	}

	//Position Conscience in lower-left of screen
	CGPoint centerPoint = CGPointMake(MLConscienceLowerLeftX, MLConscienceLowerLeftY);
	
	[thoughtModalArea addSubview:_userConscience.userConscienceView];
	
	_userConscience.userConscienceView.center = centerPoint;
	
	//The scrollbars won't flash unless the tableview is long enough.
	[dilemmaListTableView flashScrollIndicators];
    
	// Unselect the selected row if any
	NSIndexPath* selection = [dilemmaListTableView indexPathForSelectedRow];
	
	if (selection)
		[dilemmaListTableView deselectRowAtIndexPath:selection animated:YES];
	
	[dilemmaListTableView reloadData];

}


-(void)viewDidAppear:(BOOL)animated{
    
    //Present help screen after a split second
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];

    int nextRow = [userChoices count] - 1;
        
    if (nextRow > 0) {

        [dilemmaListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:nextRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
    }
}

-(void)setScreenshot:(UIImage *)screenshot {
    if (_screenshot != screenshot) {
        _screenshot = screenshot;
        self.previousScreen.image = screenshot;
    }
}

/**
 Implementation: Show an initial help screen if this is the User's first use of the screen.  Set a User Default after help screen is presented.  Launch a ConscienceHelpViewController and populate a localized help message.
 */
-(void)showInitialHelpScreen {
    
    //If this is the first time in Morathology, then show the intro
    NSObject *firstMorathologyCheck = [prefs objectForKey:@"firstMorathology"];
    
    if (firstMorathologyCheck == nil) {
        
        _conscienceHelpViewController.isConscienceOnScreen = TRUE;
        _conscienceHelpViewController.numberOfScreens = 1;
        _conscienceHelpViewController.screenshot = [self takeScreenshot];
        [self presentModalViewController:_conscienceHelpViewController animated:NO];
        
        [prefs setBool:FALSE forKey:@"firstMorathology"];
        
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    
	//If user has filtered list, we must retain this upon return to this view
	if (dilemmaSearchBar.text != nil && ![dilemmaSearchBar.text isEqualToString:@""]) {
		[prefs setObject:dilemmaSearchBar.text forKey:@"searchTextDilemma"];
	}
	
}

#pragma mark -
#pragma mark UI Interaction

/**
Implementation: Pop UIViewController from stack and remove Dilemma Campaign request
 */
-(IBAction)dismissDilemmaModal:(id)sender{
    
    //User specifically requests exit from Dilemma list
    NSString *searchString = [prefs objectForKey:@"searchText"];	
	
	if (searchString != nil) {
		
		[prefs removeObjectForKey:@"searchText"];
		
	}
    
    [prefs removeObjectForKey:@"dilemmaCampaign"];
    
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
#pragma mark Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//NSLog(@”contacts error in num of row”);
	return [tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	DilemmaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DilemmaTableViewCell class])];

	if (cell == nil) {
      	cell = [[DilemmaTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([DilemmaTableViewCell class])];
	}

	[cell.textLabel setText:tableData[indexPath.row]];
	
	//cell image is surrounding utilized in dilemma
    NSMutableString *rowImageName = [[NSMutableString alloc]  initWithString:tableDataImages[indexPath.row]];
    [rowImageName appendString:@"-sm"];
    
    UIImage *rowImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:rowImageName ofType:@"png"]];
    cell.dilemmaImage = rowImage;

	//Generate array of all keys in User Dictionary
	NSArray *allUserChoices = [userChoices allKeys];
    
	//Determine if user has already completed particular dilemma
	//If so, display checkmark and display which moral was chosen
	int previousRow = indexPath.row;
    
	BOOL isSelectable = FALSE;
    
	if (previousRow > 0) {
		previousRow = indexPath.row - 1;
        
		if ([allUserChoices containsObject:tableDataKeys[previousRow]]) {
			isSelectable = TRUE;
		}
	} else {
       
		if (![allUserChoices containsObject:tableDataKeys[indexPath.row]]) {
			isSelectable = TRUE;
		}
	}

	//Determine if user has already completed particular dilemma
	//If so, display checkmark and display which moral was chosen
	if ([allUserChoices containsObject:tableDataKeys[indexPath.row]]) {
        cell.currentCellState = DilemmaTableViewCellStateFinished;

		NSString *moralName = [moralNames valueForKey:[userChoices valueForKey:tableDataKeys[indexPath.row]]];
		[cell.detailTextLabel setText:moralName];
	} else {
        
		if (isSelectable) {
            cell.currentCellState = DilemmaTableViewCellStateAvailable;
		} else {
            cell.currentCellState = DilemmaTableViewCellStateUnavailable;
		}
        [cell.detailTextLabel setText:tableDataDetails[indexPath.row]];

	}
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    //If User has already completed Dilemma, prevent User from selecting it
    NSArray *allUserChoices = [userChoices allKeys];
    
    int previousRow = indexPath.row;
        
    BOOL isSelectable = FALSE;
    
    if (previousRow > 0) {
        previousRow = indexPath.row - 1;
        
        if ([allUserChoices containsObject:tableDataKeys[previousRow]]) {
            isSelectable = TRUE;
        }
    } else {
        
        if (![allUserChoices containsObject:tableDataKeys[indexPath.row]]) {
            isSelectable = TRUE;
        }
    }
    
    if (![allUserChoices containsObject:tableDataKeys[indexPath.row]]) {
        
        if (isSelectable) {
    
            NSMutableString *selectedRowKey = [[NSMutableString alloc] initWithString:tableDataKeys[indexPath.row]];
            
            [prefs setObject:selectedRowKey forKey:@"dilemmaKey"];
            
            if ([tableDataTypes[indexPath.row] boolValue]){
                DilemmaViewController *dilemmaViewController = [[DilemmaViewController alloc] initWithNibName:@"DilemmaView" bundle:nil modelManager:_modelManager andConscience:_userConscience];
                dilemmaViewController.screenshot = [self takeScreenshot];
                [self.navigationController pushViewController:dilemmaViewController animated:NO];
            } else {
                DilemmaViewController *dilemmaViewController = [[DilemmaViewController alloc] initWithNibName:@"ConscienceActionView" bundle:nil modelManager:_modelManager andConscience:_userConscience];
                dilemmaViewController.screenshot = [self takeScreenshot];                
                [self.navigationController pushViewController:dilemmaViewController animated:NO];
            }

        }
        
    }
    
	
}

#pragma mark -
#pragma mark UISearchBar delegate methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar’s cancel button while in edit mode
	searchBar.showsCancelButton = YES;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;

}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	searchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    [self filterResults:searchText];

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
	[tableData removeAllObjects];
	[tableDataImages removeAllObjects];
	[tableDataDetails removeAllObjects];
	[tableDataKeys removeAllObjects];
    [tableDataTypes removeAllObjects];
    
	[tableData addObjectsFromArray:dataSource];
	[tableDataImages addObjectsFromArray:self.dilemmaModel.dilemmaImages];
	[tableDataDetails addObjectsFromArray:self.dilemmaModel.dilemmaDetails];
	[tableDataKeys addObjectsFromArray:self.dilemmaModel.dilemmas];
    [tableDataTypes addObjectsFromArray:self.dilemmaModel.dilemmaTypes];
    
	@try{
		[dilemmaListTableView reloadData];
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
#pragma mark Data Manipulation

/**
Implementation: Dilemma retrieval moved to function as controller must reload data on each view appear, not just load
 */
- (void) retrieveAllDilemmas{
    
	//Setup permanent holders, table does not key on these, it keys on tabledata which is affected by searchbar
	//tabledatas are reloaded from these master arrays    
	[dataSource removeAllObjects];	
	[searchedData removeAllObjects];	
	[tableData removeAllObjects];	
	[tableDataImages removeAllObjects];
	[tableDataDetails removeAllObjects];	
	[tableDataKeys removeAllObjects];
	[tableDataTypes removeAllObjects];

    moralNames = self.dilemmaModel.moralNames;
    userChoices = self.dilemmaModel.userChoices;
    [dataSource addObjectsFromArray:self.dilemmaModel.dilemmaDisplayNames];
    [tableData addObjectsFromArray:self.dilemmaModel.dilemmaDisplayNames];
    [tableDataImages addObjectsFromArray:self.dilemmaModel.dilemmaImages];
    [tableDataKeys addObjectsFromArray:self.dilemmaModel.dilemmas];
    [tableDataDetails addObjectsFromArray:self.dilemmaModel.dilemmaDetails];
    [tableDataTypes addObjectsFromArray:self.dilemmaModel.dilemmaTypes];


	[dilemmaListTableView reloadData];
    
}

/**
Implementation: Tableview must be refreshed on appear, as returning from detail view must return user to filtered list
 */
- (void)filterResults:(NSString *) searchText{
    
	//Remove all data that belongs to previous search
	[tableData removeAllObjects];
	[tableDataImages removeAllObjects];
	[tableDataDetails removeAllObjects];
	[tableDataKeys removeAllObjects];
    [tableDataTypes removeAllObjects];
	
	//Remove all entries once User starts typing
	if([searchText isEqualToString:@""] || searchText==nil){
		[dilemmaListTableView reloadData];
        
		return;
	}
	
	BOOL isFound = FALSE;
	
	//Sping through datasource looking for match on cell.textLabel
	NSInteger counter = 0;
	for(NSString *name in dataSource)
	{
		@autoreleasepool {
        
		//Convert both searches to lowercase and compare search string to name in cell.textLabel
			NSRange searchRange = [[name lowercaseString] rangeOfString:[searchText lowercaseString]];
			NSRange searchRangeDetails = [[self.dilemmaModel.dilemmaDetails[counter] lowercaseString] rangeOfString:[searchText lowercaseString]];
        
			
			//A match was found
			if(searchRange.location != NSNotFound)
			{
				isFound = TRUE;
				
			}else if(searchRangeDetails.location != NSNotFound){
				isFound = TRUE;
			}		
			
			if (isFound) {
				//If search is slow, only search prefix
				//if(searchRange.location== 0)
				//{			
				//Add back cell.textLabel, cell.detailTextLabel and cell.imageView
				[tableData addObject:name];
                [tableDataImages addObjectsFromArray:self.dilemmaModel.dilemmaImages];
                [tableDataDetails addObjectsFromArray:self.dilemmaModel.dilemmaDetails];
                [tableDataKeys addObjectsFromArray:self.dilemmaModel.dilemmas];
                [tableDataTypes addObjectsFromArray:self.dilemmaModel.dilemmaTypes];

				//}
			}
			
			isFound = FALSE;
			counter++;
		}
	}
	
	[dilemmaListTableView reloadData];
    
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

