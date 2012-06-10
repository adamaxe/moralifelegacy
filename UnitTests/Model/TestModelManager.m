/**
 Unit Test for ModelManager.  Test to see if persistence stack can be setup and saved.
 
 @class TestModelManager
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/09/2012
 @file
 */

#import <SenTestingKit/SenTestingKit.h>

#define USE_APPLICATION_UNIT_TEST 0

@class ModelManager;

@interface TestModelManager : SenTestCase {
    
    ModelManager *testingSubject;
    
}

@end

#import "ModelManager.h"

@implementation TestModelManager

- (void)setUp{
    
    [super setUp];
    
    testingSubject = [[ModelManager alloc] init];
    
}

- (void)tearDown{
    
	//Tear-down code here.
	[testingSubject release];
    
	[super tearDown];
    
}

/**
 Ensure that the ConsciencePath was able to init.
 */
//- (void)testModelManagerExists{
//    
//    STAssertNotNil(testingSubject, @"The ModelManager was not init'ed.");
//}

/**
 Ensure that the ConsciencePath was able to init.
 */
//- (void)testModelManagerCanSave{
//    
//    STAssertNoThrow([testingSubject saveContext], @"The ModelManager was not able to save.");
//}


@end

