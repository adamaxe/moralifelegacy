/**
 Unit Test for ConscienceMind.  Test the properties for the Conscience Mind.
 
 @class TestConscienceMind
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 05/22/2012
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import "ConscienceMind.h"

@interface TestConscienceMind :XCTestCase {
    
    ConscienceMind *testingSubject;
    
}

@end

#import "ConscienceMind.h"

@implementation TestConscienceMind

- (void)setUp{
    
    [super setUp];
    
    testingSubject = [[ConscienceMind alloc] init];
    
}

- (void)tearDown{

	//Tear-down code here.
    
	[super tearDown];
    
}

/**
 Ensure that the testingSubject was able to init.
 */
- (void)testConscienceMindExists{

    XCTAssertNotNil(testingSubject, @"The Conscience Path was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConscienceMind{
    
	XCTAssertEqual(MLConscienceMoodDefault, [testingSubject mood], @"Default mood inaccurate.");
	XCTAssertEqual(MLConscienceEnthusiasmDefault, [testingSubject enthusiasm], @"Default enthusiasm inaccurate.");

}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testConscienceMindProperties{

	CGFloat testMood = 1.0;
    CGFloat testEnthusiasm = 2.0;

	[testingSubject setMood:testMood];
	[testingSubject setEnthusiasm:testEnthusiasm];
        
	XCTAssertEqual(testMood, [testingSubject mood], @"Mood setter/getter inaccurate.");
	XCTAssertEqual(testEnthusiasm, [testingSubject enthusiasm], @"Enthusiasm setter/getter inaccurate.");
}

@end
