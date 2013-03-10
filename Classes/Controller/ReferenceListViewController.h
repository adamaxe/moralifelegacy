/**
List of available References.  
 
Secondary screen in Reference review Workflow.  User can filter and review a list of available References for further inspection.
 
@class ReferenceListViewController
@see ReferenceViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/04/2010
 */

#import "ReferenceModel.h"

@class UserConscience;

@interface ReferenceListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, assign) MLReferenceModelTypeEnum referenceType;	/**< int determining type of reference selection */

/**
 Dependency injection constructor to pass model
 @param referenceModel ReferenceModel handling business logic
 @param userConscience UserConscience for modals and help screens
 @return id instance of ReferenceListViewController
 */
- (id)initWithModel:(ReferenceModel *) referenceModel andConscience:(UserConscience *)userConscience;


@end