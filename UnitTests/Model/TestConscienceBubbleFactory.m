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

@interface TestConscienceBubbleFactory : XCTestCase

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

    XCTAssertNotNil([ConscienceBubbleFactory class], @"The ConscienceBubbleFactory was not able to be called.");
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
    
    XCTAssertFalse(CGPathIsEmpty(outerPath), @"Normal Round Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Round Bubble dynamic failed");

    XCTAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Round Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Round Bubble dynamic failed");

    XCTAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Round Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Round Bubble dynamic failed");

}

- (void)testPathsStarBubbleTypes{
    
    CGMutablePathRef outerPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeStarNormal];
    CGMutablePathRef dynamicPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeStarNormal];
    CGMutablePathRef outerPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeStarShort];
    CGMutablePathRef dynamicPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeStarShort];
    CGMutablePathRef outerPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeStarTall];
    CGMutablePathRef dynamicPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeStarTall];
    
    XCTAssertFalse(CGPathIsEmpty(outerPath), @"Normal Star Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Star Bubble dynamic failed");
    
    XCTAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Star Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Star Bubble dynamic failed");
    
    XCTAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Star Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Star Bubble dynamic failed");
    
}

- (void)testPathsDiamondBubbleTypes{
    
    CGMutablePathRef outerPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeDiamondNormal];
    CGMutablePathRef dynamicPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeDiamondNormal];
    CGMutablePathRef outerPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeDiamondShort];
    CGMutablePathRef dynamicPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeDiamondShort];
    CGMutablePathRef outerPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeDiamondTall];
    CGMutablePathRef dynamicPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeDiamondTall];
    
    XCTAssertFalse(CGPathIsEmpty(outerPath), @"Normal Diamond Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Diamond Bubble dynamic failed");
    
    XCTAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Diamond Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Diamond Bubble dynamic failed");
    
    XCTAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Diamond Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Diamond Bubble dynamic failed");
    
}

- (void)testPathsPuffyBubbleTypes{
    
    CGMutablePathRef outerPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypePuffyNormal];
    CGMutablePathRef dynamicPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypePuffyNormal];
    CGMutablePathRef outerPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypePuffyShort];
    CGMutablePathRef dynamicPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypePuffyShort];
    CGMutablePathRef outerPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypePuffyTall];
    CGMutablePathRef dynamicPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypePuffyTall];
    
    XCTAssertFalse(CGPathIsEmpty(outerPath), @"Normal Puffy Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Puffy Bubble dynamic failed");
    
    XCTAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Puffy Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Puffy Bubble dynamic failed");
    
    XCTAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Puffy Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Puffy Bubble dynamic failed");
    
}

- (void)testPathsGearBubbleTypes{
    
    CGMutablePathRef outerPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeGearNormal];
    CGMutablePathRef dynamicPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeGearNormal];
    CGMutablePathRef outerPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeGearShort];
    CGMutablePathRef dynamicPathShort = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeGearShort];
    CGMutablePathRef outerPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:MLBubbleTypeGearTall];
    CGMutablePathRef dynamicPathTall = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:MLBubbleTypeGearTall];
    
    XCTAssertFalse(CGPathIsEmpty(outerPath), @"Normal Gear Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Gear Bubble dynamic failed");
    
    XCTAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Gear Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Gear Bubble dynamic failed");
    
    XCTAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Gear Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Gear Bubble dynamic failed");
    
}

- (void)testPathsBadBubbleType{
    
    CGMutablePathRef outerPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleSurfaceWithType:-1];
    CGMutablePathRef dynamicPath = (__bridge CGMutablePathRef)[ConscienceBubbleFactory bubbleAccentWithType:-1];
    
    XCTAssertFalse(CGPathIsEmpty(outerPath), @"Default Bubble outerPath failed");
    XCTAssertFalse(CGPathIsEmpty(dynamicPath), @"Default Bubble dynamic failed");
        
}

@end
