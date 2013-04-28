/**
 Unit Test for HomeModel.  Test model interaction with peristed data for the HomeViewController
 
 @class TestHomeModel
 
 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 04/14/2013
 @file
 */

#import "HomeModel.h"
#import "ModelManager.h"
#import "Moral.h"
#import "UserChoice.h"
#import "UserCollectable.h"
#import "ConscienceAsset.h"
#import "OCMock/OCMock.h"

@interface TestHomeModel : SenTestCase {
    
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

    STAssertNotNil(testingSubjectCreate, @"HomeModel can't be created.");

    
}

- (void)testChoiceHomeModelDefaultValuesAreCorrect {

    STAssertTrue([testingSubject.greatestVirtue isEqualToString:@""], @"HomeModel greatestVirtue is not empty string.");
    STAssertTrue([testingSubject.worstVice isEqualToString:@""], @"HomeModel worstVice is not empty string.");
    NSLog(@"highest:%@", testingSubject.highestRank);
    STAssertTrue([testingSubject.highestRank isEqualToString:HOME_MODEL_BEGINNER_RANK], @"HomeModel highestRank is not default rank.");

}

- (void)testChoiceHomeModelDefaultGoodReactionsAreCorrect {

    NSMutableArray *possibleReactions = [[NSMutableArray alloc] initWithCapacity:HOME_MODEL_REACTION_COUNT];
    
    for (int i = 0; i < HOME_MODEL_REACTION_COUNT; i++) {
        possibleReactions[i] = [[NSString alloc] initWithFormat:@"%@Reaction%d%@",NSStringFromClass(testingSubject.class), i, @"Good"];
    }

    NSString *reaction = [testingSubject generateReactionWithMood:51.0 andEnthusiasm:51.0];
    STAssertTrue([possibleReactions containsObject:reaction], @"HomeModel reaction is not in Good set.");

    [possibleReactions removeAllObjects];
    for (int i = 0; i < HOME_MODEL_REACTION_COUNT; i++) {
        possibleReactions[i] = [[NSString alloc] initWithFormat:@"%@Reaction%d%@",NSStringFromClass(testingSubject.class), i, @"Bad"];
    }

    STAssertFalse([possibleReactions containsObject:reaction], @"HomeModel reaction is not incorrectly in bad set.");

}

- (void)testChoiceHomeModelDefaultBadReactionsAreCorrect {

    NSMutableArray *possibleReactions = [[NSMutableArray alloc] initWithCapacity:HOME_MODEL_REACTION_COUNT];

    for (int i = 0; i < HOME_MODEL_REACTION_COUNT; i++) {
        possibleReactions[i] = [[NSString alloc] initWithFormat:@"%@Reaction%d%@",NSStringFromClass(testingSubject.class), i, @"Bad"];
    }

    NSString *reaction = [testingSubject generateReactionWithMood:40.0 andEnthusiasm:40.0];
    STAssertTrue([possibleReactions containsObject:reaction], @"HomeModel reaction is not in Good set.");

    [possibleReactions removeAllObjects];
    for (int i = 0; i < HOME_MODEL_REACTION_COUNT; i++) {
        possibleReactions[i] = [[NSString alloc] initWithFormat:@"%@Reaction%d%@",NSStringFromClass(testingSubject.class), i, @"Good"];
    }

    STAssertFalse([possibleReactions containsObject:reaction], @"HomeModel reaction is not incorrectly in bad set.");
    
}

- (void)testChoiceHomeModelHighestRankIsCorrectWhenRankIsUpdated{

    UserCollectable *testCollectable1;
    UserCollectable *testCollectable2;
    UserCollectable *testCollectable3;
    ConscienceAsset *testAsset;

    NSString *keyCollectable1;
    NSString *keyCollectable2;
    NSString *keyCollectable3;

    NSString *collectableName1;
    NSString *collectableName2;
    NSString *collectableName3;
    NSDate *collectableCreateDate;

    keyCollectable1 = @"asse-rank1";
    keyCollectable2 = @"asse-rank2a";
    keyCollectable3 = @"asse-rank2b";

    collectableName1 = @"asse-rank1";
    collectableName2 = @"asse-rank2a";
    collectableName3 = @"asse-rank2b";
    collectableCreateDate = [NSDate date];

    testCollectable1 = [testModelManager create:UserCollectable.class];
    testCollectable2 = [testModelManager create:UserCollectable.class];
    testCollectable3 = [testModelManager create:UserCollectable.class];

    testCollectable1.collectableName = collectableName1;
    testCollectable1.collectableKey = keyCollectable1;
    testCollectable1.collectableCreationDate = collectableCreateDate;

    testCollectable2.collectableName = collectableName2;
    testCollectable2.collectableKey = keyCollectable2;
    testCollectable2.collectableCreationDate = collectableCreateDate;

    testCollectable3.collectableName = collectableName3;
    testCollectable3.collectableKey = keyCollectable3;
    testCollectable3.collectableCreationDate = collectableCreateDate;

    [testModelManager saveContext];

    STAssertTrue([testingSubject.highestRank isEqualToString:HOME_MODEL_BEGINNER_RANK], @"HomeModel highestRank is not default rank.");
    
}

@end

