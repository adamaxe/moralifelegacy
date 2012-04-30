/**
 Unit Test for ConscienceBubbleView.  Test the properties for the Conscience Bubble visualization.
 
 @class TestConscienceBubbleView
 
 @author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/25/2011
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

@class ConscienceBubbleView;

@interface TestConscienceBubbleView: SenTestCase {
    
    ConscienceBubbleView *testingConscienceBubbleView;
    
}

@end

#import "ConscienceBubbleView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>


@implementation TestConscienceBubbleView

- (void)setUp{
    
    [super setUp];
    
    testingConscienceBubbleView = [[ConscienceBubbleView alloc] initWithFrame:CGRectMake(0, 0, kSymbolWidth, kSymbolHeight)];
    
}

- (void)tearDown{

    [testingConscienceBubbleView release];
    
	[super tearDown];
    
}

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
        
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

/**
 Ensure that the AccessoryObjectView was able to init.
 */
- (void)testBubbleExists{

    STAssertNotNil(testingConscienceBubbleView, @"The bubble was not init'ed.");
}

/**
 Ensure that the default values of the properties from init were executed.
 */
- (void)testDefaultBubbleProperties{
    
	STAssertEquals(kBubbleType, [testingConscienceBubbleView bubbleType], @"Default bubble type inaccurate");
	STAssertEquals(kBubbleWidth, [testingConscienceBubbleView bubbleGlowWidth], @"Default bubble glow inaccurate");
	STAssertEquals(kBubbleDuration, [testingConscienceBubbleView bubbleGlowDuration], @"Default bubble duration inaccurate");
	STAssertEqualObjects(kBubbleColor, [testingConscienceBubbleView bubbleColor], @"Default bubble color inaccurate");

}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testBubbleProperties{

	int testBubbleType = 1;
	CGFloat testBubbleGlowWidth = 4;
	CGFloat testBubbleGlowDuration = 0.50;
	NSString *testBubbleColor = @"FF00FF";

	[testingConscienceBubbleView setBubbleType:testBubbleType];
	[testingConscienceBubbleView setBubbleGlowWidth:testBubbleGlowWidth];
	[testingConscienceBubbleView setBubbleGlowDuration:testBubbleGlowDuration];
	[testingConscienceBubbleView setBubbleColor:testBubbleColor];

	STAssertEquals(testBubbleType, [testingConscienceBubbleView bubbleType], @"Bubble type setter/getter inaccurate");
	STAssertEquals(testBubbleGlowWidth, [testingConscienceBubbleView bubbleGlowWidth], @"Bubble glow setter/getter inaccurate");
	STAssertEquals(testBubbleGlowDuration, [testingConscienceBubbleView bubbleGlowDuration], @"Bubble duration setter/getter inaccurate");
	STAssertEqualObjects(testBubbleColor, [testingConscienceBubbleView bubbleColor], @"Bubble color setter/getter inaccurate");
}

#endif

@end
