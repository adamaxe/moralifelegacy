/**
Conscience vector object drawn with CoreGraphics.  

Visual Object that represents animatable facial feature, eye, mouth, symbol.

@class ConscienceObjectView
@see Conscienceview
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/20/2010
@file
 */

@class ConscienceLayer;

extern int const MLEyeWidth;
extern int const MLEyeHeight;

@interface ConscienceObjectView : UIView

@property (nonatomic, strong) NSMutableDictionary *totalLayers;     /**< all ConscienceLayers of an Object */
@property (nonatomic, strong) NSMutableDictionary *totalGradients;  /**< dictionary of ConscienceGradients */
@property (nonatomic, strong) UIColor *conscienceBackgroundColor;   /**< default background color */
@property (nonatomic, assign) CGMutablePathRef dynamicPath;         /**< path to be used in all drawing/shading */

/**
Creates a CGMutablePathRef to draw
@param points NSArray of (NSNumber *) CGFloats to build path
@param instructions NSArray of int values to choose each drawing instruction
@param path CGMutablePathRef to be constructed
 */
- (void) createPathFromPoints:(NSArray *) points WithInstructions:(NSArray *) instructions ForPath:(CGMutablePathRef) path;

@end
