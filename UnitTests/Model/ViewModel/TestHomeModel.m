/**
 Unit Test for HomeModel.  Test model interaction with peristed data for the HomeViewController
 
 @class TestHomeModel
 
 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 04/14/2013
 @file
 */

#import "HomeModel.h"
#import "ModelManager.h"
#import "TestModelHelper.h"
#import "Moral.h"
#import "UserChoice.h"
#import "UserCollectable.h"
#import "ConscienceAsset.h"
#import "OCMock/OCMock.h"

@interface TestHomeModel : XCTestCase {
    
    HomeModel *testingSubject;
    ModelManager *testModelManager;

}

@end

@implementation TestHomeModel

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    [testModelManager saveContext];

    testingSubject = [[HomeModel alloc] initWithModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];

}

- (void)testChoiceHomeModelCanBeCreated {

    HomeModel *testingSubjectCreate = [[HomeModel alloc] initWithModelManager:testModelManager];

    XCTAssertNotNil(testingSubjectCreate, @"HomeModel can't be created.");

    
}

- (void)testChoiceHomeModelDefaultValuesAreCorrect {

    XCTAssertTrue([testingSubject.greatestVirtue isEqualToString:@""], @"HomeModel greatestVirtue is not empty string.");
    XCTAssertTrue([testingSubject.worstVice isEqualToString:@""], @"HomeModel worstVice is not empty string.");
    NSLog(@"highest:%@", testingSubject.highestRank);
    XCTAssertTrue([testingSubject.highestRank isEqualToString:HOME_MODEL_BEGINNER_RANK], @"HomeModel highestRank is not default rank.");

}

- (void)testChoiceHomeModelDefaultGoodReactionsAreCorrect {

    NSMutableArray *possibleReactions = [[NSMutableArray alloc] initWithCapacity:HOME_MODEL_REACTION_COUNT];
    
    for (int i = 0; i < HOME_MODEL_REACTION_COUNT; i++) {
        possibleReactions[i] = [[NSString alloc] initWithFormat:@"%@Reaction%d%@",NSStringFromClass(testingSubject.class), i, @"Good"];
    }

    NSString *reaction = [testingSubject generateReactionWithMood:51.0 andEnthusiasm:51.0];
    XCTAssertTrue([possibleReactions containsObject:reaction], @"HomeModel reaction is not in Good set.");

    [possibleReactions removeAllObjects];
    for (int i = 0; i < HOME_MODEL_REACTION_COUNT; i++) {
        possibleReactions[i] = [[NSString alloc] initWithFormat:@"%@Reaction%d%@",NSStringFromClass(testingSubject.class), i, @"Bad"];
    }

    XCTAssertFalse([possibleReactions containsObject:reaction], @"HomeModel reaction is not incorrectly in bad set.");

}

- (void)testChoiceHomeModelDefaultBadReactionsAreCorrect {

    NSMutableArray *possibleReactions = [[NSMutableArray alloc] initWithCapacity:HOME_MODEL_REACTION_COUNT];

    for (int i = 0; i < HOME_MODEL_REACTION_COUNT; i++) {
        possibleReactions[i] = [[NSString alloc] initWithFormat:@"%@Reaction%d%@",NSStringFromClass(testingSubject.class), i, @"Bad"];
    }

    NSString *reaction = [testingSubject generateReactionWithMood:40.0 andEnthusiasm:40.0];
    XCTAssertTrue([possibleReactions containsObject:reaction], @"HomeModel reaction is not in Good set.");

    [possibleReactions removeAllObjects];
    for (int i = 0; i < HOME_MODEL_REACTION_COUNT; i++) {
        possibleReactions[i] = [[NSString alloc] initWithFormat:@"%@Reaction%d%@",NSStringFromClass(testingSubject.class), i, @"Good"];
    }

    XCTAssertFalse([possibleReactions containsObject:reaction], @"HomeModel reaction is not incorrectly in bad set.");
    
}

- (void)testChoiceHomeModelHighestRankIsCorrectWhenRankIsUpdated{

    UserCollectable *testCollectable1;
    UserCollectable *testCollectable2;
    UserCollectable *testCollectable3;
//    ConscienceAsset *testAsset;

    testCollectable1 = [TestModelHelper createUserCollectableWithName:@"asse-rank1" withModelManager:testModelManager];
    testCollectable2 = [TestModelHelper createUserCollectableWithName:@"asse-rank2a" withModelManager:testModelManager];
    testCollectable3 = [TestModelHelper createUserCollectableWithName:@"asse-rank2b" withModelManager:testModelManager];

    XCTAssertTrue([testingSubject.highestRank isEqualToString:HOME_MODEL_BEGINNER_RANK], @"HomeModel highestRank is not default rank.");
    
}

@end

