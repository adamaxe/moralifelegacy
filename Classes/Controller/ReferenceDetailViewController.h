/**
Reference information screen.  View that is presented when User requests a reference.

Final screen in Reference View Workflow.  Lists all relevant information about ReferenceAsset, Moral or ConscienceAsset.
 
@class ReferenceDetailViewController
@see ReferenceViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/06/2010
@file
@todo rename to ReferenceViewController
 */

@class ReferenceModel, UserConscience;

@interface ReferenceDetailViewController : UIViewController <UIActionSheetDelegate>

/**
 Dependency injection constructor to pass model
 @param referenceModel ReferenceModel handling business logic
 @param userConscience UserConscience for modals and help screens
 @return id instance of ReferenceDetailViewController
 */
- (id)initWithModel:(ReferenceModel *) referenceModel andConscience:(UserConscience *)userConscience;

/**
Accepts User input to ask for a Quote from reference.
 */
-(IBAction)showReferenceData:(id)sender;

/**
Accepts User input to launch Safari and browse reference's online reference.
 */
-(IBAction)showExternalURL:(id)sender;

/**
Accepts User input to cancel the detail screen.
@todo rename as ReferenceDetail is not modal
 */
-(IBAction)dismissReferenceModal:(id)sender;

@end