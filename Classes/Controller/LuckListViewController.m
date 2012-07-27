/**
Implementation:  Present User with list of User-entered Lucks.
UITableView is populated by a second set of container arrays, so that we can search on that data set without having to refetch.
Refetches of table data are necessary when sorting and ordering are requested.
 
@class LuckListViewController LuckListViewController.h
 */

#import "LuckListViewController.h"
#import "MoraLifeAppDelegate.h"
#import "LuckViewController.h"
#import "UserLuck.h"

@interface LuckListViewController () {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
    
	NSMutableArray *lucks;			/**< Array of User-entered luck titles */
	NSMutableArray *lucksAreGood;		/**< Array of whether choices are good/bad */
	NSMutableArray *luckKeys;		/**< Array of User-entered luck pkeys */
	NSMutableArray *details;		/**< Array of User-entered severities */
	NSMutableArray *icons;			/**< Array of User-entered severities */
	
	NSMutableArray *dataSource;			/**< array for storing of Choices populated from previous view*/
	NSMutableArray *tableData;			/**< array for stored data displayed in table populated from dataSource */
	NSMutableArray *tableDataColorBools;	/**< array for stored data boolean */
	NSMutableArray *tableDataImages;		/**< array for stored data images */
	NSMutableArray *tableDataDetails;		/**< array for stored data details */
	NSMutableArray *tableDataKeys;		/**< array for stored data primary keys */
	
	IBOutlet UISearchBar *luckSearchBar;	/**< ui element for limiting choices in table */
	
	IBOutlet UITableView *lucksTableView;	/**< table of User lucks */
	IBOutlet UIView *lucksView;			/**< ui surrounding tableview */
    
	IBOutlet UIButton *luckSortButton;		/**< button for sorting criteria */
	IBOutlet UIButton *luckOrderButton;		/**< button for ordering criteria */
    
	NSMutableString *luckSortDescriptor;	/**< sort descriptor for filtering Core Data */
	BOOL isAscending;					/**< is data ascending or descending order */
}


/**
 Retrieve all User entered Lucks
 */
- (void) retrieveAllLucks;

/**
 Filter the list based on User search string
 @param searchText NSString of requested pkey
 */
- (void) filterResults: (NSString *)searchText;

/**
 Retrieve luck for selection
 @param choiceKey NSString of requested pkey
 */
- (void) retrieveLuck:(NSString *) luckKey;

/**
 Delete the particular luck
 @param choiceKey NSString of requested pkey
 @todo v2.0 determine best course for Luck deletion
 */
- (void) deleteLuck:(NSString *) luckKey;

@end

@implementation LuckListViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//appDelegate needed to pass information from modal views (virtues/vices) to primary view
	//and to get Core Data Context
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	prefs = [NSUserDefaults standardUserDefaults];
	context = [appDelegate.moralModelManager managedObjectContext];
    
    isAscending = FALSE;
    luckSortDescriptor = [[NSMutableString alloc] initWithString:kChoiceListSortDate];

	
	//Retrieve localized view title string
	[self setTitle:NSLocalizedString(@"LuckListScreenTitle",@"Label for Luck List Screen")];
	
	lucks = [[NSMutableArray alloc] init];			
	icons = [[NSMutableArray alloc] init];			
	details = [[NSMutableArray alloc] init];
	luckKeys = [[NSMutableArray alloc] init];
	lucksAreGood = [[NSMutableArray alloc] init];
	
	luckSearchBar.barStyle = UIBarStyleBlack;
    luckSearchBar.showsCancelButton = FALSE;
	luckSearchBar.delegate = self;
	lucksTableView.delegate = self;
	lucksTableView.dataSource = self;
	
	dataSource = [[NSMutableArray alloc] init];
	tableData = [[NSMutableArray alloc]init];
	tableDataColorBools = [[NSMutableArray alloc] init];
	tableDataImages = [[NSMutableArray alloc] init];
	tableDataKeys = [[NSMutableArray alloc] init];
	tableDataDetails = [[NSMutableArray alloc] init];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self retrieveAllLucks];
	
	NSString *searchString = [prefs objectForKey:@"searchTextLuck"];	
	
	if (searchString != nil) {
		
		[prefs removeObjectForKey:@"searchTextLuck"];
		[self filterResults:searchString];
        [luckSearchBar setText:searchString];
		
	}
	
	//The scrollbars won't flash unless the tableview is long enough.
	[lucksTableView flashScrollIndicators];
	
	// Unselect the selected row if any
	NSIndexPath* selection = [lucksTableView indexPathForSelectedRow];
	
	if (selection)
		[lucksTableView deselectRowAtIndexPath:selection animated:YES];
	
	[lucksTableView reloadData];
    
    /** @todo localize */
    [luckSortButton setTitle:@"Sort" forState: UIControlStateNormal];
    [luckOrderButton setTitle:@"Order" forState: UIControlStateNormal];
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	if (luckSearchBar.text != nil && ![luckSearchBar.text isEqualToString:@""]) {
		[prefs setObject:luckSearchBar.text forKey:@"searchTextLuck"];

	}
	
}

#pragma mark -
#pragma mark UI Interaction

/**
Implementation: Cycle between Name, Date and Weight for sorting and Ascending and Descending for ordering.  Change button names and set sortDescriptor for next Core Data refresh.
 */
-(IBAction)switchList:(id) sender{
    
	//Set boolean to determine which version of screen to present
	if ([sender isKindOfClass:[UIButton class]]) {
		
        UIButton *senderButton = sender;
		int choiceIndex = senderButton.tag;
        
        switch (choiceIndex) {
            case 0:{    
                if ([luckSortDescriptor isEqualToString:kChoiceListSortName]) {
                    
                    [luckSortDescriptor setString:kChoiceListSortDate];
                    [luckSortButton setTitle:@"Date" forState: UIControlStateNormal];
                } else if ([luckSortDescriptor isEqualToString:kChoiceListSortDate]){
                    
                    [luckSortDescriptor setString:kChoiceListSortSeverity];
                    [luckSortButton setTitle:@"Weight" forState: UIControlStateNormal];
                    
                } else {
                    
                    [luckSortDescriptor setString:kChoiceListSortName];
                    [luckSortButton setTitle:@"Alpha" forState: UIControlStateNormal];
                }
            } break;
                
            case 1:{    
                if (isAscending) {
                    isAscending = FALSE;
                    [luckOrderButton setTitle:@"Des" forState: UIControlStateNormal];
                } else {
                    isAscending = TRUE;
                    [luckOrderButton setTitle:@"Asc" forState: UIControlStateNormal];
                    
                }
            }
                break;                 
            default:
                break;
        }
        
        [self retrieveAllLucks];
        
    }
}

#pragma mark -
#pragma mark Data Manipulation

/**
Implementation: Retrieve all User entered Lucks, and then populate a working set of data containers upon which to filter.
 */
- (void) retrieveAllLucks {
	
	[lucks removeAllObjects];
	[luckKeys removeAllObjects];
	[lucksAreGood removeAllObjects];
	[icons removeAllObjects];
	[details removeAllObjects];
	
	[dataSource removeAllObjects];
	[tableData removeAllObjects];
	[tableDataImages removeAllObjects];
	[tableDataKeys removeAllObjects];
	[tableDataDetails removeAllObjects];
    [tableDataColorBools removeAllObjects];

	//Begin CoreData Retrieval			
	NSError *outError;
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserLuck" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
	
//	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"entryModificationDate" ascending:NO];
    
    NSSortDescriptor* sortDescriptor;

    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:luckSortDescriptor ascending:isAscending];
    
	NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	NSArray *objects = [context executeFetchRequest:request error:&outError];
    
	BOOL isGood = TRUE;
	
	if ([objects count] == 0) {
		NSLog(@"No matches");
	} else {
		
		for (UserLuck *matches in objects){
			[lucks addObject:[matches entryShortDescription]];
			[luckKeys addObject:[matches entryKey]];
            
            NSMutableString *detailText = [[NSMutableString alloc] init];

            [detailText appendFormat:@"%.1f", [[matches entrySeverity] floatValue]];
            
            isGood = [[matches entryIsGood] boolValue];
			
			if (isGood) {
                [detailText appendString:@" Good"];
				[icons addObject:kLuckImageNameGood];
			} else {
                [detailText appendString:@" Bad"];
				[icons addObject:kLuckImageNameBad];
			}
            
            NSDate *modificationDate = [matches entryModificationDate];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM-dd"];
            
            [detailText appendFormat:@", %@", [dateFormat stringFromDate:modificationDate]];
            
            [dateFormat release];

            if (![[matches entryLongDescription] isEqualToString:@""]) {
                [detailText appendFormat:@": %@", [matches entryLongDescription]];
            }

			[details addObject:detailText];	
            [lucksAreGood addObject:@([[matches entryIsGood] boolValue])];

            [detailText release];
            
		}
	}
	
	[request release];
	
	[dataSource addObjectsFromArray:lucks];
	[tableData addObjectsFromArray:dataSource];
	[tableDataImages addObjectsFromArray:icons];
	[tableDataKeys addObjectsFromArray:luckKeys];
	[tableDataDetails addObjectsFromArray:details];
	[tableDataColorBools addObjectsFromArray:lucksAreGood];
	
    
	[lucksTableView reloadData];
	
}

/**
Implementation: Retrieve a requested Luck and set NSUserDefaults for ChoiceViewController to read
 */
- (void) retrieveLuck:(NSString *) luckKey {
	
	//Begin CoreData Retrieval			
	NSError *outError;
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserLuck" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
	
	if (luckKey != nil) {
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"entryKey == %@", luckKey];
		[request setPredicate:pred];
	}
	
	NSArray *objects = [context executeFetchRequest:request error:&outError];
	
	if ([objects count] == 0) {
		NSLog(@"No matches");
	} else {
		
		UserLuck *match = [objects objectAtIndex:0];
        
		[prefs setObject:[match entryKey] forKey:@"entryKey"];
		[prefs setFloat:[[match entrySeverity] floatValue]forKey:@"entrySeverity"];
		[prefs setObject:[match entryShortDescription] forKey:@"entryShortDescription"];    
		[prefs setObject:[match entryLongDescription] forKey:@"entryLongDescription"];
		[prefs setBool:[[match entryIsGood] boolValue] forKey:@"entryIsGood"];
		
	}
	
	[request release];
	
	
}

/**
Implementation:  VERSION 2.0 Delete selected luck
@todo determine best deletion affect
 */
- (void) deleteLuck:(NSString *) luckKey {
	
	//Begin CoreData Retrieval			
	NSError *outError = nil;
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserLuck" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
	
	if (luckKey != nil) {
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"entryKey == %@", luckKey];
		[request setPredicate:pred];
	}
	
	NSArray *objects = [context executeFetchRequest:request error:&outError];
	
	if ([objects count] == 0) {
		NSLog(@"No matches");
	} else {
		
		UserLuck *match = [objects objectAtIndex:0];
		
		[context deleteObject:match];		
		
	}
	
	[context save:&outError];
	[context reset];
	
	if (outError != nil) {
		NSLog(@"save:%@", outError);
	}
	
	[request release];
	
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
	
    static NSString *cellIdentifier = @"Lucks";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
		
    }
	
	[[cell textLabel] setText:[tableData objectAtIndex:indexPath.row]];
    [[cell textLabel] setFont:[UIFont systemFontOfSize:18.0]];
    [[cell textLabel] setNumberOfLines:1];
    [[cell textLabel] setAdjustsFontSizeToFitWidth:TRUE];
    [[cell textLabel] setMinimumFontSize:12.0];    
	[[cell detailTextLabel] setText:[tableDataDetails objectAtIndex:indexPath.row]]; 
	
    BOOL isRowGood = [[tableDataColorBools objectAtIndex:indexPath.row] boolValue];
    
    if (isRowGood) {
        [[cell detailTextLabel] setTextColor:[UIColor colorWithRed:0.0/255.0 green:176.0/255.0 blue:0.0/255.0 alpha:1]];
        
    } else {
		[[cell detailTextLabel] setTextColor:[UIColor colorWithRed:200.0/255.0 green:25.0/255.0 blue:2.0/255.0 alpha:1]];
    }
    
	NSMutableString *rowImageName = [[NSMutableString alloc]  initWithString:[tableDataImages objectAtIndex:indexPath.row]];
	[rowImageName appendString:@".png"];
	[[cell imageView] setImage:[UIImage imageNamed:rowImageName]];
	[rowImageName release];
	
    return cell;
}


#pragma mark -
#pragma mark Table view edit

-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	NSMutableString *selectedRow = [[NSMutableString alloc] initWithString:[tableDataKeys objectAtIndex:indexPath.row]];
	
	[self deleteLuck:selectedRow];
	
	[selectedRow release];
	
	[self retrieveAllLucks];
	[lucksTableView reloadData];
	
	/** @todo make nice animation deletion work */
	/*
	 // If row is deleted, remove it from the list.
	 if (editingStyle == UITableViewCellEditingStyleDelete)
	 {
	 
	 // Animate the deletion from the table.
	 [lucksTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	 
	 }
	 */
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSMutableString *selectedRow = [[NSMutableString alloc] initWithString:[tableDataKeys objectAtIndex:indexPath.row]];
	
	[self retrieveLuck:selectedRow];
	
	[selectedRow release];
	
	//Create subsequent view controller to be pushed onto stack
	LuckViewController *luckCont = [[LuckViewController alloc] init];
	
	//Push view onto stack
	[self.navigationController pushViewController:luckCont animated:YES];
	[luckCont release];
	
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
	//[tableData removeAllObjects];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	searchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self filterResults:searchText];
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
		[lucksTableView reloadData];
		
		return;
	}
	
	BOOL isFound = FALSE;
	
	//Sping through datasource looking for match on cell.textLabel
	NSInteger counter = 0;
	for(NSString *name in dataSource)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
		
		//Convert both searches to lowercase and compare search string to name in cell.textLabel
		NSRange searchRange = [[name lowercaseString] rangeOfString:[searchText lowercaseString]];
		NSRange searchRangeDetails = [[[details objectAtIndex:counter] lowercaseString] rangeOfString:[searchText lowercaseString]];
		
		
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
			[tableData addObject:[lucks objectAtIndex:counter]];
			[tableDataImages addObject:[icons objectAtIndex:counter]];
			[tableDataDetails addObject:[details objectAtIndex:counter]];
			[tableDataKeys addObject:[luckKeys objectAtIndex:counter]];
			
			//}
		}
		
		isFound = FALSE;
		counter++;
		[pool release];
	}
	
	[lucksTableView reloadData];
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
	[tableDataKeys addObjectsFromArray:luckKeys];
	[tableDataColorBools addObjectsFromArray:lucksAreGood];
    
	
	@try{
		[lucksTableView reloadData];
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
	[tableDataDetails release];
	[tableDataKeys release];
	[tableDataColorBools release];
	[dataSource release];	
	[lucks release], lucks = nil;
	[luckKeys release], luckKeys = nil;
	[lucksAreGood release], lucksAreGood = nil;
	[details release], details = nil;
	[icons release], icons = nil;
	[lucksView release];
    
    [luckSortDescriptor release];
	[super dealloc];
}

@end
