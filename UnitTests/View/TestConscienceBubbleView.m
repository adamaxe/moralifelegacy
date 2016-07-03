/**
 Unit Test for ConscienceBubbleView.  Test the properties for the Conscience Bubble visualization.
 
 @class TestConscienceBubbleView
 
 @author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/25/2011
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import "ConscienceBubbleView.h"

@interface TestConscienceBubbleView: XCTestCase {
    
    ConscienceBubbleView *testingSubject;
    
}

@end

#import "ConscienceBubbleView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>


@implementation TestConscienceBubbleView

- (void)setUp{
    
    [super setUp];
    
    testingSubject = [[ConscienceBubbleView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    
}

- (void)tearDown{

    
	[super tearDown];
    
}

/**
 Ensure that the AccessoryObjectView was able to init.
 */
- (void)testBubbleExists{

    XCTAssertNotNil(testingSubject, @"The bubble was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultBubbleProperties{
    
	XCTAssertEqual(MLBubbleTypeDefault, [testingSubject bubbleType], @"Default bubble type inaccurate");
	XCTAssertEqual(MLBubbleWidthDefault, [testingSubject bubbleGlowWidth], @"Default bubble glow inaccurate");
	XCTAssertEqual(MLBubbleDurationDefault, [testingSubject bubbleGlowDuration], @"Default bubble duration inaccurate");
	XCTAssertEqualObjects(MLBubbleColorDefault, [testingSubject bubbleColor], @"Default bubble color inaccurate");

}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testBubbleProperties{

	int testBubbleType = 1;
	CGFloat testBubbleGlowWidth = 4;
	CGFloat testBubbleGlowDuration = 0.50;
	NSString *testBubbleColor = @"FF00FF";

	[testingSubject setBubbleType:testBubbleType];
	[testingSubject setBubbleGlowWidth:testBubbleGlowWidth];
	[testingSubject setBubbleGlowDuration:testBubbleGlowDuration];
	[testingSubject setBubbleColor:testBubbleColor];

	XCTAssertEqual(testBubbleType, [testingSubject bubbleType], @"Bubble type setter/getter inaccurate");
	XCTAssertEqual(testBubbleGlowWidth, [testingSubject bubbleGlowWidth], @"Bubble glow setter/getter inaccurate");
	XCTAssertEqual(testBubbleGlowDuration, [testingSubject bubbleGlowDuration], @"Bubble duration setter/getter inaccurate");
	XCTAssertEqualObjects(testBubbleColor, [testingSubject bubbleColor], @"Bubble color setter/getter inaccurate");
}

@end
