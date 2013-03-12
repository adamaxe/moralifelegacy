/**
 Unit Test for ConscienceBubbleFactory.  Test the class methods for generating dynamic and outer paths.
 
 Test that each bubble type is successfully generated
 
 @class TestConscienceBubbleFactory
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 05/22/2012
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import "ConscienceBubbleFactory.h"

@interface TestConscienceBubbleFactory : SenTestCase

@end

#import "ConscienceBubbleFactory.h"

@implementation TestConscienceBubbleFactory

- (void)setUp{
    
    [super setUp];
        
}

- (void)tearDown{
    
	[super tearDown];
    
}

/**
 Ensure that the ConscienceBubbleFactory exists.
 */
- (void)testConscienceBubbleFactoryExists{

    STAssertNotNil([ConscienceBubbleFactory class], @"The ConscienceBubbleFactory was not able to be called.");
}

/**
 Ensure that the different bubble types are available.
 */
- (void)testPathsRoundBubbleTypes{

    CGMutablePathRef outerPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeRoundNormal];
    CGMutablePathRef dynamicPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeRoundNormal];
    CGMutablePathRef outerPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeRoundShort];
    CGMutablePathRef dynamicPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeRoundShort];
    CGMutablePathRef outerPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeRoundTall];
    CGMutablePathRef dynamicPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeRoundTall];
    
    STAssertFalse(CGPathIsEmpty(outerPath), @"Normal Round Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Round Bubble dynamic failed");

    STAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Round Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Round Bubble dynamic failed");

    STAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Round Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Round Bubble dynamic failed");

}

- (void)testPathsStarBubbleTypes{
    
    CGMutablePathRef outerPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeStarNormal];
    CGMutablePathRef dynamicPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeStarNormal];
    CGMutablePathRef outerPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeStarShort];
    CGMutablePathRef dynamicPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeStarShort];
    CGMutablePathRef outerPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeStarTall];
    CGMutablePathRef dynamicPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeStarTall];
    
    STAssertFalse(CGPathIsEmpty(outerPath), @"Normal Star Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Star Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Star Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Star Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Star Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Star Bubble dynamic failed");
    
}

- (void)testPathsDiamondBubbleTypes{
    
    CGMutablePathRef outerPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeDiamondNormal];
    CGMutablePathRef dynamicPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeDiamondNormal];
    CGMutablePathRef outerPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeDiamondShort];
    CGMutablePathRef dynamicPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeDiamondShort];
    CGMutablePathRef outerPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeDiamondTall];
    CGMutablePathRef dynamicPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeDiamondTall];
    
    STAssertFalse(CGPathIsEmpty(outerPath), @"Normal Diamond Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Diamond Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Diamond Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Diamond Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Diamond Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Diamond Bubble dynamic failed");
    
}

- (void)testPathsPuffyBubbleTypes{
    
    CGMutablePathRef outerPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypePuffyNormal];
    CGMutablePathRef dynamicPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypePuffyNormal];
    CGMutablePathRef outerPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypePuffyShort];
    CGMutablePathRef dynamicPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypePuffyShort];
    CGMutablePathRef outerPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypePuffyTall];
    CGMutablePathRef dynamicPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypePuffyTall];
    
    STAssertFalse(CGPathIsEmpty(outerPath), @"Normal Puffy Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Puffy Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Puffy Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Puffy Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Puffy Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Puffy Bubble dynamic failed");
    
}

- (void)testPathsGearBubbleTypes{
    
    CGMutablePathRef outerPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeGearNormal];
    CGMutablePathRef dynamicPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeGearNormal];
    CGMutablePathRef outerPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeGearShort];
    CGMutablePathRef dynamicPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeGearShort];
    CGMutablePathRef outerPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeGearTall];
    CGMutablePathRef dynamicPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeGearTall];
    
    STAssertFalse(CGPathIsEmpty(outerPath), @"Normal Gear Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Gear Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Gear Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Gear Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Gear Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Gear Bubble dynamic failed");
    
}

- (void)testPathsBadBubbleType{
    
    CGMutablePathRef outerPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:-1];
    CGMutablePathRef dynamicPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:-1];
    
    STAssertFalse(CGPathIsEmpty(outerPath), @"Default Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPath), @"Default Bubble dynamic failed");
        
}

@end
