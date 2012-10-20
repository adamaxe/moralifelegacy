/**
 Unit Test for ConscienceBody.  Test the properties for the Conscience Body.
 
 @class TestConscienceBody
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 05/22/2012
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import "ConscienceBody.h"

@interface TestConscienceBody : SenTestCase {
    
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

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
        
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

/**
 Ensure that the testingSubject was able to init.
 */
- (void)testConscienceBodyExists{

    STAssertNotNil(testingSubject, @"The Conscience Body was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConscienceBody{
    
	STAssertEquals(MLConscienceAgeDefault, [testingSubject age], @"Default ConscienceAge inaccurate.");
	STAssertEquals(MLConscienceSizeDefault, [testingSubject size], @"Default ConscienceSize inaccurate.");
	STAssertEquals(MLBubbleTypeDefault, [testingSubject bubbleType], @"Default BubbleType inaccurate.");
	STAssertEqualObjects(MLBubbleColorDefault, [testingSubject bubbleColor], @"Default BubbleColor inaccurate.");
	STAssertEqualObjects(MLConscienceBrowColorDefault, [testingSubject browColor], @"Default BrowColor inaccurate.");
    STAssertEqualObjects(MLConscienceEyeColorDefault, [testingSubject eyeColor], @"Default EyeColor inaccurate.");
    STAssertEqualObjects(MLSymbolFileNameResourceDefault, [testingSubject symbolName], @"Default SymbolName inaccurate.");
    STAssertEqualObjects(MLEyeFileNameResourceDefault, [testingSubject eyeName], @"Default EyeName inaccurate.");
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
    
    STAssertEquals(testSize, [testingSubject size], @"size setter/getter inaccurate.");
	STAssertEquals(testAge, [testingSubject age], @"age setter/getter inaccurate.");
	STAssertEquals(testBubbleType, [testingSubject bubbleType], @"bubbleType setter/getter inaccurate.");
	STAssertEqualObjects(testEyeFileName, [testingSubject eyeName], @"eyeName setter/getter inaccurate.");
	STAssertEqualObjects(testMouthFileName, [testingSubject mouthName], @"mouthName setter/getter inaccurate.");
	STAssertEqualObjects(testSymbolFileName, [testingSubject symbolName], @"symbolName setter/getter inaccurate.");
	STAssertEqualObjects(testEyeColor, [testingSubject eyeColor], @"eyeColor setter/getter inaccurate.");    
	STAssertEqualObjects(testBrowColor, [testingSubject browColor], @"browColor setter/getter inaccurate.");    
	STAssertEqualObjects(testBubbleColor, [testingSubject bubbleColor], @"bubbleColor setter/getter inaccurate.");    
}

#endif

@end
