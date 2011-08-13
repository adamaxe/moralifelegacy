/**
TestAccessoryObjectView Implementation.  Test the filename property for the Conscience accessory.
 
@class TestAccessoryObjectView TestAccessoryObjectView.h
 */

#import "TestAccessoryObjectView.h"
#import "AccessoryObjectView.h"

@implementation TestAccessoryObjectView

- (void)setUp{
    
    [super setUp];
    
    testingAccessoryObjectView = [[AccessoryObjectView alloc] initWithFrame:CGRectMake(0, 0, kSideAccessoryWidth, kSideAccessoryHeight)];
    
}

- (void)tearDown{

    [testingAccessoryObjectView release];
    
	[super tearDown];
    
}

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
        
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testAccessoryExists{

    STAssertNotNil(testingAccessoryObjectView, @"The accessory was not init'ed.");
}

- (void)testDefaultAccessory{

    STAssertEqualObjects(kAccessoryFileNameResource, [testingAccessoryObjectView accessoryFilename], @"Default accessory name inaccurate.");
}

- (void)testAccessoryProperties{

    NSString *testFilename = @"testAccessory";
    
    [testingAccessoryObjectView setAccessoryFilename:testFilename];
    
    STAssertEqualObjects(testFilename, [testingAccessoryObjectView accessoryFilename], @"Filename setter/getter inaccurate.");
}

#endif

@end
