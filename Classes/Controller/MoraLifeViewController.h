/**
MoraLife Superclass View Controller.  Base UIViewController for all MoraLife UIViewControllers.

This UIViewController subclass possesses an init for ModelManager and UserConscience, because every MoraLife UIViewController needs these two items

@class MoraLifeViewController

@author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 03/10/2013
*/

#import "ModelManager.h"
#import "UserConscience.h"
#import "UIViewController+Screenshot.h"
#import "ConscienceHelpViewController.h"
#import "UIFont+Utility.h"
#import "ViewControllerLocalization.h"

/**
 User Conscience Touch Protocol.  User Conscience should handle the visualizations of what happens when a User touches it.  However, each ViewController that is presenting the UserConscience should elect to do something when the conscience is touched.

 Copyright 2013 Team Axe, LLC. All rights reserved.

 @class UserConscienceTouchProtocol
 @author Team Axe, LLC. http://www.teamaxe.org
 @date 04/14/2013
 */

@protocol UserConscienceTouchProtocol

/**
 Action when the User has began touching the Conscience
 */
- (void) userConscienceTouchBegan;

/**
 Action when the User has stopped touching the Conscience
 */
- (void) userConscienceTouchEnded;

@end

@interface MoraLifeViewController : UIViewController <ViewControllerLocalization, UserConscienceTouchProtocol> {

    @protected
        ModelManager *_modelManager;
        UserConscience *_userConscience;
        ConscienceHelpViewController *_conscienceHelpViewController;
}

-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
-(instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 Nib version of Init that creates the viewController with the User's Conscience
 @param nibNameOrNil NSString signifying the XIB to load
 @param nibBundleOrNil NSBundle where the XIB is stored
 @param modelManager ModelManager data persistence
 @param userConscience UserConscience for modals and help screens
 @return id instance of MoraLifeViewController
 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience;

/**
 Creates the viewController with the User's Conscience
 @param modelManager ModelManager data persistence
 @param userConscience UserConscience for modals and help screens
 @return id instance of MoraLifeViewController
 */
-(instancetype)initWithModelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience NS_DESIGNATED_INITIALIZER;

/**
 Clears the conscience off the screen before taking a screenshot
 @return UIImage screenshot without the Conscience on screen
 */
@property (NS_NONATOMIC_IOSONLY, readonly, strong) UIImage *prepareScreenForScreenshot;

@end
