/**
Conscience Interaction dilemma screen.  View for Conscience asking User moral question.

@class DilemmaViewController
@see ConscienceListViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 09/9/2010
@file
 */

#import "MoraLifeViewController.h"

@interface DilemmaViewController : MoraLifeViewController

@property(nonatomic, strong) UIImage *screenshot;       /**< screenshot of previous screen for transition */

/**
Accepts User input to change the presently displayed UIView and possibly commit Choice
@param sender id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)selectChoice:(id)sender;

/**
Accepts User input to return to ConscienceViewController
@param sender id Object which requested method
@return IBAction method available from Interface Builder
 */
-(IBAction)returnToHome:(id)sender;

@end