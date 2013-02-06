/**
Implementation:  Allow User to progress through story and build moral profile.
Prevent User from selecting Dilemmas/Action out of order.  Present selected choices.

@class DilemmaListViewController DilemmaListViewController.h
 */

#import "DilemmaListViewController.h"
#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "ConscienceView.h"
#import "DilemmaViewController.h"
#import "DilemmaDAO.h"
#import "UserDilemmaDAO.h"
#import "Moral.h"
#import "UserCollectableDAO.h"
#import "ConscienceHelpViewController.h"
#import "DilemmaTableViewCell.h"
#import "UIViewController+Screenshot.h"

@interface DilemmaListViewController () {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSUserDefaults *prefs;                  /**< serialized user settings/state retention */
	NSManagedObjectContext *context;		/**< Core Data context */
	
	IBOutlet UITableView *dilemmaListTableView;  	/**< table referenced by IB */
    
	NSMutableArray *dataSource;				/**< array for storing of Choices populated from previous view*/
	NSMutableArray *tableData;				/**< array for stored data displayed in table populated from dataSource */
	NSMutableArray *tableDataImages;		/**< array for stored data images */
	NSMutableArray *tableDataDetails;		/**< array for stored data details */
	NSMutableArray *tableDataKeys;			/**< array for stored data primary keys */
    NSMutableArray *tableDataTypes;			/**< array for stored data primary keys */
    
	NSMutableArray *searchedData;			/**< array for matched data from User search */
	NSMutableArray *choiceNames;			/**< these arrays house origial queried data to be re-entered into search results */
	NSMutableArray *choiceDisplayNames;		/**< name to be shown to User */
	NSMutableArray *choiceImages;			/**< image in tableRowCell */
	NSMutableArray *choiceDetails;          /**< tableRowCell detailText */
    NSMutableArray *choiceTypes;            /**< tableRowCell detailText */
    
	NSMutableDictionary *userChoices;		/**< dictionary to hold Dilemmas already completed by User */
	NSMutableDictionary *moralNames;		/**< dictionary to hold names of selected Morals */
    
    IBOutlet UIButton *previousButton;
	IBOutlet UISearchBar *dilemmaSearchBar;	/**< ui element for limiting choices in table */
	
	IBOutlet UIView *thoughtModalArea;
    int dilemmaCampaign;                    /**< current campaign to select correct dilemmas */
    
}

@property (nonatomic) IBOutlet UIImageView *previousScreen;

/**
 Load User data to determine which Dilemmas have already been completed
 */
- (void) loadUserData;

/**
 Load Dilemma data from Core Data for table
 */
- (void) retrieveAllDilemmas;

/**
 VERSION 2.0
 Allow limited ability to rechoose dilemma
 */
- (void) deleteChoice:(NSString *) choiceKey;

/**
 Remove entries from tableview that don't correspond to being searched
 */
- (void)filterResults:(NSString *) searchText;


@end

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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.previousScreen.image = _screenshot;

	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	prefs = [NSUserDefaults standardUserDefaults];
	context = [appDelegate.moralModelManager readWriteManagedObjectContext];
    
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
        
        ConscienceHelpViewController *conscienceHelpViewController = [[ConscienceHelpViewController alloc] init];
        conscienceHelpViewController.viewControllerClassName = NSStringFromClass([self class]);
        conscienceHelpViewController.isConscienceOnScreen = TRUE;
        conscienceHelpViewController.numberOfScreens = 1;
        conscienceHelpViewController.screenshot = [self takeScreenshot];
        [self presentModalViewController:conscienceHelpViewController animated:NO];
        
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

	DilemmaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DilemmaTableViewCell class])];

	if (cell == nil) {
      	cell = [[DilemmaTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([DilemmaTableViewCell class])];
	}

	[cell.textLabel setText:tableData[indexPath.row]];
	
	//cell image is surrounding utilized in dilemma
    NSMutableString *rowImageName = [[NSMutableString alloc]  initWithString:tableDataImages[indexPath.row]];
    [rowImageName appendString:@"-sm"];
    
    UIImage *rowImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:rowImageName ofType:@"png"]];
    //	[[cell imageView] setImage:[UIImage imageNamed:rowImageName]];
    cell.dilemmaImage = rowImage;


    /** @todo check for empty arrays */
	//Generate array of all keys in User Dictionary
	NSArray *allUserChoices = [[NSArray alloc] initWithArray:[userChoices allKeys]];
    
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
            [cell.detailTextLabel setText:tableDataDetails[indexPath.row]];
		} else {
            cell.currentCellState = DilemmaTableViewCellStateUnavailable;

            [cell.detailTextLabel setText:tableDataDetails[indexPath.row]];
            
		}
        
	}
    
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    //If User has already completed Dilemma, prevent User from selecting it
    NSArray *allUserChoices = [[NSArray alloc] initWithArray:[userChoices allKeys]];
    
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
                DilemmaViewController *dilemmaViewController = [[DilemmaViewController alloc] initWithNibName:@"DilemmaView" bundle:nil];
                dilemmaViewController.screenshot = [self takeScreenshot];
                [self.navigationController pushViewController:dilemmaViewController animated:NO];
            } else {
                DilemmaViewController *dilemmaViewController = [[DilemmaViewController alloc] initWithNibName:@"ConscienceActionView" bundle:nil];
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
//	NSInteger dilemmaCampaign;
    
	if (boolCheck != nil) {
		dilemmaCampaign = [prefs integerForKey:@"dilemmaCampaign"];
	}else {
		dilemmaCampaign = 0;
	}
    
	//Retrieve all available Dilemmas, sort by name, limit to currently requested Campaign
    DilemmaDAO *currentDilemmaDAO = [[DilemmaDAO alloc] init];

	NSString *dilemmaPredicate = [[NSString alloc] initWithFormat:@"dile-%d-", dilemmaCampaign];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"nameDilemma contains[cd] %@", dilemmaPredicate];

	if (dilemmaCampaign > 0) {
		[currentDilemmaDAO setPredicates:@[pred]];
	}
    
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameDilemma" ascending:YES];
	NSArray* sortDescriptors = @[sortDescriptor];
	[currentDilemmaDAO setSorts:sortDescriptors];
	
	NSArray *objects = [currentDilemmaDAO readAll];
    
	if ([objects count] == 0) {
		NSLog(@"No matches");
	} else {
		
        //Add dilemmas to list, concatenate two morals together for detail text
		for (Dilemma *match in objects){
            
			[choiceNames addObject:[match nameDilemma]];
			[choiceImages addObject:[match surrounding]];
			[choiceDisplayNames addObject:[match displayNameDilemma]];
            
            NSString *dilemmaDescription;
            
            if ([[[match moralChoiceA] nameMoral] isEqualToString:[[match moralChoiceB] nameMoral]]) {
                dilemmaDescription = [[NSString alloc] initWithString:[[match moralChoiceA] displayNameMoral]];
                isDilemma = FALSE;
            } else {
                dilemmaDescription = [[NSString alloc] initWithFormat:@"%@ vs. %@", [[match moralChoiceA] displayNameMoral], [[match moralChoiceB] displayNameMoral]];
                isDilemma = TRUE;
            }

            [moralNames setValue:[[match moralChoiceA] displayNameMoral] forKey:[[match moralChoiceA] nameMoral]];
            [moralNames setValue:[[match moralChoiceB] displayNameMoral] forKey:[[match moralChoiceB] nameMoral]];
            [choiceTypes addObject:@(isDilemma)];
			[choiceDetails addObject:dilemmaDescription];			
			
		}
	}
	
    
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
    
    UserDilemmaDAO *currentUserDilemmaDAO = [[UserDilemmaDAO alloc] init];
    
    NSString *dilemmaPredicate = [[NSString alloc] initWithFormat:@"dile-%d-", dilemmaCampaign];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"entryKey contains[cd] %@", dilemmaPredicate];
    
    currentUserDilemmaDAO.predicates = @[pred];
    
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"entryShortDescription" ascending:YES];
	NSArray* sortDescriptors = @[sortDescriptor];

    currentUserDilemmaDAO.sorts = sortDescriptors;
    
    NSArray *objects = [currentUserDilemmaDAO readAll];
    
	if ([objects count] == 0) {
		
        //User has not completed a single choice
        //populate array to prevent npe
        [userChoices setValue:@"" forKey:@"noUserEntries"];
        
	} else {
        
		//Populate dictionary with dilemmaName (key) and moral that was chosen
		for(UserDilemma * match in objects) {
			[userChoices setValue:match.entryLongDescription forKey:match.entryShortDescription];
            
		}
        
	}
	
    
}

/**
Implementation: Determine what effects to rollback from an already completed dilemma.  Delete dilemma
 */
- (void) deleteChoice:(NSString *) choiceKey {
	
	//Begin CoreData Retrieval			
    UserDilemmaDAO *currentUserDilemmaDAO = [[UserDilemmaDAO alloc] initWithKey:@""];
    
	if (choiceKey != nil) {
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"entryShortDescription == %@", choiceKey];
        currentUserDilemmaDAO.predicates = @[pred];
    }
	
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"entryCreationDate" ascending:YES];
	NSArray* sortDescriptors = @[sortDescriptor];
    currentUserDilemmaDAO.sorts = sortDescriptors;    
    UserDilemma *match = [currentUserDilemmaDAO read:@""];
    
    NSString *moralKey = [match entryLongDescription];
    
    //See if moral has been rewarded before
    //Cannot assume that first instance of UserDilemma implies no previous reward
    if ([appDelegate.userCollection containsObject:moralKey]) {
        
        
        UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:moralKey];

        UserCollectable *currentUserCollectable = [currentUserCollectableDAO read:@""];
        
        //Increase the moral's value
        float moralDecrease = [[currentUserCollectable collectableValue] floatValue];
        
        if (moralDecrease <= 1.0) {
            [context deleteObject:currentUserCollectable];
            
        } else {
            moralDecrease -= 1.0;
            [currentUserCollectable setValue:@(moralDecrease) forKey:@"collectableValue"];
        }
        
        
    }
    
    [currentUserDilemmaDAO delete:match];		
	
	
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
			NSRange searchRangeDetails = [[choiceDetails[counter] lowercaseString] rangeOfString:[searchText lowercaseString]];
        
			
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
				[tableDataImages addObject:choiceImages[counter]];
				[tableDataDetails addObject:choiceDetails[counter]];
				[tableDataKeys addObject:choiceNames[counter]];
                [tableDataTypes addObject:choiceTypes[counter]];

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

