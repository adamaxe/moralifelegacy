/**
 Dilemma view model.  Generate the various dilemmas available to User.

 @class DilemmaModel
 @see DilemmaListViewController

 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 02/18/2013
 @file
 */

#import "ModelManager.h"

typedef enum {
    MLRequestedMorathologyAdventure0,
    MLRequestedMorathologyAdventure1,
    MLRequestedMorathologyAdventure2,
    MLRequestedMorathologyAdventure3,
    MLRequestedMorathologyAdventure4
} MLRequestedMorathologyAdventure;

@interface DilemmaModel : NSObject

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
 @param dilemmaCampaign int of requested campaign
 @return id DilemmaModel
 */
- (id)initWithCampaign:(MLRequestedMorathologyAdventure)campaign;

/**
 Builds model with dependency injection
 @param modelManager ModelManager for either production or testing
 @param prefs NSUserDefaults for dependency injection
 @param dilemmaCampaign int of requested campaign
 @return id DilemmaModel
 */
- (id)initWithModelManager:(ModelManager *) modelManager andDefaults:(NSUserDefaults *) prefs andCurrentCampaign:(MLRequestedMorathologyAdventure) campaign;

/**
 Retrieve reference for display
 @param reference NSString of requested pkey
 */
- (void) selectDilemma:(NSString *) dilemmaKey;

@end
