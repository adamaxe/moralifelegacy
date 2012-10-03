/**
 Unit Test for AccessoryObjectView.  Test the properties for the Conscience Accessories
 
 @class TestAccessoryObjectView
 
 @author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/25/2011
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import "AccessoryObjectView.h"

@interface TestAccessoryObjectView : SenTestCase {
    
    AccessoryObjectView *testingSubject;
    
}

@end

#import "AccessoryObjectView.h"

@implementation TestAccessoryObjectView

- (void)setUp{
    
    [super setUp];
    
    testingSubject = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(0, 0, kSideAccessoryWidth, kSideAccessoryHeight)];
    
}

- (void)tearDown{

    
	[super tearDown];
    
}

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
        
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

/**
 Ensure that the AccessoryObjectView was able to init.
 */
- (void)testAccessoryExists{

    STAssertNotNil(testingSubject, @"The accessory was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultAccessory{

    STAssertEqualObjects(kAccessoryFileNameResource, [testingSubject accessoryFilename], @"Default accessory name inaccurate.");
}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testAccessoryProperties{

    NSString *testFilename = @"testAccessory";
    
    [testingSubject setAccessoryFilename:testFilename];
    
    STAssertEqualObjects(testFilename, [testingSubject accessoryFilename], @"Filename setter/getter inaccurate.");
}

#endif

@end
