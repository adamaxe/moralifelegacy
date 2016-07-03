/**
 Unit Test for ConscienceAccessories.  Test the properties for the Conscience Accessory and default values.
 
 @class TestConscienceAccessories
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 05/22/2012
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

@class ConscienceAccessories;

@interface TestConscienceAccessories : XCTestCase {
    
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

/**
 Ensure that the ConscienceAccessory was able to init.
 */
- (void)testConscienceAccessoriesExists{

    XCTAssertNotNil(testingSubject, @"The Conscience Accessory was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConscienceAccessories{
    
	XCTAssertEqual(MLPrimaryAccessoryFileNameResourceDefault, [testingSubject primaryAccessory], @"Default primaryAccessory inaccurate.");
	XCTAssertEqual(MLSecondaryAccessoryFileNameResourceDefault, [testingSubject secondaryAccessory], @"Default secondaryAccessory inaccurate.");
	XCTAssertEqual(MLTopAccessoryFileNameResourceDefault, [testingSubject topAccessory], @"Default topAccessory inaccurate.");
	XCTAssertEqual(MLBottomAccessoryFileNameResourceDefault, [testingSubject bottomAccessory], @"Default bottomAccessory inaccurate.");
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
        
	XCTAssertEqualObjects(testPrimaryAccessory, [testingSubject primaryAccessory], @"primaryAccessory setter/getter inaccurate.");
	XCTAssertEqualObjects(testSecondaryAccessory, [testingSubject secondaryAccessory], @"secondaryAccessory setter/getter inaccurate.");
	XCTAssertEqualObjects(testTopAccessory, [testingSubject topAccessory], @"topAccessory setter/getter inaccurate.");
	XCTAssertEqualObjects(testBottomAccessory, [testingSubject bottomAccessory], @"bottomAccessory setter/getter inaccurate.");

}

@end
