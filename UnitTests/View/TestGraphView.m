/**
 TestGraphView.h Unit Tests for Graph.  Unit Tests to ensure proper init/alloc of Pie Chart.
 
 @author Copyright Team Axe, LLC. http://www.teamaxe.org, All rights reserved.
 @class TestGraphView
 @date 03/30/2011
 @file
 */

#define USE_APPLICATION_UNIT_TEST 0

#import "UIColor+Utility.h"
@class GraphView;

@interface TestGraphView :XCTestCase {
    GraphView *testingSubject;
}

@end

#import "GraphView.h"

const int kGraphHeight = 240;
const int kGraphWidth = 240;

@implementation TestGraphView

- (void)setUp
{
    [super setUp];
    testingSubject = [[GraphView alloc] initWithFrame:CGRectMake(0, 0,  kGraphWidth, kGraphHeight)];
}

- (void)tearDown
{
    
    [super tearDown];

}

/**
 Ensure that the GraphView was able to init.
 */
- (void)testGraphExists{
    
    XCTAssertNotNil(testingSubject, @"The graph was not init'ed.");
}

/**
 Ensure that the default values of the data/colors from init were executed.
 */

- (void)testDefaultData{
    
    XCTAssertEqualObjects([NSNumber numberWithFloat:360.0], [testingSubject pieValues][0], @"Default Graph data inaccurate.");
    XCTAssertEqualObjects([UIColor moraLifeChoiceRed], [testingSubject pieColors][0], @"Default Graph Color inaccurate.");
}

/**
 Ensure that the properties can be set/get correctly.
 */
- (void)testGraphProperties{

    NSNumber *pieValue1 = @30.0f;
    NSNumber *pieValue2 = @70.0f;

	NSArray *testValues = @[pieValue1, pieValue2];
	NSArray *testColors = @[[UIColor blueColor], [UIColor greenColor]];
    
    [testingSubject setPieValues:testValues];
    [testingSubject setPieColors:testColors];
    
    XCTAssertEqualObjects(pieValue1, [testingSubject pieValues][0], @"Graph data setter inaccurate.");
    XCTAssertEqualObjects([UIColor blueColor], [testingSubject pieColors][0], @"Graph color setter inaccurate.");


}

@end
