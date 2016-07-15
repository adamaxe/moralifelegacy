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

@property (nonatomic, readonly, strong) NSArray *reportNames;    /**< report types */
@property (nonatomic, readonly, strong) NSArray *moralNames;     /**< display names for Moral listings */
@property (nonatomic, readonly, strong) NSArray *pieValues;      /**< percentage of pie chart */
@property (nonatomic, readonly, strong) NSArray *pieColors;      /**< color assigned to moral for name/pie slice */
@property (nonatomic, readonly, strong) NSDictionary *moralImageNames;   /**< moral icon */

-(instancetype)init NS_UNAVAILABLE;

/**
Builds model with dependency injection
 @param modelManager ModelManager for either production or testing
 @return id ReportPieModel
 */
- (instancetype)initWithModelManager:(ModelManager *) modelManager NS_DESIGNATED_INITIALIZER;

@end
