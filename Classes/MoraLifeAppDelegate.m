/**
Moralife AppDelegate.  Implementation.  The delegate handles both the Core Data Stack and the Conscience.  User Conscience can appear on any screen, so it makes sense to create and maintain him in the delegate. He is not a singleton, however, due to the fact that there can be many different iterations of a Conscience type.
 
<br>All setup for navigation, UI, is done in App delegate.
@todo project->buildsettings->architectures->debug->remove any IOS SDK
@todo Model: change ReferenceText.belief to-many relationship to beliefs
@todo Model: change Character.story to-many relationship to stories
@todo Model: change delete rule for ReferenceText.children to cascade
@todo Model: change Character.sizeCharacter type to Float, change UserCharacter and Character to similiar
@todo Model: change Moral.dilemmaA/B typo
@todo Model: why is Moral.dilemma 1 to many?
@todo View: Figure out why appdelegate.userConscienceView has to be loaded at every viewWillAppear
@class MoralifeAppDelegate MoralifeAppDelegate.h
*/

#import "MoraLifeAppDelegate.h"
#import "ModelManager.h"
#import "ConscienceViewController.h"
#import "ConscienceBody.h"
#import "ConscienceAccessories.h"
#import "ConscienceView.h"
#import "ConscienceAsset.h"
#import "ConscienceBuilder.h"
#import "ReferenceViewController.h"
#import "UserCharacterDAO.h"
#import "ConscienceMind.h"
#import "UserCollectableDAO.h"

@interface MoraLifeAppDelegate () {

	UINavigationController *navController1; /**< UINavController for first screen, Home */

    NSManagedObjectContext *context;
    	
}

/**
 Create base Monitor before personalization re-instatement
 */
- (void)createConscience;
/**
 Remove Monitor for memory-restricted conditions
 */
- (void)destroyConscience;
/**
 Apply User's changes to base Monitor
 */
- (void)configureConscience;
/**
 Retrieve all User's current possessions/interview questions from persistent store.
 */
- (void)configureCollection;

@end

@implementation MoraLifeAppDelegate

#pragma mark -
#pragma mark AppDelegate lifecycle

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    
    [_moralModelManager saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    [_userConscienceView setNeedsDisplay];
    
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [_moralModelManager saveContext];
}


/**
 Application starting point.  Setup navigation, delegate, user data, conscience and conscience body/acc/mind.
 @see ConscienceBody
 @see ConscienceAccessories
 */
- (void)applicationDidFinishLaunching:(UIApplication *)application {

    _isCurrentIOS = (&UIApplicationDidEnterBackgroundNotification != NULL);
    
    _moralModelManager = [[ModelManager alloc] init];
    
	context = [self.moralModelManager readWriteManagedObjectContext];

    //Call method to create base Conscience.    
    [self createConscience];
    
	navController1 = [[UINavigationController alloc] init];

	ConscienceViewController *conscienceViewController1 = [[ConscienceViewController alloc] init];
	ReferenceViewController *referenceViewController1 = [[ReferenceViewController alloc] init];

	navController1.navigationBar.barStyle = UIBarStyleBlackTranslucent;

	[navController1	pushViewController:referenceViewController1 animated:NO];
	[navController1 pushViewController:conscienceViewController1 animated:NO];

#if defined(__IPHONE_5_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    
    if ([UINavigationBar respondsToSelector:@selector(appearance)])	{
    
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-texture-bevel.png"] forBarMetrics:UIBarMetricsDefault];
    }    

#endif

	application.applicationSupportsShakeToEdit = YES;
    [_window setRootViewController:navController1];
	[_window makeKeyAndVisible];
	
} 

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
	
	//Working
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -
#pragma mark Conscience Setup

/**
 Implementation: Call all constructors for default Conscience features if they do not already exist.  These setups will be overridden by the configuration task.
 */
- (void) createConscience{
    
    if (!_userConscienceBody) {
        _userConscienceBody = [[ConscienceBody alloc] init];
        
    }
    
    if (!_userConscienceAccessories) {
        _userConscienceAccessories = [[ConscienceAccessories alloc] init];
        
    }
    
    if (!_userConscienceMind) {
        _userConscienceMind = [[ConscienceMind alloc] init];
        
    }
    
    if (!_userCollection) {
        _userCollection = [[NSMutableArray alloc] init];
        
    }
	    
	//Apply User customizations to Conscience and User Data    
    [self configureConscience];
    [self configureCollection];    
	
	//Create physcial, viewable Conscience from constructs    
    if (!_userConscienceView) {
        _userConscienceView = [[ConscienceView alloc] initWithFrame:CGRectMake(20, 130, 200, 200) withBody:_userConscienceBody withAccessories:_userConscienceAccessories withMind:_userConscienceMind];
        
        _userConscienceView.tag = MLConscienceViewTag;
        _userConscienceView.multipleTouchEnabled = TRUE;
    }
    
}

/**
 Implementation: Tear down Conscience.  This is used in low-memory/background scenarios.  Monitor is re-creatable at any point from persistent data.
 */
- (void) destroyConscience{
    
}

/**
 Implementation: Retrieve User-customizations to Monitor from Core Data.  Then build physical traits (eyes/mouth/face/mind).
 */
- (void)configureConscience{
    UserCharacterDAO *currentUserCharacterDAO = [[UserCharacterDAO alloc] init];
    UserCharacter *currentUserCharacter = [currentUserCharacterDAO read:@""];
        
    //Populate User Conscience
    _userConscienceBody.eyeName = [currentUserCharacter characterEye];
    _userConscienceBody.mouthName = [currentUserCharacter characterMouth];
    _userConscienceBody.symbolName = [currentUserCharacter characterFace];

    _userConscienceBody.eyeColor = [currentUserCharacter characterEyeColor];
    _userConscienceBody.browColor = [currentUserCharacter characterBrowColor];
    _userConscienceBody.bubbleColor = [currentUserCharacter characterBubbleColor];
    _userConscienceBody.bubbleType = [[currentUserCharacter characterBubbleType] intValue];
    
    _userConscienceBody.age = [[currentUserCharacter characterAge] intValue];
    _userConscienceBody.size = [[currentUserCharacter characterSize] floatValue];
    
    _userConscienceAccessories.primaryAccessory = [currentUserCharacter characterAccessoryPrimary];
    _userConscienceAccessories.secondaryAccessory = [currentUserCharacter characterAccessorySecondary];
    _userConscienceAccessories.topAccessory = [currentUserCharacter characterAccessoryTop];
    _userConscienceAccessories.bottomAccessory = [currentUserCharacter characterAccessoryBottom];
    
    _userConscienceMind.mood = [[currentUserCharacter characterMood] floatValue];
    _userConscienceMind.enthusiasm = [[currentUserCharacter characterEnthusiasm] floatValue];


	//Call utility class to parse svg data for feature building    
	[ConscienceBuilder buildConscience:_userConscienceBody];
}

/**
 Implementation: Retrieve User-entries such as questions/responses.
 */
- (void)configureCollection{
        
    //Retrieve  assets already earned by user
    UserCollectableDAO *currentUserCollectableDAO = [[UserCollectableDAO alloc] initWithKey:@""];

    NSArray *objects = [currentUserCollectableDAO readAll];
    //Populate dictionary with dilemmaName (key) and moral that was chosen
    for (UserCollectable *match in objects) {
        
        [_userCollection addObject:[match collectableName]];
    }
                
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
    NSLog(@"MEMORY WARNING!");
    
//    [self destroyConscience];
}

@end