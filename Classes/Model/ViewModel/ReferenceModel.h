/**
 Reference view model.  Generate the various reference assets to which the User has access.

 @class ReferenceModel
 @see ReferenceListViewController

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 08/16/2012
 @file
 */

/**
 Possible positions of Extensions
 typedef utilized to avoid having to use enum declaration
 */
typedef enum referenceModelTypeEnum{
	kReferenceModelTypeConscienceAsset,
	kReferenceModelTypeBelief,
	kReferenceModelTypeText,
	kReferenceModelTypePerson,
	kReferenceModelTypeMoral,
	kReferenceModelTypeReferenceAsset
}referenceModelTypeEnum;

@interface ReferenceModel : NSObject

@property (nonatomic, assign) int referenceType;    /**< current reference type */

//Raw, readonly data of all entered choices
@property (nonatomic, readonly, retain) NSMutableArray *references;			/**< Array of User-entered choice titles */
@property (nonatomic, readonly, retain) NSMutableArray *referenceKeys;     	/**< Array of whether choices are good/bad */
@property (nonatomic, readonly, retain) NSMutableArray *details;			/**< Array of User-entered details */
@property (nonatomic, readonly, retain) NSMutableArray *icons;				/**< Array of associated images */


/**
 Builds model with dependency injection
 @param modelManager ModelManager for either production or testing
 @return id ChoiceHistoryModel
 */
- (id)initWithModelManager:(ModelManager *) modelManager andDefaults:(NSUserDefaults *) prefs andUserCollection:(NSArray *) userCollection;

/**
 Retrieve choice for copying into new choice
 @param choiceKey NSString of requested pkey
 */
- (void) retrieveReference:(NSString *) referenceKey;

@end
