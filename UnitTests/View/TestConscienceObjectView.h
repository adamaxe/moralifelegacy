/**
Unit Test for ConscienceObjectView.  Test the properties for the Conscience Object (facial features).
 
@class TestConscienceObjectView
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/25/2011
@file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

@class ConscienceObjectView;

@interface TestConscienceObjectView : SenTestCase {
    
    ConscienceObjectView *testingConscienceObjectView;

}

#if USE_APPLICATION_UNIT_TEST
- (void)testAppDelegate;       // simple test on application
#else
/**
Ensure that the ConscienceObjectView was able to init.
 */
- (void)testConscienceObjectExists;
/**
Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConscienceObject;
/**
Ensure that the properties can be set/get correctly.
 */
- (void)testConscienceObjectProperties;

#endif

@end