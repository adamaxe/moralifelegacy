//
//  UnitTests.m
//  UnitTests
//
//  Created by aaxe on 2/17/11.
//  Copyright 2011 Team Axe, LLC. All rights reserved.
//

#import "UnitTests.h"

@implementation UnitTests

- (void)setUp
{
    
    [super setUp];
    
    // Set-up code here.
    
//    SenTestSuite *suite = [SenTestSuite testSuiteWithName: @"ML Logic Tests"];
//    
//    [suite addTest:[UnitTests testCaseWithSelector:@selector(testExample)]];
//    
//    SenTestSuite *anotherSuite = [SenTestSuite testSuiteForTestCaseClass:[UnitTests class]];
//    
//    [suite addTest: anotherSuite];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
//    STFail(@"Unit tests are not implemented yet in UnitTests");
//    //STFail(@"Unit tests are not implemented yet in LogicTests.  YAY!");
//    NSString *test1 = @"test";
//    NSString *test2 = @"test";
//    STAssertEquals(4, 4, @"This didn't pass!");
//    STAssertEqualObjects(test1, test2, @"Testing strings", test1);
}

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testMath {
    
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}

- (void)suite1Test
{
    
    //STFail(@"Unit tests are not implemented yet in LogicTests.  YAY!");
//    NSString *testSuite1 = @"test";
//    NSString *testSuite2 = @"test3";
//    STAssertEquals(4, 3, @"This didn't pass!");
//    STAssertEqualObjects(testSuite1, testSuite2, @"Testing strings in suite", testSuite1);
}

#endif

@end
