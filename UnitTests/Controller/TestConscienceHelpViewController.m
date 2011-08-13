/**
Implementation: Test the properties for the helptext/titles and Boolean of Conscience appearance.
 
@class TestConscienceHelpViewController TestConscienceHelpViewController.h
 */

#import "TestConscienceHelpViewController.h"
#import "ConscienceHelpViewController.h"

@implementation TestConscienceHelpViewController

- (void)setUp{
    
    [super setUp];
    
    testingHelpViewController = [[ConscienceHelpViewController alloc] init];
    testingView = testingHelpViewController.view;
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
        
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate.");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testViewExists{

    STAssertNotNil(testingView, @"The view controller should have an associated view.");
}

- (void)testDefaultHelpContentTest{

    int defaultNumberOfTitles = [[testingHelpViewController helpTitles] count];
    isConscienceOnScreenTest = [testingHelpViewController isConscienceOnScreen];
    STAssertEquals(0, defaultNumberOfTitles, @"Title array was not initialized properly.");
    STAssertFalse(isConscienceOnScreenTest, @"Monitor Bool not initialized correctly.");

}

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
