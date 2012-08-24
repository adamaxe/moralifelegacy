/**
 Report view model.  Generate the data from User choices to display as a list of selections to allow the User to re-enter choice based upon a previous choice.

 @class ChoiceHistoryModel
 @see ChoiceHistoryViewController

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 08/16/2012
 @file
 */

@class ModelManager;

@interface ChoiceHistoryModel : NSObject

@property (nonatomic, assign) BOOL isGood;		/**< is current view for Virtues or Vices */
@property (nonatomic, assign) BOOL isAscending;		/**< current order type */


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
- (id)initWithModelManager:(ModelManager *) modelManager;

/**
 Retrieve choice for copying into new choice
 @param choiceKey NSString of requested pkey
 */
- (void) retrieveChoice:(NSString *) choiceKey;

@end
