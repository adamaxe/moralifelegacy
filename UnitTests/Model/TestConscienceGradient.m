/**
 Unit Test for ConscienceGradient.  Test the properties for the Conscience Gradient derived from svg.
  
 @class TestConsciencePath
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 05/22/2012
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

@class ConscienceGradient;

@interface TestConscienceGradient :XCTestCase {
    
    ConscienceGradient *testingSubject;
    
}

@end

#import "ConscienceGradient.h"

@implementation TestConscienceGradient

- (void)setUp{
    
    [super setUp];
    
    testingSubject = [[ConscienceGradient alloc] init];
    
}

- (void)tearDown{

	//Tear-down code here.
    
	[super tearDown];
    
}

/**
 Ensure that the ConsciencePath was able to init.
 */
- (void)testConscienceGradientExists{

    XCTAssertNotNil(testingSubject, @"The Conscience Path was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConscienceGradient{

	XCTAssertEqual(2, [testingSubject locationsCount], @"Default locationsCount inaccurate.");
	XCTAssertEqual(8, [testingSubject componentsCount], @"Default components count inaccurate.");
	XCTAssertEqual(2, [testingSubject pointsCount], @"Default points count inaccurate.");
	XCTAssertEqualObjects(@"", [testingSubject gradientID], @"Default gradient inaccurate.");

}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testConscienceGradientProperties{

	NSString *testGradientID = @"testGradientID";
	int testLocationsCount = 10;
	int testComponentsCount = 20;
	int testPointsCount = 30;
    
	[testingSubject setGradientID:testGradientID];
	[testingSubject setLocationsCount:testLocationsCount];
	[testingSubject setComponentsCount:testComponentsCount];
	[testingSubject setPointsCount:testPointsCount];
    
	XCTAssertEqual(testLocationsCount, [testingSubject locationsCount], @"locationsCount setter/getter inaccurate.");
	XCTAssertEqual(testComponentsCount, [testingSubject componentsCount], @"componentsCount setter/getter inaccurate.");
	XCTAssertEqual(testPointsCount, [testingSubject pointsCount], @"pointsCount setter/getter inaccurate.");
	XCTAssertEqualObjects(testGradientID, [testingSubject gradientID], @"gradientID setter/getter inaccurate.");

}

@end
