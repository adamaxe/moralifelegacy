/**
 Report view model.  Generate the data from User choices to display as a list of selections to allow the User to re-enter choice based upon a previous choice.

 @class ChoiceHistoryModel
 @see ChoiceHistoryViewController

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 08/16/2012
 @file
 */

@class ModelManager;

extern NSString* const kChoiceHistoryModelTypeAll;
extern NSString* const kChoiceHistoryModelTypeIsGood;
extern NSString* const kChoiceHistoryModelTypeIsBad;

extern NSString* const kChoiceListSortDate;
extern NSString* const kChoiceListSortWeight;
extern NSString* const kChoiceListSortSeverity;
extern NSString* const kChoiceListSortName;

@interface ChoiceHistoryModel : NSObject

@property (nonatomic, retain) NSString *choiceType;     /**< determine if Virtues/Vices/All should be returned */
@property (nonatomic, assign) BOOL isAscending;         /**< current order type */
@property (nonatomic, retain) NSString *sortKey; /**< sort order */

//Raw, readonly data of all entered choices
@property (nonatomic, readonly, retain) NSMutableArray *choices;			/**< Array of User-entered choice titles */
@property (nonatomic, readonly, retain) NSMutableArray *choicesAreGood;     	/**< Array of whether choices are good/bad */
@property (nonatomic, readonly, retain) NSMutableArray *choiceKeys;			/**< Array of User-entered choice titles */
@property (nonatomic, readonly, retain) NSMutableArray *details;			/**< Array of User-entered details */
@property (nonatomic, readonly, retain) NSMutableArray *icons;				/**< Array of associated images */


/**
 Builds model with dependency injection
 @param modelManager ModelManager for either production or testing
 @return id ChoiceHistoryModel
 */
- (id)initWithModelManager:(ModelManager *) modelManager andDefaults:(NSUserDefaults *) prefs;

/**
 Retrieve choice for copying into new choice
 @param choiceKey NSString of requested pkey
 */
- (void) retrieveChoice:(NSString *) choiceKey;

@end
