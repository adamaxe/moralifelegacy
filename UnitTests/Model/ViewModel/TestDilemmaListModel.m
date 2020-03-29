/**
 Unit Test for DilemmaListModel.  Test model interaction with peristed data for DilemmaListViewController
 
 @class TestDilemmaModel
 
 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 02/18/2013
 @file
 */

#import "DilemmaListModel.h"
#import "TestModelHelper.h"
#import "UserDilemma.h"
#import "Dilemma.h"
#import "Moral.h"
#import "UserCollectable.h"
#import "OCMock/OCMock.h"

@interface TestDilemmaListModel :XCTestCase {
    
    DilemmaListModel *testingSubject;
    ModelManager *testModelManager;
    Dilemma *testDilemma1;
    Dilemma *testDilemma2;
    Dilemma *testDilemma3;
    Moral *testMoralA;
    Moral *testMoralB;
    UserDilemma *testUserDilemma;

    id userDefaultsMock;

    NSString *nameDilemma1;
    NSString *nameDilemma2;
    NSString *nameDilemma3;

}

@end

@implementation TestDilemmaListModel

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    userDefaultsMock = [OCMockObject niceMockForClass:NSUserDefaults.class];

    nameDilemma1 = @"dile-1-01";
    nameDilemma2 = @"dile-2-01";
    nameDilemma3 = @"dile-3-01";

    testDilemma1 = [TestModelHelper createDilemmaWithName:nameDilemma1 withModelManager:testModelManager];
    testDilemma2 = [TestModelHelper createDilemmaWithName:nameDilemma2 withModelManager:testModelManager];

    testMoralA = [TestModelHelper createMoralWithName:@"Virtue Name1" withType:@"Virtue" withModelManager:testModelManager];
    testMoralB = [TestModelHelper createMoralWithName:@"Vice Name2" withType:@"Vice" withModelManager:testModelManager];

    testDilemma1.moralChoiceA = testMoralA;
    testDilemma1.moralChoiceB = testMoralB;

    testDilemma2.moralChoiceA = testMoralA;
    testDilemma2.moralChoiceB = testMoralA;

    testUserDilemma = [TestModelHelper createUserDilemmaWithName:@"dile-1-01user" withModelManager:testModelManager];
    testingSubject = [[DilemmaListModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure1];

}

- (void)testDilemmaModelCanBeCreated {

    DilemmaListModel *testingSubjectCreate = [[DilemmaListModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure1];

    XCTAssertNotNil(testingSubjectCreate, @"DilemmaModel can't be created.");
}

- (void)testDilemmaModelCanRetrieveCorrectDilemmaGivenRequestedCampaign {

    XCTAssertTrue(testingSubject.dilemmas.count == 1, @"DilemmaModel didn't return correct number of dilemmas.");

    XCTAssertEqualObjects(testingSubject.dilemmas[0], testDilemma1.nameDilemma, @"DilemmaName not correct.");
    XCTAssertEqualObjects(testingSubject.dilemmaDisplayNames[0], testDilemma1.displayNameDilemma, @"dilemmaDisplayName not correct.");
    XCTAssertEqualObjects(testingSubject.dilemmaImages[0], testDilemma1.surrounding, @"surrounding Image not correct.");
}

- (void)testRetrievedDilemmaHasCorrectDerivedDataForAChoiceType {

    NSString *vsText = [NSString stringWithFormat:@"%@ vs. %@", testDilemma1.moralChoiceA.displayNameMoral, testDilemma1.moralChoiceB.displayNameMoral];

    //test vs. dilemma
    XCTAssertEqualObjects(testingSubject.dilemmaDetails[0], vsText, @"DilemmaDetails not correctly displayed as the moral vs. moral.");
    XCTAssertTrue([testingSubject.dilemmaTypes[0] boolValue] == TRUE, @"dilemmaType not correct.");

    NSArray *moralKeys = [testingSubject.moralNames allKeys];
    NSArray *moralValues = [testingSubject.moralNames allValues];

    XCTAssertTrue([moralKeys containsObject:testDilemma1.moralChoiceA.nameMoral], @"Dilemma moralNames doesn't contain moralA name");
    XCTAssertTrue([moralValues containsObject:testDilemma1.moralChoiceA.displayNameMoral], @"Dilemma moralNames doesn't contain moralA name");
    XCTAssertTrue([moralKeys containsObject:testDilemma1.moralChoiceB.nameMoral], @"Dilemma moralNames doesn't contain moralB name");
    XCTAssertTrue([moralValues containsObject:testDilemma1.moralChoiceB.displayNameMoral], @"Dilemma moralNames doesn't contain moralB name");
}

- (void)testRetrievedDilemmaHasCorrectDerivedDataForAnActionType {
    DilemmaListModel *testingSubjectCreate = [[DilemmaListModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure2];

    //test action dilemma
    XCTAssertEqualObjects(testingSubjectCreate.dilemmaDetails[0], testDilemma2.moralChoiceA.displayNameMoral, @"DilemmaDetails not correctly displayed as the moral.");
    XCTAssertTrue([testingSubjectCreate.dilemmaTypes[0] boolValue] == FALSE, @"dilemmaType not correct.");

    NSArray *moralKeys = [testingSubjectCreate.moralNames allKeys];
    NSArray *moralValues = [testingSubjectCreate.moralNames allValues];

    XCTAssertTrue([moralKeys containsObject:testDilemma2.moralChoiceA.nameMoral], @"Dilemma moralNames doesn't contain moralA name");
    XCTAssertTrue([moralValues containsObject:testDilemma2.moralChoiceA.displayNameMoral], @"Dilemma moralNames doesn't contain moralA name");

    XCTAssertTrue(moralKeys.count == 1, @"Dilemma moralNames doesn't have a single entry (Morals aren't the same)");
    XCTAssertTrue(moralValues.count == 1, @"Dilemma moralDisplayNames doesn't have a single entry (Morals aren't the same)");

}

- (void)testDilemmaModelCanFilterDilemmaGivenRequestedCampaign {

    DilemmaListModel *testingSubjectCreate = [[DilemmaListModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure2];

    XCTAssertTrue(testingSubjectCreate.dilemmas.count == 1, @"DilemmaModel didn't return correct number of dilemmas.");

    XCTAssertEqualObjects(testingSubjectCreate.dilemmas[0], testDilemma2.nameDilemma, @"DilemmaName not correct.");
}

- (void)testDilemmaModelCanRetrieveCorrectlySortedDilemmasGivenRequestedCampaign {

    NSString *nameDilemmaOrderedSecond = @"dile-1-02";
    Dilemma *testDilemmaOrderedSecond = [TestModelHelper createDilemmaWithName:nameDilemmaOrderedSecond withModelManager:testModelManager];

    DilemmaListModel *testingSubjectCreate = [[DilemmaListModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure1];

    XCTAssertTrue(testingSubjectCreate.dilemmas.count == 2, @"DilemmaModel didn't return correct number of dilemmas.");

    XCTAssertEqualObjects(testingSubjectCreate.dilemmas[0], testDilemma1.nameDilemma, @"DilemmaName not correct order.");
    XCTAssertEqualObjects(testingSubjectCreate.dilemmaDisplayNames[0], testDilemma1.displayNameDilemma, @"dilemmaDisplayName not correct order.");
    XCTAssertEqualObjects(testingSubjectCreate.dilemmaImages[0], testDilemma1.surrounding, @"surrounding Image not correct order.");

    XCTAssertEqualObjects(testingSubjectCreate.dilemmas[1], testDilemmaOrderedSecond.nameDilemma, @"DilemmaName not correct order.");
    XCTAssertEqualObjects(testingSubjectCreate.dilemmaDisplayNames[1], testDilemmaOrderedSecond.displayNameDilemma, @"dilemmaDisplayName not correct order.");
    XCTAssertEqualObjects(testingSubjectCreate.dilemmaImages[1], testDilemmaOrderedSecond.surrounding, @"surrounding Image not correct order.");

}

- (void)testDilemmaModelReturnsNoDilemmasIfCampaignIsWrong {

    DilemmaListModel *testingSubjectCreate = [[DilemmaListModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure3];

    XCTAssertTrue(testingSubjectCreate.dilemmas.count == 0, @"DilemmaModel returned dilemma it shouldn't have.");
}

- (void)testDilemmaModelReturnsASingleUserDilemmaIfCampaignIsWrong {


    DilemmaListModel *testingSubjectCreate = [[DilemmaListModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure3];

    NSArray *userDilemmaKeys = [testingSubjectCreate.userChoices allKeys];
    NSArray *userDilemmaValues = [testingSubjectCreate.userChoices allValues];
    XCTAssertTrue(userDilemmaKeys.count == 1, @"DilemmaModel didn't return correct number of userChoiceKeys.");
    XCTAssertEqualObjects(userDilemmaKeys[0], @"noUserEntries", @"DilemmaModel didn't return correct empty key designation.");
    XCTAssertTrue(userDilemmaValues.count == 1, @"DilemmaModel didn't return correct userChoiceValues.");
    XCTAssertEqualObjects(userDilemmaValues[0], @"", @"DilemmaModel didn't return correct empty value designation.");
    
}

- (void)testDilemmaModelReturnsCorrectUserDilemmaIfCampaignIsRight {

    NSArray *userDilemmaKeys = [testingSubject.userChoices allKeys];
    NSArray *userDilemmaValues = [testingSubject.userChoices allValues];
    XCTAssertTrue(userDilemmaKeys.count == 1, @"DilemmaModel didn't return correct number of userChoiceKeys.");
    XCTAssertEqualObjects(userDilemmaKeys[0], testUserDilemma.entryShortDescription, @"DilemmaModel didn't return correct userDilemma key.");
    XCTAssertTrue(userDilemmaValues.count == 1, @"DilemmaModel didn't return correct userChoiceValues.");
    XCTAssertEqualObjects(userDilemmaValues[0], testUserDilemma.entryLongDescription, @"DilemmaModel didn't return correct userDilemma key.");

}

- (void)testSelectDilemmaWritesToStandardUserDefaultsForViewing {

    [[userDefaultsMock expect] setObject:nameDilemma1 forKey:@"dilemmaKey"];
    [[userDefaultsMock expect] synchronize];

    [testingSubject selectDilemma:nameDilemma1];

    [userDefaultsMock verify];
}

@end

