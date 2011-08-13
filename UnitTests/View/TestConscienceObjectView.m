/**
TestConscienceObjectView Implementation.  Test the vector construction properties for the Conscience facial features.
 
@class TestConscienceObjectView TestConscienceObjectView.h
 */

#import "TestConscienceObjectView.h"
#import "ConscienceObjectView.h"
#import "ConscienceLayer.h"
#import "ConscienceGradient.h"

@implementation TestConscienceObjectView

- (void)setUp{
    
    [super setUp];
    
    testingConscienceObjectView = [[ConscienceObjectView alloc] initWithFrame:CGRectMake(0, 0, kEyeWidth, kEyeHeight)];
    
}

- (void)tearDown{

    [testingConscienceObjectView release];
    
	[super tearDown];
    
}

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
        
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testConscienceObjectExists{

    STAssertNotNil(testingConscienceObjectView, @"The Conscience object was not init'ed.");
}

- (void)testDefaultConscienceObject{

	UIColor *testColor = [UIColor clearColor];
	int count = 0;
    int countSetter = [[testingConscienceObjectView totalLayers] count];
    
	STAssertEquals(count, countSetter, @"totalLayers was not initialized properly.");
    
    countSetter = [[testingConscienceObjectView totalGradients] count];
    
	STAssertEquals(count, countSetter, @"totalGradients was not initialized properly.");
	STAssertEqualObjects(testColor, [testingConscienceObjectView conscienceBackgroundColor], @"conscienceBackgroundColor was not initialized properly.");

}

- (void)testConscienceObjectProperties{

	NSMutableDictionary *testLayers = [[NSMutableDictionary alloc] initWithCapacity:1];
	NSMutableDictionary *testGradients = [[NSMutableDictionary alloc] initWithCapacity:1];
	UIColor *testColor = [UIColor blackColor];
	int count = 1;

	ConscienceLayer *testLayer = [[ConscienceLayer alloc] init];
	ConscienceGradient *testGradient = [[ConscienceGradient alloc] init];

	[testLayers setObject:testLayer forKey:@"layer1"];
	[testGradients setObject:testGradient forKey:@"gradient1"];

	[testingConscienceObjectView setTotalLayers:testLayers];
	[testingConscienceObjectView setTotalGradients:testGradients];
	[testingConscienceObjectView setConscienceBackgroundColor:testColor];
    
    int countSetter = [[testingConscienceObjectView totalLayers] count];
    
	STAssertEquals(count, countSetter, @"totalLayers setter/getter inaccurate.");
    
    countSetter = [[testingConscienceObjectView totalGradients] count];

	STAssertEquals(count, countSetter, @"totalGradients setter/getter inaccurate.");
	STAssertEqualObjects(testColor, [testingConscienceObjectView conscienceBackgroundColor], @"conscienceBackgroundColor setter/getter inaccurate.");

	[testLayers release];
	[testGradients release];
	[testLayer release];
	[testGradient release];
}

#endif

@end
