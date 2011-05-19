/**
Moralife AppDelegate.  This class represents beginning of code.
 
Moralife is the iPhone application which will provide its User with a Digital Conscience.
The User can then enter in moral and immoral choices that the make throughout their daily lives.
These choices will both affect the Conscience's demeanor as well as provide the User the ability to customize the Conscience.
The Conscience can also challenge the User to answer hypotheical moral dilemmas or engage in games.
The User can also view reports on their moral progress and read about historical references.

@mainpage Moralife
@version 0.5
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@class MoralifeAppDelegate MoralifeAppDelegate.h
@date 03/28/2010
@file
*/

#import <CoreData/CoreData.h>

@class ConscienceBody, ConscienceAccessories, ConscienceView, ConscienceMind;

@interface MoraLifeAppDelegate : NSObject <UIApplicationDelegate> {

	UIWindow *window;	/**< UIWindow that contains all other UIViews */
	
	UITabBarController *mainMenuTabBarCont;	/**< UITabBarController along bottom of screens */
	UINavigationController *navController1; /**< UINavController for first screen, Home */
	UINavigationController *navController2; /**< UINavController for second screen, Choices */
	UINavigationController *navController3; /**< UINavController for third screen, Reference */

//	ConscienceBody *userConscienceBody;					/**< Representation of User's Conscience */
//	ConscienceAccessories *userConscienceAccessories;	/**< Representation of User's Accessories */
//	ConscienceView *userConscienceView;					/**< Visual representation of User's Conscience+Accessories */
//  ConscienceMind *userConscienceMind;					/**< Representation of User's Mental State */
//	NSMutableArray *userCollection;                     /**< Currently owned items */
    
	@private	
	NSManagedObjectModel	*managedObjectModel;
	NSManagedObjectContext	*managedObjectContext;
	NSPersistentStoreCoordinator	*persistentStoreCoordinator;
	
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) ConscienceBody *userConscienceBody;
@property (nonatomic, retain) ConscienceAccessories *userConscienceAccessories;
@property (nonatomic, retain) ConscienceView *userConscienceView;
@property (nonatomic, retain) ConscienceMind *userConscienceMind;
@property (nonatomic, retain) NSMutableArray *userCollection;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator	*persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;
- (void)createConscience;
- (void)destroyConscience;
- (void)configureConscience;
- (void)configureCollection;

@end

