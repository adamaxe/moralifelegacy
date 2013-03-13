/**
Conscience Interaction dilemma screen.  View for Conscience asking User moral question.

@class DilemmaViewController
@see ConscienceListViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/9/2010
@file
 */

@class ModelManager, UserConscience;

@interface DilemmaViewController : UIViewController

@property(nonatomic, strong) UIImage *screenshot;       /**< screenshot of previous screen for transition */

/**
 Creates the viewController with the User's Conscience
 @param nibNameOrNil name of XIB
 @param nibBundleOrNil bundle in which to locate XIB
 @param modelManager ModelManager data persistence
 @param userConscience UserConscience for modals and help screens
 @return id instance of DilemmaViewController
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience;

/**
Accepts User input to change the presently displayed UIView and possibly commit Choice
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)selectChoice:(id)sender;

/**
Accepts User input to return to ConscienceModalViewController
@param id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)returnToHome:(id)sender;

@end