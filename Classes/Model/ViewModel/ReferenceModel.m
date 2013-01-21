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

@property (nonatomic, readwrite, strong) NSArray *references;
@property (nonatomic, readwrite, strong) NSArray *referenceKeys;
@property (nonatomic, readwrite, strong) NSArray *details;
@property (nonatomic, readwrite, strong) NSArray *icons;
@property (nonatomic, readwrite, strong) NSArray *longDescriptions;
@property (nonatomic, readwrite, strong) NSArray *links;
@property (nonatomic, readwrite, strong) NSArray *originYears;
@property (nonatomic, readwrite, strong) NSArray *endYears;
@property (nonatomic, readwrite, strong) NSArray *originLocations;
@property (nonatomic, readwrite, strong) NSArray *orientations;
@property (nonatomic, readwrite, strong) NSArray *quotes;
@property (nonatomic, readwrite, strong) NSArray *relatedMorals;

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

        _referenceKey = @"";
        self.hasLink = TRUE;
        self.hasQuote = TRUE;
        self.title = NSLocalizedString(@"ReferenceDetailScreenAccessoriesTitle",nil);

        self.referenceType = MLReferenceModelTypeConscienceAsset;
        self.references = [[NSArray alloc] init];
        self.referenceKeys = [[NSArray alloc] init];
        self.details = [[NSArray alloc] init];
        self.icons = [[NSArray alloc] init];
        self.longDescriptions = [[NSArray alloc] init];
        self.links = [[NSArray alloc] init];
        self.originYears = [[NSArray alloc] init];
        self.endYears = [[NSArray alloc] init];
        self.originLocations = [[NSArray alloc] init];
        self.orientations = [[NSArray alloc] init];
        self.quotes = [[NSArray alloc] init];
        self.relatedMorals = [[NSArray alloc] init];

        preferences = prefs;
        currentUserCollection = userCollection;
        moralModelManager = modelManager;

    }

    [self retrieveAllReferences];

    return self;
    
}

#pragma mark -
#pragma mark Overloaded Setters

/* Whenever referenceKey is changed from ViewController, model is refreshed */
- (void) setReferenceKey:(NSString *)referenceKey {
    if ((_referenceKey != referenceKey)) {
        _referenceKey = referenceKey;
        [self retrieveAllReferences];
    }
}

/* Whenever referenceType is changed from ViewController, model is refreshed */
- (void) setReferenceType:(MLReferenceModelTypeEnum)referenceType {
    if ((_referenceType != referenceType)) {
        _referenceType = referenceType;
        [self retrieveAllReferences];
    }
}

/**
 Implementation: Retrieve all User-received references, and then populate a working set of data containers upon which to filter.
 */
- (void) retrieveAllReferences {

	//Clear all datasets
    NSMutableArray *derivedReferences = [[NSMutableArray alloc] init];
    NSMutableArray *derivedReferenceKeys = [[NSMutableArray alloc] init];
    NSMutableArray *derivedDetails = [[NSMutableArray alloc] init];
    NSMutableArray *derivedIcons = [[NSMutableArray alloc] init];
    NSMutableArray *derivedLongDescriptions = [[NSMutableArray alloc] init];
    NSMutableArray *derivedLinks = [[NSMutableArray alloc] init];
    NSMutableArray *derivedOriginYears = [[NSMutableArray alloc] init];
    NSMutableArray *derivedEndYears = [[NSMutableArray alloc] init];
    NSMutableArray *derivedOriginLocations = [[NSMutableArray alloc] init];
    NSMutableArray *derivedOrientations = [[NSMutableArray alloc] init];
    NSMutableArray *derivedQuotes = [[NSMutableArray alloc] init];
    NSMutableArray *derivedRelatedMorals = [[NSMutableArray alloc] init];

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

                    [derivedReferences addObject:[match displayNameReference]];
                    [derivedIcons addObject:[match imageNameReference]];
                    [derivedDetails addObject:[match shortDescriptionReference]];
                    [derivedReferenceKeys addObject:[match nameReference]];
                    [derivedLongDescriptions addObject:[match longDescriptionReference]];
                    [derivedLinks addObject:[match linkReference]];
                    [derivedOriginYears addObject:[match originYear]];

                    if ([match relatedMoral] == nil) {
                        [derivedRelatedMorals addObject:@""];
                    } else {
                        relatedMoral = [match relatedMoral];
                        [derivedRelatedMorals addObject:[relatedMoral imageNameMoral]];
                    }

                    if ([match originLocation] == nil) {

                        if ((self.referenceType != MLReferenceModelTypePerson) && relatedMoral) {
                            [derivedOriginLocations addObject:[[NSString alloc] initWithFormat:@"+%d %@", [[match moralValueAsset] intValue], relatedMoral.displayNameMoral]];
                        } else {
                            [derivedOriginLocations addObject:@""];
                        }

                    } else {
                        [derivedOriginLocations addObject:[match originLocation]];
                    }

                    if ([match respondsToSelector:@selector(deathYearPerson)]) {
                        [derivedEndYears addObject:[[match deathYearPerson] stringValue]];
                    } else {
                        [derivedEndYears addObject:@0];
                    }

                    if ([match respondsToSelector:@selector(orientationAsset)] && ([match orientationAsset] != nil)) {
                        [derivedOrientations addObject:[match orientationAsset]];
                    } else {
                        [derivedOrientations addObject:@""];
                    }

                    if ([match respondsToSelector:@selector(quotePerson)] && ([match quotePerson] != nil)) {
                            [derivedQuotes addObject:[match quotePerson]];
                    } else {
                        [derivedQuotes addObject:@""];
                    }

                }

            }
        } else {

            for (Moral *moralMatch in objects){

                if([currentUserCollection containsObject:[moralMatch nameMoral]]){

                    [derivedReferences addObject:[moralMatch displayNameMoral]];
                    [derivedIcons addObject:[moralMatch imageNameMoral]];
                    [derivedDetails addObject:[NSString stringWithFormat:@"%@: %@", [moralMatch shortDescriptionMoral], [moralMatch longDescriptionMoral]]];
                    [derivedReferenceKeys addObject:[moralMatch nameMoral]];
                    [derivedLongDescriptions addObject:[[NSString alloc] initWithFormat:@"%@: %@", [moralMatch shortDescriptionMoral], [moralMatch longDescriptionMoral]]];
                    [derivedLinks addObject:[moralMatch linkMoral]];
                    [derivedOriginYears addObject:@0];
                    [derivedOriginLocations addObject:@""];
                    [derivedEndYears addObject:@"0"];
                    [derivedOrientations addObject:@""];
                    [derivedQuotes addObject:@""];
                    [derivedRelatedMorals addObject:@""];
                }
            }

		}

    }

	self.references = [NSArray arrayWithArray:derivedReferences];
	self.referenceKeys = [NSArray arrayWithArray:derivedReferenceKeys];
	self.icons = [NSArray arrayWithArray:derivedIcons];
	self.details = [NSArray arrayWithArray:derivedDetails];
	self.longDescriptions = [NSArray arrayWithArray:derivedLongDescriptions];
	self.links = [NSArray arrayWithArray:derivedLinks];
	self.originYears = [NSArray arrayWithArray:derivedOriginYears];
	self.endYears = [NSArray arrayWithArray:derivedEndYears];
	self.originLocations = [NSArray arrayWithArray:derivedOriginLocations];
	self.orientations = [NSArray arrayWithArray:derivedOrientations];
	self.quotes = [NSArray arrayWithArray:derivedQuotes];
	self.relatedMorals = [NSArray arrayWithArray:derivedRelatedMorals];

}

/**
 Implementation: Retrieve a requested reference and set NSUserDefaults for Reference*ViewControllers to read
 */
- (void) selectReference:(NSString *) referenceKey {
    self.referenceKey = referenceKey;

    //Set state retention for eventual call to ChoiceViewController to pick up
    [preferences setInteger:self.referenceType forKey:@"referenceType"];
    [preferences setObject:referenceKey forKey:@"referenceKey"];

    [preferences synchronize];
    [self retrieveAllReferences];

}



@end
