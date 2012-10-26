#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
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

@property (nonatomic, readwrite, strong) NSMutableArray *references;			/**< Array of User-entered choice titles */
@property (nonatomic, readwrite, strong) NSMutableArray *referenceKeys;			/**< Array of User-entered choice titles */
@property (nonatomic, readwrite, strong) NSMutableArray *details;			/**< Array of User-entered details */
@property (nonatomic, readwrite, strong) NSMutableArray *icons;				/**< Array of associated images */

/**
 Retrieve all User entered Choices
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

        _referenceType = MLReferenceModelTypeConscienceAsset;
        _references = [[NSMutableArray alloc] init];
        _referenceKeys = [[NSMutableArray alloc] init];
        _details = [[NSMutableArray alloc] init];
        _icons = [[NSMutableArray alloc] init];
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

    id currentDAO;	

    //Populate subsequent list controller with appropriate choice
	switch (_referenceType){
		case MLReferenceModelTypeConscienceAsset:
			currentDAO = [[ConscienceAssetDAO alloc] initWithKey:@"" andModelManager:moralModelManager];
			break;
		case MLReferenceModelTypeBelief:
			currentDAO = [[ReferenceBeliefDAO alloc] initWithKey:@"" andModelManager:moralModelManager];
			break;
		case MLReferenceModelTypeText:
			currentDAO = [[ReferenceTextDAO alloc] initWithKey:@"" andModelManager:moralModelManager];
			break;
		case MLReferenceModelTypePerson:
			currentDAO = [[ReferencePersonDAO alloc] initWithKey:@"" andModelManager:moralModelManager];
			break;
		case MLReferenceModelTypeMoral:
			currentDAO = [[MoralDAO alloc] initWithKey:@"" andModelManager:moralModelManager];
			break;
        case MLReferenceModelTypeReferenceAsset:
            currentDAO = [[ReferenceAssetDAO alloc] initWithKey:@"" andModelManager:moralModelManager];
            break;
		default:
			currentDAO = [[ReferenceAssetDAO alloc] initWithKey:@"" andModelManager:moralModelManager];
			break;
	}

    if (_referenceType != MLReferenceModelTypeMoral) {
        NSSortDescriptor* sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"shortDescriptionReference" ascending:YES];

        NSArray *sortDescriptors = @[sortDescriptor1];
        [currentDAO setSorts:sortDescriptors];
    }


	/** @bug leaks complaint */
	NSArray *objects = [currentDAO readAll];

	if ([objects count] > 0) {

        if (_referenceType != MLReferenceModelTypeMoral) {
            for (ReferenceAsset *matches in objects){

                //Is the asset owned
                if([currentUserCollection containsObject:[matches nameReference]]){

                    [self.references addObject:[matches displayNameReference]];
                    [self.icons addObject:[matches imageNameReference]];
                    [self.details addObject:[matches shortDescriptionReference]];
                    [self.referenceKeys addObject:[matches nameReference]];
                }

            }
        } else {

            for (Moral *matches in objects){

                if([currentUserCollection containsObject:[matches nameMoral]]){

                    [self.references addObject:[matches displayNameMoral]];
                    [self.icons addObject:[matches imageNameMoral]];
                    [self.details addObject:[NSString stringWithFormat:@"%@: %@", [matches shortDescriptionMoral], [matches longDescriptionMoral]]];
                    [self.referenceKeys addObject:[matches nameMoral]];
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
