/**
 Implementation:  Present User with list of previously entered Choices.  Dilemma-entered choices are filtered from view.
 UITableView is populated by a second set of container arrays, so that we can search on that data set without having to refetch.
 Refetches of table data are necessary when sorting and ordering are requested.
 
 This class allows the User to quickly re-enter entries that they do on a consistent basis such as repeated good/bad behavior (weekly donations, smoking, etc.).  An entry from this list will populate all of the fields on ChoiceViewController except for entryKey.  This is to ensure that a new entry is added to the UserChoice tables instead of overriding a previous choice.
 
 @class ChoiceHistoryViewController ChoiceHistoryViewController.h
 */

#import "ChoiceHistoryViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "ChoiceViewController.h"
#import "ConscienceView.h"
#import "UserChoiceDAO.h"
#import "MoralDAO.h"
#import "ViewControllerLocalization.h"

@interface ChoiceHistoryViewController () <ViewControllerLocalization> {
	
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
    
	//Raw data of all entered choices
	NSMutableArray *choices;			/**< Array of User-entered choice titles */
	NSMutableArray *choicesAreGood;     	/**< Array of whether choices are good/bad */
	NSMutableArray *choiceKeys;			/**< Array of User-entered choice titles */
	NSMutableArray *details;			/**< Array of User-entered details */
	NSMutableArray *icons;				/**< Array of associated images */
    
	//Data for filtering/searching sourced from raw data
	NSMutableArray *dataSource;			/**< array for storing of Choices populated from previous view*/
	NSMutableArray *tableData;			/**< array for stored data displayed in table populated from dataSource */
	NSMutableArray *tableDataColorBools;	/**< array for stored data booleans for Virtue/Vice distinction */
	NSMutableArray *tableDataImages;		/**< array for stored data images */
	NSMutableArray *tableDataDetails;		/**< array for stored data details */
	NSMutableArray *tableDataKeys;		/**< array for stored data primary keys */
	
	IBOutlet UISearchBar *choiceSearchBar;	/**< ui element for limiting choices in table */
	
	IBOutlet UITableView *choicesTableView;	/**< table of User choices*/
    IBOutlet UIView *thoughtArea;			/**< area in which thought bubble appears */
	IBOutlet UIButton *previousButton;		/**< return to previous page */    
    
	NSMutableString *choiceSortDescriptor;	/**< sort descriptor for filtering Core Data */
	BOOL isAscending;					/**< is data ascending or descending order */
    BOOL isVirtue;
}

/**
 Retrieve all User entered Choices
 */
- (void) retrieveAllChoices;

/**
 Retrieve choice for selection
 @param choiceKey NSString of requested pkey
 */
- (void) retrieveChoice:(NSString *) choiceKey;

/**
 Filter the list based on User search string
 @param searchText NSString of requested pkey
 */
- (void) filterResults: (NSString *)searchText;

@end

@implementation ChoiceHistoryViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
	//appDelegate needed to retrieve CoreData Context, prefs used to save form state
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	context = [appDelegate.moralModelManager readWriteManagedObjectContext];
	prefs = [NSUserDefaults standardUserDefaults];
    
	//Set default listing and sort order
	isAscending = FALSE;
	choiceSortDescriptor = [[NSMutableString alloc] initWithString:kChoiceListSortDate];
    
	choiceSearchBar.barStyle = UIBarStyleBlack;
	choiceSearchBar.delegate = self;
	choiceSearchBar.showsCancelButton = NO;
	choicesTableView.delegate = self;
	choicesTableView.dataSource = self;
    
    CGPoint centerPoint = CGPointMake(kConscienceOffscreenBottomX, kConscienceOffscreenBottomY);
	
	[thoughtArea addSubview:appDelegate.userConscienceView];
	
	appDelegate.userConscienceView.center = centerPoint;
    
    //User can back out of Choice Entry screen and state will be saved
	//However, user should not be able to select a virtue, and then select a vice for entry
	NSObject *boolCheck = [prefs objectForKey:@"entryIsGood"];
	
	if (boolCheck != nil) {
		isVirtue = [prefs boolForKey:@"entryIsGood"];
		
	}else {
		isVirtue = TRUE;
	}
    
	//Initialize raw data containers
	choices = [[NSMutableArray alloc] init];			
	icons = [[NSMutableArray alloc] init];			
	details = [[NSMutableArray alloc] init];
	choiceKeys = [[NSMutableArray alloc] init];
	choicesAreGood = [[NSMutableArray alloc] init];
    
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
		[choiceSearchBar setText:searchString];
	}
	
	//The scrollbars won't flash unless the tableview is long enough.
	[choicesTableView flashScrollIndicators];
	
	//Unselect the selected row if any was previously selected
	NSIndexPath* selection = [choicesTableView indexPathForSelectedRow];
	
	if (selection){
		[choicesTableView deselectRowAtIndexPath:selection animated:YES];
	}
    
    thoughtArea.alpha = 0;
    
	CGPoint centerPoint = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY);
	
	[UIView beginAnimations:@"BottomUpConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
	thoughtArea.alpha = 1;
	appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.25f, 1.25f);
	
	appDelegate.userConscienceView.center = centerPoint;
	
	[UIView commitAnimations];
	
	[appDelegate.userConscienceView setNeedsDisplay];

	
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
 Implementation: Moves Conscience gracefully off screen before dismissing controller after a delay
 */
-(IBAction)dismissChoiceModal:(id)sender{
	
	CGPoint centerPoint = CGPointMake(kConscienceOffscreenBottomX, kConscienceOffscreenBottomY);
	
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
	[choices removeAllObjects];
	[choiceKeys removeAllObjects];
	[choicesAreGood removeAllObjects];
	[icons removeAllObjects];
	[details removeAllObjects];
	
	[dataSource removeAllObjects];
	[tableData removeAllObjects];
	[tableDataImages removeAllObjects];
	[tableDataKeys removeAllObjects];
	[tableDataDetails removeAllObjects];
	[tableDataColorBools removeAllObjects];
	
    UserChoiceDAO *currentUserChoiceDAO = [[UserChoiceDAO alloc] initWithKey:@""];
    
    NSString *predicateParam = [[NSString alloc] initWithString:@"dile-"];

	//Ensure that Choices created during Morathology sessions are not displayed here
	//All Dilemma/Action Choice entryKeys are prefixed with string "dile-"
	//@see DilemmaViewController
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"entryIsGood == %@ AND NOT entryKey contains[cd] %@", [NSNumber numberWithBool: isVirtue], predicateParam];
	currentUserChoiceDAO.predicates = [NSArray arrayWithObject:pred];
	[predicateParam release];
    
	NSSortDescriptor* sortDescriptor;
    
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:choiceSortDescriptor ascending:isAscending];
    
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
	currentUserChoiceDAO.sorts = sortDescriptors;
	[sortDescriptor release];
    [sortDescriptors release];
	
	NSArray *objects = [currentUserChoiceDAO readAll];
	
	if ([objects count] > 0) {

		//Build raw data list to be filtered by second data container set
		for (UserChoice *matches in objects){
            
			[choices addObject:[matches entryShortDescription]];
		 	[choiceKeys addObject:[matches entryKey]];
			[choicesAreGood addObject:[NSNumber numberWithBool:[[matches entryIsGood] boolValue]]];
            
			//Detailed text is name of Moral, Weight, Date, Long Description
			NSMutableString *detailText = [[NSMutableString alloc] init];
            
			[detailText appendFormat:@"%.1f ", [[matches choiceWeight] floatValue]];
			NSString *value = [matches choiceMoral];
				
            MoralDAO *currentMoralDAO = [[MoralDAO alloc] init];

			Moral *currentMoral = [currentMoralDAO read:value];
							
            //Display image and moral name
            [icons addObject:[currentMoral imageNameMoral]];
            [detailText appendString:[currentMoral displayNameMoral]];
            
            [currentMoralDAO release];
            
			//Display date last modified for sorting
            NSDate *modificationDate = [matches entryModificationDate];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM-dd"];
            
            [detailText appendFormat:@" %@", [dateFormat stringFromDate:modificationDate]];
            
            [dateFormat release];
            
			//If longDescription is empty, do not show colon separating
            if (![[matches entryLongDescription] isEqualToString:@""]) {
                [detailText appendFormat:@": %@", [matches entryLongDescription]];
            }
            
			//Populate details array with constructed detail
            [details addObject:detailText];
			[detailText release];
            
		}
	}
	
	[currentUserChoiceDAO release];
	
	//Populate datasource arrays for filtering
	[dataSource addObjectsFromArray:choices];
	[tableData addObjectsFromArray:dataSource];
	[tableDataImages addObjectsFromArray:icons];
	[tableDataKeys addObjectsFromArray:choiceKeys];
	[tableDataDetails addObjectsFromArray:details];
	[tableDataColorBools addObjectsFromArray:choicesAreGood];
    
	[choicesTableView reloadData];
	
}

/**
 Implementation: Retrieve a requested Choice and set NSUserDefaults for ChoiceViewController to read
 */
- (void) retrieveChoice:(NSString *) choiceKey {
	
    UserChoiceDAO *currentUserChoiceDAO = [[UserChoiceDAO alloc] init];
	        
    UserChoice *match = [currentUserChoiceDAO read:choiceKey];
    
    //Set state retention for eventual call to ChoiceViewController to pick up
//		[prefs setObject:[match entryKey] forKey:@"entryKey"];
    [prefs setFloat:[[match entrySeverity] floatValue]forKey:@"entrySeverity"];
    [prefs setObject:[match entryShortDescription] forKey:@"entryShortDescription"];    
    [prefs setObject:[match entryLongDescription] forKey:@"entryLongDescription"];
    [prefs setObject:[match choiceJustification] forKey:@"choiceJustification"];    
    [prefs setObject:[match choiceConsequences] forKey:@"choiceConsequence"];    
    [prefs setFloat:[[match choiceInfluence] floatValue] forKey:@"choiceInfluence"];
    [prefs setObject:[match choiceMoral] forKey:@"moralKey"];
    [prefs setBool:[[match entryIsGood] boolValue] forKey:@"entryIsGood"];
    
    
    MoralDAO *currentMoralDAO = [[MoralDAO alloc] initWithKey:[match choiceMoral]];
    
    Moral *currentMoral = [currentMoralDAO read:@""];

    [prefs setObject:[currentMoral displayNameMoral] forKey:@"moralName"];
    [prefs setObject:[match choiceMoral] forKey:@"moralKey"];
    [prefs setObject:[currentMoral imageNameMoral] forKey:@"moralImage"];
    
    [currentMoralDAO release];
	
	[currentUserChoiceDAO release];
    
    id placeHolder = nil;
    
    [self dismissChoiceModal:placeHolder];

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
    
	static NSString *cellIdentifier = @"Choices";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil) {
      	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
	}
    
	//Setup cell contents
	[[cell textLabel] setText:[tableData objectAtIndex:indexPath.row]];
	[[cell textLabel] setMinimumFontSize:12.0];    
	[[cell detailTextLabel] setText:[tableDataDetails objectAtIndex:indexPath.row]];
    
	//Determine if Choice is good or bad
	BOOL isRowGood = [[tableDataColorBools objectAtIndex:indexPath.row] boolValue];
    
	if (isRowGood) {
		[[cell detailTextLabel] setTextColor:[UIColor colorWithRed:0.0/255.0 green:176.0/255.0 blue:0.0/255.0 alpha:1]];
	} else {
		[[cell detailTextLabel] setTextColor:[UIColor colorWithRed:200.0/255.0 green:25.0/255.0 blue:2.0/255.0 alpha:1]];
	}
    
	//Set cell content wrapping
	[[cell textLabel] setFont:[UIFont systemFontOfSize:18.0]];
	[[cell textLabel] setNumberOfLines:1];
	[[cell textLabel] setAdjustsFontSizeToFitWidth:TRUE];
	
	NSMutableString *rowImageName = [[NSMutableString alloc]  initWithString:[tableDataImages objectAtIndex:indexPath.row]];
    //	[rowImageName appendString:@".png"];
    
    UIImage *rowImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:rowImageName ofType:@"png"]];
    //	[[cell imageView] setImage:[UIImage imageNamed:rowImageName]];
    [[cell imageView] setImage:rowImage];
    [rowImage release];
    [rowImageName release];
    
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSMutableString *selectedRow = [[NSMutableString alloc] initWithString:[tableDataKeys objectAtIndex:indexPath.row]];
    
	//Get selected row and commit to NSUserDefaults    
	[self retrieveChoice:selectedRow];
	[selectedRow release];
	
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
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
		
		//Convert both searches to lowercase and compare search string to name in cell.textLabel
		NSRange searchRange = [[name lowercaseString] rangeOfString:[searchText lowercaseString]];
		NSRange searchRangeDetails = [[[details objectAtIndex:counter] lowercaseString] rangeOfString:[searchText lowercaseString]];
		NSRange searchRangeMorals = [[[icons objectAtIndex:counter] lowercaseString] rangeOfString:[searchText lowercaseString]];
		
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
			[tableData addObject:[choices objectAtIndex:counter]];
			[tableDataImages addObject:[icons objectAtIndex:counter]];
			[tableDataDetails addObject:[details objectAtIndex:counter]];
			[tableDataKeys addObject:[choiceKeys objectAtIndex:counter]];
            [tableDataColorBools addObject:[choicesAreGood objectAtIndex:counter]];
            
			//}
		}
		
		isFound = FALSE;
		counter++;
		[pool release];
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
	[tableDataImages addObjectsFromArray:icons];
	[tableDataDetails addObjectsFromArray:details];
	[tableDataKeys addObjectsFromArray:choiceKeys];
	[tableDataColorBools addObjectsFromArray:choicesAreGood];
    
    
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
    
    self.title = NSLocalizedString(@"ChoiceListScreenTitle",@"Label for Choice List Screen");
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint", @"Hint for previous button");
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",@"Label for previous button");
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


- (void)dealloc {
	
	[tableData release];
	[tableDataImages release];
	[tableDataColorBools release];
	[tableDataDetails release];
	[tableDataKeys release];
	[dataSource release];	
	[choices release], choices = nil;
	[choiceKeys release], choiceKeys = nil;
	[details release], details = nil;
	[icons release], icons = nil;
	[choicesAreGood release], choicesAreGood = nil;
	[choiceSortDescriptor release];
    
	[super dealloc];
}

@end