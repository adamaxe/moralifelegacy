/**
 Unit Test for ConscienceAccessories.  Test the properties for the Conscience Accessory and default values.
 
 @class TestConscienceAccessories
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 05/22/2012
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

@class ConscienceAccessories;

@interface TestConscienceAccessories : SenTestCase {
    
    ConscienceAccessories *testingSubject;
    
}

@end

#import "ConscienceAccessories.h"

@implementation TestConscienceAccessories

- (void)setUp{
    
    [super setUp];
    
    testingSubject = [[ConscienceAccessories alloc] init];
    
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
 Ensure that the ConscienceAccessory was able to init.
 */
- (void)testConscienceAccessoriesExists{

    STAssertNotNil(testingSubject, @"The Conscience Accessory was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConscienceAccessories{
    
	STAssertEquals(MLPrimaryAccessoryFileNameResourceDefault, [testingSubject primaryAccessory], @"Default primaryAccessory inaccurate.");
	STAssertEquals(MLSecondaryAccessoryFileNameResourceDefault, [testingSubject secondaryAccessory], @"Default secondaryAccessory inaccurate.");
	STAssertEquals(MLTopAccessoryFileNameResourceDefault, [testingSubject topAccessory], @"Default topAccessory inaccurate.");
	STAssertEquals(MLBottomAccessoryFileNameResourceDefault, [testingSubject bottomAccessory], @"Default bottomAccessory inaccurate.");
}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testConsciencePathProperties{
	NSString *testPrimaryAccessory = @"primaryAccessory";
	NSString *testSecondaryAccessory = @"secondaryAccessory";
	NSString *testTopAccessory = @"topAccessory";
	NSString *testBottomAccessory = @"bottomAccessory";

    [testingSubject setPrimaryAccessory:testPrimaryAccessory];
    [testingSubject setSecondaryAccessory:testSecondaryAccessory];
    [testingSubject setTopAccessory:testTopAccessory];
    [testingSubject setBottomAccessory:testBottomAccessory];
        
	STAssertEqualObjects(testPrimaryAccessory, [testingSubject primaryAccessory], @"primaryAccessory setter/getter inaccurate.");
	STAssertEqualObjects(testSecondaryAccessory, [testingSubject secondaryAccessory], @"secondaryAccessory setter/getter inaccurate.");
	STAssertEqualObjects(testTopAccessory, [testingSubject topAccessory], @"topAccessory setter/getter inaccurate.");
	STAssertEqualObjects(testBottomAccessory, [testingSubject bottomAccessory], @"bottomAccessory setter/getter inaccurate.");

}

#endif

@end
