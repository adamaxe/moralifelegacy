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

@interface TestConscienceHelpViewController : SenTestCase {
    
    MoraLifeAppDelegate *delegate;
    ConscienceHelpViewController *testingHelpViewController;
    BOOL isConscienceOnScreenTest;
    UIView *testingView;
    
}

@end

#import "ConscienceHelpViewController.h"

@implementation TestConscienceHelpViewController

- (void)setUp{
    
    [super setUp];
    delegate = (MoraLifeAppDelegate *)[[UIApplication sharedApplication] delegate];

    testingHelpViewController = [[ConscienceHelpViewController alloc] init];

    testingView = [testingHelpViewController view];
    isConscienceOnScreenTest = FALSE;
    
}

- (void)tearDown{
	//Tear-down code here.
    testingView = nil;
    [testingHelpViewController release];
    
	[super tearDown];
    
}

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
        
    STAssertNotNil(delegate, @"UIApplication failed to find the AppDelegate.");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

/**
 Ensure that the UIViewController was able to init.
 */
- (void)testViewExists{

    STAssertNotNil(testingHelpViewController, @"The view controller exists.");    
    STAssertNotNil(testingView, @"The view controller should have an associated view.");
        
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultHelpContentTest{

    int defaultNumberOfTitles = [[testingHelpViewController helpTitles] count];
    isConscienceOnScreenTest = [testingHelpViewController isConscienceOnScreen];
    STAssertEquals(0, defaultNumberOfTitles, @"Title array was not initialized properly.");
    STAssertFalse(isConscienceOnScreenTest, @"Monitor Bool not initialized correctly.");

}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testHelpContentProperties{

    NSString *testTitle = @"Test Title";
    NSString *testText = @"Test Text for the Text Help Screen";
    
    NSArray *titles = [[NSArray alloc] initWithObjects:testTitle, nil];
    NSArray *texts = [[NSArray alloc] initWithObjects:testText, nil];
    
    [testingHelpViewController setHelpTitles:titles];
    [testingHelpViewController setHelpTexts:texts];
    [testingHelpViewController setIsConscienceOnScreen:TRUE];
    
    int numberOfTitles = [[testingHelpViewController helpTitles] count];
    isConscienceOnScreenTest = [testingHelpViewController isConscienceOnScreen];
    STAssertEquals(1, numberOfTitles, @"Title setter/getter non-functional");
    STAssertEquals(isConscienceOnScreenTest, [testingHelpViewController isConscienceOnScreen], @"Conscience Bool setter/getter non-functional.");    
    STAssertEqualObjects(testTitle, [[testingHelpViewController helpTitles] objectAtIndex:0], @"Title setter/getter inaccurate.");
    STAssertEqualObjects(testText, [[testingHelpViewController helpTexts] objectAtIndex:0], @"Title setter/getter inaccurate.");
}

#endif

@end
