/**
 Unit Test for ConscienceBubbleFactory.  Test the class methods for generating dynamic and outer paths.
 
 Test that each bubble type is successfully generated
 
 @class TestConscienceBubbleFactory
 
 @author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
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
 Ensure that the default values of the properties from init were executed.
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

    STAssertFalse(CGPathIsEmpty(outerPathShort), @"Normal Round Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathShort), @"Normal Round Bubble dynamic failed");

    STAssertFalse(CGPathIsEmpty(outerPathTall), @"Normal Round Bubble outerPath failed");
    STAssertFalse(CGPathIsEmpty(dynamicPathTall), @"Normal Round Bubble dynamic failed");

}

#endif

@end
