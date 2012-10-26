/**
 Report view model.  Generate the data from User choices to display as a list of selections to allow the User to re-enter choice based upon a previous choice.

 @class ChoiceHistoryModel
 @see ChoiceHistoryViewController

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 08/16/2012
 @file
 */

@class ModelManager;

extern NSString* const MLChoiceHistoryModelTypeAll;
extern NSString* const MLChoiceHistoryModelTypeIsGood;
extern NSString* const MLChoiceHistoryModelTypeIsBad;

extern NSString* const MLChoiceListSortDate;
extern NSString* const MLChoiceListSortWeight;
extern NSString* const MLChoiceListSortSeverity;
extern NSString* const MLChoiceListSortName;

@interface ChoiceHistoryModel : NSObject

@property (nonatomic, strong) NSString *choiceType;     /**< determine if Virtues/Vices/All should be returned */
@property (nonatomic, assign) BOOL isAscending;         /**< current order type */
@property (nonatomic, strong) NSString *sortKey; /**< sort order */

//Raw, readonly data of all entered choices
@property (nonatomic, readonly, strong) NSMutableArray *choices;			/**< Array of User-entered choice titles */
@property (nonatomic, readonly, strong) NSMutableArray *choicesAreGood;     	/**< Array of whether choices are good/bad */
@property (nonatomic, readonly, strong) NSMutableArray *choiceKeys;			/**< Array of User-entered choice titles */
@property (nonatomic, readonly, strong) NSMutableArray *details;			/**< Array of User-entered details */
@property (nonatomic, readonly, strong) NSMutableArray *icons;				/**< Array of associated images */


/**
 Builds model with dependency injection
 @param modelManager ModelManager for either production or testing
 @return id ChoiceHistoryModel
 */
- (id)initWithModelManager:(ModelManager *) modelManager andDefaults:(NSUserDefaults *) prefs;

/**
 Retrieve choice for copying into new choice
 @param choiceKey NSString of requested pkey
 @param isEditing BOOL return determining if choice should be used for new entry or for editing
 */
- (void) retrieveChoice:(NSString *) choiceKey forEditing:(BOOL)isEditing;

@end
