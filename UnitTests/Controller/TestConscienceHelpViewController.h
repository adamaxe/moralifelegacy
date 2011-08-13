/**
Unit Test for ConscienceHelpViewController.  Test the properties for the helptext/titles and Boolean
 
@class TestConscienceHelpViewController 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/25/2011
@file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

@class ConscienceHelpViewController;

@interface TestConscienceHelpViewController : SenTestCase {
    
    ConscienceHelpViewController *testingHelpViewController;
    BOOL isConscienceOnScreenTest;
    UIView *testingView;

}

#if USE_APPLICATION_UNIT_TEST
- (void)testAppDelegate;       // simple test on application
#else
/**
Ensure that the UIViewController was able to init.
 */
- (void)testViewExists;
/**
Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultHelpContentTest;
/**
Ensure that the properties can be set/get correctly.
 */
- (void)testHelpContentProperties;
#endif

@end