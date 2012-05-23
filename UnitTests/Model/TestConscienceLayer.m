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
    
    ConscienceLayer *testingSubject;
    
}

@end

@implementation TestConscienceLayer

- (void)setUp{
    
    [super setUp];
    
    testingSubject = [[ConscienceLayer alloc] init];
    
}

- (void)tearDown{

	//Tear-down code here.
	[testingSubject release];
    
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

    STAssertNotNil(testingSubject, @"The Conscience Layer was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConscienceLayer{

    int count = [[testingSubject consciencePaths] count];
    
	STAssertEquals(0, count, @"Default empty paths array inaccurate.");
	STAssertEquals(kFeatureOffsetX, [testingSubject offsetX], @"Default feature offset X inaccurate.");
	STAssertEquals(kFeatureOffsetY, [testingSubject offsetY], @"Default feature offset Y inaccurate.");
	STAssertEqualObjects(kPathColor, [testingSubject currentFillColor], @"Default fill color inaccurate.");
	STAssertEqualObjects(kPathColor, [testingSubject currentStrokeColor], @"Default stroke color inaccurate.");
	STAssertEqualObjects(@"", [testingSubject layerID], @"Default layer ID inaccurate.");

}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testConscienceLayerProperties{

	NSString *testFillColor = @"FFFFFF";
	NSString *testStrokeColor = @"FF00FF";

	NSString *testID = @"none";
	CGFloat testXOffset = 1.0;
    CGFloat testYOffset = 2.0;

	ConsciencePath *testPath = [[ConsciencePath alloc] init];
	NSMutableArray *testPaths = [[NSMutableArray alloc] initWithCapacity:1];
	[testPaths addObject:testPath];

	[testingSubject setCurrentFillColor:testFillColor];
	[testingSubject setCurrentStrokeColor:testStrokeColor];
	[testingSubject setLayerID:testID];
	[testingSubject setOffsetX:testXOffset];
	[testingSubject setOffsetY:testYOffset];
    [testingSubject setConsciencePaths:testPaths];

    int count = [[testingSubject consciencePaths] count];
    
	STAssertEquals(1, count, @"consciencePaths setter/getter inaccurate.");
	STAssertEquals(testXOffset, [testingSubject offsetX], @"feature offset X setter/getter inaccurate.");
	STAssertEquals(testYOffset, [testingSubject offsetY], @"feature offset Y setter/getter inaccurate.");
	STAssertEqualObjects(testFillColor, [testingSubject currentFillColor], @"fill color setter/getter inaccurate.");
	STAssertEqualObjects(testStrokeColor, [testingSubject currentStrokeColor], @"stroke color setter/getter inaccurate.");
	STAssertEqualObjects(testID, [testingSubject layerID], @"layerID setter/getter inaccurate.");

	[testPath release];
	[testPaths release];

}

#endif

@end
