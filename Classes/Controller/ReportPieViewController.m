/**
Implementation:  Present a GraphView of piechart type with accompanying data descriptors.
 
@class ReportPieViewController ReportPieViewController.h
 */

#import "ReportPieViewController.h"
#import "GraphView.h"
#import "UserChoice.h"
#import "Moral.h"
#import "ConscienceView.h"
#import "MoraLifeAppDelegate.h"


@implementation ReportPieViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //appDelegate needed to retrieve CoreData Context, prefs used to save form state
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
	context = [appDelegate managedObjectContext];
	prefs = [NSUserDefaults standardUserDefaults];
    
    //Position Conscience in lower-left of screen
    CGPoint centerPoint = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY);
	
	[thoughtModalArea addSubview:appDelegate.userConscienceView];
	
	appDelegate.userConscienceView.center = centerPoint;
    
    isGood = TRUE;
    isAlphabetical = FALSE;
    isAscending = FALSE;
        
    NSString *titleName =[[NSString alloc] initWithFormat:@"%@",NSStringFromClass([self class])];

    [self setTitle:NSLocalizedString(([NSString stringWithFormat:@"%@%dTitle", titleName, isGood]), @"Title For View Controller")];
    [moralTypeLabel setText:@"Virtue"];                
    [titleName release];
    
    reportValues = [[NSMutableDictionary alloc] init];
    moralDisplayNames = [[NSMutableDictionary alloc] init];
    moralImageNames = [[NSMutableDictionary alloc] init];
    moralColors = [[NSMutableDictionary alloc] init];
    pieValues = [[NSMutableArray alloc] init];
    pieColors = [[NSMutableArray alloc] init];
    reportNames = [[NSMutableArray alloc] init];
    moralNames = [[NSMutableArray alloc] init];
    
    [self generateGraph];

    

}

#pragma mark -
#pragma mark UI Interaction

/**
Implementation: Based upon User input, set flags for Moral type (Virtue/Vice), Sort Type (Name/Percentage) and Order Type (Asc/Des)
 */
-(IBAction)switchGraph:(id) sender{

	//Set boolean to determine which version of screen to present
	if ([sender isKindOfClass:[UIButton class]]) {
		
        UIButton *senderButton = sender;
		int choiceIndex = senderButton.tag;
        
        switch (choiceIndex) {
            case 0:{    
                if (isGood) {
                    isGood = FALSE;
                    [moralType setImage:[UIImage imageNamed:@"acc-pri-weapon-trident-sm.png"]];
                    [moralTypeLabel setText:@"Vice"];
                } else {
                    isGood = TRUE;
                    [moralType setImage:[UIImage imageNamed:@"acc-top-halo-sm.png"]];
                    [moralTypeLabel setText:@"Virtue"];                
                }
            } break;
            case 1:{    
                if (isAlphabetical) {
                    isAlphabetical = FALSE;
                    [moralListButton setTitle:@"%" forState: UIControlStateNormal];
                } else {
                    isAlphabetical = TRUE;
                    [moralListButton setTitle:@"A" forState: UIControlStateNormal];
                }
            }
                break;
            case 2:{    
                if (isAscending) {
                    isAscending = FALSE;
                    [moralSortButton setTitle:@"Des" forState: UIControlStateNormal];
                } else {
                    isAscending = TRUE;
                    [moralSortButton setTitle:@"Asc" forState: UIControlStateNormal];
                    
                }
            }
                break;                 
            default:
                break;
        }

        [self generateGraph];
    
    }
}

/**
Implementation: Pop UIViewController from navigation stack
 */
-(IBAction)returnToHome:(id) sender{
	
	[self.navigationController popViewControllerAnimated:NO];
	
}

#pragma mark -
#pragma mark Data Manipulation

/**
Implementation: Retrieve all UserChoice entries, retrieve Morals for each, build color for each Moral
 */
- (void) retrieveChoices{
	
	//Reset data    
 	[reportValues removeAllObjects];
	[moralDisplayNames removeAllObjects];
	[moralImageNames removeAllObjects];
	[pieColors removeAllObjects];
	[pieValues removeAllObjects];
	[reportNames removeAllObjects];
	[moralNames removeAllObjects];
    
	//Begin CoreData Retrieval
	NSError *outError;
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserChoice" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
    
	//Retrieve virtue or vice
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"entryIsGood == %@", [NSNumber numberWithBool:isGood]];
	[request setPredicate:pred];
	
	NSArray *objects = [context executeFetchRequest:request error:&outError];
    
	if ([objects count] == 0) {
		NSLog(@"No matches");

	} else {
        
		float currentValue = 0.0;
        
		//Iterate through every UserChoice combining each entry
		for (UserChoice *match in objects){
            
			NSNumber *choiceWeightTemp = [reportValues objectForKey:[match choiceMoral]];
      
			//See if a Choice has already been entered for particular Moral      
            	if (choiceWeightTemp != nil) {
            	   	currentValue = [choiceWeightTemp floatValue];
            	} else {
	                	currentValue = 0.0;
            	}
//            	currentValue = [[reportValues objectForKey:[match choiceMoral]] floatValue];

			//Keep running of absolute value of Morals for percentage calculation
			//Vices are stored as negative
	            runningTotal += fabsf([[match choiceWeight] floatValue]);
      	      currentValue += fabsf([[match choiceWeight] floatValue]);

	            [reportValues setValue:[NSNumber numberWithFloat:currentValue] forKey:[match choiceMoral]];

      	      NSEntityDescription *entityAssetDesc2 = [NSEntityDescription entityForName:@"Moral" inManagedObjectContext:context];
            	NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
	            [request2 setEntity:entityAssetDesc2];
            
      	      NSString *value = [match choiceMoral];
            	NSPredicate *pred = [NSPredicate predicateWithFormat:@"nameMoral == %@", value];
	            [request2 setPredicate:pred];
            
      	      NSArray *objects = [context executeFetchRequest:request2 error:&outError];
            
	            if ([objects count] == 0) {
      	          NSLog(@"No matches");
            	} else {
                
				NSString *moralDisplayName = [[NSString alloc] initWithString:[[objects objectAtIndex:0] displayNameMoral]];
				NSString *moralName = [[NSString alloc] initWithString:[[objects objectAtIndex:0] nameMoral]];
				NSString *moralImageName = [[NSString alloc] initWithString:[[objects objectAtIndex:0] imageNameMoral]];
				NSString *moralColor = [[NSString alloc] initWithString:[[objects objectAtIndex:0] colorMoral]];
                
				//Moral color stored as hex, must convert to CGColorRef
				NSScanner *fillColorScanner = [[NSScanner alloc] initWithString:moralColor];
                
				unsigned fillColorInt;
                
				[fillColorScanner scanHexInt:&fillColorInt]; 
                
				//Bitshift each position to get 1-255 value
				//Divide value by 255 to get CGColorRef compatible value
				CGFloat red   = ((fillColorInt & 0xFF0000) >> 16) / 255.0f;
				CGFloat green = ((fillColorInt & 0x00FF00) >>  8) / 255.0f;
				CGFloat blue  =  (fillColorInt & 0x0000FF) / 255.0f;
                
				UIColor *moralColorTemp = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0];
                                
				[moralDisplayNames setValue:moralDisplayName forKey:moralName];
				[moralImageNames setValue:moralImageName forKey:moralName];
				[moralColors setValue:moralColorTemp forKey:moralName];
                
				[moralColorTemp release];
				[fillColorScanner release];
                
				[moralDisplayName release];
				[moralName release];
				[moralImageName release];
				[moralColor release];
			}
            
			[request2 release];

	        }
		
	}
	
	[request release];
	
}

/**
Implementation:  Transform UserData entries of all Virtues/Vices into summation of weights for each Moral.
Sum each summation of Moral into total of Virtue/Vice, then calculate percentage of each entry as percentage of whole
Convert percentage to degrees out of 360.  Send values and colors to GraphView
@todo split off color generation
 */
- (void) generateGraph {
	//Reset running total before getting Choices
	runningTotal = 0.0;
    
	//Get all choices
	[self retrieveChoices];
	    
	float moralPercentage = 0.0;
    
	//Create raw, sorted and reversed versions of the keys for sorting/ordering options
	NSArray *reportKeys = [reportValues allKeys];
	NSArray *sortedPercentages = [reportValues keysSortedByValueUsingSelector:@selector(compare:)];
	NSArray* reversedPercentages = [[sortedPercentages reverseObjectEnumerator] allObjects];

	NSArray *sortedKeys = [reportKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	NSArray *reversedKeys = [[sortedKeys reverseObjectEnumerator] allObjects];

	NSArray *iteratorArray;
    
	//Determine sorting and ordering
	if (isAlphabetical) {
        
		if (isAscending) {
	            iteratorArray = reversedKeys;
      	} else {
			iteratorArray = sortedKeys;
		}
	} else {
		if (isAscending) {
            	iteratorArray = sortedPercentages;
      	} else {
	            iteratorArray = reversedPercentages;
		}
	}
    
	//Iterate through every User selection
	for (NSString *moralInstance in iteratorArray) {

		//Determine percentage of each entry in regards to every entry
      	moralPercentage = ([[reportValues valueForKey:moralInstance] floatValue]/runningTotal);

		//Convert percentage to degrees
		[pieValues addObject:[NSNumber numberWithFloat:(moralPercentage * 360)]];

		//Add report names for relation to table
		[reportNames addObject:[NSString stringWithFormat:@"%@: %.2f%%", [moralDisplayNames objectForKey:moralInstance], moralPercentage * 100]];
        
		[pieColors addObject:[moralColors objectForKey:moralInstance]];

		//Don't add Moral if it already exists in the display list        
		if (![moralNames containsObject:moralInstance]) {
			[moralNames addObject:moralInstance];
		}

	}
    
	//Account for no User entries
	if ([iteratorArray count] == 0) {

		if (isGood) {
			[reportNames addObject:@"No Moral Entries!"];
		} else {
			[reportNames addObject:@"No Immoral Entries!"];
		}
        
		[pieColors addObject:[UIColor redColor]];
	}
    

	//Create blank pie chart
	GraphView *graph = [[GraphView alloc] initWithFrame:CGRectMake(0.0, 0.0, 240, 240)];

	//Populate Graph with entries    
	[graph setPieValues:pieValues];
	[graph setPieColors:pieColors];

	//Add new graph to view
	[thoughtModalArea addSubview:graph];
	[graph release];
    
	//Refresh tableview with new data
	[reportTableView reloadData];

}


/**
Generate random list of Colors that differ enough to be displayed consecutively
-(void)generatePieColors{
        
    CGFloat colorDecrement1 = 1.0;
    CGFloat colorDecrement2 = 1.0;
    CGFloat colorDecrement3 = 1.0;
    
    int randomSwitch1 = 0;
    int randomSwitch2 = 0;
    int randomSwitch3 = 0;
    CGFloat randomDifference1 = 0.0;
    CGFloat randomDifference2 = 0.0;
    CGFloat randomDifference3 = 0.0;
    
    for (int i = 0; i < [pieValues count]; i++) {
        
        randomSwitch1 = arc4random() % 100;
        randomSwitch2 = arc4random() % 100;
        randomSwitch3 = arc4random() % 100;
        
        randomDifference1 = randomSwitch1/100.0;
        randomDifference2 = randomSwitch2/100.0;
        randomDifference3 = randomSwitch3/100.0;
        
        
        switch (i%3) {
            case 0:
                [pieColors addObject:[UIColor colorWithRed:colorDecrement1 green:randomDifference2 blue:randomDifference3 alpha:1]];
                if (colorDecrement1 > 0.2){ colorDecrement1 -= 0.2;} else { colorDecrement1 = 1;};
                break;
            case 1:
                [pieColors addObject:[UIColor colorWithRed:randomDifference1 green:colorDecrement2 blue:randomDifference3 alpha:1]];
                if (colorDecrement2 > 0.2){ colorDecrement2 -= 0.2;} else { colorDecrement2 = 1;};
                break;
            case 2:
                [pieColors addObject:[UIColor colorWithRed:randomDifference1 green:randomDifference2 blue:colorDecrement3 alpha:1]];
                if (colorDecrement3 > 0.2){ colorDecrement3 -= 0.2;} else { colorDecrement3 = 1;};
                break;                
            default:
                break;
        }
        
    }
}
*/

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    return [pieValues count];
    return [reportNames count];

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *cellIdentifier = @"Reports";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
		
    }
	
	[[cell textLabel] setText:[reportNames objectAtIndex:indexPath.row]];
    
    [[cell textLabel] setTextColor:[pieColors objectAtIndex:indexPath.row]];
    [[cell textLabel] setShadowColor:[UIColor lightGrayColor]];
    [[cell textLabel] setShadowOffset:CGSizeMake(1, 1)];

    [[cell textLabel] setFont:[UIFont systemFontOfSize:18.0]];
    [[cell textLabel] setNumberOfLines:1];
    [[cell textLabel] setAdjustsFontSizeToFitWidth:TRUE];
    
    if ([moralNames count] > 0) {
        
        NSMutableString *rowImageName = [[NSMutableString alloc] initWithString:[moralImageNames objectForKey:[moralNames objectAtIndex:indexPath.row]]];
        [rowImageName appendString:@".png"];
        [[cell imageView] setImage:[UIImage imageNamed:rowImageName]];
        [rowImageName release];
        
    } else {
        [[cell imageView] setImage:[UIImage imageNamed:@"card-doubt.png"]];
        [[cell textLabel] setTextAlignment:UITextAlignmentCenter];

    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
    return cell;
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {

    [reportValues release];
    [moralDisplayNames release];
    [moralImageNames release];
    [moralColors release];
    [pieColors release];
    [pieValues release];
    [reportNames release];
    [moralNames release];
    
    [super dealloc];


}


@end
