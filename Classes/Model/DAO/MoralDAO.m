#import "MoralDAO.h"
#import "MoraLifeAppDelegate.h"
#import "Moral.h"

@interface MoralDAO () {
    MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSManagedObjectContext *context;		/**< Core Data context */	
}

- (Moral *)findMoral:(NSString *)moralName;
- (NSArray *)listMorals;

@property (nonatomic, retain) NSString *currentMoralType;
@property (nonatomic, retain) NSArray *morals;
@property (nonatomic, retain) NSMutableArray *moralNames;
@property (nonatomic, retain) NSMutableArray *moralImages;
@property (nonatomic, retain) NSMutableArray *moralDetails;
@property (nonatomic, retain) NSMutableArray *moralDisplayNames;

- (void)processMorals;
- (NSArray *)retrieveMorals;

@end

@implementation MoralDAO 

@synthesize currentMoralType;
@synthesize morals;
@synthesize moralNames, moralImages, moralDetails, moralDisplayNames;

- (id) init {
    
    return [self initWithMoralType:nil];
}

- (id) initWithMoralType:(NSString *)moralType {
    self = [super init];
    if (self) {
        appDelegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
        context = [appDelegate.moralModelManager managedObjectContext];

        moralNames = [[NSMutableArray alloc] init];
        moralImages = [[NSMutableArray alloc] init];
        moralDisplayNames = [[NSMutableArray alloc] init];
        moralDetails = [[NSMutableArray alloc] init];
        
        if (moralType) {
            currentMoralType = [[NSString alloc] initWithFormat:moralType];
        } else {
            currentMoralType = [[NSString alloc] initWithFormat:@"all"];
        }
                
    }
    
    return self;
}

- (NSString *)findMoralColor:(NSString *)moralName {
    return [self findMoral:moralName].colorMoral;
}

- (NSString *)findMoralDefinition:(NSString *)moralName {
    return [self findMoral:moralName].definitionMoral;
}

- (NSString *)findMoralLongDescription:(NSString *)moralName {
    return [self findMoral:moralName].longDescriptionMoral;
}

- (NSString *)findMoralDisplayName:(NSString *)moralName {
    return [self findMoral:moralName].displayNameMoral;
}

- (NSString *)findMoralImageName:(NSString *)moralName {
    return [self findMoral:moralName].imageNameMoral;    
}

- (NSArray *)listAllMoralNames {
    if (morals.count == 0) {
        [self processMorals];
    }
    return moralNames;
}

- (NSArray *)listAllMoralDisplayNames {
    if (morals.count == 0) {
        [self processMorals];
    }
    
    return moralDisplayNames;
}

- (NSArray *)listAllMoralImages {
    if (morals.count == 0) {
        [self processMorals];
    }
    
    return moralImages;
}

- (NSArray *)listAllMoralDetails {
    if (morals.count == 0) {
        [self processMorals];
    }
    
    return moralDetails;
}

#pragma mark -
#pragma mark Private API
- (Moral *)findMoral:(NSString *)moralName {
    if (morals.count == 0) {
        [self processMorals];
    }
    
    NSPredicate *findPred = [NSPredicate predicateWithFormat:@"SELF.nameMoral == %@", moralName];
    
    NSArray *objects = [morals filteredArrayUsingPredicate:findPred];
    
    return [objects objectAtIndex:0];
    
}

- (NSArray *)listMorals {
    if (morals.count == 0) {
        [self processMorals];
    }    
    
    return [self retrieveMorals];
}

- (void)processMorals {
    
    morals = [self retrieveMorals];
    
    for (Moral *match in morals){
        [moralNames addObject:[match nameMoral]];
        [moralImages addObject:[match imageNameMoral]];
        [moralDisplayNames addObject:[match displayNameMoral]];
        [moralDetails addObject:[match longDescriptionMoral]];			
    }
    
}

- (NSArray *)retrieveMorals {
    //Begin CoreData Retrieval			
	NSError *outError;
	
	NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"Moral" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
		

    if (![currentMoralType isEqualToString:@"all"]) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"shortDescriptionMoral == %@", currentMoralType];
        [request setPredicate:pred];
    }
	
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameMoral" ascending:YES];
	NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	NSArray *objects = [context executeFetchRequest:request error:&outError];
    	
	[request release];
    
    return objects;

}

-(void)dealloc {
    
    [currentMoralType release];
    [moralNames release];
    [moralDisplayNames release];
    [moralDetails release];
    [moralImages release];
    
    [super dealloc];
}

@end
