/**
Unit Test for ConsciencePath.  Test the properties for the Conscience Path derived from svg.
 
@class TestConsciencePath
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/25/2011
@file
 */

#define USE_APPLICATION_UNIT_TEST 0

@class ConsciencePath;

@interface TestConsciencePath : SenTestCase {
    
    ConsciencePath *testingConsciencePath;

}

#if USE_APPLICATION_UNIT_TEST
- (void)testAppDelegate;       // simple test on application
#else
/**
Ensure that the ConscienceLayer was able to init.
 */
- (void)testConsciencePathExists;
/**
Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConsciencePath;
/**
Ensure that the properties can be set/get correctly.
 */
- (void)testConsciencePathProperties;
#endif

@end