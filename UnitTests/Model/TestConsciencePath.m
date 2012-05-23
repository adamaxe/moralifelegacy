/**
 Unit Test for ConsciencePath.  Test the properties for the Conscience Path derived from svg.
 
 Test the vector construction properties for a single Conscience Path.
 
 @class TestConsciencePath
 
 @author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/25/2011
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

@class ConsciencePath;

@interface TestConsciencePath : SenTestCase {
    
    ConsciencePath *testingSubject;
    
}

@end

#import "ConsciencePath.h"

@implementation TestConsciencePath

- (void)setUp{
    
    [super setUp];
    
    testingSubject = [[ConsciencePath alloc] init];
    
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
 Ensure that the ConsciencePath was able to init.
 */
- (void)testConsciencePathExists{

    STAssertNotNil(testingSubject, @"The Conscience Path was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConsciencePath{
    
    int countPaths = [[testingSubject pathPoints] count];
    int countInstructions = [[testingSubject pathInstructions] count];

	STAssertEquals(0, countPaths, @"Default empty path points array inaccurate.");
	STAssertEquals(0, countInstructions, @"Default empty path instructions array inaccurate.");
	STAssertEquals(kDefault0Float, [testingSubject pathStrokeWidth], @"Default path stroke width inaccurate.");
	STAssertEquals(kDefault0Float, [testingSubject pathFillOpacity], @"Default path fill opacity inaccurate.");
	STAssertEquals(kDefault0Float, [testingSubject pathStrokeMiterLimit], @"Default path stroke miter limit inaccurate.");
	STAssertEquals(kDefault0Float, [testingSubject pathStrokeOpacity], @"Default path stroke opacity inaccurate.");
	STAssertEqualObjects(kPathColor, [testingSubject pathFillColor], @"Default fill color inaccurate.");
	STAssertEqualObjects(kPathColor, [testingSubject pathStrokeColor], @"Default stroke color inaccurate.");
	STAssertEqualObjects(@"none", [testingSubject pathID], @"Default path ID inaccurate.");
	STAssertEqualObjects(@"", [testingSubject pathGradient], @"Default gradient inaccurate.");

}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testConsciencePathProperties{

	NSMutableArray *pathPoints = [[NSMutableArray alloc] initWithCapacity:1];
	NSMutableArray *pathInstructions = [[NSMutableArray alloc] initWithCapacity:1];

	[pathPoints addObject:[NSNumber numberWithFloat:1.0]];
	[pathInstructions addObject:[NSNumber numberWithInt:1]];

	NSString *testFillColor = @"FFFFFF";
	NSString *testStrokeColor = @"FF00FF";
	NSString *testPathID = @"pathID";
	NSString *testGradientID = @"gradientID";
    
	CGFloat testStrokeWidth = 1.0;
	CGFloat testFillOpacity = 0.5;
	CGFloat testStrokeMiterLimit = 0.8;    
	CGFloat testStrokeOpacity = 0.4;    

	[testingSubject setPathFillColor:testFillColor];
	[testingSubject setPathStrokeColor:testStrokeColor];
	[testingSubject setPathID:testPathID];
	[testingSubject setPathGradient:testGradientID];
	[testingSubject setPathStrokeWidth:testStrokeWidth];
	[testingSubject setPathFillOpacity:testFillOpacity];
	[testingSubject setPathStrokeMiterLimit:testStrokeMiterLimit];
	[testingSubject setPathStrokeOpacity:testStrokeOpacity];
    [testingSubject setPathPoints:pathPoints];
    [testingSubject setPathInstructions:pathInstructions];
    
    int countPaths = [[testingSubject pathPoints] count];
    int countInstructions = [[testingSubject pathInstructions] count];
    
	STAssertEquals(1, countPaths, @"Path points array setter/getter inaccurate.");
	STAssertEquals(1, countInstructions, @"Path instructions array setter/getter inaccurate.");
	STAssertEquals(testStrokeWidth, [testingSubject pathStrokeWidth], @"Path stroke width setter/getter inaccurate.");
	STAssertEquals(testFillOpacity, [testingSubject pathFillOpacity], @"Path fill opacity setter/getter inaccurate.");
	STAssertEquals(testStrokeMiterLimit, [testingSubject pathStrokeMiterLimit], @"Path stroke miter limit setter/getter inaccurate.");
	STAssertEquals(testStrokeOpacity, [testingSubject pathStrokeOpacity], @"Path stroke opacity setter/getter inaccurate.");
	STAssertEqualObjects(testFillColor , [testingSubject pathFillColor], @"Fill color setter/getter inaccurate.");
	STAssertEqualObjects(testStrokeColor , [testingSubject pathStrokeColor], @"Stroke color setter/getter inaccurate.");
	STAssertEqualObjects(testPathID , [testingSubject pathID], @"Path ID setter/getter inaccurate.");
	STAssertEqualObjects(testGradientID , [testingSubject pathGradient], @"Gradient setter/getter inaccurate.");

	[pathPoints release];
	[pathInstructions release];

}

#endif

@end
