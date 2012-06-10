/*
Implementation:  Retrieve all Virtues/Vices, depending upon requested type.  Present ability to search both Moral name and synonyms.

@class ChoiceModalViewController ChoiceModalViewController.h
 */

#import "ChoiceModalViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ConscienceView.h"
#import "Moral.h"

@interface ChoiceModalViewController () {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */	
	
	IBOutlet UITableView *choiceModalTableView;  	/**< table referenced by IB */
    
	//Raw data of all available morals
	NSMutableArray *searchedData;			/**< array for matched data from User search */
	NSMutableArray *choiceNames;			/**< array for Moral pkey */
	NSMutableArray *choiceDisplayNames;		/**< array for Moral name */
	NSMutableArray *choiceImages;			/**< array for Moral Image */
	NSMutableArray *choiceDetails;		/**< array for Moral synonyms */
    
	//Data for filtering/searching sourced from raw data
	NSMutableArray *dataSource;				/**< array for storing of Choices populated from previous view*/
	NSMutableArray *tableData;				/**< array for stored data displayed in table populated from dataSource */
	NSMutableArray *tableDataImages;			/**< array for stored data images */
	NSMutableArray *tableDataDetails;			/**< array for stored data details */
	NSMutableArray *tableDataKeys;			/**< array for stored data pkeys */
    
	IBOutlet UISearchBar *moralSearchBar;			/**< ui element for limiting choices in table */
	
    IBOutlet UIButton *previousButton;
	IBOutlet UIView *thoughtModalArea;				/**< ui surrounding table */
	
	BOOL isVirtue;		/**< is Moral Virtue or Vice */
    
}

/**
 Retrieve all available Morals
 */
-(void)retrieveAllSelections;

@end

@implementation ChoiceModalViewController

#pragma mark - 
#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//appDelegate needed to retrieve CoreData Context, prefs used to save form state
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	prefs = [NSUserDefaults standardUserDefaults];
	context = [appDelegate.moralModelManager managedObjectContext];
    
	moralSearchBar.barStyle = UIBarStyleBlack;
	moralSearchBar.delegate = self;
	moralSearchBar.showsCancelButton = NO;
	choiceModalTableView.delegate = self;
	choiceModalTableView.dataSource = self;
    
	CGPoint centerPoint = CGPointMake(kConscienceOffscreenBottomX, kConscienceOffscreenBottomY);
	
	[thoughtModalArea addSubview:appDelegate.userConscienceView];
	
	appDelegate.userConscienceView.center = centerPoint;
    
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint", @"Hint for previous button");
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",@"Label for previous button");
    
    //User can back out of Choice Entry screen and state will be saved
	//However, user should not be able to select a virtue, and then select a vice for entry
	NSObject *boolCheck = [prefs objectForKey:@"entryIsGood"];
	
	if (boolCheck != nil) {
		isVirtue = [prefs boolForKey:@"entryIsGood"];
		
	}else {
		isVirtue = TRUE;
	}
    
    [self retrieveAllSelections];

    
}

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	thoughtModalArea.alpha = 0;
    
	CGPoint centerPoint = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY);
	
	[UIView beginAnimations:@"BottomUpConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:NO];
	thoughtModalArea.alpha = 1;
	appDelegate.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(1.25f, 1.25f);
	
	appDelegate.userConscienceView.center = centerPoint;
	
	[UIView commitAnimations];
	
	[appDelegate.userConscienceView setNeedsDisplay];
	
}

-(void) viewWillDisappear:(BOOL)animated{
	id placeHolderID = nil;
	
	[self dismissChoiceModal:placeHolderID];
	
}

#pragma mark - 
#pragma mark - UI Interaction
/**
Implementation: Moves Conscience gracefully off screen before dismissing controller after a delay
 */
-(IBAction)dismissChoiceModal:(id)sender{
	
	CGPoint centerPoint = CGPointMake(kConscienceOffscreenBottomX, kConscienceOffscreenBottomY);
	
	[UIView beginAnimations:@"ReplaceConscience" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationBeginsFromCurrentState:YES];
	thoughtModalArea.alpha = 0;
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
Implementation: Retrieve all available Virtues/Vices and populate searchable data set.
 */
- (void) retrieveAllSelections {
	//Begin CoreData Retrieval			
	NSError *outError;
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"Moral" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
	
	NSString *value;
	
	if (isVirtue) {
		value = [NSString stringWithString:@"Virtue"];
	}else {
		value = [NSString stringWithString:@"Vice"];
		
	}
	
	//Virtue or Vice is stored in shortDescription
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"shortDescriptionMoral == %@", value];
	[request setPredicate:pred];
	
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameMoral" ascending:YES];
	NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	NSArray *objects = [context executeFetchRequest:request error:&outError];
	choiceNames = [[NSMutableArray alloc] initWithCapacity:[objects count]];			
	choiceImages = [[NSMutableArray alloc] initWithCapacity:[objects count]];			
	choiceDetails = [[NSMutableArray alloc] initWithCapacity:[objects count]];
	choiceDisplayNames = [[NSMutableArray alloc] initWithCapacity:[objects count]];
    
	
	if ([objects count] == 0) {
		NSLog(@"No matches");
	} else {
		
		for (Moral *matches in objects){
			[choiceNames addObject:[matches nameMoral]];
			[choiceImages addObject:[matches imageNameMoral]];
			[choiceDisplayNames addObject:[matches displayNameMoral]];
			[choiceDetails addObject:[matches longDescriptionMoral]];			
			
		}
	}
	
	[request release];
	//End CoreData Retrieval
	
	dataSource = [[NSMutableArray alloc] initWithArray:choiceDisplayNames];
	searchedData = [[NSMutableArray alloc]init];
	tableData = [[NSMutableArray alloc]initWithArray:dataSource];
	tableDataImages = [[NSMutableArray alloc]initWithArray:choiceImages];
	tableDataDetails = [[NSMutableArray alloc]initWithArray:choiceDetails];
	tableDataKeys = [[NSMutableArray alloc]initWithArray:choiceNames];
    
}

#pragma mark -
#pragma mark Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return [tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"moralIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
		
	}
    
	//Populate cell information
    if ([tableData count] > 0) {
        [[cell textLabel] setText:[[tableData objectAtIndex:indexPath.row] capitalizedString]];
        
        NSMutableString *rowImageName = [[NSMutableString alloc]  initWithString:[tableDataImages objectAtIndex:indexPath.row]];
        
        UIImage *rowImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:rowImageName ofType:@"png"]];
        [[cell imageView] setImage:rowImage];
        [rowImage release];
        [rowImageName release];
        
        [[cell detailTextLabel] setText:[tableDataDetails objectAtIndex:indexPath.row]];
    }
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//Commit selected Moral to NSUserDefaults for retrieval from ChoiceViewController
 	NSMutableString *selectedRow = [[NSMutableString alloc] initWithString:[tableData objectAtIndex:indexPath.row]];
 	NSMutableString *selectedRowImage = [[NSMutableString alloc] initWithString:[tableDataImages objectAtIndex:indexPath.row]];
 	NSMutableString *selectedRowKey = [[NSMutableString alloc] initWithString:[tableDataKeys objectAtIndex:indexPath.row]];
    
	[prefs setObject:selectedRowKey forKey:@"moralKey"];
	[prefs setObject:selectedRow forKey:@"moralName"];
	[prefs setObject:selectedRowImage forKey:@"moralImage"];
	
	[selectedRow release];
	[selectedRowImage release];
	[selectedRowKey release];
	
	//Must create blank ID to call function typically referenced by IB
	id placeHolderID = @"";
	
	[self dismissChoiceModal:placeHolderID];
	//[self dismissModalViewControllerAnimated:NO];	
}

#pragma mark -
#pragma mark UISearchBar delegate methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar’s cancel button while in edit mode
	searchBar.showsCancelButton = YES;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	// flush the previous search content
	[tableData removeAllObjects];
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
	
	//Remove all entries once User starts typing
	if([searchText isEqualToString:@""] || searchText==nil){
		[choiceModalTableView reloadData];
        
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
		NSRange searchRangeDetails = [[[choiceDetails objectAtIndex:counter] lowercaseString] rangeOfString:[searchText lowercaseString]];
        
		
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
			[tableDataImages addObject:[choiceImages objectAtIndex:counter]];
			[tableDataDetails addObject:[choiceDetails objectAtIndex:counter]];
			[tableDataKeys addObject:[choiceNames objectAtIndex:counter]];
            
			//}
		}
		
		isFound = FALSE;
		counter++;
		[pool release];
	}
	
	[choiceModalTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
	[tableData removeAllObjects];
	[tableDataImages removeAllObjects];
	[tableDataDetails removeAllObjects];
	[tableDataKeys removeAllObjects];
    
	[tableData addObjectsFromArray:dataSource];
	[tableDataImages addObjectsFromArray:choiceImages];
	[tableDataDetails addObjectsFromArray:choiceDetails];
	[tableDataKeys addObjectsFromArray:choiceNames];
	
	@try{
		[choiceModalTableView reloadData];
	}
	@catch(NSException *e){
	}
	[searchBar resignFirstResponder];
	[searchBar setText:@""];
}


// called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
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
    [previousButton release];
    previousButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [searchedData release];
	[tableData release];
	[tableDataImages release];
	[tableDataDetails release];
	[tableDataKeys release];
	[dataSource release];
	[choiceNames release];
	[choiceImages release];
	[choiceDetails release];
	[choiceDisplayNames release];
    [previousButton release];
    [super dealloc];
}

@end
