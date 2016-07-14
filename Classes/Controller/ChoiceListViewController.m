/**
Implementation:  Present User with list of User-entered Choices.  Dilemma-entered choices are filtered from view.
UITableView is populated by a second set of container arrays, so that we can search on that data set without having to refetch.
Refetches of table data are necessary when sorting and ordering are requested.

@class ChoiceListViewController ChoiceListViewController.h
 */

#import "ChoiceListViewController.h"
#import "ChoiceViewController.h"
#import "ChoiceHistoryModel.h"
#import "ChoiceTableViewCell.h"

@interface ChoiceListViewController () <ViewControllerLocalization> {
	
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
    
	//Data for filtering/searching sourced from raw data
	NSMutableArray *dataSource;			/**< array for storing of Choices populated from previous view*/
	NSMutableArray *tableData;			/**< array for stored data displayed in table populated from dataSource */
	NSMutableArray *tableDataColorBools;	/**< array for stored data booleans for Virtue/Vice distinction */
	NSMutableArray *tableDataImages;		/**< array for stored data images */
	NSMutableArray *tableDataDetails;		/**< array for stored data details */
	NSMutableArray *tableDataKeys;		/**< array for stored data primary keys */
	
	IBOutlet UISearchBar *choiceSearchBar;	/**< ui element for limiting choices in table */
	
	IBOutlet UITableView *choicesTableView;	/**< table of User choices*/
	IBOutlet UIView *choicesView;			/**< ui surrounding tableview */
    
	IBOutlet UIButton *moralSortButton;		/**< button for sorting criteria */
	IBOutlet UIButton *moralOrderButton;	/**< button for ordering criteria */
	IBOutlet UIButton *cancelButton;        /**< button for returning to previous screen */

    //Refactor into model
	NSMutableString *choiceSortDescriptor;	/**< sort descriptor for filtering Core Data */
	BOOL isAscending;					/**< is data ascending or descending order */
}

@property (nonatomic, strong) ChoiceHistoryModel *choiceHistoryModel;   /**< Model to handle data/business logic */

/**
 Retrieve all User entered Choices
 */
- (void) retrieveAllChoices;

/**
 Filter the list based on User search string
 @param searchText NSString of requested pkey
 */
- (void) filterResults: (NSString *)searchText;

///**
// Delete the particular choice
// @param choiceKey NSString of requested pkey
// @todo v2.0 determine best course for Choice deletion
// */
//- (void) deleteChoice:(NSString *) choiceKey;

@end

@implementation ChoiceListViewController

#pragma mark -
#pragma mark View lifecycle

- (instancetype)initWithModel:(ChoiceHistoryModel *)choiceHistoryModel modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience {

    self = [super initWithModelManager:modelManager andConscience:userConscience];

    if (self) {
        self.choiceHistoryModel = choiceHistoryModel;
        self.choiceHistoryModel.choiceType = MLChoiceHistoryModelTypeAll;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	prefs = [NSUserDefaults standardUserDefaults];
    choiceSearchBar.placeholder = NSLocalizedString(@"SearchBarPlaceholderText", nil);

	//Set default listing and sort order
	isAscending = FALSE;
	choiceSortDescriptor = [[NSMutableString alloc] initWithString:MLChoiceListSortDate];
    
	//Retrieve localized view title string
	/** 
	@todo utilize consistent localization string references 
	*/
	[moralSortButton setTitle:NSLocalizedString(@"ChoiceListViewControllerSortLabel", nil) forState: UIControlStateNormal];
	[moralOrderButton setTitle:NSLocalizedString(@"ChoiceListViewControllerOrderLabel", nil) forState: UIControlStateNormal];
        
	choiceSearchBar.barStyle = UIBarStyleBlack;
	choiceSearchBar.delegate = self;
	choiceSearchBar.showsCancelButton = NO;
	choicesTableView.delegate = self;
	choicesTableView.dataSource = self;
        
	//Initialize filtered data containers
	dataSource = [[NSMutableArray alloc] init];
	tableData = [[NSMutableArray alloc] init];
	tableDataColorBools = [[NSMutableArray alloc] init];
	tableDataImages = [[NSMutableArray alloc] init];
	tableDataKeys = [[NSMutableArray alloc] init];
	tableDataDetails = [[NSMutableArray alloc] init];

    self.navigationItem.hidesBackButton = YES;

    UIBarButtonItem *choiceBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"PrimaryNav1Label", nil) style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popToRootViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = choiceBarButton;

    [self localizeUI];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	//Refresh Data in case something changed since last time onscreen
	[self retrieveAllChoices];
	
	//Retrieve previous search if available
	NSString *searchString = [prefs objectForKey:@"searchTextChoice"];	
	
	if (searchString != nil) {
		[prefs removeObjectForKey:@"searchTextChoice"];
		[self filterResults:searchString];
		choiceSearchBar.text = searchString;
	}
	
	//The scrollbars won't flash unless the tableview is long enough.
	[choicesTableView flashScrollIndicators];
	
	//Unselect the selected row if any was previously selected
	NSIndexPath* selection = choicesTableView.indexPathForSelectedRow;
	
	if (selection){
		[choicesTableView deselectRowAtIndexPath:selection animated:YES];
	}

    //Upon a return from a higher viewcontroller in uinavigationcontroller stack, view does not refresh
    //Tell the choiceHistoryModel to update itself in the event that a user changed an entry
    [self switchList:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
	//If search text was present, retain it for retrieval upon return to this UIViewController
	if (choiceSearchBar.text != nil && ![choiceSearchBar.text isEqualToString:@""]) {
		[prefs setObject:choiceSearchBar.text forKey:@"searchTextChoice"];
		
	}
}

#pragma mark -
#pragma mark UI Interaction

/**
Implementation: Cycle between Name, Date and Weight for sorting and Ascending and Descending for ordering.  Change button names and set sortDescriptor for next Core Data refresh.
 */
-(IBAction)switchList:(id) sender{
    
	//Set boolean to determine which version of screen to present
    //This method can be called from UI or from code
	if ([sender isKindOfClass:[UIButton class]]) {
		
		UIButton *senderButton = sender;
		NSInteger choiceIndex = senderButton.tag;
        
		//Determine if Sort or Order change is requested
		switch (choiceIndex) {

		//Sort change requested, cycle between Name, Date, Weight
            case 0:{    
                if ([choiceSortDescriptor isEqualToString:MLChoiceListSortName]) {

                    [choiceSortDescriptor setString:MLChoiceListSortDate];
                    [moralSortButton setTitle:NSLocalizedString(@"ChoiceListViewControllerDateLabel", nil) forState: UIControlStateNormal];
                } else if ([choiceSortDescriptor isEqualToString:MLChoiceListSortDate]){

                    [choiceSortDescriptor setString:MLChoiceListSortWeight];
                    [moralSortButton setTitle:NSLocalizedString(@"ChoiceListViewControllerWeightLabel", nil) forState: UIControlStateNormal];
                    
                } else {

                    [choiceSortDescriptor setString:MLChoiceListSortName];
                    [moralSortButton setTitle:NSLocalizedString(@"ChoiceListViewControllerSortLabel", nil) forState: UIControlStateNormal];
                }

                self.choiceHistoryModel.sortKey = choiceSortDescriptor;

            } break;

		//Order change requested, cycle between Ascending, Descending
            case 1:{    
                if (isAscending) {
                    isAscending = FALSE;
                    [moralOrderButton setTitle:NSLocalizedString(@"ChoiceListViewControllerDescendingLabel", nil) forState: UIControlStateNormal];
                } else {
                    isAscending = TRUE;
                    [moralOrderButton setTitle:NSLocalizedString(@"ChoiceListViewControllerAscendingLabel", nil) forState: UIControlStateNormal];
                }
                self.choiceHistoryModel.isAscending = isAscending;
            }
                break;
        //Cancel requested, return to Choice Init
            case 2:{
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            default:
                break;
        }

    } else {
        self.choiceHistoryModel.sortKey = self.choiceHistoryModel.sortKey;
        self.choiceHistoryModel.isAscending = self.choiceHistoryModel.isAscending;
    }
    
    //Refresh data view based on new criteria
    [self retrieveAllChoices];
}

#pragma mark -
#pragma mark Data Manipulation

/**
Implementation: Retrieve all User entered Choices, and then populate a working set of data containers upon which to filter.
 */
- (void) retrieveAllChoices {
		
	[dataSource removeAllObjects];
	[tableData removeAllObjects];
	[tableDataImages removeAllObjects];
	[tableDataKeys removeAllObjects];
	[tableDataDetails removeAllObjects];
	[tableDataColorBools removeAllObjects];
    	
	//Populate datasource arrays for filtering
	[dataSource addObjectsFromArray:self.choiceHistoryModel.choices];
	[tableData addObjectsFromArray:dataSource];
	[tableDataImages addObjectsFromArray:self.choiceHistoryModel.icons];
	[tableDataKeys addObjectsFromArray:self.choiceHistoryModel.choiceKeys];
	[tableDataDetails addObjectsFromArray:self.choiceHistoryModel.details];
	[tableDataColorBools addObjectsFromArray:self.choiceHistoryModel.choicesAreGood];

	[choicesTableView reloadData];
	
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
    
	ChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChoiceTableViewCell class])];
	
	if (cell == nil) {
      	cell = [[ChoiceTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([ChoiceTableViewCell class])];
	}
    
	cell.textLabel.text = tableData[indexPath.row];
    cell.detailTextLabel.text = tableDataDetails[indexPath.row];
    cell.isVirtue = [tableDataColorBools[indexPath.row] boolValue];

	NSMutableString *rowImageName = [[NSMutableString alloc]  initWithString:tableDataImages[indexPath.row]];
    
    UIImage *rowImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:rowImageName ofType:@"png"]];
    cell.moralImage = rowImage;
    
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSMutableString *selectedRow = [[NSMutableString alloc] initWithString:tableDataKeys[indexPath.row]];

	//Get selected row and commit to NSUserDefaults    
	[self.choiceHistoryModel retrieveChoice:selectedRow forEditing:YES];
	
	//Create subsequent view controller to be pushed onto stack
	//ChoiceViewController gets data from NSUserDefaults
	ChoiceViewController *choiceCont = [[ChoiceViewController alloc] initWithModelManager:_modelManager andConscience:_userConscience];
	
	//Push view onto stack
	[self.navigationController pushViewController:choiceCont animated:YES];

}

#pragma mark -
#pragma mark UISearchBar delegate methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar’s cancel button while in edit mode
	searchBar.showsCancelButton = YES;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	//flush the previous search content
	//[tableData removeAllObjects];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	searchBar.showsCancelButton = NO;
}

- (void)filterResults: (NSString *)searchText{
    
	//Remove all data that belongs to previous search
	[tableData removeAllObjects];
	[tableDataImages removeAllObjects];
	[tableDataDetails removeAllObjects];
	[tableDataKeys removeAllObjects];
	[tableDataColorBools removeAllObjects];
	
    
	//Remove all entries once User starts typing
	if([searchText isEqualToString:@""] || searchText==nil){
		[choicesTableView reloadData];
		
		return;
	}
	
	BOOL isFound = FALSE;
	
	//Spin through datasource looking for match on cell.textLabel
	NSInteger counter = 0;
	for(NSString *name in dataSource)
	{
		@autoreleasepool {
		
		//Convert both searches to lowercase and compare search string to name in cell.textLabel
			NSRange searchRange = [name.lowercaseString rangeOfString:searchText.lowercaseString];
			NSRange searchRangeDetails = [[(self.choiceHistoryModel.details)[counter] lowercaseString] rangeOfString:searchText.lowercaseString];
			NSRange searchRangeMorals = [[(self.choiceHistoryModel.icons)[counter] lowercaseString] rangeOfString:searchText.lowercaseString];
			
			//A match was found in row name, details or moral
			if(searchRange.location != NSNotFound)
			{
				isFound = TRUE;
			}else if(searchRangeDetails.location != NSNotFound){
				isFound = TRUE;
			}else if(searchRangeMorals.location != NSNotFound){
				isFound = TRUE;
			}		
			
			if (isFound) {
				//If search is slow, only search prefix
				//if(searchRange.location== 0)
				//{
				
				//Add back cell.textLabel, cell.detailTextLabel and cell.imageView
				[tableData addObject:(self.choiceHistoryModel.choices)[counter]];
				[tableDataImages addObject:(self.choiceHistoryModel.icons)[counter]];
				[tableDataDetails addObject:(self.choiceHistoryModel.details)[counter]];
				[tableDataKeys addObject:(self.choiceHistoryModel.choiceKeys)[counter]];
            	[tableDataColorBools addObject:(self.choiceHistoryModel.choicesAreGood)[counter]];

				//}
			}
			
			isFound = FALSE;
			counter++;
		}
	}
	
	[choicesTableView reloadData];
	
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
	[tableDataColorBools removeAllObjects];

    
	[tableData addObjectsFromArray:dataSource];
	[tableDataImages addObjectsFromArray:self.choiceHistoryModel.icons];
	[tableDataDetails addObjectsFromArray:self.choiceHistoryModel.details];
	[tableDataKeys addObjectsFromArray:self.choiceHistoryModel.choiceKeys];
	[tableDataColorBools addObjectsFromArray:self.choiceHistoryModel.choicesAreGood];

    
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
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    self.title = NSLocalizedString(@"ChoiceListScreenTitle",nil);
    moralSortButton.accessibilityLabel = NSLocalizedString(@"ChoiceListScreenSortButtonLabel",nil);
	moralSortButton.accessibilityHint = NSLocalizedString(@"ChoiceListScreenSortButtonHint",nil);
    
    moralOrderButton.accessibilityLabel = NSLocalizedString(@"ChoiceListScreenOrderButtonLabel",nil);
	moralOrderButton.accessibilityHint = NSLocalizedString(@"ChoiceListScreenOrderButtonHint",nil);

}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    [super viewDidUnload];

}



@end
