/**
List of available References.  
 
Secondary screen in Reference review Workflow.  User can filter and review a list of available References for further inspection.
 
@class ReferenceListViewController
@see ReferenceViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/04/2010
 */

#import "ReferenceModel.h"
#import "MoraLifeViewController.h"

@interface ReferenceListViewController : MoraLifeViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, assign) MLReferenceModelTypeEnum referenceType;	/**< int determining type of reference selection */

/**
 Dependency injection constructor to pass model
 @param referenceModel ReferenceModel handling business logic
 @param modelManager ModelManager data persistence
 @param userConscience UserConscience for modals and help screens
 @return id instance of ReferenceListViewController
 */
- (instancetype)initWithModel:(ReferenceModel *) referenceModel modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience NS_DESIGNATED_INITIALIZER;


@end
