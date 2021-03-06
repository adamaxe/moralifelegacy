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
#import "HomeModel.h"
#import "HomeViewController.h"
#import "UserConscience.h"
//#import <Crashlytics/Crashlytics.h>
//#import "Flurry.h"

NSString* const MLAPIKeyPListFileName = @"moralife-apikeys";

@interface MoraLifeAppDelegate () {

	UINavigationController *homeNavigationController; /**< UINavController for first screen, Home */

}

@property (nonatomic, strong) ModelManager *moralModelManager;

/**
 Retrieve current sandbox Documents directory
 @return Documents NSURL of sandboxed application writable Doc directory
 */
- (NSURL *)applicationDocumentsDirectory;

@end

@implementation MoraLifeAppDelegate

#pragma mark -
#pragma mark AppDelegate lifecycle

- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {

    
    [self.moralModelManager saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

        
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [self.moralModelManager saveContext];
}


/**
 Application starting point.  Setup navigation, delegate, user data, conscience and conscience body/acc/mind.
 @see ConscienceBody
 @see ConscienceAccessories
 */
- (void)applicationDidFinishLaunching:(UIApplication *)application {
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:MLAPIKeyPListFileName ofType:@"plist"];
//    NSDictionary *apiKeys = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
//    NSString *crashlyticsAPIKey = [apiKeys objectForKey:@"crashlytics"];
//    NSString *flurryAPIKey = [apiKeys objectForKey:@"flurry"];
//
//    if (![crashlyticsAPIKey isEqualToString:@""]) {
//        [Crashlytics startWithAPIKey:crashlyticsAPIKey];
//    }
//
//    if (![flurryAPIKey isEqualToString:@""]) {
//        [Flurry startSession:flurryAPIKey];
//    }



    self.moralModelManager = [[ModelManager alloc] init];
    HomeModel *homeModel = [[HomeModel alloc] initWithModelManager:self.moralModelManager];

	homeNavigationController = [[UINavigationController alloc] init];

    UserConscience *userConscience = [[UserConscience alloc] initWithModelManager:self.moralModelManager];

	HomeViewController *homeViewController = [[HomeViewController alloc] initWithModel:homeModel modelManager:self.moralModelManager andConscience:userConscience];

	homeNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

	[homeNavigationController pushViewController:homeViewController animated:NO];

#if defined(__IPHONE_5_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
    
    if ([UINavigationBar respondsToSelector:@selector(appearance)])	{
    
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar-texture-bevel.png"] forBarMetrics:UIBarMetricsDefault];
    }    

#endif

	application.applicationSupportsShakeToEdit = YES;
    [self.window setRootViewController:homeNavigationController];
	[self.window makeKeyAndVisible];
	
} 

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
	
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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
