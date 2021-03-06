/**
Moralife AppDelegate.  This class represents beginning of code.
 
Moralife is the iPhone application which will provide its User with a Digital Conscience.
<br>
<br>The User can then enter in moral and immoral choices that the make throughout their daily lives.  These choices will both affect the Conscience's demeanor as well as provide the User the ability to customize the Conscience.
<br>The Conscience can also challenge the User to answer hypotheical moral dilemmas or engage in games.
<br>The User can also view reports on their moral progress and read about historical references.

<br>For code walk purposes, please review MoraLifeAppDelegate which launches HomeViewController as the starting point.  IntroViewController is launched from there on first installation.  From this starting point, you can walk the entire code base by referencing the See Also: Tags.
 
<br>Application has been tested on iPhone 3GS/4 and iOS 4.2/4.3/5.0
 
@mainpage Moralife
@see HomeViewController
@version 1.3.4
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@class MoralifeAppDelegate
@date 03/28/2010
@file
*/

@class ModelManager;

@interface MoraLifeAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;

@end

