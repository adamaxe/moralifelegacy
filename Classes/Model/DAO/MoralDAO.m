#import "MoralDAO.h"
#import "MoraLifeAppDelegate.h"
#import "Moral.h"

@interface MoralDAO () {
    MoraLifeAppDelegate *appDelegate;		/**< delegate for application level callbacks */
	NSManagedObjectContext *context;		/**< Core Data context */	
}

@property (nonatomic, retain) NSString *currentMoralType;
@property (nonatomic, retain) NSMutableArray *moralNames;
@property (nonatomic, retain) NSMutableArray *moralImages;
@property (nonatomic, retain) NSMutableArray *moralDetails;
@property (nonatomic, retain) NSMutableArray *moralDisplayNames;

- (void)processMorals;
- (NSArray *)retrieveMorals;

@end

@implementation MoralDAO 

@synthesize currentMoralType;
@synthesize moralNames, moralImages, moralDetails, moralDisplayNames;

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
        
        [self processMorals];
        
    }
    
    return self;
}

- (NSArray *)getAllMoralNames {
    return moralNames;
}

- (NSArray *)getAllMoralDisplayNames {
    return moralDisplayNames;
}

- (NSArray *)getAllMoralImages {
    return moralImages;
}

- (NSArray *)getAllMoralDetails {
    return moralDetails;
}

#pragma mark -
#pragma mark Private API

- (void)processMorals {
    
    NSArray *morals = [self retrieveMorals];
    
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
