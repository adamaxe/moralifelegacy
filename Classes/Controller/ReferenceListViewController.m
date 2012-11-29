/**
Implementation: Retrieve requested Reference types from SystemData.  Allow User to filter results with UISearchBar.

@class ReferenceListViewController ReferenceListViewController.h
 */

#import "ReferenceListViewController.h"
#import "ReferenceDetailViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ReferenceModel.h"
#import "ConscienceAssetDAO.h"
#import "ReferenceAssetDAO.h"
#import "ReferenceBeliefDAO.h"
#import "ReferencePersonDAO.h"
#import "ReferenceTextDAO.h"
#import "MoralDAO.h"


@interface ReferenceListViewController () {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
		
	NSMutableArray *dataSource;			/**< array for storing of References populated from previous view*/
	NSMutableArray *searchedData;
	NSMutableArray *tableData;			/**< array for stored data displayed in table populated from dataSource */
	NSMutableArray *tableDataImages;		/**< array for stored data images */
	NSMutableArray *tableDataDetails;		/**< array for stored data details */
	NSMutableArray *tableDataKeys;		/**< array for stored data primary keys */	
	
	IBOutlet UITableView *referencesTableView;	/**< table housing requested data */ 
	IBOutlet UISearchBar *referenceSearchBar;		/**< search bar for limiting list */
	IBOutlet UIView *namesView;
}

@property (nonatomic, strong) ReferenceModel *referenceModel;   /**< Model to handle data/business logic */


/**
 Load Reference data from Core Data for table
 */
- (void) retrieveAllReferences;

/**
 Remove entries from tableview that don't correspond to being searched
 @param searchText NSString of requested reference
 */
- (void)filterResults:(NSString *) searchText;

@end

@implementation ReferenceListViewController

#pragma mark -
#pragma mark View lifecycle

- (id)initWithModel:(ReferenceModel *)referenceModel {
    self = [super init];

    if (self) {
        _referenceModel = referenceModel;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	//appDelegate needed to retrieve User ownership, prefs used to save form state
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	prefs = [NSUserDefaults standardUserDefaults];
    
	referenceSearchBar.barStyle = UIBarStyleBlack;
	referenceSearchBar.delegate = self;
	referenceSearchBar.showsCancelButton = NO;
	referencesTableView.delegate = self;
	referencesTableView.dataSource = self;
    
    [self setTitle:@"List"];
	
	dataSource = [[NSMutableArray alloc] init];
	searchedData = [[NSMutableArray alloc] init];
	tableData = [[NSMutableArray alloc] init];
	tableDataImages = [[NSMutableArray alloc] init];
	tableDataKeys = [[NSMutableArray alloc] init];
	tableDataDetails = [[NSMutableArray alloc] init];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self retrieveAllReferences];
    
    //User may be returning from DilemmaView and will expect search filtered list
	NSString *searchString = [prefs objectForKey:[NSString stringWithFormat:@"searchText%d", self.referenceModel.referenceType]];	
	
	if (searchString != nil) {
		
		[prefs removeObjectForKey:[NSString stringWithFormat:@"searchText%d", self.referenceModel.referenceType]];
		[self filterResults:searchString];
        [referenceSearchBar setText:searchString];
		
	}
	
	//The scrollbars won't flash unless the tableview is long enough.
	[referencesTableView flashScrollIndicators];
	
	// Unselect the selected row if any
	NSIndexPath* selection = [referencesTableView indexPathForSelectedRow];
	
	if (selection)
		[referencesTableView deselectRowAtIndexPath:selection animated:YES];
	
	[referencesTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
    //If user has filtered list, we must retain this upon return to this view
	if (referenceSearchBar.text != nil && ![referenceSearchBar.text isEqualToString:@""]) {
		[prefs setObject:referenceSearchBar.text forKey:[NSString stringWithFormat:@"searchText%d", self.referenceModel.referenceType]];
		
	}
	
}

#pragma mark -
#pragma mark Manipulate Requested Data

/**
Implementation: Retrieve all relevant hits from SystemData as raw.  Populate searchable dataset for filtering
 */
- (void) retrieveAllReferences{
		
	[dataSource removeAllObjects];
	[searchedData removeAllObjects];
	[tableData removeAllObjects];
	[tableDataImages removeAllObjects];
	[tableDataKeys removeAllObjects];
	[tableDataDetails removeAllObjects];
    
    for (int i = 0; i < self.referenceModel.referenceKeys.count; i++) {

        if([appDelegate.userCollection containsObject:(self.referenceModel.referenceKeys)[i]]){

            [dataSource addObject:(self.referenceModel.references)[i]];
            [tableData addObject:(self.referenceModel.references)[i]];
            [tableDataImages addObject:(self.referenceModel.icons)[i]];
            [tableDataKeys addObject:(self.referenceModel.referenceKeys)[i]];
            [tableDataDetails addObject:(self.referenceModel.details)[i]];
        }
    }

	[referencesTableView reloadData];
	
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
    
    static NSString *cellIdentifier = @"Names";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
	
    [[cell textLabel] setText:tableData[indexPath.row]];
    [[cell textLabel] setFont:[UIFont systemFontOfSize:18.0]];
    [[cell textLabel] setNumberOfLines:1];
    [[cell textLabel] setAdjustsFontSizeToFitWidth:TRUE];    

    [[cell detailTextLabel] setText:tableDataDetails[indexPath.row]];
	
	NSMutableString *rowImageName = [[NSMutableString alloc] initWithString:tableDataImages[indexPath.row]];	

    if (self.referenceModel.referenceType != MLReferenceModelTypeMoral) {
        [rowImageName appendString:@"-sm"];
    }
    
    UIImage *rowImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:rowImageName ofType:@"png"]];
    [[cell imageView] setImage:rowImage];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ReferenceDetailViewController *detailViewCont = [[ReferenceDetailViewController alloc] initWithModel:[[ReferenceModel alloc] init]];

    [self.referenceModel selectReference:tableDataKeys[indexPath.row]];

	[self.navigationController pushViewController:detailViewCont animated:YES];
}

#pragma mark -
#pragma mark UISearchBar delegate methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar’s cancel button while in edit mode
	searchBar.showsCancelButton = YES;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	// flush the previous search content
//    [tableData removeAllObjects];
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
	
	[tableData addObjectsFromArray:dataSource];
	[tableDataImages addObjectsFromArray:self.referenceModel.icons];
	[tableDataDetails addObjectsFromArray:self.referenceModel.details];
	[tableDataKeys addObjectsFromArray:self.referenceModel.referenceKeys];
	
	@try{
		[referencesTableView reloadData];
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

/**
Implementation: Iterate through searchData looking for instances of searchText 
 */
- (void)filterResults:(NSString *) searchText {
    
	//Remove all data that belongs to previous search
	[tableData removeAllObjects];
	[tableDataImages removeAllObjects];
	[tableDataDetails removeAllObjects];
	[tableDataKeys removeAllObjects];
	
	//Remove all entries once User starts typing
	if([searchText isEqualToString:@""] || searchText==nil){
		[referencesTableView reloadData];
		
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
			NSRange searchRangeDetails = [[(self.referenceModel.details)[counter] lowercaseString] rangeOfString:[searchText lowercaseString]];
			
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
				[tableData addObject:(self.referenceModel.references)[counter]];
				[tableDataImages addObject:(self.referenceModel.icons)[counter]];
				[tableDataDetails addObject:(self.referenceModel.details)[counter]];
				[tableDataKeys addObject:(self.referenceModel.referenceKeys)[counter]];
				
				//}
			}
			
			isFound = FALSE;
			counter++;
		}
	}
	
	[referencesTableView reloadData];
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

