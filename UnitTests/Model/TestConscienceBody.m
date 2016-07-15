/**
 Unit Test for ConscienceBody.  Test the properties for the Conscience Body.
 
 @class TestConscienceBody
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 05/22/2012
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import "ConscienceBody.h"

@interface TestConscienceBody : XCTestCase {
    
    ConscienceBody *testingSubject;
    
}

@end

#import "ConscienceBody.h"

@implementation TestConscienceBody

- (void)setUp{
    
    [super setUp];
    
    testingSubject = [[ConscienceBody alloc] init];
    
}

- (void)tearDown{

	//Tear-down code here.
    
	[super tearDown];
    
}

/**
 Ensure that the testingSubject was able to init.
 */
- (void)testConscienceBodyExists{

    XCTAssertNotNil(testingSubject, @"The Conscience Body was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConscienceBody{
    
	XCTAssertEqual(MLConscienceAgeDefault, [testingSubject age], @"Default ConscienceAge inaccurate.");
	XCTAssertEqual(MLConscienceSizeDefault, [testingSubject size], @"Default ConscienceSize inaccurate.");
	XCTAssertEqual(MLBubbleTypeDefault, [testingSubject bubbleType], @"Default BubbleType inaccurate.");
	XCTAssertEqualObjects(MLBubbleColorDefault, [testingSubject bubbleColor], @"Default BubbleColor inaccurate.");
	XCTAssertEqualObjects(MLConscienceBrowColorDefault, [testingSubject browColor], @"Default BrowColor inaccurate.");
    XCTAssertEqualObjects(MLConscienceEyeColorDefault, [testingSubject eyeColor], @"Default EyeColor inaccurate.");
    XCTAssertEqualObjects(MLSymbolFileNameResourceDefault, [testingSubject symbolName], @"Default SymbolName inaccurate.");
    XCTAssertEqualObjects(MLEyeFileNameResourceDefault, [testingSubject eyeName], @"Default EyeName inaccurate.");
}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testConscienceBodyProperties{

    CGFloat testSize = 1.1;
    int testAge = 2;
    int testBubbleType = 3;
    
    NSString *testEyeFileName = @"eyeFile.svg";
    NSString *testMouthFileName = @"mouthFile.svg";
    NSString *testSymbolFileName = @"symbolFile.svg";
    NSString *testEyeColor = @"FF00FF";
    NSString *testBubbleColor = @"FFFF00";
    NSString *testBrowColor = @"FF0000";

    //In case of first time run, or User does not supply configuration, default Conscience
    [testingSubject setEyeName:testEyeFileName];
    [testingSubject setMouthName:testMouthFileName];
    [testingSubject setSymbolName:testSymbolFileName];
    [testingSubject setEyeColor:testEyeColor];
    [testingSubject setBrowColor:testBrowColor];
    [testingSubject setBubbleColor:testBubbleColor];
    [testingSubject setBubbleType:testBubbleType];
    [testingSubject setAge:testAge];
    [testingSubject setSize:testSize];
    
    XCTAssertEqualWithAccuracy(testSize, testingSubject.size, 1, @"size setter/getter inaccurate.");
    XCTAssertEqual(testAge, testingSubject.age, @"age setter/getter inaccurate.");
	XCTAssertEqual(testBubbleType, [testingSubject bubbleType], @"bubbleType setter/getter inaccurate.");
	XCTAssertEqualObjects(testEyeFileName, [testingSubject eyeName], @"eyeName setter/getter inaccurate.");
	XCTAssertEqualObjects(testMouthFileName, [testingSubject mouthName], @"mouthName setter/getter inaccurate.");
	XCTAssertEqualObjects(testSymbolFileName, [testingSubject symbolName], @"symbolName setter/getter inaccurate.");
	XCTAssertEqualObjects(testEyeColor, [testingSubject eyeColor], @"eyeColor setter/getter inaccurate.");    
	XCTAssertEqualObjects(testBrowColor, [testingSubject browColor], @"browColor setter/getter inaccurate.");    
	XCTAssertEqualObjects(testBubbleColor, [testingSubject bubbleColor], @"bubbleColor setter/getter inaccurate.");    
}

@end
