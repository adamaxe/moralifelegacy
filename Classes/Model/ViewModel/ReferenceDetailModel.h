/**
 ReferenceDetails view model.  Returns the details about a specific reference asset.

 @class ReferenceDetailModel
 @see ReferenceDetailViewController

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 08/16/2012
 @file
 */

#import "ModelManager.h"

@interface ReferenceDetailModel : NSObject

@property (nonatomic, assign) int referenceType;    /**< current reference type */

//Raw, readonly data of all entered choices
@property (nonatomic, readonly, strong) NSMutableArray *references;			/**< Array of User-entered choice titles */
@property (nonatomic, readonly, strong) NSMutableArray *referenceKeys;     	/**< Array of whether choices are good/bad */
@property (nonatomic, readonly, strong) NSMutableArray *details;			/**< Array of User-entered details */
@property (nonatomic, readonly, strong) NSMutableArray *icons;				/**< Array of associated images */


/**
 Builds model with dependency injection
 @param modelManager ModelManager for either production or testing
 @param prefs NSUserDefaults for dependency injection
 @param userCollection NSArray of currently owned objects for comparison
 @return id ReferenceModel
 */
- (id)initWithModelManager:(ModelManager *) modelManager andDefaults:(NSUserDefaults *) prefs andUserCollection:(NSArray *) userCollection;

/**
 Retrieve reference for display
 @param reference NSString of requested pkey
 */
- (void) retrieveReference:(NSString *) referenceKey;

@end
