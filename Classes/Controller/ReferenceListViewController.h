/**
List of available References.  
 
Secondary screen in Reference review Workflow.  User can filter and review a list of available References for further inspection.
 
@class ReferenceListViewController
@see ReferenceViewController

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/04/2010
 */

@class ReferenceModel;

@interface ReferenceListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, assign) int referenceType;	/**< int determining type of reference selection */

/**
 Dependency injection constructor to pass model
 @param referenceModel ReferenceModel handling business logic
 @return id instance of ReferenceModel
 */
- (id)initWithModel:(ReferenceModel *) referenceModel;


@end