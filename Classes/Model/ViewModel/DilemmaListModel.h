/**
 Dilemma List view model.  Generate list of the various dilemmas available to User.  Dilemmas are requested at init or upon setting the dilemmaKey.

 @class DilemmaListModel
 @see DilemmaListViewController

 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 02/18/2013
 @file
 */

#import "ModelManager.h"

typedef NS_ENUM(unsigned int, MLRequestedMorathologyAdventure) {
    MLRequestedMorathologyAdventure0,
    MLRequestedMorathologyAdventure1,
    MLRequestedMorathologyAdventure2,
    MLRequestedMorathologyAdventure3,
    MLRequestedMorathologyAdventure4
};

@interface DilemmaListModel : NSObject

@property (nonatomic, strong) NSString *dilemmaKey; /**< pkey for requested asset */

@property (nonatomic, readonly, strong) NSArray *dilemmas;			/**< dilemma names */
@property (nonatomic, readonly, strong) NSArray *dilemmaDisplayNames;			/**< dilemma names */
@property (nonatomic, readonly, strong) NSArray *dilemmaDetails;			/**< description of Reference */
@property (nonatomic, readonly, strong) NSArray *dilemmaTypes;				/**< associated images */
@property (nonatomic, readonly, strong) NSArray *dilemmaImages;			/**< images for Dilemma */
@property (nonatomic, readonly, strong) NSDictionary *moralNames;			/**< user entries for Dilemma */
@property (nonatomic, readonly, strong) NSDictionary *userChoices;			/**< user entries for Dilemma */

/**
 Builds model with dependency injection
 @param modelManager ModelManager for either production or testing
 @param prefs NSUserDefaults for dependency injection
 @param campaign int of requested campaign
 @return id DilemmaModel
 */
- (instancetype)initWithModelManager:(ModelManager *) modelManager andDefaults:(NSUserDefaults *) prefs andCurrentCampaign:(MLRequestedMorathologyAdventure) campaign NS_DESIGNATED_INITIALIZER;

/**
 Retrieve reference for display
 @param dilemmaKey NSString of requested pkey
 */
- (void) selectDilemma:(NSString *) dilemmaKey;

@end
