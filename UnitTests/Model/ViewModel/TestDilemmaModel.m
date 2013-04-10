/**
 Unit Test for DilemmaModel.  Test model interaction with peristed data for DilemmaViewController and DilemmaListViewController
 
 @class TestDilemmaModel
 
 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 02/18/2013
 @file
 */

#import "DilemmaModel.h"
#import "Dilemma.h"
#import "UserCollectable.h"
#import "OCMock/OCMock.h"

@interface TestDilemmaModel : SenTestCase {
    
    DilemmaModel *testingSubject;
    ModelManager *testModelManager;
    Dilemma *testDilemma1;
    Dilemma *testDilemma2;
    Dilemma *testDilemma3;
    id userDefaultsMock;
    NSArray *userCollection;

    NSString *nameDilemma1;
    NSString *nameDilemma2;
    NSString *nameDilemma3;
    NSString *rewardADilemma;
    NSString *choiceB;
    NSNumber *moodDilemma;
    NSString *displayNameDilemma;
    NSString *surrounding;
    NSString *rewardBDilemma;
    NSString *choiceA;
    NSNumber *enthusiasmDilemma;
    NSString *dilemmaText;

}

@end

@implementation TestDilemmaModel

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    userDefaultsMock = [OCMockObject niceMockForClass:NSUserDefaults.class];

    nameDilemma1 = @"dile-1-01";
    nameDilemma2 = @"dile-2-01";
    nameDilemma3 = @"dile-3-01";
    choiceA = @"choiceA";
    choiceB = @"choiceB";
    displayNameDilemma = @"displayNameDilemma";
    surrounding = @"surrounding";
    rewardADilemma = @"rewardADilemma";
    rewardBDilemma = @"rewardBDilemma";
    moodDilemma = @1.5f;
    enthusiasmDilemma = @1.0f;
    dilemmaText = @"dilemmaText";

    testDilemma1 = [self createDilemmaWithName:nameDilemma1 withModelManager:testModelManager];
    testDilemma2 = [self createDilemmaWithName:nameDilemma2 withModelManager:testModelManager];

    [testModelManager saveContext];

    testingSubject = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure1];

}

- (void)testDilemmaModelCanBeCreated {

    DilemmaModel *testingSubjectCreate = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure1];

    STAssertNotNil(testingSubjectCreate, @"DilemmaModel can't be created.");
}

- (void)testDilemmaModelCanRetrieveCorrectDilemmaGivenRequestedCampaign {

    STAssertTrue(testingSubject.dilemmas.count == 1, @"DilemmaModel didn't return correct number of dilemmas.");

    STAssertEqualObjects(testingSubject.dilemmas[0], nameDilemma1, @"DilemmaName not correct.");
    STAssertEqualObjects(testingSubject.dilemmaDisplayNames[0], displayNameDilemma, @"dilemmaDisplayName not correct.");
    STAssertEqualObjects(testingSubject.dilemmaImages[0], surrounding, @"surrounding Image not correct.");

    DilemmaModel *testingSubjectCreate = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure2];

    STAssertTrue(testingSubjectCreate.dilemmas.count == 1, @"DilemmaModel didn't return correct number of dilemmas.");

    STAssertEqualObjects(testingSubjectCreate.dilemmas[0], nameDilemma2, @"DilemmaName not correct.");
}

- (void)testDilemmaModelReturnsNoDilemmasIfCampaignIsWrong {

    DilemmaModel *testingSubjectCreate = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure3];

    STAssertTrue(testingSubjectCreate.dilemmas.count == 0, @"DilemmaModel returned dilemma it shouldn't have.");
}

- (Dilemma *)createDilemmaWithName:(NSString *)dilemmaName withModelManager:(ModelManager *)modelManager{

    Dilemma *testDilemmaLocal1 = [modelManager create:Dilemma.class];

    testDilemmaLocal1.nameDilemma = dilemmaName;
    testDilemmaLocal1.rewardADilemma = rewardADilemma;
    testDilemmaLocal1.choiceB = choiceB;
    testDilemmaLocal1.moodDilemma = moodDilemma;
    testDilemmaLocal1.displayNameDilemma = displayNameDilemma;
    testDilemmaLocal1.surrounding = surrounding;
    testDilemmaLocal1.rewardBDilemma = rewardBDilemma;
    testDilemmaLocal1.choiceA = choiceA;
    testDilemmaLocal1.enthusiasmDilemma = enthusiasmDilemma;
    testDilemmaLocal1.dilemmaText = dilemmaText;
    [modelManager saveContext];

    return testDilemmaLocal1;
}

@end

