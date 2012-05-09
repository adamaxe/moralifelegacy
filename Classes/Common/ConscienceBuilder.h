/**
Static Utility Class used to build Consciences.  
 
@class ConscienceBuilder
@see ConscienceBody
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/20/2010
@file
 */

@class ConscienceBody;

@interface ConscienceBuilder : NSObject 
/**
Build Conscience by rendering all Core Graphics objects and accessory images
@param requestedConscienceBody ConscienceBody to be populated
 */
+ (void)buildConscience:(ConscienceBody *) requestedConscienceBody;

/**
Populate each piece of ConscienceBody
@param manipulatedConscience ConscienceBody to be populated
@param currentFeature NSString of filename to be added to ConscienceBody
@see XMLParser
 */
+ (void)populateConscience:(ConscienceBody *) manipulatedConscience WithFeature:(NSString *) currentFeature;

@end
