/**
Unit Test for ConscienceLayer.  Test the properties for the Conscience Layer derived from svg.
 
@class TestConscienceLayer
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/25/2011
@file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

@class ConscienceLayer;

@interface TestConscienceLayer : SenTestCase {
    
    ConscienceLayer *testingConscienceLayer;

}

#if USE_APPLICATION_UNIT_TEST
- (void)testAppDelegate;       // simple test on application
#else
/**
Ensure that the ConscienceLayer was able to init.
 */
- (void)testConscienceLayerExists;
/**
Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConscienceLayer;
/**
Ensure that the properties can be set/get correctly.
 */
- (void)testConscienceLayerProperties;
#endif

@end