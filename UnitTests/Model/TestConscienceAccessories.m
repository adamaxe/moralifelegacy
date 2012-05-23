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
    
    ConscienceAccessories *testingConscienceAccessories;
    
}

@end

#import "ConscienceAccessories.h"

@implementation TestConscienceAccessories

- (void)setUp{
    
    [super setUp];
    
    testingConscienceAccessories = [[ConscienceAccessories alloc] init];
    
}

- (void)tearDown{

	//Tear-down code here.
	[testingConscienceAccessories release];
    
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

    STAssertNotNil(testingConscienceAccessories, @"The Conscience Accessory was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConscienceAccessories{
    
	STAssertEquals(kPrimaryAccessoryFileNameResource, [testingConscienceAccessories primaryAccessory], @"Default primaryAccessory inaccurate.");
	STAssertEquals(kSecondaryAccessoryFileNameResource, [testingConscienceAccessories secondaryAccessory], @"Default secondaryAccessory inaccurate.");
	STAssertEquals(kTopAccessoryFileNameResource, [testingConscienceAccessories topAccessory], @"Default topAccessory inaccurate.");
	STAssertEquals(kBottomAccessoryFileNameResource, [testingConscienceAccessories bottomAccessory], @"Default bottomAccessory inaccurate.");
}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testConsciencePathProperties{
	NSString *testPrimaryAccessory = @"primaryAccessory";
	NSString *testSecondaryAccessory = @"secondaryAccessory";
	NSString *testTopAccessory = @"topAccessory";
	NSString *testBottomAccessory = @"bottomAccessory";

    [testingConscienceAccessories setPrimaryAccessory:testPrimaryAccessory];
    [testingConscienceAccessories setSecondaryAccessory:testSecondaryAccessory];
    [testingConscienceAccessories setTopAccessory:testTopAccessory];
    [testingConscienceAccessories setBottomAccessory:testBottomAccessory];
        
	STAssertEqualObjects(testPrimaryAccessory, [testingConscienceAccessories primaryAccessory], @"primaryAccessory setter/getter inaccurate.");
	STAssertEqualObjects(testSecondaryAccessory, [testingConscienceAccessories secondaryAccessory], @"secondaryAccessory setter/getter inaccurate.");
	STAssertEqualObjects(testTopAccessory, [testingConscienceAccessories topAccessory], @"topAccessory setter/getter inaccurate.");
	STAssertEqualObjects(testBottomAccessory, [testingConscienceAccessories bottomAccessory], @"bottomAccessory setter/getter inaccurate.");

}

#endif

@end
