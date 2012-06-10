/**
Moralife AppDelegate.  This class represents beginning of code.
 
Moralife is the iPhone application which will provide its User with a Digital Conscience.
<br>
<br>The User can then enter in moral and immoral choices that the make throughout their daily lives.  These choices will both affect the Conscience's demeanor as well as provide the User the ability to customize the Conscience.
<br>The Conscience can also challenge the User to answer hypotheical moral dilemmas or engage in games.
<br>The User can also view reports on their moral progress and read about historical references.

<br>For code walk purposes, please review MoraLifeAppDelegate which launches ConscienceViewController as the starting point.  IntroViewController is launched from there on first installation.  From this starting point, you can walk the entire code base by referencing the See Also: Tags.
 
<br>Application has been tested on iPhone 1/3G/3GS/4 and iOS 3.1/4.2/4.3/5.0
 
@mainpage Moralife
@see ConscienceViewController
@version 1.0
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@class MoralifeAppDelegate
@date 03/28/2010
@file
*/

@class ConscienceBody, ConscienceAccessories, ConscienceView, ConscienceMind, ModelManager;

@interface MoraLifeAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) ConscienceBody *userConscienceBody;   /**< Representation of User's Conscience */
@property (nonatomic, retain) ConscienceAccessories *userConscienceAccessories;     /**< Representation of User's Accessories */
@property (nonatomic, retain) ConscienceView *userConscienceView;   /**< Visual representation of User's Conscience+Accessories */
@property (nonatomic, retain) ConscienceMind *userConscienceMind;   /**< Representation of User's Mental State */
@property (nonatomic, retain) NSMutableArray *userCollection;       /**< Currently owned items */
@property (nonatomic, assign) BOOL isCurrentIOS;
@property (nonatomic, retain) ModelManager *moralModelManager;

/**
 Retrieve current sandbox Documents directory
 @return Documents NSURL of sandboxed application writable Doc directory
 */
- (NSURL *)applicationDocumentsDirectory;

@end

