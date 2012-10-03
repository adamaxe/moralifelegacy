/**
 Report view model.  Generate the data from User choices to display on the ReportPieViewController.

 @class ReportPieViewModel
 @see ReportPieViewController

 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 08/16/2012
 @file
 */

@class ModelManager;
@interface ReportPieModel : NSObject

@property (nonatomic, assign) BOOL isGood;		/**< is current view for Virtues or Vices */
@property (nonatomic, assign) BOOL isAscending;		/**< current order type */
@property (nonatomic, assign) BOOL isAlphabetical;	/**< current sort type */

@property (nonatomic, readonly, strong) NSMutableArray *reportNames;    /**< virtue/vice display */
@property (nonatomic, readonly, strong) NSMutableArray *moralNames;     /**< display names for Moral listings */
@property (nonatomic, readonly, strong) NSMutableArray *pieValues;      /**< percentage of pie chart */
@property (nonatomic, readonly, strong) NSMutableArray *pieColors;      /**< color assigned to moral for name/pie slice */
@property (nonatomic, readonly, strong) NSMutableDictionary *moralImageNames;   /**< moral icon */

/**
Builds model with dependency injection
 @param modelManager ModelManager for either production or testing
 @return id ReportPieModel
 */
- (id)initWithModelManager:(ModelManager *) modelManager;

@end
