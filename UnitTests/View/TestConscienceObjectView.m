/**
 Unit Test for ConscienceObjectView.  Test the properties for the Conscience Object (facial features).
 
 Test the vector construction properties for the Conscience facial features.
 
 @class TestConscienceObjectView
 
 @author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/25/2011
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import "ConscienceObjectView.h"

@interface TestConscienceObjectView : XCTestCase {
    
    ConscienceObjectView *testingSubject;
    
}

@end

#import "ConscienceObjectView.h"
#import "ConscienceLayer.h"
#import "ConscienceGradient.h"

@implementation TestConscienceObjectView

- (void)setUp{
    
    [super setUp];
    
    testingSubject = [[ConscienceObjectView alloc] initWithFrame:CGRectMake(0, 0, MLEyeWidth, MLEyeHeight)];
    
}

- (void)tearDown{

    
	[super tearDown];
    
}

/**
 Ensure that the ConscienceObjectView was able to init.
 */
- (void)testConscienceObjectExists{

    XCTAssertNotNil(testingSubject, @"The Conscience object was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultConscienceObject{

	UIColor *testColor = [UIColor clearColor];
	int count = 0;
    int countSetter = [[testingSubject totalLayers] count];
    
	XCTAssertEqual(count, countSetter, @"totalLayers was not initialized properly.");
    
    countSetter = [[testingSubject totalGradients] count];
    
	XCTAssertEqual(count, countSetter, @"totalGradients was not initialized properly.");
	XCTAssertEqualObjects(testColor, [testingSubject conscienceBackgroundColor], @"conscienceBackgroundColor was not initialized properly.");

}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testConscienceObjectProperties{

	NSMutableDictionary *testLayers = [[NSMutableDictionary alloc] initWithCapacity:1];
	NSMutableDictionary *testGradients = [[NSMutableDictionary alloc] initWithCapacity:1];
	UIColor *testColor = [UIColor blackColor];
	int count = 1;

	ConscienceLayer *testLayer = [[ConscienceLayer alloc] init];
	ConscienceGradient *testGradient = [[ConscienceGradient alloc] init];

	testLayers[@"layer1"] = testLayer;
	testGradients[@"gradient1"] = testGradient;

	[testingSubject setTotalLayers:testLayers];
	[testingSubject setTotalGradients:testGradients];
	[testingSubject setConscienceBackgroundColor:testColor];
    
    int countSetter = [[testingSubject totalLayers] count];
    
	XCTAssertEqual(count, countSetter, @"totalLayers setter/getter inaccurate.");
    
    countSetter = [[testingSubject totalGradients] count];

	XCTAssertEqual(count, countSetter, @"totalGradients setter/getter inaccurate.");
	XCTAssertEqualObjects(testColor, [testingSubject conscienceBackgroundColor], @"conscienceBackgroundColor setter/getter inaccurate.");

}

@end
