/**
 Unit Test for ConscienceLayer.  Test the properties for the Conscience Layer derived from svg.
 
 Test the vector construction properties for a single Conscience Layer.
 
 @class TestConscienceLayer
 
 @author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/25/2011
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import "ConscienceLayer.h"
#import "ConsciencePath.h"

@class ConscienceLayer;

@interface TestConscienceLayer : SenTestCase {
    
    ConscienceLayer *testingConscienceLayer;
    
}

@end

@implementation TestConscienceLayer

- (void)setUp{
    
    [super setUp];
    
    testingConscienceLayer = [[ConscienceLayer alloc] init];
    
}

- (void)tearDown{

	//Tear-down code here.
	[testingConscienceLayer release];
    
	[super tearDown];
    
}

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
        
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

/**
 Ensure that the ConscienceLayer was able to init.
 */
- (void)testConscienceLayerExists{

    STAssertNotNil(testingConscienceLayer, @"The Conscience Layer was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConscienceLayer{

    int count = [[testingConscienceLayer consciencePaths] count];
    
	STAssertEquals(0, count, @"Default empty paths array inaccurate.");
	STAssertEquals(kFeatureOffsetX, [testingConscienceLayer offsetX], @"Default feature offset X inaccurate.");
	STAssertEquals(kFeatureOffsetY, [testingConscienceLayer offsetY], @"Default feature offset Y inaccurate.");
	STAssertEqualObjects(kPathColor, [testingConscienceLayer currentFillColor], @"Default fill color inaccurate.");
	STAssertEqualObjects(kPathColor, [testingConscienceLayer currentStrokeColor], @"Default stroke color inaccurate.");
	STAssertEqualObjects(@"", [testingConscienceLayer layerID], @"Default layer ID inaccurate.");

}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testConscienceLayerProperties{

	NSString *testColor = @"FFFFFF";
	NSString *testID = @"none";
	CGFloat testOffset = 1.0;

	ConsciencePath *testPath = [[ConsciencePath alloc] init];
	NSMutableArray *testPaths = [[NSMutableArray alloc] initWithCapacity:1];
	[testPaths addObject:testPath];

	[testingConscienceLayer setCurrentFillColor:testColor];
	[testingConscienceLayer setCurrentStrokeColor:testColor];
	[testingConscienceLayer setLayerID:testID];
	[testingConscienceLayer setOffsetX:testOffset];
	[testingConscienceLayer setOffsetY:testOffset];
    [testingConscienceLayer setConsciencePaths:testPaths];

    int count = [[testingConscienceLayer consciencePaths] count];

    
	STAssertEquals(1, count, @"consciencePaths setter/getter inaccurate.");
	STAssertEquals(testOffset, [testingConscienceLayer offsetX], @"feature offset X setter/getter inaccurate.");
	STAssertEquals(testOffset, [testingConscienceLayer offsetY], @"feature offset Y setter/getter inaccurate.");
	STAssertEqualObjects(testColor, [testingConscienceLayer currentFillColor], @"fill color setter/getter inaccurate.");
	STAssertEqualObjects(testColor, [testingConscienceLayer currentStrokeColor], @"stroke color setter/getter inaccurate.");
	STAssertEqualObjects(testID, [testingConscienceLayer layerID], @"layerID setter/getter inaccurate.");

	[testPath release];
	[testPaths release];

}

#endif

@end
