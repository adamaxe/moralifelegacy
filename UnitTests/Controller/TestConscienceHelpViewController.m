/**
 Unit Test for ConscienceHelpViewController.  Test the properties for the helptext/titles and Boolean of Conscience appearance.
 
 @class TestConscienceHelpViewController 
 @author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/25/2011
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import "MoraLifeAppDelegate.h"
@class ConscienceHelpViewController;

@interface TestConscienceHelpViewController :XCTestCase {
    
    MoraLifeAppDelegate *delegate;
    ConscienceHelpViewController *testingSubject;
    BOOL isConscienceOnScreenTest;
    UIView *testingView;
    id userConscience;
    
}

@end

#import "ConscienceHelpViewController.h"

@implementation TestConscienceHelpViewController

- (void)setUp{
    
    [super setUp];
    delegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];

    testingSubject = [[ConscienceHelpViewController alloc] initWithConscience:userConscience];

    testingView = [testingSubject view];
    isConscienceOnScreenTest = FALSE;
    
}

- (void)tearDown{
	//Tear-down code here.
    testingView = nil;
    
	[super tearDown];
    
}

//#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application
//
//- (void)testAppDelegate {
//        
//    XCTAssertNotNil(delegate, @"UIApplication failed to find the AppDelegate.");
//    
//}
//
//#else                           // all code under test must be linked into the Unit Test bundle

/**
 Ensure that the UIViewController was able to init.
 */
//- (void)testViewExists{
//
//    XCTAssertNotNil(testingSubject, @"The view controller exists.");    
//    XCTAssertNotNil(testingView, @"The view controller should have an associated view.");
//
//}

/**
 Ensure that the default values of the properties from init were executed.
 */
//- (void)testDefaultHelpContentTest{
//
//    int defaultNumberOfTitles = [[testingSubject helpTitles] count];
//    isConscienceOnScreenTest = [testingSubject isConscienceOnScreen];
//    XCTAssertEqual(0, defaultNumberOfTitles, @"Title array was not initialized properly.");
//    XCTAssertFalse(isConscienceOnScreenTest, @"Monitor Bool not initialized correctly.");
//
//}

/**
 Ensure that the properties can be set/get correctly.
 */
//- (void)testHelpContentProperties{
//
//    NSString *testTitle = @"Test Title";
//    NSString *testText = @"Test Text for the Text Help Screen";
//    
//    NSArray *titles = @[testTitle];
//    NSArray *texts = @[testText];
//    
//    [testingSubject setHelpTitles:titles];
//    [testingSubject setHelpTexts:texts];
//    [testingSubject setIsConscienceOnScreen:TRUE];
//    
//    int numberOfTitles = [[testingSubject helpTitles] count];
//    isConscienceOnScreenTest = [testingSubject isConscienceOnScreen];
//    XCTAssertEqual(1, numberOfTitles, @"Title setter/getter non-functional");
//    XCTAssertEqual(isConscienceOnScreenTest, [testingSubject isConscienceOnScreen], @"Conscience Bool setter/getter non-functional.");    
//    XCTAssertEqualObjects(testTitle, [testingSubject helpTitles][0], @"Title setter/getter inaccurate.");
//    XCTAssertEqualObjects(testText, [testingSubject helpTexts][0], @"Title setter/getter inaccurate.");
//}

//#endif

@end
