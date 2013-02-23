#import "MoraLifeAppDelegate.h"
#import "DilemmaModel.h"
#import "UserDilemmaDAO.h"
#import "DilemmaDAO.h"
#import "Moral.h"

@interface DilemmaModel () {
    NSUserDefaults *preferences;            /**< User defaults to write to file system */
    NSArray *currentUserCollection;                /**< collection of owned Assets */
    ModelManager *moralModelManager;    

}

@property (nonatomic, readwrite, strong) NSArray *dilemmas;
@property (nonatomic, readwrite, strong) NSArray *dilemmaDetails;
@property (nonatomic, readwrite, strong) NSArray *dilemmaImages;
@property (nonatomic, readwrite, strong) NSArray *dilemmaTypes;
@property (nonatomic, readwrite, strong) NSArray *dilemmaDisplayNames;
@property (nonatomic, readwrite, strong) NSDictionary *moralNames;
@property (nonatomic, readwrite, strong) NSDictionary *userChoices;
@property (nonatomic) int dilemmaCampaign;

/**
 Retrieve all References
 */
- (void) retrieveAllDilemmas;

@end

@implementation DilemmaModel

- (id)initWithCampaign:(MLRequestedMorathologyAdventure)campaign {
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];

    return [self initWithModelManager:[appDelegate moralModelManager] andDefaults:[NSUserDefaults standardUserDefaults] andCurrentCampaign:campaign];
}

- (id)initWithModelManager:(ModelManager *) modelManager andDefaults:(NSUserDefaults *) prefs andCurrentCampaign:(MLRequestedMorathologyAdventure) campaign {

    self = [super init];
    if (self) {

        _dilemmaKey = @"";
        self.dilemmas = [[NSArray alloc] init];
        self.dilemmaDetails = [[NSArray alloc] init];
        self.dilemmaImages = [[NSArray alloc] init];
        self.dilemmaTypes = [[NSArray alloc] init];
        self.dilemmaDisplayNames = [[NSArray alloc] init];
        self.userChoices = [[NSDictionary alloc] init];
        self.moralNames = [[NSDictionary alloc] init];

        preferences = prefs;
        self.dilemmaCampaign = campaign;
        moralModelManager = modelManager;

    }

    [self retrieveAllDilemmas];

    return self;
    
}

#pragma mark -
#pragma mark Overloaded Setters

/* Whenever referenceKey is changed from ViewController, model is refreshed */
- (void) setDilemmaKey:(NSString *)dilemmaKey {
    if ((_dilemmaKey != dilemmaKey)) {
        _dilemmaKey = dilemmaKey;
        [self retrieveAllDilemmas];
    }
}

- (NSDictionary *)userChoices {
    [self loadUserData];
    return _userChoices;
}

/**
 Implementation: Retrieve all User-received references, and then populate a working set of data containers upon which to filter.
 */
- (void) retrieveAllDilemmas {

	//Setup permanent holders, table does not key on these, it keys on tabledata which is affected by searchbar
	//tabledatas are reloaded from these master arrays
	NSMutableArray *derivedDilemmas = [[NSMutableArray alloc] init];
	NSMutableDictionary *derivedMoralNames = [[NSMutableDictionary alloc] init];
	NSMutableArray *derivedDilemmaImages = [[NSMutableArray alloc] init];
	NSMutableArray *derivedDilemmaDetails = [[NSMutableArray alloc] init];
	NSMutableArray *derivedDilemmaDisplayNames = [[NSMutableArray alloc] init];
	NSMutableArray *derivedDilemmaTypes = [[NSMutableArray alloc] init];

	BOOL isDilemma = TRUE;

	//Retrieve all available Dilemmas, sort by name, limit to currently requested Campaign
    DilemmaDAO *currentDilemmaDAO = [[DilemmaDAO alloc] init];

	NSString *dilemmaPredicate = [[NSString alloc] initWithFormat:@"dile-%d-", self.dilemmaCampaign];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"nameDilemma contains[cd] %@", dilemmaPredicate];

	if (self.dilemmaCampaign > 0) {
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

			[derivedDilemmas addObject:[match nameDilemma]];
			[derivedDilemmaImages addObject:[match surrounding]];
			[derivedDilemmaDisplayNames addObject:[match displayNameDilemma]];

            NSString *dilemmaDescription;

            if ([[[match moralChoiceA] nameMoral] isEqualToString:[[match moralChoiceB] nameMoral]]) {
                dilemmaDescription = [[NSString alloc] initWithString:[[match moralChoiceA] displayNameMoral]];
                isDilemma = FALSE;
            } else {
                dilemmaDescription = [[NSString alloc] initWithFormat:@"%@ vs. %@", [[match moralChoiceA] displayNameMoral], [[match moralChoiceB] displayNameMoral]];
                isDilemma = TRUE;
            }

            if ([match moralChoiceA]) {
                [derivedMoralNames setValue:[[match moralChoiceA] displayNameMoral] forKey:[[match moralChoiceA] nameMoral]];
            }
            if ([match moralChoiceB]) {
                [derivedMoralNames setValue:[[match moralChoiceB] displayNameMoral] forKey:[[match moralChoiceB] nameMoral]];
            }
            [derivedDilemmaTypes addObject:@(isDilemma)];
			[derivedDilemmaDetails addObject:dilemmaDescription];

		}
	}

	self.dilemmas = derivedDilemmas;
    self.moralNames = derivedMoralNames;
	self.dilemmaImages = derivedDilemmaImages;
	self.dilemmaDetails = derivedDilemmaDetails;
	self.dilemmaDisplayNames = derivedDilemmaDisplayNames;
	self.dilemmaTypes = derivedDilemmaTypes;

	[self loadUserData];

}

/**
 Implementation: Load User data to determine which Dilemmas have already been completed
 */
- (void) loadUserData {
	NSMutableDictionary *derivedUserChoices = [[NSMutableDictionary alloc] init];

    UserDilemmaDAO *currentUserDilemmaDAO = [[UserDilemmaDAO alloc] init];

    NSString *dilemmaPredicate = [[NSString alloc] initWithFormat:@"dile-%d-", self.dilemmaCampaign];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"entryKey contains[cd] %@", dilemmaPredicate];

    currentUserDilemmaDAO.predicates = @[pred];

	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"entryShortDescription" ascending:YES];
	NSArray* sortDescriptors = @[sortDescriptor];

    currentUserDilemmaDAO.sorts = sortDescriptors;

    NSArray *objects = [currentUserDilemmaDAO readAll];

	if ([objects count] == 0) {

        //User has not completed a single choice
        //populate array to prevent npe
        [derivedUserChoices setValue:@"" forKey:@"noUserEntries"];

	} else {

		//Populate dictionary with dilemmaName (key) and moral that was chosen
		for(UserDilemma *match in objects) {
			[derivedUserChoices setValue:match.entryLongDescription forKey:match.entryShortDescription];
            
		}
        
	}

    self.userChoices = (NSDictionary *)derivedUserChoices;
    
}

/**
 Implementation: Retrieve a requested dilemma and set NSUserDefaults for Reference*ViewControllers to read
 */
- (void) selectDilemma:(NSString *) dilemmaKey {
    self.dilemmaKey = dilemmaKey;

    //Set state retention for eventual call to ChoiceViewController to pick up
    [preferences setObject:dilemmaKey forKey:@"dilemmaKey"];

    [preferences synchronize];
    [self retrieveAllDilemmas];

}

@end
