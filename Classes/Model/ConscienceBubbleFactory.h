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
typedef enum {
	kBubbleTypeRoundNormal,
	kBubbleTypeRoundTall,
	kBubbleTypeRoundShort,
	kBubbleTypeDiamondNormal,
	kBubbleTypeDiamondTall,
	kBubbleTypeDiamondShort,
	kBubbleTypeStarNormal,
	kBubbleTypeStarTall,
	kBubbleTypeStarShort,
	kBubbleTypePuffyNormal,
	kBubbleTypePuffyTall,
	kBubbleTypePuffyShort,
	kBubbleTypeGearNormal,
	kBubbleTypeGearTall,
	kBubbleTypeGearShort
} kBubbleTypeEnum;

@interface ConscienceBubbleFactory : NSObject

/**
 Returns and autoreleased CGMutablePathRef representing the Conscience's Outer Surface Bubble
 @param int Type of Bubble to Draw (kBubbleTypeRoundNormal, kBubbleTypeRoundShort, etc.)
 @return NSObject autoreleased CGMutablePathRef to add to CGContext
 */
+ (NSObject *)bubbleSurfaceWithType:(int)bubbleType;

/**
 Returns and autoreleased CGMutablePathRef representing the Conscience's Inner Bubble Accent
 @param int Type of Bubble to Draw (kBubbleTypeRoundNormal, kBubbleTypeRoundShort, etc.)
 @return NSObject autoreleased CGMutablePathRef to add to CGContext
 */
+ (NSObject *)bubbleAccentWithType:(int)bubbleType;

@end
