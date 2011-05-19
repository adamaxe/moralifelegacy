/**
Conscience's Body Collection.  Object to be populated with the ConscienceLayers.
Each Dictionary contains every expression frame for currently selected feature type
 
@class ConscienceBody

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/20/2010
@file
 */

@interface ConscienceBody : NSObject <NSMutableCopying> {
	
}

@property (nonatomic, retain) NSMutableDictionary *browLayers;	/**< Conscience Layer states of eye brow */
@property (nonatomic, retain) NSMutableDictionary *bagsLayers;	/**< Conscience Layer states of bags */
@property (nonatomic, retain) NSMutableDictionary *eyeLayers;	/**< Conscience Layer states of pupil */
@property (nonatomic, retain) NSMutableDictionary *lidLayers;	/**< Conscience Layer states of eye lids */
@property (nonatomic, retain) NSMutableDictionary *lashesLayers;	/**< Conscience Layer states of eye lashes */
@property (nonatomic, retain) NSMutableDictionary *socketLayers;	/**< Conscience Layer states of eye socket */
@property (nonatomic, retain) NSMutableDictionary *dimplesLayers;		/**< ConscienceLayer states of dimples */
@property (nonatomic, retain) NSMutableDictionary *lipsLayers;		/**< Conscience Layer states of lips */
@property (nonatomic, retain) NSMutableDictionary *teethLayers;		/**< Conscience Layer states of teeth */
@property (nonatomic, retain) NSMutableDictionary *tongueLayers;		/**< Conscience Layer states of tongue */
@property (nonatomic, retain) NSMutableDictionary *symbolLayers;		/**< Conscience Layer states of facial symbol */
@property (nonatomic, retain) NSMutableDictionary *gradientLayers;	/**< Conscience Layer states of all gradients */
@property (nonatomic, retain) NSString *eyeName;	/**< filename of eye */
@property (nonatomic, retain) NSString *mouthName;	/**< filename of mouth */
@property (nonatomic, retain) NSString *symbolName;	/**< filename of facial symbol */
@property (nonatomic, retain) NSString *eyeColor;	/**< hex representation of eye color */
@property (nonatomic, retain) NSString *browColor;	/**< hex representation of brow color */
@property (nonatomic, retain) NSString *bubbleColor;	/**< hex representation of bubble color */
@property (nonatomic, assign) int bubbleType;		/**< type of Bubble */
@property (nonatomic, assign) int age;		/**< Conscience age */
@property (nonatomic, assign) float size;		/**< Conscience size */

@end