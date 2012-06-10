/**
Moralife AppDelegate.  Implementation.  The delegate handles both the Core Data Stack and the Conscience.  User Conscience can appear on any screen, so it makes sense to create and maintain him in the delegate. He is not a singleton, however, due to the fact that there can be many different iterations of a Conscience type.
 
<br>All setup for Conscience data, navigation, UI, is done in App delegate.  All setup for data, navigation, UI, is done in App delegate.
@todo project->buildsettings->architectures->debug->remove any IOS SDK
@todo Model: change ReferenceText.belief to-many relationship to beliefs
@todo Model: change Character.story to-many relationship to stories
@todo Model: change delete rule for ReferenceText.children to cascade
@todo Model: change Character.sizeCharacter type to Float, change UserCharacter and Character to similiar
@todo Model: change Moral.dilemmaA/B typo
@todo Model: why is Moral.dilemma 1 to many?
@class MoralifeAppDelegate MoralifeAppDelegate.h
*/

#import "MoraLifeAppDelegate.h"
#import "ConscienceViewController.h"
#import "XMLParser.h"
#import "ConscienceBody.h"
#import "ConscienceAccessories.h"
#import "ConscienceView.h"
#import "ConscienceAsset.h"
#import "ConscienceBuilder.h"
#import "ChoiceInitViewController.h"
#import "ReferenceViewController.h"
#import "UserCharacter.h"
#import "ConscienceMind.h"
#import "UserCollectable.h"
#import "ModelManager.h"

@interface MoraLifeAppDelegate () {
    
	UIWindow *window;	/**< UIWindow that contains all other UIViews */
	
	UITabBarController *mainMenuTabBarCont;	/**< UITabBarController along bottom of screens */
	UINavigationController *navController1; /**< UINavController for first screen, Home */
	UINavigationController *navController2; /**< UINavController for second screen, Choices */
	UINavigationController *navController3; /**< UINavController for third screen, Reference */
    	
}

@end

@implementation MoraLifeAppDelegate

@synthesize window;
@synthesize userConscienceBody;
@synthesize userConscienceAccessories;
@synthesize userConscienceView;
@synthesize userConscienceMind;
@synthesize userCollection;
@synthesize isCurrentIOS;
@synthesize moralModelManager;

#pragma mark -
#pragma mark AppDelegate lifecycle

- (void)awakeFromNib {
    
    moralModelManager = [[ModelManager alloc] init];
    
	//Call method to create base Conscience.    
    [self createConscience];

}

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
    
    [moralModelManager saveContext];
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
    
    [userConscienceView setNeedsDisplay];
    
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [moralModelManager saveContext];
}


/**
 Application starting point.  Setup navigation, delegate, user data, conscience and conscience body/acc/mind.
 @see ConscienceBody
 @see ConscienceAccessories
 */
- (void)applicationDidFinishLaunching:(UIApplication *)application { 
	
    isCurrentIOS = (&UIApplicationDidEnterBackgroundNotification != NULL);
    
	mainMenuTabBarCont = [[UITabBarController alloc] init];
	navController1 = [[UINavigationController alloc] init];
	navController2 = [[UINavigationController alloc] init];
	navController3 = [[UINavigationController alloc] init];
	
	ConscienceViewController *conscienceViewController1 = [[ConscienceViewController alloc] init];
	ChoiceInitViewController *choiceIntViewController1 = [[ChoiceInitViewController alloc] init];
	ReferenceViewController *referenceViewController1 = [[ReferenceViewController alloc] init];
	
	navController1.tabBarItem.title = NSLocalizedString(@"PrimaryNav1Title",@"Title for Navigation 1");
	navController1.tabBarItem.accessibilityHint = NSLocalizedString(@"PrimaryNav1Hint",@"Hint for Navigation 1");
	navController1.tabBarItem.accessibilityLabel = NSLocalizedString(@"PrimaryNav1Label",@"Label for Navigation 1");	
	navController1.tabBarItem.image = [UIImage imageNamed:@"tabbar-home.png"];
	navController1.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	navController2.tabBarItem.title = NSLocalizedString(@"PrimaryNav2Title",@"Title for Navigation 2");
	navController2.tabBarItem.accessibilityHint = NSLocalizedString(@"PrimaryNav2Hint",@"Hint for Navigation 2");
	navController2.tabBarItem.accessibilityLabel = NSLocalizedString(@"PrimaryNav2Label",@"Label for Navigation 2");
	navController2.tabBarItem.image = [UIImage imageNamed:@"tabbar-quill.png"];	
	//[navController2.navigationBar setTintColor:[UIColor colorWithHue:0 saturation:0 brightness:0.5f alpha:0.1f]];
	navController2.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	navController3.tabBarItem.title = NSLocalizedString(@"PrimaryNav3Title",@"Title for Navigation 3");
	navController3.tabBarItem.accessibilityHint = NSLocalizedString(@"PrimaryNav3Hint",@"Hint for Navigation 3");
	navController3.tabBarItem.accessibilityLabel = NSLocalizedString(@"PrimaryNav3Label",@"Label for Navigation 3");
	navController3.tabBarItem.image = [UIImage imageNamed:@"tabbar-ref.png"];
	navController3.navigationBar.barStyle = UIBarStyleBlackTranslucent;
		
	[navController1 pushViewController:conscienceViewController1 animated:NO];
	
    [navController2	pushViewController:choiceIntViewController1 animated:NO];
	[navController3	pushViewController:referenceViewController1 animated:NO];
	
    [conscienceViewController1 release];
	[choiceIntViewController1 release];
	[referenceViewController1 release];

#if defined(__IPHONE_5_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    
    if ([UINavigationBar respondsToSelector:@selector(appearance)])	{
    
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-texture-bevel.png"] forBarMetrics:UIBarMetricsDefault];
    }    

#endif

    //Menubar removal
	CGFloat cgf = 0.8;
	
    // Override point for customization after application launch
	[mainMenuTabBarCont setViewControllers:[NSArray arrayWithObjects:navController1, navController2, navController3, nil]];
	mainMenuTabBarCont.title = NSLocalizedString(@"PrimaryMenuTitle",@"Label for Primary Tab Menu");
	mainMenuTabBarCont.accessibilityHint = NSLocalizedString(@"PrimaryMenuHint",@"Hint for Primary Tab Menu");
	mainMenuTabBarCont.accessibilityLabel = NSLocalizedString(@"PrimaryMenuLabel",@"Label for Primary Tab Menu");
	//mainMenuTabBarCont.tabBar.opaque = YES;
	//mainMenuTabBarCont.view.alpha = [NSNumber numberWithFloat:0.5];
	[mainMenuTabBarCont.tabBar setAlpha:cgf];
	[navController1 release];
	[navController2 release];
	[navController3 release];
		
	application.applicationSupportsShakeToEdit = YES;
    
	[window addSubview:mainMenuTabBarCont.view];
	[window makeKeyAndVisible];
	
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
    
    if (!userConscienceBody) {
        userConscienceBody = [[ConscienceBody alloc] init];
        
    }
    
    if (!userConscienceAccessories) {
        userConscienceAccessories = [[ConscienceAccessories alloc] init];
        
    }
    
    if (!userConscienceMind) {
        userConscienceMind = [[ConscienceMind alloc] init];
        
    }
    
    if (!userCollection) {
        userCollection = [[NSMutableArray alloc] init];
        
    }
	    
	//Apply User customizations to Conscience and User Data    
    [self configureConscience];
    [self configureCollection];    
	
	//Create physcial, viewable Conscience from constructs    
    if (!userConscienceView) {
        userConscienceView = [[ConscienceView alloc] initWithFrame:CGRectMake(20, 130, 200, 200) withBody:userConscienceBody withAccessories:userConscienceAccessories withMind:userConscienceMind];
        
        userConscienceView.tag = kConscienceViewTag;
        userConscienceView.multipleTouchEnabled = TRUE; 
    }
    
}

/**
 Implementation: Tear down Conscience.  This is used in low-memory/background scenarios.  Monitor is re-creatable at any point from persistent data.
 */
- (void) destroyConscience{
    
	[userConscienceBody release];
	[userConscienceAccessories release];
    [userConscienceMind release];
	[userConscienceView release];
}

/**
 Implementation: Retrieve User-customizations to Monitor from Core Data.  Then build physical traits (eyes/mouth/face/mind).
 */
- (void)configureConscience{
    
    //Retrieve ConscienceBody attributes completed by User
    NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserCharacter" inManagedObjectContext:moralModelManager.managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
    
    // Execute the fetch
    NSError *error = nil;
    NSArray *objects = [moralModelManager.managedObjectContext executeFetchRequest:request error:&error];
    
	if ([objects count] == 0) {
		
        //User has not completed a single choice
        //populate array to prevent npe
        NSLog(@"No matches");
        
	} else {
        
        //Populate User Conscience
        UserCharacter* match = [objects objectAtIndex:0];

        userConscienceBody.eyeName = [match characterEye];
        userConscienceBody.mouthName = [match characterMouth];
        userConscienceBody.symbolName = [match characterFace];

        userConscienceBody.eyeColor = [match characterEyeColor];
        userConscienceBody.browColor = [match characterBrowColor];
        userConscienceBody.bubbleColor = [match characterBubbleColor];
        userConscienceBody.bubbleType = [[match characterBubbleType] intValue];
        
        userConscienceBody.age = [[match characterAge] intValue];
        userConscienceBody.size = [[match characterSize] floatValue];
        
        userConscienceAccessories.primaryAccessory = [match characterAccessoryPrimary];
        userConscienceAccessories.secondaryAccessory = [match characterAccessorySecondary];
        userConscienceAccessories.topAccessory = [match characterAccessoryTop];
        userConscienceAccessories.bottomAccessory = [match characterAccessoryBottom];
        
        userConscienceMind.mood = [[match characterMood] floatValue];
        userConscienceMind.enthusiasm = [[match characterEnthusiasm] floatValue];

    }
    
    [request release];

	//Call utility class to parse svg data for feature building    
	[ConscienceBuilder buildConscience:userConscienceBody];
}

/**
 Implementation: Retrieve User-entries such as questions/responses.
 */
- (void)configureCollection{
        
    //Retrieve  assets already earned by user
    NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserCollectable" inManagedObjectContext:moralModelManager.managedObjectContext];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
    
    // Execute the fetch
    NSError *error = nil;
    NSArray *objects = [moralModelManager.managedObjectContext executeFetchRequest:request error:&error];
    
	if ([objects count] == 0) {
		
        //User has not completed a single choice
        //populate array to prevent npe
        NSLog(@"No matches");
        
	} else {
        
        //Populate dictionary with dilemmaName (key) and moral that was chosen
        for (UserCollectable *match in objects) {
            
            [userCollection addObject:[match collectableName]];
        }
    }
    
    [request release];
    
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

/**
 Release init'ed objects, deallocate super.
 */
- (void)dealloc {
	
	/** @todo revisit memory management for ARC migration */    
	
	[mainMenuTabBarCont release];
	[userConscienceBody release];
	[userConscienceAccessories release];
    [userConscienceMind release];
	[userConscienceView release];
    [userCollection release];
    [window release];
    [super dealloc];
}


@end