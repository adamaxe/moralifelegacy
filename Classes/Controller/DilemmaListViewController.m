/**
Implementation:  Allow User to progress through story and build moral profile.
Prevent User from selecting Dilemmas/Action out of order.  Present selected choices.

@class DilemmaListViewController DilemmaListViewController.h
 */

#import "DilemmaListViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ConscienceView.h"
#import "DilemmaViewController.h"
#import "Dilemma.h"
#import "UserDilemma.h"
#import "Moral.h"
#import "UserCollectable.h"
#import "ConscienceActionViewController.h"

@implementation DilemmaListViewController

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	prefs = [NSUserDefaults standardUserDefaults];
	context = [appDelegate managedObjectContext];
    
	//Setup permanent holders, table does not key on these, it keys on tabledata which is affected by searchbar
	//tabledatas are reloaded from these master arrays
	choiceNames = [[NSMutableArray alloc] init];			
	choiceImages = [[NSMutableArray alloc] init];			
	choiceDetails = [[NSMutableArray alloc] init];
    choiceTypes = [[NSMutableArray alloc] init];
	choiceDisplayNames = [[NSMutableArray alloc] init];
	userChoices = [[NSMutableDictionary alloc] init];
	moralNames = [[NSMutableDictionary alloc] init];

    
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
	CGPoint centerPoint = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY);
	
	[thoughtModalArea addSubview:appDelegate.userConscienceView];
	
	appDelegate.userConscienceView.center = centerPoint;
	
	//The scrollbars won't flash unless the tableview is long enough.
	[dilemmaListTableView flashScrollIndicators];
    
	// Unselect the selected row if any
	NSIndexPath* selection = [dilemmaListTableView indexPathForSelectedRow];
	
	if (selection)
		[dilemmaListTableView deselectRowAtIndexPath:selection animated:YES];
	
	[dilemmaListTableView reloadData];

}

-(void)viewDidAppear:(BOOL)animated{
    
    int nextRow = [userChoices count] - 1;
    
    [dilemmaListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:nextRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
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
Implementation: Signals User desire to return to ConscienceModalViewController
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
	static NSString *cellIdentifier = @"moralIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
		
	}
    
	[[cell textLabel] setText:[tableData objectAtIndex:indexPath.row]];
	
	//cell image is surrounding utilized in dilemma
    
    NSMutableString *rowImageName = [[NSMutableString alloc]  initWithString:[tableDataImages objectAtIndex:indexPath.row]];
    [rowImageName appendString:@"-sm"];
    
    UIImage *rowImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:rowImageName ofType:@"png"]];
    //	[[cell imageView] setImage:[UIImage imageNamed:rowImageName]];
    [[cell imageView] setImage:rowImage];
    [rowImage release];
    [rowImageName release];
    
    

	//Setup cell text visuals
	[[cell detailTextLabel] setTextColor:[UIColor colorWithRed:0.0/255.0 green:176.0/255.0 blue:0.0/255.0 alpha:1]];
	[[cell textLabel] setFont:[UIFont systemFontOfSize:16.0]];
	[[cell textLabel] setNumberOfLines:1];
	[[cell textLabel] setAdjustsFontSizeToFitWidth:TRUE]; 
	[[cell detailTextLabel] setAdjustsFontSizeToFitWidth:TRUE];   


	//Generate array of all keys in User Dictionary
	NSArray *allUserChoices = [[NSArray alloc] initWithArray:[userChoices allKeys]];
    
	//Determine if user has already completed particular dilemma
	//If so, display checkmark and display which moral was chosen
//    if ([allUserChoices containsObject:[tableDataKeys objectAtIndex:indexPath.row]]) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//		[[cell detailTextLabel] setTextColor:[UIColor colorWithRed:200.0/255.0 green:25.0/255.0 blue:2.0/255.0 alpha:1]];
//        
//        NSString *moralName = [moralNames valueForKey:[userChoices valueForKey:[tableDataKeys objectAtIndex:indexPath.row]]];
//        [[cell detailTextLabel] setText:moralName];
//        
//    }else {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//		cell.selectionStyle = UITableViewCellSelectionStyleGray;
//		[[cell detailTextLabel] setTextColor:[UIColor colorWithRed:0.0/255.0 green:176.0/255.0 blue:0.0/255.0 alpha:1]];
//        [[cell detailTextLabel] setText:[tableDataDetails objectAtIndex:indexPath.row]];
//
//    }
    
	int previousRow = indexPath.row;
    
	BOOL isSelectable = FALSE;
    
	if (previousRow > 0) {
		previousRow = indexPath.row - 1;
        
		if ([allUserChoices containsObject:[tableDataKeys objectAtIndex:previousRow]]) {
			isSelectable = TRUE;
		}
	} else {
       
		if (![allUserChoices containsObject:[tableDataKeys objectAtIndex:indexPath.row]]) {
			isSelectable = TRUE;
		}
	}
        
	//Determine if user has already completed particular dilemma
	//If so, display checkmark and display which moral was chosen
	if ([allUserChoices containsObject:[tableDataKeys objectAtIndex:indexPath.row]]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [[cell textLabel] setTextColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1]];
		[[cell detailTextLabel] setTextColor:[UIColor colorWithRed:200.0/255.0 green:25.0/255.0 blue:2.0/255.0 alpha:1]];
        
		NSString *moralName = [moralNames valueForKey:[userChoices valueForKey:[tableDataKeys objectAtIndex:indexPath.row]]];
		[[cell detailTextLabel] setText:moralName];
		[[cell textLabel] setFont:[UIFont systemFontOfSize:12.0]];
	} else {
        
		if (isSelectable) {
            
            	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            	cell.selectionStyle = UITableViewCellSelectionStyleGray;
            	[[cell textLabel] setTextColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1]];
            	[[cell detailTextLabel] setTextColor:[UIColor colorWithRed:0.0/255.0 green:176.0/255.0 blue:0.0/255.0 alpha:1]];
            	[[cell detailTextLabel] setText:[tableDataDetails objectAtIndex:indexPath.row]];
		} else {
        
                [[cell textLabel] setTextColor:[UIColor colorWithRed:100.0/255.0 green:150.00/255.0 blue:100.0/255.0 alpha:1]];
            	[[cell detailTextLabel] setTextColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1]];

            	cell.accessoryType = UITableViewCellAccessoryNone;
            	cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            	[[cell detailTextLabel] setTextColor:[UIColor colorWithRed:0.0/255.0 green:176.0/255.0 blue:0.0/255.0 alpha:1]];
            	[[cell detailTextLabel] setText:[tableDataDetails objectAtIndex:indexPath.row]]; 
            
		}
        
	}
    
	[allUserChoices release];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    //If User has already completed Dilemma, prevent User from selecting it
    NSArray *allUserChoices = [[NSArray alloc] initWithArray:[userChoices allKeys]];
    
    int previousRow = indexPath.row;
    
    BOOL isSelectable = FALSE;
    
    if (previousRow > 0) {
        previousRow = indexPath.row - 1;
        
        if ([allUserChoices containsObject:[tableDataKeys objectAtIndex:previousRow]]) {
            isSelectable = TRUE;
        }
    } else {
        
        if (![allUserChoices containsObject:[tableDataKeys objectAtIndex:indexPath.row]]) {
            isSelectable = TRUE;
        }
    }
    
    if (![allUserChoices containsObject:[tableDataKeys objectAtIndex:indexPath.row]]) {
        
        if (isSelectable) {
    
            NSMutableString *selectedRowKey = [[NSMutableString alloc] initWithString:[tableDataKeys objectAtIndex:indexPath.row]];
            
            [prefs setObject:selectedRowKey forKey:@"dilemmaKey"];
            
            [selectedRowKey release];

            //if ([[tableDataDetails objectAtIndex:indexPath.row] rangeOfString:@"vs. "].location != NSNotFound){
            if ([[tableDataTypes objectAtIndex:indexPath.row] boolValue]){
                DilemmaViewController *dilemmaViewCont = [[DilemmaViewController alloc] initWithNibName:@"DilemmaView" bundle:[NSBundle mainBundle]];
                [self.navigationController pushViewController:dilemmaViewCont animated:NO];
                [dilemmaViewCont release];
            } else {
                ConscienceActionViewController *actionViewCont = [[ConscienceActionViewController alloc] initWithNibName:@"ConscienceActionView" bundle:[NSBundle mainBundle]];
                [self.navigationController pushViewController:actionViewCont animated:NO];
                [actionViewCont release];
            }
        }
        
    }
    
    [allUserChoices release];
	
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
	[tableDataImages addObjectsFromArray:choiceImages];
	[tableDataDetails addObjectsFromArray:choiceDetails];
	[tableDataKeys addObjectsFromArray:choiceNames];
    [tableDataTypes addObjectsFromArray:choiceTypes];

    
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
	[choiceNames removeAllObjects];			
	[choiceImages removeAllObjects];	
	[choiceDetails removeAllObjects];	
	[choiceDisplayNames removeAllObjects];	
    [choiceTypes removeAllObjects];	
	[userChoices removeAllObjects];	
    
	[dataSource removeAllObjects];	
	[searchedData removeAllObjects];	
	[tableData removeAllObjects];	
	[tableDataImages removeAllObjects];	
	[tableDataDetails removeAllObjects];	
	[tableDataKeys removeAllObjects];
    [tableDataTypes removeAllObjects];

    BOOL isDilemma = TRUE;
	NSObject *boolCheck = [prefs objectForKey:@"dilemmaCampaign"];
	NSInteger dilemmaCampaign;
    
	if (boolCheck != nil) {
		dilemmaCampaign = [prefs integerForKey:@"dilemmaCampaign"];
	}else {
		dilemmaCampaign = 0;
	}
    
	//Begin CoreData Retrieval			
	NSError *outError;
	
	//Retrieve all available Dilemmas, sort by name
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"Dilemma" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
    
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"campaign == %d", dilemmaCampaign];

	if (dilemmaCampaign > 0) {
		[request setPredicate:pred];
	}
    
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameDilemma" ascending:YES];
	NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	NSArray *objects = [context executeFetchRequest:request error:&outError];
    
	if ([objects count] == 0) {
		NSLog(@"No matches");
	} else {
		
        //Add dilemmas to list, concatenate two morals together for detail text
		for (Dilemma *matches in objects){
			[choiceNames addObject:[matches nameDilemma]];
			[choiceImages addObject:[matches surrounding]];
			[choiceDisplayNames addObject:[matches displayNameDilemma]];
            
            NSString *dilemmaDescription;
            
            if ([[[matches moralChoiceA] nameMoral] isEqualToString:[[matches moralChoiceB] nameMoral]]) {
                dilemmaDescription = [[NSString alloc] initWithString:[[matches moralChoiceA] displayNameMoral]];
                isDilemma = FALSE;
            } else {
                dilemmaDescription = [[NSString alloc] initWithFormat:@"%@ vs. %@", [[matches moralChoiceA] displayNameMoral], [[matches moralChoiceB] displayNameMoral]];
                isDilemma = TRUE;
            }

            [moralNames setValue:[[matches moralChoiceA] displayNameMoral] forKey:[[matches moralChoiceA] nameMoral]];
            [moralNames setValue:[[matches moralChoiceB] displayNameMoral] forKey:[[matches moralChoiceB] nameMoral]];
            [choiceTypes addObject:[NSNumber numberWithBool:isDilemma]];
			[choiceDetails addObject:dilemmaDescription];			
            [dilemmaDescription release];
			
		}
	}
	
	[request release];
    
	[self loadUserData];
	//End CoreData Retrieval
    
	[dataSource addObjectsFromArray:choiceDisplayNames];
	[tableData addObjectsFromArray:dataSource];
	[tableDataImages addObjectsFromArray:choiceImages];
	[tableDataKeys addObjectsFromArray:choiceNames];
	[tableDataDetails addObjectsFromArray:choiceDetails];
    [tableDataTypes addObjectsFromArray:choiceTypes];

	[dilemmaListTableView reloadData];
    
}

/**
Implementation: Load User data to determine which Dilemmas have already been completed
 */
- (void) loadUserData {
	[userChoices removeAllObjects];
    
	//Retrieve list of Dilemmas already completed by User, sort by dilemma name (stored in entryShortDescription)
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserDilemma" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
    
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"entryShortDescription" ascending:YES];
	NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
    
	//We don't need entire UserDilemma ManagedObject, we only need short/longdescriptions
	//entryShortDescription = dilemmaName, entryLongDescription = moralName that was chosen
	[request setResultType:NSDictionaryResultType];
	[request setPropertiesToFetch:[NSArray arrayWithObjects:@"entryShortDescription", @"entryLongDescription", nil]];
    
	// Execute the fetch
	NSError *error = nil;
	NSArray *objects = [context executeFetchRequest:request error:&error];
    
	if ([objects count] == 0) {
		
        //User has not completed a single choice
        //populate array to prevent npe
        NSLog(@"No matches");
        [userChoices setValue:@"" forKey:@"noUserEntries"];
        
	} else {
        
		//Populate dictionary with dilemmaName (key) and moral that was chosen
		for(NSDictionary* match in objects) {
			[userChoices setValue:[match objectForKey:@"entryLongDescription"] forKey:[match objectForKey:@"entryShortDescription"]];
            
		}
        
	}
	
	[request release];
}

/**
Implementation: Determine what effects to rollback from an already completed dilemma.  Delete dilemma
 */
- (void) deleteChoice:(NSString *) choiceKey {
	
	//Begin CoreData Retrieval			
	NSError *outError = nil;
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserDilemma" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
	
	if (choiceKey != nil) {
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"entryShortDescription == %@", choiceKey];
		[request setPredicate:pred];
	}
	
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"entryCreationDate" ascending:YES];
	NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	NSArray *objects = [context executeFetchRequest:request error:&outError];
	
	if ([objects count] == 0) {
		NSLog(@"No matches");
	} else {
		
		UserDilemma *match = [objects objectAtIndex:0];
        
        NSString *moralKey = [match entryLongDescription];
		
        //See if moral has been rewarded before
        //Cannot assume that first instance of UserDilemma implies no previous reward
        if ([appDelegate.userCollection containsObject:moralKey]) {
            
            NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserCollectable" inManagedObjectContext:context];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityAssetDesc];
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"collectableName == %@", moralKey];
            [request setPredicate:pred];
            
            NSArray *objects = [context executeFetchRequest:request error:&outError];
            UserCollectable *currentUserCollectable = [objects objectAtIndex:0];
            
            //Increase the moral's value
            float moralDecrease = [[currentUserCollectable collectableValue] floatValue];
            NSLog(@"moral value:%f", moralDecrease);
            if (moralDecrease <= 1.0) {
                [context deleteObject:currentUserCollectable];
                NSLog(@"should be deleted");
                
            } else {
                moralDecrease -= 1.0;
                [currentUserCollectable setValue:[NSNumber numberWithFloat:moralDecrease] forKey:@"collectableValue"];
            }
                        
            [request release];
            
            
        }
        
		[context deleteObject:match];		
		
	}
	
	[context save:&outError];
	[context reset];
    
	if (outError != nil) {
		NSLog(@"save:%@", outError);
	}
	
	[request release];
	
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
            [tableDataTypes addObject:[choiceTypes objectAtIndex:counter]];

			//}
		}
		
		isFound = FALSE;
		counter++;
		[pool release];
	}
	
	[dilemmaListTableView reloadData];
    
}

#pragma mark -
#pragma mark Table view edit

/** 
Implementation - Delete
@todo v2.0 determine a good path for Dilemma retries 
 */

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //Generate array of all keys in User Dictionary
//    NSArray *allUserChoices = [[NSArray alloc] initWithArray:[userChoices allKeys]];
//    BOOL isDeletable = FALSE;
//    
//    //If User has not completed dilemma, disallow deletion
//    if ([allUserChoices containsObject:[tableDataKeys objectAtIndex:indexPath.row]]) {
//        isDeletable = TRUE;
//    } 
//    
//    [allUserChoices release];
//    
//    if (isDeletable) {
//        return UITableViewCellEditingStyleDelete;
//    } else {
//        return UITableViewCellEditingStyleNone;
//    }
//    
//    
//}
//
//-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	
//	NSMutableString *selectedRow = [[NSMutableString alloc] initWithString:[tableDataKeys objectAtIndex:indexPath.row]];
//	
//	[self deleteChoice:selectedRow];
//	
//	[selectedRow release];
//	
//	[self retrieveAllDilemmas];
//	[dilemmaListTableView reloadData];
//	
//}

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
    [tableDataTypes release];
	[dataSource release];
	[choiceNames release];
	[choiceImages release];
	[choiceDetails release];
    [choiceTypes release];
	[choiceDisplayNames release];
	[userChoices release];
	[moralNames release];
	[super dealloc];
}

@end

