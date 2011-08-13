/**
TestConscienceBubbleView Implementation.  Test the properties for the visualization of the Conscience bubble.
 
@class TestConscienceBubbleView TestConscienceBubbleView.h
 */

#import "TestConscienceBubbleView.h"
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

- (void)testBubbleExists{

    STAssertNotNil(testingConscienceBubbleView, @"The bubble was not init'ed.");
}

- (void)testDefaultBubbleProperties{
    
	STAssertEquals(kBubbleType, [testingConscienceBubbleView bubbleType], @"Default bubble type inaccurate");
	STAssertEquals(kBubbleWidth, [testingConscienceBubbleView bubbleGlowWidth], @"Default bubble glow inaccurate");
	STAssertEquals(kBubbleDuration, [testingConscienceBubbleView bubbleGlowDuration], @"Default bubble duration inaccurate");
	STAssertEqualObjects(kBubbleColor, [testingConscienceBubbleView bubbleColor], @"Default bubble color inaccurate");

}

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
