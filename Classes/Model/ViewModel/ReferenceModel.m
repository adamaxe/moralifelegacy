#import "MoraLifeAppDelegate.h"
#import "ReferenceModel.h"
#import "UserChoiceDAO.h"
#import "ConscienceAssetDAO.h"
#import "ReferenceAssetDAO.h"
#import "ReferenceBeliefDAO.h"
#import "ReferencePersonDAO.h"
#import "ReferenceTextDAO.h"
#import "MoralDAO.h"

@interface ReferenceModel () {
    NSUserDefaults *preferences;            /**< User defaults to write to file system */
    NSArray *currentUserCollection;                /**< collection of owned Assets */
    ModelManager *moralModelManager;    

}

@property (nonatomic, readwrite, strong) NSString *title;
@property (nonatomic, readwrite) BOOL hasQuote;
@property (nonatomic, readwrite) BOOL hasLink;

@property (nonatomic, readwrite, strong) NSMutableArray *references;
@property (nonatomic, readwrite, strong) NSMutableArray *referenceKeys;
@property (nonatomic, readwrite, strong) NSMutableArray *details;
@property (nonatomic, readwrite, strong) NSMutableArray *icons;
@property (nonatomic, readwrite, strong) NSMutableArray *longDescriptions;
@property (nonatomic, readwrite, strong) NSMutableArray *links;
@property (nonatomic, readwrite, strong) NSMutableArray *originYears;
@property (nonatomic, readwrite, strong) NSMutableArray *endYears;
@property (nonatomic, readwrite, strong) NSMutableArray *originLocations;
@property (nonatomic, readwrite, strong) NSMutableArray *orientations;
@property (nonatomic, readwrite, strong) NSMutableArray *quotes;
@property (nonatomic, readwrite, strong) NSMutableArray *relatedMorals;

/**
 Retrieve all References
 */
- (void) retrieveAllReferences;

@end

@implementation ReferenceModel

- (id)init {
    MoraLifeAppDelegate *appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];

    return [self initWithModelManager:[appDelegate moralModelManager] andDefaults:[NSUserDefaults standardUserDefaults] andUserCollection:appDelegate.userCollection];
}

- (id)initWithModelManager:(ModelManager *) modelManager andDefaults:(NSUserDefaults *) prefs andUserCollection:(NSArray *) userCollection{

    self = [super init];
    if (self) {

        self.referenceKey = @"";
        self.hasLink = TRUE;
        self.hasQuote = TRUE;
        self.title = NSLocalizedString(@"ReferenceDetailScreenAccessoriesTitle",nil);

        self.referenceType = MLReferenceModelTypeConscienceAsset;
        self.references = [[NSMutableArray alloc] init];
        self.referenceKeys = [[NSMutableArray alloc] init];
        self.details = [[NSMutableArray alloc] init];
        self.icons = [[NSMutableArray alloc] init];
        self.longDescriptions = [[NSMutableArray alloc] init];
        self.links = [[NSMutableArray alloc] init];
        self.originYears = [[NSMutableArray alloc] init];
        self.endYears = [[NSMutableArray alloc] init];
        self.originLocations = [[NSMutableArray alloc] init];
        self.orientations = [[NSMutableArray alloc] init];
        self.quotes = [[NSMutableArray alloc] init];
        self.relatedMorals = [[NSMutableArray alloc] init];

        preferences = prefs;
        currentUserCollection = userCollection;
        moralModelManager = modelManager;

    }

    [self retrieveAllReferences];

    return self;
    
}

#pragma mark -
#pragma mark Overloaded Setters

/* Whenever referenceType is changed from ViewController, model is refreshed */
- (void) setReferenceType:(int)referenceType {
    if (_referenceType != referenceType) {
        _referenceType = referenceType;
        [self retrieveAllReferences];
    }
}

/**
 Implementation: Retrieve all User-received references, and then populate a working set of data containers upon which to filter.
 */
- (void) retrieveAllReferences {

	//Clear all datasets
	[self.references removeAllObjects];
	[self.referenceKeys removeAllObjects];
	[self.icons removeAllObjects];
	[self.details removeAllObjects];
	[self.longDescriptions removeAllObjects];
	[self.links removeAllObjects];
	[self.originYears removeAllObjects];
	[self.endYears removeAllObjects];
	[self.originLocations removeAllObjects];
	[self.orientations removeAllObjects];
	[self.quotes removeAllObjects];
	[self.relatedMorals removeAllObjects];

    id currentDAO;	
    self.hasLink = TRUE;
    self.hasQuote = TRUE;

    Moral *relatedMoral;

    //Populate subsequent list controller with appropriate choice
	switch (self.referenceType){
		case MLReferenceModelTypeConscienceAsset:
			self.title = NSLocalizedString(@"ReferenceDetailScreenAccessoriesTitle",nil);
			self.hasQuote = FALSE;
			self.hasLink = FALSE;
			currentDAO = [[ConscienceAssetDAO alloc] initWithKey:self.referenceKey andModelManager:moralModelManager];
			break;
		case MLReferenceModelTypeBelief:
			self.title = NSLocalizedString(@"ReferenceDetailScreenBeliefsTitle",nil);            
			currentDAO = [[ReferenceBeliefDAO alloc] initWithKey:self.referenceKey andModelManager:moralModelManager];
			break;
		case MLReferenceModelTypeText:
			self.title = NSLocalizedString(@"ReferenceDetailScreenBooksTitle",nil);
			currentDAO = [[ReferenceTextDAO alloc] initWithKey:self.referenceKey andModelManager:moralModelManager];
			break;
		case MLReferenceModelTypePerson:
			self.title = NSLocalizedString(@"ReferenceDetailScreenPeopleTitle",nil);
			currentDAO = [[ReferencePersonDAO alloc] initWithKey:self.referenceKey andModelManager:moralModelManager];
			break;
		case MLReferenceModelTypeMoral:
			self.title = NSLocalizedString(@"ReferenceDetailScreenMoralsTitle",nil);
			self.hasQuote = FALSE;
			currentDAO = [[MoralDAO alloc] initWithKey:self.referenceKey andModelManager:moralModelManager];
			break;
        case MLReferenceModelTypeReferenceAsset:
            currentDAO = [[ReferenceAssetDAO alloc] initWithKey:self.referenceKey andModelManager:moralModelManager];
            break;
		default:
			self.title = NSLocalizedString(@"ReferenceDetailScreenDefaultTitle",nil);
			currentDAO = [[ReferenceAssetDAO alloc] initWithKey:self.referenceKey andModelManager:moralModelManager];
			break;
	}

    if (self.referenceType != MLReferenceModelTypeMoral) {
        NSSortDescriptor* sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"shortDescriptionReference" ascending:YES];

        NSArray *sortDescriptors = @[sortDescriptor1];
        [currentDAO setSorts:sortDescriptors];
    }


	/** @bug leaks complaint */
	NSArray *objects = [currentDAO readAll];

	if ([objects count] > 0) {

        if (self.referenceType != MLReferenceModelTypeMoral) {
            for (id match in objects){

                //Is the asset owned
                if([currentUserCollection containsObject:[match nameReference]]){

                    [self.references addObject:[match displayNameReference]];
                    [self.icons addObject:[match imageNameReference]];
                    [self.details addObject:[match shortDescriptionReference]];
                    [self.referenceKeys addObject:[match nameReference]];
                    [self.longDescriptions addObject:[match longDescriptionReference]];
                    [self.links addObject:[match linkReference]];
                    [self.originYears addObject:[match originYear]];

                    if ([match relatedMoral] == nil) {
                        [self.relatedMorals addObject:@""];
                    } else {
                        relatedMoral = [match relatedMoral];
                        [self.relatedMorals addObject:[relatedMoral imageNameMoral]];
                    }

                    if ([match originLocation] == nil) {

                        if ((self.referenceType != MLReferenceModelTypePerson) && relatedMoral) {
                            [self.originLocations addObject:[[NSString alloc] initWithFormat:@"+%d %@", [[match moralValueAsset] intValue], relatedMoral.displayNameMoral]];
                        } else {
                            [self.originLocations addObject:@""];
                        }

                    } else {
                        [self.originLocations addObject:[match originLocation]];
                    }

                    if ([match respondsToSelector:@selector(deathYearPerson)]) {
                        [self.endYears addObject:[[match deathYearPerson] stringValue]];
                    } else {
                        [self.endYears addObject:@0];
                    }

                    if ([match respondsToSelector:@selector(orientationAsset)] && ([match orientationAsset] != nil)) {
                        [self.orientations addObject:[match orientationAsset]];
                    } else {
                        [self.orientations addObject:@""];
                    }

                    if ([match respondsToSelector:@selector(quotePerson)] && ([match quotePerson] != nil)) {
                            [self.quotes addObject:[match quotePerson]];
                    } else {
                        [self.quotes addObject:@""];
                    }

                }

            }
        } else {

            for (Moral *matches in objects){

                if([currentUserCollection containsObject:[matches nameMoral]]){

                    [self.references addObject:[matches displayNameMoral]];
                    [self.icons addObject:[matches imageNameMoral]];
                    [self.details addObject:[NSString stringWithFormat:@"%@: %@", [matches shortDescriptionMoral], [matches longDescriptionMoral]]];
                    [self.referenceKeys addObject:[matches nameMoral]];
                    [self.longDescriptions addObject:[[NSString alloc] initWithFormat:@"%@: %@", [matches shortDescriptionMoral], [matches longDescriptionMoral]]];
                    [self.links addObject:[matches linkMoral]];
                    [self.originYears addObject:@0];
                    [self.originLocations addObject:@""];
                    [self.endYears addObject:@"0"];
                    [self.orientations addObject:@""];
                    [self.quotes addObject:@""];
                    [self.relatedMorals addObject:@""];
                }
            }

		}

    }

}

/**
 Implementation: Retrieve a requested reference and set NSUserDefaults for Reference*ViewControllers to read
 */
- (void) selectReference:(NSString *) referenceKey {

    //Set state retention for eventual call to ChoiceViewController to pick up
    [preferences setInteger:self.referenceType forKey:@"referenceType"];
    [preferences setObject:referenceKey forKey:@"referenceKey"];

    [preferences synchronize];

}



@end
