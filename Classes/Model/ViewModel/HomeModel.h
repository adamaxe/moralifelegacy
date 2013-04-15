/**
 Home view model.  Retrieve data from User's entries in order to display greatest virtue, worst vice, highest rank and ethicals.

 @class HomeModel
 @see HomeViewController

 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 04/14/2013
 @file
 */

@class ModelManager;

@interface HomeModel : NSObject

@property (nonatomic, strong, readonly) NSString *greatestVirtue;
@property (nonatomic, strong, readonly) NSString *worstVice;
@property (nonatomic, strong, readonly) NSString *highestRank;

@property (nonatomic, strong, readonly) UIImage *greatestVirtueImage;
@property (nonatomic, strong, readonly) UIImage *worstViceImage;
@property (nonatomic, strong, readonly) UIImage *highestRankImage;

/**
 Builds model with dependency injection
 @param modelManager ModelManager for either production or testing
 @return id HomeModel
 */
- (id)initWithModelManager:(ModelManager *) modelManager;

/**
 Return a welcome message to be spoken by UserConscience
 @param NSDate current time of day
 @param CGFloat current UserConscience mood
 @param CGFloat current UserConscience enthusiasm
 @return NSString welcomeMessage
 */
- (NSString *)generateWelomeMessageWithTimeOfDay:(NSDate *)now andMood:(CGFloat)mood andEnthusiasm:(CGFloat)enthusiasm;

/**
 Return a welcome message to be spoken by UserConscience
 @param CGFloat current UserConscience mood
 @param CGFloat current UserConscience enthusiasm
 @return NSString reactionMessage
 */
- (NSString *)generateReactionWithMood:(CGFloat)mood andEnthusiasm:(CGFloat)enthusiasm;

@end
