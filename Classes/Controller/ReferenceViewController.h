/**
Reference Menu screen.  

Primary screen of Reference selection Workflow.  User can select what type of Reference is desired.

@class ReferenceViewController
@see ReferenceListViewController
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 05/17/2010
@file
@todo rename to ReferenceInitViewController
*/

@interface ReferenceViewController : UIViewController

/**
Accepts User input to determine type of Reference requested
@param id Object which requested method
@return IBAction referenced from Interface Builder
 */
- (IBAction) selectReferenceType:(id)sender;

@end
