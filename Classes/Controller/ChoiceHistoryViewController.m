/**
 Implementation:  Present User with list of previously entered Choices.  Dilemma-entered choices are filtered from view.
 UITableView is populated by a second set of container arrays, so that we can search on that data set without having to refetch.
 Refetches of table data are necessary when sorting and ordering are requested.
 
 This class allows the User to quickly re-enter entries that they do on a consistent basis such as repeated good/bad behavior (weekly donations, smoking, etc.).  An entry from this list will populate all of the fields on ChoiceViewController except for entryKey.  This is to ensure that a new entry is added to the UserChoice tables instead of overriding a previous choice.
 
 @class ChoiceHistoryViewController ChoiceHistoryViewController.h
 */

#import "ChoiceHistoryViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ChoiceViewController.h"
#import "ConscienceView.h"
#import "ChoiceHistoryModel.h"
#import "ChoiceTableViewCell.h"
#import "ViewControllerLocalization.h"

@interface ChoiceHistoryViewController () <ViewControllerLocalization> {
	
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;                  /**< serialized user settings/state retention */

	IBOutlet UISearchBar *modalSearchBar;	/**< ui element for limiting choices in table */
	IBOutlet UITableView *modalTableView;	/**< table of User choices*/
    IBOutlet UIView *thoughtArea;			/**< area in which thought bubble appears */
    IBOutlet UIView *searchArea;			/**< area in which search bubble appears */
	IBOutlet UIButton *previousButton;		/**< return to previous page */

	//Data for filtering/searching sourced from raw data
	NSMutableArray *dataSource;			/**< array for storing of Choices populated from previous view*/
	NSMutableArray *tableData;			/**< array for stored data displayed in table populated from dataSource */
	NSMutableArray *tableDataColorBools;	/**< array for stored data booleans for Virtue/Vice distinction */
	NSMutableArray *tableDataImages;		/**< array for stored data images */
	NSMutableArray *tableDataDetails;		/**< array for stored data details */
	NSMutableArray *tableDataKeys;		/**< array for stored data primary keys */


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

@end

@implementation ChoiceHistoryViewController

#pragma mark -
#pragma mark View lifecycle

- (id)initWithModel:(ChoiceHistoryModel *)choiceHistoryModel {
    self = [super initWithNibName:@"ChoiceModalView" bundle:nil];

    if (self) {
        _choiceHistoryModel = choiceHistoryModel;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	//appDelegate needed to retrieve CoreData Context, prefs used to save form state
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	prefs = [NSUserDefaults standardUserDefaults];
    
	//Set default listing and sort order    
	modalSearchBar.barStyle = UIBarStyleDefault;
	modalSearchBar.delegate = self;
	modalSearchBar.showsCancelButton = NO;
	modalTableView.delegate = self;
	modalTableView.dataSource = self;
    
    CGPoint centerPoint = CGPointMake(MLConscienceOffscreenBottomX, MLConscienceOffscreenBottomY);
	
	[thoughtArea addSubview:appDelegate.userConscienceView];
	
	appDelegate.userConscienceView.center = centerPoint;
    
    //User can back out of Choice Entry screen and state will be saved
	//However, user should not be able to select a virtue, and then select a vice for entry
	NSObject *boolCheck = [prefs objectForKey:@"entryIsGood"];
	
	if (boolCheck != nil) {

        BOOL isPersistentChoiceGood = [prefs boolForKey:@"entryIsGood"];
        self.choiceHistoryModel.choiceType = isPersistentChoiceGood ? MLChoiceHistoryModelTypeIsGood: MLChoiceHistoryModelTypeIsBad;
	}else {
        self.choiceHistoryModel.choiceType = MLChoiceHistoryModelTypeIsGood;
	}
        
	//Initialize filtered data containers
	dataSource = [[NSMutableArray alloc] init];
	tableData = [[NSMutableArray alloc] init];
	tableDataColorBools = [[NSMutableArray alloc] init];
	tableDataImages = [[NSMutableArray alloc] init];
	tableDataKeys = [[NSMutableArray alloc] init];
	tableDataDetails = [[NSMutableArray alloc] init];

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
		[modalSearchBar setText:searchString];
	}
	
	//The scrollbars won't flash unless the tableview is long enough.
	[modalTableView flashScrollIndicators];
	
	//Unselect the selected row if any was previously selected
	NSIndexPath* selection = [modalTableView indexPathForSelectedRow];
	
	if (selection){
		[modalTableView deselectRowAtIndexPath:selection animated:YES];
	}
    
    thoughtArea.alpha = 0;
    
	CGPoint centerPoint = CGPointMake(MLConscienceLowerLeftX, MLConscienceLowerLeftY);
	
	[UIView beginAnimations:@"BottomUpConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
	thoughtArea.alpha = 1;
	appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.25f, 1.25f);
	
	appDelegate.userConscienceView.center = centerPoint;
	
	[UIView commitAnimations];
	
	[appDelegate.userConscienceView setNeedsDisplay];
    modalTableView.contentInset = UIEdgeInsetsMake(15.0, 0.0, 0.0, 0.0);
    modalSearchBar.frame = CGRectMake(0, 0, searchArea.frame.size.width, searchArea.frame.size.height);
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
	
	//If search text was present, retain it for retrieval upon return to this UIViewController
	if (modalSearchBar.text != nil && ![modalSearchBar.text isEqualToString:@""]) {
		[prefs setObject:modalSearchBar.text forKey:@"searchTextChoice"];
		
	}
}

#pragma mark -
#pragma mark UI Interaction

/**
 Implementation: Moves Conscience gracefully off screen before dismissing controller after a delay
 */
-(IBAction)dismissChoiceModal:(id)sender{
	
	CGPoint centerPoint = CGPointMake(MLConscienceOffscreenBottomX, MLConscienceOffscreenBottomY);
	
	[UIView beginAnimations:@"ReplaceConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	thoughtArea.alpha = 0;
	appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
	
	appDelegate.userConscienceView.center = centerPoint;
	
	[UIView commitAnimations];
	
	//Call dismissFunction with a delay
	SEL selector = @selector(dismissModalViewControllerAnimated:);
	
	NSMethodSignature *signature = [UIViewController instanceMethodSignatureForSelector:selector];
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
	[invocation setSelector:selector];
	
	BOOL timerBool = NO;
	
	//Set the arguments
	[invocation setTarget:self];
	[invocation setArgument:&timerBool atIndex:2];
	
	[NSTimer scheduledTimerWithTimeInterval:0.5 invocation:invocation repeats:NO];
    
}

#pragma mark -
#pragma mark Data Manipulation

/**
 Implementation: Retrieve all User entered Choices, and then populate a working set of data containers upon which to filter.
 */
- (void) retrieveAllChoices {
	
	//Clear all datasets
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
    
	[modalTableView reloadData];
	
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
	[self.choiceHistoryModel retrieveChoice:selectedRow forEditing:NO];

    id placeHolder = nil;

    [self dismissChoiceModal:placeHolder];

	
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
		[modalTableView reloadData];
		
		return;
	}
	
	BOOL isFound = FALSE;
	
	//Spin through datasource looking for match on cell.textLabel
	NSInteger counter = 0;
	for(NSString *name in dataSource)
	{
		@autoreleasepool {
		
		//Convert both searches to lowercase and compare search string to name in cell.textLabel
			NSRange searchRange = [[name lowercaseString] rangeOfString:[searchText lowercaseString]];
			NSRange searchRangeDetails = [[(self.choiceHistoryModel.details)[counter] lowercaseString] rangeOfString:[searchText lowercaseString]];
			NSRange searchRangeMorals = [[(self.choiceHistoryModel.icons)[counter] lowercaseString] rangeOfString:[searchText lowercaseString]];
			
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
	
	[modalTableView reloadData];
	
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
		[modalTableView reloadData];
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
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint",nil);
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",nil);
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