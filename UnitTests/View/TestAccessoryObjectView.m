/**
 Unit Test for AccessoryObjectView.  Test the properties for the Conscience Accessories
 
 @class TestAccessoryObjectView
 
 @author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/25/2011
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import "AccessoryObjectView.h"

@interface TestAccessoryObjectView :XCTestCase {
    
    AccessoryObjectView *testingSubject;
    
}

@end

#import "AccessoryObjectView.h"

@implementation TestAccessoryObjectView

- (void)setUp{
    
    [super setUp];
    
    testingSubject = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(0, 0, MLSideAccessoryWidth, MLSideAccessoryHeight)];
    
}

- (void)tearDown{

    
	[super tearDown];
    
}

/**
 Ensure that the AccessoryObjectView was able to init.
 */
- (void)testAccessoryExists{

    XCTAssertNotNil(testingSubject, @"The accessory was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultAccessory{

    XCTAssertEqualObjects(MLAccessoryFileNameResourceDefault, [testingSubject accessoryFilename], @"Default accessory name inaccurate.");
}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testAccessoryProperties{

    NSString *testFilename = @"testAccessory";
    
    [testingSubject setAccessoryFilename:testFilename];
    
    XCTAssertEqualObjects(testFilename, [testingSubject accessoryFilename], @"Filename setter/getter inaccurate.");
}

@end
