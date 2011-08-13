/**
 TestGraphView.h Unit Tests for Graph
 
@author Copyright Team Axe, LLC. http://www.teamaxe.org, All rights reserved.
@class TestGraphView
@date 03/30/2011
@file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

@class GraphView;

@interface TestGraphView : SenTestCase {
    GraphView *testingGraphView;
}

#if USE_APPLICATION_UNIT_TEST
- (void)testAppDelegate;       // simple test on application
#else
/**
 Ensure that the GraphView was able to init.
 */
- (void)testGraphExists;
/**
 Ensure that the default values of the data/colors from init were executed.
 */
- (void)testDefaultData;
/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testGraphProperties;
#endif

@end
