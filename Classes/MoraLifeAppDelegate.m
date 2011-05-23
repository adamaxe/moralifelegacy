/**
Moralife AppDelegate.  Implementation.
 
All setup for data, navigation, UI, is done in App delegate.
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@class MoralifeAppDelegate MoralifeAppDelegate.h
@date 03/28/2010
@file
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

@implementation MoraLifeAppDelegate

@synthesize window;
@synthesize userConscienceBody;
@synthesize userConscienceAccessories;
@synthesize userConscienceView;
@synthesize userConscienceMind;
@synthesize userCollection;

@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;

#pragma mark -
#pragma mark AppDelegate lifecycle

- (void)awakeFromNib {
    
    [self createConscience];
    
    //RootViewController *rootViewController = (RootViewController *)[navigationController topViewController];
    //rootViewController.managedObjectContext = self.managedObjectContext;
}

/*
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    return YES;
}
*/

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
    
    [self saveContext];
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
    [self saveContext];
}


/**
 Application starting point.  Setup navigation, delegate, user data, conscience and conscience body/acc/mind.
 @see ConscienceBody
 @see ConscienceAccessories
 */
- (void)applicationDidFinishLaunching:(UIApplication *)application { 
	
	mainMenuTabBarCont = [[UITabBarController alloc] init];
	navController1 = [[UINavigationController alloc] init];
	navController2 = [[UINavigationController alloc] init];
	navController3 = [[UINavigationController alloc] init];
	
	ConscienceViewController *conscienceViewController1 = [[ConscienceViewController alloc] initWithNibName:@"ConscienceView" bundle:[NSBundle mainBundle]];
	ChoiceInitViewController *choiceIntViewController1 = [[ChoiceInitViewController alloc] initWithNibName:@"ChoiceInitView" bundle:[NSBundle mainBundle]];
	ReferenceViewController *referenceViewController1 = [[ReferenceViewController alloc] initWithNibName:@"ReferenceView" bundle:[NSBundle mainBundle]];
	
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
	
	
	//[navController1 pushViewController:homeViewController1 animated:NO];
	[navController1 pushViewController:conscienceViewController1 animated:NO];
	[navController2	pushViewController:choiceIntViewController1 animated:NO];
	[navController3	pushViewController:referenceViewController1 animated:NO];
	
	//[homeViewController1 release];
	[conscienceViewController1 release];
	[choiceIntViewController1 release];
	[referenceViewController1 release];
	
	CGFloat cgf = 0.8;
	
    // Override point for customization after application launch
	mainMenuTabBarCont.viewControllers = [NSArray arrayWithObjects:navController1, navController2, navController3, nil];
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
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
	NSString *pathReadWrite = [[NSBundle mainBundle] pathForResource:@"UserData" ofType:@"momd"];
	NSURL *momURLReadWrite = [NSURL fileURLWithPath:pathReadWrite];
    
	NSManagedObjectModel *modelReadWrite = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadWrite]; 
	
	NSString *pathReadOnly = [[NSBundle mainBundle] pathForResource:@"SystemData" ofType:@"momd"];
	NSURL *momURLReadOnly = [NSURL fileURLWithPath:pathReadOnly];
	NSManagedObjectModel *modelReadOnly = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURLReadOnly];      
	
	managedObjectModel = [NSManagedObjectModel modelByMergingModels:[NSArray arrayWithObjects:modelReadWrite, modelReadOnly, nil]];
	
	[modelReadOnly release];
	[modelReadWrite release];
	
	/*
	//After versioning enabled, mom becomes directory
	NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"SystemData" ofType:@"momd"];
	//NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"SystemData" ofType:@"mom"];

    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    */
	
	return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 Additionally, if the pre-populated DB hasn't been moved to Documents, this occurs.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
	//Retrieve readwrite Documents directory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	//Create pre-loaded SQLite db location
	NSString *preloadData =  [documentsDirectory stringByAppendingPathComponent:@"SystemData.sqlite"];
	NSURL *storeURL = [NSURL fileURLWithPath:preloadData];
	NSString *preloadDataReadWrite =  [documentsDirectory stringByAppendingPathComponent:@"UserData.sqlite"];
	NSURL *storeURLReadWrite = [NSURL fileURLWithPath:preloadDataReadWrite];

	//Create filemanager to manipulate filesystem
	NSFileManager *fileManager = [NSFileManager defaultManager];

	//Determine if pre-loaded SQLite db exists
	BOOL isSQLiteFilePresent = [fileManager fileExistsAtPath:preloadData];

	//Copy pre-loaded SQLite db from bundle to Documents if it doesn't exist
	if (!isSQLiteFilePresent) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"SystemData" ofType:@"sqlite"];
        NSString *defaultStorePathWrite = [[NSBundle mainBundle] pathForResource:@"UserData" ofType:@"sqlite"];

		//Ensure that pre-loaded SQLite db exists in bundle before copy
		if (defaultStorePath) {
			NSError *error = nil;

			[fileManager copyItemAtPath:defaultStorePath toPath:preloadData error:&error];

			NSLog(@"Unresolved error %@", error);
		}
        
		//Ensure that pre-loaded SQLite db exists in bundle before copy
		if (defaultStorePathWrite) {
			NSError *error = nil;
            
			[fileManager copyItemAtPath:defaultStorePathWrite toPath:preloadDataReadWrite error:&error];
            
			NSLog(@"Unresolved error %@", error);
		}        
	}

	//handle db upgrade for auto migration for minor schema changes
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
	/*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
	
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURLReadWrite options:options error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    } 
    
    return persistentStoreCoordinator;
}

- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *saveManagedObjectContext = self.managedObjectContext;
    if (saveManagedObjectContext != nil) {
        if ([saveManagedObjectContext hasChanges] && ![saveManagedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
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
	    
    [self configureConscience];
    [self configureCollection];    
	
    if (!userConscienceView) {
        userConscienceView = [[ConscienceView alloc] initWithFrame:CGRectMake(20, 130, 200, 200) withBody:userConscienceBody withAccessories:userConscienceAccessories withMind:userConscienceMind];
        
        userConscienceView.tag = kConscienceViewTag;
        userConscienceView.multipleTouchEnabled = TRUE; 
    }
    
}

- (void) destroyConscience{
    
	[userConscienceBody release];
	[userConscienceAccessories release];
    [userConscienceMind release];
	[userConscienceView release];
}

- (void)configureConscience{

    NSManagedObjectContext *context = [self managedObjectContext];

    //Retrieve ConscienceBody attributes completed by User
    NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserCharacter" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
    
    // Execute the fetch
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
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

	[ConscienceBuilder buildConscience:userConscienceBody];
}

- (void)configureCollection{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //Retrieve  assets already earned by user
    NSEntityDescription *entityAssetDesc = [NSEntityDescription entityForName:@"UserCollectable" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityAssetDesc];
    
    // Execute the fetch
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
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
	
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	
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