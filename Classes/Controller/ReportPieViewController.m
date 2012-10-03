/**
Implementation:  Present a GraphView of piechart type with accompanying data descriptors.
 
@class ReportPieViewController ReportPieViewController.h
 */

#import "ReportPieViewController.h"
#import "GraphView.h"
#import "ConscienceView.h"
#import "MoraLifeAppDelegate.h"
#import "ConscienceHelpViewController.h"
#import "ViewControllerLocalization.h"
#import "ReportPieModel.h"

@interface ReportPieViewController () <ViewControllerLocalization> {
    
	MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */

	IBOutlet UIView *thoughtModalArea;
	
	IBOutlet UIImageView *moralType;		/**< image to depict current status of view (Virtue/Vice) */
	IBOutlet UIButton *moralTypeButton;		/**< button to switch between Virtue/Vice */
	IBOutlet UIButton *moralSortButton;		/**< button to toggle sort type (Name/Weight) */
	IBOutlet UIButton *moralOrderButton;		/**< button to toggle order type (Asc/Des) */
    IBOutlet UIButton *previousButton;
	IBOutlet UITableView *reportTableView;	/**< table to house results */
    IBOutlet UILabel *moralTypeLabel;       /**< is report virtue or vice */
}

@property (nonatomic, strong) ReportPieModel *reportPieModel;
@property (nonatomic, assign) BOOL isGood;		/**< is current view for Virtues or Vices */
@property (nonatomic, assign) BOOL isAscending;		/**< current order type */
@property (nonatomic, assign) BOOL isAlphabetical;	/**< current sort type */


/**
 Convert UserData into graphable data, create a GraphView
 */
- (void) generateGraph;

@end

@implementation ReportPieViewController

- (id)initWithModel:(ReportPieModel *)reportPieModel {
    self = [super init];

    if (self) {
        _reportPieModel = reportPieModel;
        _isGood = TRUE;
        _isAlphabetical = FALSE;
        _isAscending = FALSE;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //appDelegate needed to place Conscience on screen
	appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
        
    
    [self generateGraph];
    
    [self localizeUI];    

}

-(void)viewDidAppear:(BOOL)animated {
    
	//Present help screen after a split second
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    //Position Conscience in lower-left of screen
    CGPoint centerPoint = CGPointMake(kConscienceLowerLeftX, kConscienceLowerLeftY);

    //Add User Conscience to view
    [self.view addSubview:appDelegate.userConscienceView];
    
    appDelegate.userConscienceView.center = centerPoint;

    
}

#pragma mark -
#pragma mark Overloaded Setters

/* Whenever this isGood is changed from UI, model is informed of change */
- (void) setIsGood:(BOOL) isGood {
    if (_isGood != isGood) {
        _isGood = isGood;
        self.reportPieModel.isGood = isGood;
    }
}

/* Whenever this isAlphabetical is changed from UI, model is informed of change */
- (void) setIsAlphabetical:(BOOL) isAlphabetical {
    if (_isAlphabetical != isAlphabetical) {
        _isAlphabetical = isAlphabetical;
        self.reportPieModel.isAlphabetical = isAlphabetical;
    }
}

/* Whenever this isAscending is changed from UI, model is informed of change */
- (void) setIsAscending:(BOOL)isAscending {
    if (_isAscending != isAscending) {
        _isAscending = isAscending;
        self.reportPieModel.isAscending = isAscending;
    }
}

#pragma mark -
#pragma mark UI Interaction

/**
 Implementation: Show an initial help screen if this is the User's first use of the screen.  Set a User Default after help screen is presented.  Launch a ConscienceHelpViewController and populate a localized help message.
 */
-(void)showInitialHelpScreen {
    
    //If this is the first time that the app, then show the intro
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject *firstPieCheck = [prefs objectForKey:@"firstPie"];
    
    if (firstPieCheck == nil) {
        
        ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] init];
        [conscienceHelpViewCont setViewControllerClassName:NSStringFromClass([self class])];        
		[conscienceHelpViewCont setIsConscienceOnScreen:TRUE];
        [conscienceHelpViewCont setHelpVersion:0];
		[self presentModalViewController:conscienceHelpViewCont animated:NO];
        
        [prefs setBool:FALSE forKey:@"firstPie"];
        
    }
}


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
                if (self.isGood) {
                    self.isGood = FALSE;
                    [moralType setImage:[UIImage imageNamed:@"acc-pri-weapon-trident-sm.png"]];
                    [moralTypeLabel setText:@"Vice"];
                } else {
                    self.isGood = TRUE;
                    [moralType setImage:[UIImage imageNamed:@"acc-top-halo-sm.png"]];
                    [moralTypeLabel setText:@"Virtue"];                
                }
            } break;
            case 1:{    
                if (self.isAlphabetical) {
                    self.isAlphabetical = FALSE;
                    [moralSortButton setTitle:@"%" forState: UIControlStateNormal];
                } else {
                    self.isAlphabetical = TRUE;
                    [moralSortButton setTitle:@"A" forState: UIControlStateNormal];
                }
            }
                break;
            case 2:{    
                if (self.isAscending) {
                    self.isAscending = FALSE;
                    [moralOrderButton setTitle:@"Des" forState: UIControlStateNormal];
                } else {
                    self.isAscending = TRUE;
                    [moralOrderButton setTitle:@"Asc" forState: UIControlStateNormal];
                    
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

/**
Implementation:  Transform UserData entries of all Virtues/Vices into summation of weights for each Moral.
Sum each summation of Moral into total of Virtue/Vice, then calculate percentage of each entry as percentage of whole
Convert percentage to degrees out of 360.  Send values and colors to GraphView
@todo needs to be optimized.  Don't generate sorted and reversed keys without need.  Check for empty first.
 */
- (void) generateGraph {    

	//Create blank pie chart
	GraphView *graph = [[GraphView alloc] initWithFrame:CGRectMake(0.0, 0.0, 240, 240)];

	//Populate Graph with entries    
	[graph setPieValues:self.reportPieModel.pieValues];
	[graph setPieColors:self.reportPieModel.pieColors];

	//Add new graph to view
	[thoughtModalArea addSubview:graph];
    
	//Refresh tableview with new data
	[reportTableView reloadData];

}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.reportPieModel.reportNames count];

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *cellIdentifier = @"Reports";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
		
    }
	
	[[cell textLabel] setText:[self.reportPieModel.reportNames objectAtIndex:indexPath.row]];
    
    [[cell textLabel] setTextColor:[self.reportPieModel.pieColors objectAtIndex:indexPath.row]];
    [[cell textLabel] setShadowColor:[UIColor lightGrayColor]];
    [[cell textLabel] setShadowOffset:CGSizeMake(1, 1)];

    [[cell textLabel] setFont:[UIFont systemFontOfSize:18.0]];
    [[cell textLabel] setNumberOfLines:1];
    [[cell textLabel] setAdjustsFontSizeToFitWidth:TRUE];
    
    if ([self.reportPieModel.moralNames count] > 0) {
        
        NSMutableString *rowImageName = [[NSMutableString alloc] initWithString:[self.reportPieModel.moralImageNames objectForKey:[self.reportPieModel.moralNames objectAtIndex:indexPath.row]]];
        [rowImageName appendString:@".png"];
        [[cell imageView] setImage:[UIImage imageNamed:rowImageName]];
        
    } else {
        [[cell imageView] setImage:[UIImage imageNamed:@"card-doubt.png"]];
        [[cell textLabel] setTextAlignment:UITextAlignmentCenter];

    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
    return cell;
}


#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    
    NSString *titleName =[[NSString alloc] initWithFormat:@"%@",NSStringFromClass([self class])];
    
    [self setTitle:NSLocalizedString(([NSString stringWithFormat:@"%@%dTitle", titleName, self.isGood]), @"Title For View Controller")];
    [moralTypeLabel setText:@"Virtue"];                
    
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint", @"Hint for previous button");
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",@"Label for previous button");
    
    moralTypeButton.accessibilityHint = NSLocalizedString(@"ReportScreenMoralTypeButtonHint", @"Hint for moralTypeButton");
	moralTypeButton.accessibilityLabel =  NSLocalizedString(@"ReportScreenMoralTypeButtonLabel",@"Label for moralTypeButton");

    moralSortButton.accessibilityHint = NSLocalizedString(@"ReportScreenMoralSortButtonHint", @"Hint for moralSortButton");
	moralSortButton.accessibilityLabel =  NSLocalizedString(@"ReportScreenMoralSortButtonLabel",@"Label for moralSortButton");

    moralOrderButton.accessibilityHint = NSLocalizedString(@"ReportScreenMoralOrderButtonHint", @"Hint for moralOrderButton");
	moralOrderButton.accessibilityLabel =  NSLocalizedString(@"ReportScreenMoralOrderButtonLabel",@"Label for moralOrderButton");
    
}


#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    previousButton = nil;
    [super viewDidUnload];
}



@end
