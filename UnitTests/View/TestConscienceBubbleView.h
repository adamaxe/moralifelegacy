/**
Unit Test for ConscienceBubbleView.  Test the properties for the Conscience Bubble
 
@class TestConscienceBubbleView
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/25/2011
@file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

@class ConscienceBubbleView;

@interface TestConscienceBubbleView: SenTestCase {
    
    ConscienceBubbleView *testingConscienceBubbleView;

}

#if USE_APPLICATION_UNIT_TEST
- (void)testAppDelegate;       // simple test on application
#else
/**
Ensure that the AccessoryObjectView was able to init.
 */
- (void)testBubbleExists;
/**
Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultBubbleProperties;
/**
Ensure that the properties can be set/get correctly.
 */
- (void)testBubbleProperties;
#endif

@end