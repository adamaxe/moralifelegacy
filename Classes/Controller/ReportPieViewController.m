/**
Implementation:  Present a GraphView of piechart type with accompanying data descriptors.
 
@class ReportPieViewController ReportPieViewController.h
 */

#import "ReportPieViewController.h"
#import "GraphView.h"
#import "ViewControllerLocalization.h"
#import "ReportPieModel.h"
#import "ReportMoralTableViewCell.h"

@interface ReportPieViewController () <ViewControllerLocalization> {

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
@property (nonatomic) IBOutlet UIImageView *previousScreen;

/**
 Convert UserData into graphable data, create a GraphView
 */
- (void) generateGraph;

@end

@implementation ReportPieViewController

- (instancetype)initWithModel:(ReportPieModel *)reportPieModel modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience {
    self = [super initWithModelManager:modelManager andConscience:userConscience];

    if (self) {
        self.reportPieModel = reportPieModel;
        self.isGood = TRUE;
        self.isAlphabetical = FALSE;
        self.isAscending = FALSE;

    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.previousScreen.image = self.screenshot;

    [self generateGraph];
    
    [self localizeUI];    

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	//Present help screen after a split second
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showInitialHelpScreen) userInfo:nil repeats:NO];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //Position Conscience in lower-left of screen
    CGPoint centerPoint = CGPointMake(MLConscienceLowerLeftX, MLConscienceLowerLeftY);

    //Add User Conscience to view
    [self.view addSubview:_userConscience.userConscienceView];
    
    _userConscience.userConscienceView.center = centerPoint;

    
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

-(void)setScreenshot:(UIImage *)screenshot {
    if (_screenshot != screenshot) {
        _screenshot = screenshot;
        self.previousScreen.image = screenshot;
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
        
		_conscienceHelpViewController.isConscienceOnScreen = TRUE;
        _conscienceHelpViewController.numberOfScreens = 1;
        _conscienceHelpViewController.screenshot = [self prepareScreenForScreenshot];

        [self presentViewController:_conscienceHelpViewController animated:NO completion:nil];
        
        
        [prefs setBool:FALSE forKey:@"firstPie"];

        [prefs synchronize];

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
                    moralType.image = [UIImage imageNamed:@"acc-pri-weapon-trident-sm.png"];
                    moralTypeLabel.text = @"Vice";
                } else {
                    self.isGood = TRUE;
                    moralType.image = [UIImage imageNamed:@"acc-top-halo-sm.png"];
                    moralTypeLabel.text = @"Virtue";
                }
                moralTypeLabel.accessibilityValue = moralTypeLabel.text;
            } break;
            case 1:{    
                if (self.isAlphabetical) {
                    self.isAlphabetical = FALSE;
                    [moralSortButton setTitle:@"%" forState: UIControlStateNormal];
                } else {
                    self.isAlphabetical = TRUE;
                    [moralSortButton setTitle:@"A" forState: UIControlStateNormal];
                }
                moralSortButton.accessibilityValue = moralSortButton.titleLabel.text;

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
                moralOrderButton.accessibilityValue = moralOrderButton.titleLabel.text;

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
	graph.pieValues = self.reportPieModel.pieValues;
	graph.pieColors = self.reportPieModel.pieColors;

	//Add new graph to view
	[thoughtModalArea addSubview:graph];
    [thoughtModalArea bringSubviewToFront:moralTypeButton];
    [thoughtModalArea bringSubviewToFront:moralType];
    
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
    return (self.reportPieModel.reportNames).count;

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ReportMoralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReportMoralTableViewCell class])];

	if (cell == nil) {
      	cell = [[ReportMoralTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([ReportMoralTableViewCell class])];
	}
    
	(cell.textLabel).text = (self.reportPieModel.reportNames)[indexPath.row];
    
    cell.moralColor = self.reportPieModel.pieColors[indexPath.row];
    if ((self.reportPieModel.moralNames).count > 0) {
        
        NSMutableString *rowImageName = [[NSMutableString alloc] initWithString:(self.reportPieModel.moralImageNames)[(self.reportPieModel.moralNames)[indexPath.row]]];
        [rowImageName appendString:@".png"];
        cell.moralImage = [UIImage imageNamed:rowImageName];
        
    } else {
        cell.moralImage = [UIImage imageNamed:@"card-doubt.png"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }

    return cell;
}


#pragma mark -
#pragma mark ViewControllerLocalization Protocol

- (void) localizeUI {
    
    NSString *titleName =[[NSString alloc] initWithFormat:@"%@",NSStringFromClass([self class])];
    
    [self setTitle:NSLocalizedString(([NSString stringWithFormat:@"%@%dTitle", titleName, self.isGood]),nil)];
    moralTypeLabel.text = @"Virtue";                
    
    previousButton.accessibilityHint = NSLocalizedString(@"PreviousButtonHint",nil);
	previousButton.accessibilityLabel =  NSLocalizedString(@"PreviousButtonLabel",nil);
    
    moralTypeButton.accessibilityHint = NSLocalizedString(@"ReportScreenMoralTypeButtonHint",nil);
	moralTypeButton.accessibilityLabel =  NSLocalizedString(@"ReportScreenMoralTypeButtonLabel",nil);

    moralSortButton.accessibilityHint = NSLocalizedString(@"ReportScreenMoralSortButtonHint",nil);
	moralSortButton.accessibilityLabel =  NSLocalizedString(@"ReportScreenMoralSortButtonLabel",nil);
    moralSortButton.accessibilityValue = moralSortButton.titleLabel.text;

    moralOrderButton.accessibilityHint = NSLocalizedString(@"ReportScreenMoralOrderButtonHint",nil);
	moralOrderButton.accessibilityLabel =  NSLocalizedString(@"ReportScreenMoralOrderButtonLabel",nil);
    moralOrderButton.accessibilityValue = moralOrderButton.titleLabel.text;

    moralTypeLabel.accessibilityHint = NSLocalizedString(@"ReportScreenMoralTypeLabelHint",nil);
	moralTypeLabel.accessibilityLabel =  NSLocalizedString(@"ReportScreenMoralTypeLabelLabel",nil);
    moralTypeLabel.accessibilityValue = moralTypeLabel.text;

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
