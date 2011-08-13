/**
TestConsciencePath Implementation.  Test the vector construction properties for a single Conscience Path.
 
@class TestConsciencePath TestConsciencePath.h
 */

#import "TestConsciencePath.h"
#import "ConsciencePath.h"

@implementation TestConsciencePath

- (void)setUp{
    
    [super setUp];
    
    testingConsciencePath = [[ConsciencePath alloc] init];
    
}

- (void)tearDown{

	//Tear-down code here.
	[testingConsciencePath release];
    
	[super tearDown];
    
}

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
        
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testConsciencePathExists{

    STAssertNotNil(testingConsciencePath, @"The Conscience Path was not init'ed.");
}

- (void)testDefaultConsciencePath{
    
    int countPaths = [[testingConsciencePath pathPoints] count];
    int countInstructions = [[testingConsciencePath pathInstructions] count];

	STAssertEquals(0, countPaths, @"Default empty path points array inaccurate.");
	STAssertEquals(0, countInstructions, @"Default empty path instructions array inaccurate.");
	STAssertEquals(kDefault0Float, [testingConsciencePath pathStrokeWidth], @"Default path stroke width inaccurate.");
	STAssertEquals(kDefault0Float, [testingConsciencePath pathFillOpacity], @"Default path fill opacity inaccurate.");
	STAssertEquals(kDefault0Float, [testingConsciencePath pathStrokeMiterLimit], @"Default path stroke miter limit inaccurate.");
	STAssertEquals(kDefault0Float, [testingConsciencePath pathStrokeOpacity], @"Default path stroke opacity inaccurate.");
	STAssertEqualObjects(kPathColor, [testingConsciencePath pathFillColor], @"Default fill color inaccurate.");
	STAssertEqualObjects(kPathColor, [testingConsciencePath pathStrokeColor], @"Default stroke color inaccurate.");
	STAssertEqualObjects(@"none", [testingConsciencePath pathID], @"Default path ID inaccurate.");
	STAssertEqualObjects(@"", [testingConsciencePath pathGradient], @"Default gradient inaccurate.");

}

- (void)testConsciencePathProperties{

	NSMutableArray *pathPoints = [[NSMutableArray alloc] initWithCapacity:1];
	NSMutableArray *pathInstructions = [[NSMutableArray alloc] initWithCapacity:1];

	[pathPoints addObject:[NSNumber numberWithFloat:1.0]];
	[pathInstructions addObject:[NSNumber numberWithInt:1]];

	NSString *testColor = @"FFFFFF";
	NSString *testID = @"none";
	CGFloat testOffset = 1.0;

	[testingConsciencePath setPathFillColor:testColor];
	[testingConsciencePath setPathStrokeColor:testColor];
	[testingConsciencePath setPathID:testID];
	[testingConsciencePath setPathGradient:testID];
	[testingConsciencePath setPathStrokeWidth:testOffset];
	[testingConsciencePath setPathFillOpacity:testOffset];
	[testingConsciencePath setPathStrokeMiterLimit:testOffset];
	[testingConsciencePath setPathStrokeOpacity:testOffset];
    [testingConsciencePath setPathPoints:pathPoints];
    [testingConsciencePath setPathInstructions:pathInstructions];
    
    int countPaths = [[testingConsciencePath pathPoints] count];
    int countInstructions = [[testingConsciencePath pathInstructions] count];
    
	STAssertEquals(1, countPaths, @"Path points array setter/getter inaccurate.");
	STAssertEquals(1, countInstructions, @"Path instructions array setter/getter inaccurate.");
	STAssertEquals(testOffset, [testingConsciencePath pathStrokeWidth], @"Path stroke width setter/getter inaccurate.");
	STAssertEquals(testOffset, [testingConsciencePath pathFillOpacity], @"Path fill opacity setter/getter inaccurate.");
	STAssertEquals(testOffset, [testingConsciencePath pathStrokeMiterLimit], @"Path stroke miter limit setter/getter inaccurate.");
	STAssertEquals(testOffset, [testingConsciencePath pathStrokeOpacity], @"Path stroke opacity setter/getter inaccurate.");
	STAssertEqualObjects(testColor , [testingConsciencePath pathFillColor], @"Fill color setter/getter inaccurate.");
	STAssertEqualObjects(testColor , [testingConsciencePath pathStrokeColor], @"Stroke color setter/getter inaccurate.");
	STAssertEqualObjects(testID , [testingConsciencePath pathID], @"Path ID setter/getter inaccurate.");
	STAssertEqualObjects(testID , [testingConsciencePath pathGradient], @"Gradient setter/getter inaccurate.");

	[pathPoints release];
	[pathInstructions release];

}

#endif

@end
