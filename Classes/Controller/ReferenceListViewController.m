/**
Implementation: Retrieve requested Reference types from SystemData.  Allow User to filter results with UISearchBar.

@class ReferenceListViewController ReferenceListViewController.h
 */

#import "ReferenceListViewController.h"
#import "ReferenceDetailViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ReferenceAsset.h"
#import "ReferenceBelief.h"
#import "ReferencePerson.h"
#import "ReferenceReport.h"
#import "ReferenceText.h"
#import "Moral.h"

@interface ReferenceListViewController () {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;				/**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
	NSEntityDescription *entityAssetDesc;	/**< select for request */
	
	NSMutableArray *references;			/**< text to appear as row name */
	NSMutableArray *referenceKeys;		/**< text to key on DB */
	NSMutableArray *icons;				/**< filename of picture to be shown in row */
	NSMutableArray *details;			/**< text to appear under row name */
	
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

@synthesize referenceType;

#pragma mark -
#pragma mark View lifecycle

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {

		//Setup default values
		referenceType = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	//appDelegate needed to retrieve CoreData Context, prefs used to save form state
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	context = [appDelegate.moralModelManager managedObjectContext];
	prefs = [NSUserDefaults standardUserDefaults];
    
	referenceSearchBar.barStyle = UIBarStyleBlack;
	referenceSearchBar.delegate = self;
	referenceSearchBar.showsCancelButton = NO;
	referencesTableView.delegate = self;
	referencesTableView.dataSource = self;
    
    [self setTitle:@"List"];

	//Populate subsequent list controller with appropriate choice
	switch (referenceType){
		case 0:
			entityAssetDesc = [NSEntityDescription entityForName:@"ConscienceAsset" inManagedObjectContext:context];
			break;
		case 1:
			entityAssetDesc = [NSEntityDescription entityForName:@"ReferenceBelief" inManagedObjectContext:context];
			break;
		case 2:
			entityAssetDesc = [NSEntityDescription entityForName:@"ReferenceText" inManagedObjectContext:context];
			break;
		case 3:
			entityAssetDesc = [NSEntityDescription entityForName:@"ReferencePerson" inManagedObjectContext:context];
			break;
		case 4:
			entityAssetDesc = [NSEntityDescription entityForName:@"Moral" inManagedObjectContext:context];
			break;
		case 5:
			entityAssetDesc = [NSEntityDescription entityForName:@"ReferenceReport" inManagedObjectContext:context];
			break;
		default:
			entityAssetDesc = [NSEntityDescription entityForName:@"ReferenceAccessory" inManagedObjectContext:context];			
			break;
	}
	
	references = [[NSMutableArray alloc] init];			
	icons = [[NSMutableArray alloc] init];			
	details = [[NSMutableArray alloc] init];
	referenceKeys = [[NSMutableArray alloc] init];
	
	dataSource = [[NSMutableArray alloc] init];
	searchedData = [[NSMutableArray alloc]init];
	tableData = [[NSMutableArray alloc]init];
	tableDataImages = [[NSMutableArray alloc] init];
	tableDataKeys = [[NSMutableArray alloc] init];
	tableDataDetails = [[NSMutableArray alloc] init];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self retrieveAllReferences];
    
    //User may be returning from DilemmaView and will expect search filtered list
	NSString *searchString = [prefs objectForKey:[NSString stringWithFormat:@"searchText%d", referenceType]];	
	
	if (searchString != nil) {
		
		[prefs removeObjectForKey:[NSString stringWithFormat:@"searchText%d", referenceType]];
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
		[prefs setObject:referenceSearchBar.text forKey:[NSString stringWithFormat:@"searchText%d", referenceType]];
		
	}
	
}

#pragma mark -
#pragma mark Manipulate Requested Data

/**
Implementation: Retrieve all relevant hits from SystemData as raw.  Populate searchable dataset for filtering
 */
- (void) retrieveAllReferences{
	
	[references removeAllObjects];
	[referenceKeys removeAllObjects];
	[icons removeAllObjects];
	[details removeAllObjects];
	
	[dataSource removeAllObjects];
	[searchedData removeAllObjects];
	[tableData removeAllObjects];
	[tableDataImages removeAllObjects];
	[tableDataKeys removeAllObjects];
	[tableDataDetails removeAllObjects];
	
	//Begin CoreData Retrieval
	NSError *outError;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
	
    //Determine sort order
    if (referenceType != 4) {
        NSSortDescriptor* sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"displayNameReference" ascending:YES];
        NSSortDescriptor* sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"shortDescriptionReference" ascending:YES];
        
        NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor1, sortDescriptor2, nil] autorelease];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptor1 release];
        [sortDescriptor2 release];
    } else {
        
        NSSortDescriptor* sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"displayNameMoral" ascending:YES];
        
        NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor1, nil] autorelease];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptor1 release];
        
    }

	
	/** @bug leaks complaint */
	NSArray *objects = [context executeFetchRequest:request error:&outError];
	
	if ([objects count] == 0) {
		NSLog(@"No matches");
	} else {
		
        if (referenceType != 4) {
            for (ReferenceAsset *matches in objects){

                //Is the asset owned
                if([appDelegate.userCollection containsObject:[matches nameReference]]){

                    [references addObject:[matches displayNameReference]];
                    [icons addObject:[matches imageNameReference]];
                    [details addObject:[matches shortDescriptionReference]];
                    [referenceKeys addObject:[matches nameReference]];		
                }
                
            }
        } else {

            for (Moral *matches in objects){
                
                if([appDelegate.userCollection containsObject:[matches nameMoral]]){

                    [references addObject:[matches displayNameMoral]];
                    [icons addObject:[matches imageNameMoral]];
                    [details addObject:[NSString stringWithFormat:@"%@: %@", [matches shortDescriptionMoral], [matches longDescriptionMoral]]];
                    [referenceKeys addObject:[matches nameMoral]];			
                }
            }
            			
		}
		
	}
	
	[request release];
	
	[dataSource addObjectsFromArray:references];
	[tableData addObjectsFromArray:dataSource];
	[tableDataImages addObjectsFromArray:icons];
	[tableDataKeys addObjectsFromArray:referenceKeys];
	[tableDataDetails addObjectsFromArray:details];
	
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
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    }
	
    [[cell textLabel] setText:[tableData objectAtIndex:indexPath.row]];
    [[cell textLabel] setFont:[UIFont systemFontOfSize:18.0]];
    [[cell textLabel] setNumberOfLines:1];
    [[cell textLabel] setAdjustsFontSizeToFitWidth:TRUE];    

    [[cell detailTextLabel] setText:[tableDataDetails objectAtIndex:indexPath.row]];
	
	NSMutableString *rowImageName = [[NSMutableString alloc] initWithString:[tableDataImages objectAtIndex:indexPath.row]];	

    if (referenceType != 4) {
        [rowImageName appendString:@"-sm"];
    }
    
    UIImage *rowImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:rowImageName ofType:@"png"]];
    [[cell imageView] setImage:rowImage];
    [rowImage release];
    [rowImageName release];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ReferenceDetailViewController *detailViewCont = [[ReferenceDetailViewController alloc] init];
	
	[prefs setInteger:referenceType forKey:@"referenceType"];
	[prefs setObject:[tableDataKeys objectAtIndex:indexPath.row] forKey:@"referenceKey"];
    
	[self.navigationController pushViewController:detailViewCont animated:YES];
	[detailViewCont release];
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
	[tableData removeAllObjects];
	[tableDataImages removeAllObjects];
	[tableDataDetails removeAllObjects];
	[tableDataKeys removeAllObjects];
	
	[tableData addObjectsFromArray:dataSource];
	[tableDataImages addObjectsFromArray:icons];
	[tableDataDetails addObjectsFromArray:details];
	[tableDataKeys addObjectsFromArray:referenceKeys];
	
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
			[tableData addObject:[references objectAtIndex:counter]];
			[tableDataImages addObject:[icons objectAtIndex:counter]];
			[tableDataDetails addObject:[details objectAtIndex:counter]];
			[tableDataKeys addObject:[referenceKeys objectAtIndex:counter]];
			
			//}
		}
		
		isFound = FALSE;
		counter++;
		[pool release];
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


- (void)dealloc {
    
    [searchedData release];
	[tableData release];
	[tableDataImages release];
	[tableDataDetails release];
	[tableDataKeys release];
	[dataSource release];	
	
	[references release], references = nil;
	[referenceKeys release], referenceKeys = nil;
	[details release], details = nil;
	[icons release], icons = nil;
    
    [super dealloc];
}


@end

