/**
 Unit Test for ConscienceGradient.  Test the properties for the Conscience Gradient derived from svg.
  
 @class TestConsciencePath
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 05/22/2012
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

@class ConscienceGradient;

@interface TestConscienceGradient : SenTestCase {
    
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
- (void)testConscienceGradientExists{

    STAssertNotNil(testingSubject, @"The Conscience Path was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConscienceGradient{

	STAssertEquals(2, [testingSubject locationsCount], @"Default locationsCount inaccurate.");
	STAssertEquals(8, [testingSubject componentsCount], @"Default components count inaccurate.");
	STAssertEquals(2, [testingSubject pointsCount], @"Default points count inaccurate.");
	STAssertEqualObjects(@"", [testingSubject gradientID], @"Default gradient inaccurate.");

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
    
	STAssertEquals(testLocationsCount, [testingSubject locationsCount], @"locationsCount setter/getter inaccurate.");
	STAssertEquals(testComponentsCount, [testingSubject componentsCount], @"componentsCount setter/getter inaccurate.");
	STAssertEquals(testPointsCount, [testingSubject pointsCount], @"pointsCount setter/getter inaccurate.");
	STAssertEqualObjects(testGradientID, [testingSubject gradientID], @"gradientID setter/getter inaccurate.");

}

#endif

@end
