/**
 Unit Test for ConscienceBubbleFactory.  Test the class methods for generating dynamic and outer paths.
 
 Test that each bubble type is successfully generated
 
 @class TestConscienceBubbleFactory
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 05/22/2012
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

@class ConscienceBubbleFactory;

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

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
        
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

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

    CGMutablePathRef outerPath = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypeRoundNormal];
    CGMutablePathRef dynamicPath = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypeRoundNormal];
    CGMutablePathRef outerPathShort = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypeRoundShort];
    CGMutablePathRef dynamicPathShort = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypeRoundShort];
    CGMutablePathRef outerPathTall = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypeRoundTall];
    CGMutablePathRef dynamicPathTall = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypeRoundTall];
    
    STAssertFalse(CGPathIsEmpty(outerPath), @"Normal Round Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Round Bubble dynamic failed");

    STAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Round Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Round Bubble dynamic failed");

    STAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Round Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Round Bubble dynamic failed");

}

- (void)testPathsStarBubbleTypes{
    
    CGMutablePathRef outerPath = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypeStarNormal];
    CGMutablePathRef dynamicPath = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypeStarNormal];
    CGMutablePathRef outerPathShort = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypeStarShort];
    CGMutablePathRef dynamicPathShort = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypeStarShort];
    CGMutablePathRef outerPathTall = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypeStarTall];
    CGMutablePathRef dynamicPathTall = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypeStarTall];
    
    STAssertFalse(CGPathIsEmpty(outerPath), @"Normal Star Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Star Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Star Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Star Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Star Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Star Bubble dynamic failed");
    
}

- (void)testPathsDiamondBubbleTypes{
    
    CGMutablePathRef outerPath = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypeDiamondNormal];
    CGMutablePathRef dynamicPath = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypeDiamondNormal];
    CGMutablePathRef outerPathShort = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypeDiamondShort];
    CGMutablePathRef dynamicPathShort = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypeDiamondShort];
    CGMutablePathRef outerPathTall = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypeDiamondTall];
    CGMutablePathRef dynamicPathTall = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypeDiamondTall];
    
    STAssertFalse(CGPathIsEmpty(outerPath), @"Normal Diamond Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Diamond Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Diamond Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Diamond Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Diamond Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Diamond Bubble dynamic failed");
    
}

- (void)testPathsPuffyBubbleTypes{
    
    CGMutablePathRef outerPath = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypePuffyNormal];
    CGMutablePathRef dynamicPath = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypePuffyNormal];
    CGMutablePathRef outerPathShort = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypePuffyShort];
    CGMutablePathRef dynamicPathShort = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypePuffyShort];
    CGMutablePathRef outerPathTall = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypePuffyTall];
    CGMutablePathRef dynamicPathTall = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypePuffyTall];
    
    STAssertFalse(CGPathIsEmpty(outerPath), @"Normal Puffy Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Puffy Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Puffy Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Puffy Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Puffy Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Puffy Bubble dynamic failed");
    
}

- (void)testPathsGearBubbleTypes{
    
    CGMutablePathRef outerPath = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypeGearNormal];
    CGMutablePathRef dynamicPath = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypeGearNormal];
    CGMutablePathRef outerPathShort = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypeGearShort];
    CGMutablePathRef dynamicPathShort = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypeGearShort];
    CGMutablePathRef outerPathTall = [ConscienceBubbleFactory bubbleSurfaceWithType:kBubbleTypeGearTall];
    CGMutablePathRef dynamicPathTall = [ConscienceBubbleFactory bubbleAccentWithType:kBubbleTypeGearTall];
    
    STAssertFalse(CGPathIsEmpty(outerPath), @"Normal Gear Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPath), @"Normal Gear Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathShort), @"Short Gear Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Short Gear Bubble dynamic failed");
    
    STAssertFalse(CGPathIsEmpty(outerPathTall), @"Tall Gear Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Tall Gear Bubble dynamic failed");
    
}

- (void)testPathsBadBubbleType{
    
    CGMutablePathRef outerPath = [ConscienceBubbleFactory bubbleSurfaceWithType:-1];
    CGMutablePathRef dynamicPath = [ConscienceBubbleFactory bubbleAccentWithType:-1];
    
    STAssertFalse(CGPathIsEmpty(outerPath), @"Default Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPath), @"Default Bubble dynamic failed");
        
}

#endif

@end
