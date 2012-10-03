/**
Conscience's Body Collection.  Object to be populated with the ConscienceLayers.
Each Dictionary contains every expression frame for currently selected feature type.  Member of ConscienceView.
 
@class ConscienceBody
@see ConscienceView

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/20/2010
@file
 */

#import "ConscienceBubbleView.h"

extern float const kConscienceSize;
extern int const kConscienceAge;

extern NSString* const kEyeColor;
extern NSString* const kBrowColor;
extern NSString* const kEyeFileNameResource;
extern NSString* const kMouthFileNameResource;
extern NSString* const kSymbolFileNameResource;

@interface ConscienceBody : NSObject 

@property (nonatomic, strong) NSMutableDictionary *browLayers;	/**< Conscience Layer states of eye brow */
@property (nonatomic, strong) NSMutableDictionary *bagsLayers;	/**< Conscience Layer states of bags */
@property (nonatomic, strong) NSMutableDictionary *eyeLayers;	/**< Conscience Layer states of pupil */
@property (nonatomic, strong) NSMutableDictionary *lidLayers;	/**< Conscience Layer states of eye lids */
@property (nonatomic, strong) NSMutableDictionary *lashesLayers;	/**< Conscience Layer states of eye lashes */
@property (nonatomic, strong) NSMutableDictionary *socketLayers;	/**< Conscience Layer states of eye socket */
@property (nonatomic, strong) NSMutableDictionary *dimplesLayers;		/**< ConscienceLayer states of dimples */
@property (nonatomic, strong) NSMutableDictionary *lipsLayers;		/**< Conscience Layer states of lips */
@property (nonatomic, strong) NSMutableDictionary *teethLayers;		/**< Conscience Layer states of teeth */
@property (nonatomic, strong) NSMutableDictionary *tongueLayers;		/**< Conscience Layer states of tongue */
@property (nonatomic, strong) NSMutableDictionary *symbolLayers;		/**< Conscience Layer states of facial symbol */
@property (nonatomic, strong) NSMutableDictionary *gradientLayers;	/**< Conscience Layer states of all gradients */
@property (nonatomic, strong) NSString *eyeName;	/**< filename of eye */
@property (nonatomic, strong) NSString *mouthName;	/**< filename of mouth */
@property (nonatomic, strong) NSString *symbolName;	/**< filename of facial symbol */
@property (nonatomic, strong) NSString *eyeColor;	/**< hex representation of eye color */
@property (nonatomic, strong) NSString *browColor;	/**< hex representation of brow color */
@property (nonatomic, strong) NSString *bubbleColor;	/**< hex representation of bubble color */
@property (nonatomic, assign) int bubbleType;		/**< type of Bubble */
@property (nonatomic, assign) int age;		/**< Conscience age */
@property (nonatomic, assign) float size;		/**< Conscience size */

@end