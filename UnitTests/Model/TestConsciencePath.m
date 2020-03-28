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

@interface TestConsciencePath :XCTestCase {
    
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
    
	[super tearDown];
    
}

/**
 Ensure that the ConsciencePath was able to init.
 */
- (void)testConsciencePathExists{

    XCTAssertNotNil(testingSubject, @"The Conscience Path was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConsciencePath{
    
    int countPaths = [[testingSubject pathPoints] count];
    int countInstructions = [[testingSubject pathInstructions] count];

	XCTAssertEqual(0, countPaths, @"Default empty path points array inaccurate.");
	XCTAssertEqual(0, countInstructions, @"Default empty path instructions array inaccurate.");
	XCTAssertEqual(MLDefault0Float, [testingSubject pathStrokeWidth], @"Default path stroke width inaccurate.");
	XCTAssertEqual(MLDefault0Float, [testingSubject pathFillOpacity], @"Default path fill opacity inaccurate.");
	XCTAssertEqual(MLDefault0Float, [testingSubject pathStrokeMiterLimit], @"Default path stroke miter limit inaccurate.");
	XCTAssertEqual(MLDefault0Float, [testingSubject pathStrokeOpacity], @"Default path stroke opacity inaccurate.");
	XCTAssertEqualObjects(MLPathColorDefault, [testingSubject pathFillColor], @"Default fill color inaccurate.");
	XCTAssertEqualObjects(MLPathColorDefault, [testingSubject pathStrokeColor], @"Default stroke color inaccurate.");
	XCTAssertEqualObjects(@"none", [testingSubject pathID], @"Default path ID inaccurate.");
	XCTAssertEqualObjects(@"", [testingSubject pathGradient], @"Default gradient inaccurate.");

}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testConsciencePathProperties{

	NSMutableArray *pathPoints = [[NSMutableArray alloc] initWithCapacity:1];
	NSMutableArray *pathInstructions = [[NSMutableArray alloc] initWithCapacity:1];

	[pathPoints addObject:@1.0f];
	[pathInstructions addObject:@1];

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
    
	XCTAssertEqual(1, countPaths, @"Path points array setter/getter inaccurate.");
	XCTAssertEqual(1, countInstructions, @"Path instructions array setter/getter inaccurate.");
	XCTAssertEqual(testStrokeWidth, [testingSubject pathStrokeWidth], @"Path stroke width setter/getter inaccurate.");
	XCTAssertEqual(testFillOpacity, [testingSubject pathFillOpacity], @"Path fill opacity setter/getter inaccurate.");
	XCTAssertEqual(testStrokeMiterLimit, [testingSubject pathStrokeMiterLimit], @"Path stroke miter limit setter/getter inaccurate.");
	XCTAssertEqual(testStrokeOpacity, [testingSubject pathStrokeOpacity], @"Path stroke opacity setter/getter inaccurate.");
	XCTAssertEqualObjects(testFillColor , [testingSubject pathFillColor], @"Fill color setter/getter inaccurate.");
	XCTAssertEqualObjects(testStrokeColor , [testingSubject pathStrokeColor], @"Stroke color setter/getter inaccurate.");
	XCTAssertEqualObjects(testPathID , [testingSubject pathID], @"Path ID setter/getter inaccurate.");
	XCTAssertEqualObjects(testGradientID , [testingSubject pathGradient], @"Gradient setter/getter inaccurate.");


}

@end
