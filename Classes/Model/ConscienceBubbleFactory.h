/**
 Bubble Construction Factory.  Accepts paths and populates drawing instructions accordingly  
 Build an outer and dynamic path based upon User's bubble selection.
 
 @class ConscienceBubbleFactory
 @see ConscienceBubbleView
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 05/21/2012
 @file
 */

/**
 Possible bubbleTypes
 */
typedef NS_ENUM(unsigned int, MLBubbleType) {
	MLBubbleTypeRoundNormal,
	MLBubbleTypeRoundTall,
	MLBubbleTypeRoundShort,
	MLBubbleTypeDiamondNormal,
	MLBubbleTypeDiamondTall,
	MLBubbleTypeDiamondShort,
	MLBubbleTypeStarNormal,
	MLBubbleTypeStarTall,
	MLBubbleTypeStarShort,
	MLBubbleTypePuffyNormal,
	MLBubbleTypePuffyTall,
	MLBubbleTypePuffyShort,
	MLBubbleTypeGearNormal,
	MLBubbleTypeGearTall,
	MLBubbleTypeGearShort
};

@interface ConscienceBubbleFactory : NSObject

/**
 Returns and autoreleased CGMutablePathRef representing the Conscience's Outer Surface Bubble
 @param bubbleType Type of Bubble to Draw (MLBubbleTypeRoundNormal, MLBubbleTypeRoundShort, etc.)
 @return NSObject CGMutablePathRef to add to CGContext
 */
+ (NSObject *)bubbleSurfaceWithType:(MLBubbleType)bubbleType;

/**
 Returns and autoreleased CGMutablePathRef representing the Conscience's Inner Bubble Accent
 @param bubbleType Type of Bubble to Draw (MLBubbleTypeRoundNormal, MLBubbleTypeRoundShort, etc.)
 @return NSObject CGMutablePathRef to add to CGContext
 */
+ (NSObject *)bubbleAccentWithType:(MLBubbleType)bubbleType;

@end
