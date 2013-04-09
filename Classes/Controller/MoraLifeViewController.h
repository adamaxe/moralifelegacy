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

@interface MoraLifeViewController : UIViewController <ViewControllerLocalization> {

    @protected
        ModelManager *_modelManager;
        UserConscience *_userConscience;
        ConscienceHelpViewController *_conscienceHelpViewController;
}

/**
 Nib version of Init that creates the viewController with the User's Conscience
 @param nibName NSString signifying the XIB to load
 @param nibBundle NSBundle where the XIB is stored
 @param modelManager ModelManager data persistence
 @param userConscience UserConscience for modals and help screens
 @return id instance of MoraLifeViewController
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience;

/**
 Creates the viewController with the User's Conscience
 @param modelManager ModelManager data persistence
 @param userConscience UserConscience for modals and help screens
 @return id instance of MoraLifeViewController
 */
-(id)initWithModelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience;

@end
