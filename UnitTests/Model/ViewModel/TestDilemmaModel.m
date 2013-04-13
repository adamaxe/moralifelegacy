/**
 Unit Test for DilemmaModel.  Test model interaction with peristed data for DilemmaViewController and DilemmaListViewController
 
 @class TestDilemmaModel
 
 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 02/18/2013
 @file
 */

#import "DilemmaModel.h"
#import "UserDilemma.h"
#import "Dilemma.h"
#import "UserCollectable.h"
#import "OCMock/OCMock.h"

@interface TestDilemmaModel : SenTestCase {
    
    DilemmaModel *testingSubject;
    ModelManager *testModelManager;
    Dilemma *testDilemma1;
    Dilemma *testDilemma2;
    Dilemma *testDilemma3;
    UserDilemma *testUserDilemma;

    NSString *nameUserDilemma1;
    NSString *entryShortDescription;
    NSNumber *entryIsGood;
    NSString *entryKey;
    NSString *entryLongDescription;
    NSNumber *entrySeverity;
    NSDate *entryCreationDate;

    id userDefaultsMock;

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

    testDilemma1 = [self createDilemmaWithName:nameDilemma1];
    testDilemma2 = [self createDilemmaWithName:nameDilemma2];

    entryShortDescription = @"entryShortDescription";
    entryIsGood = @1;
    entryKey = @"dile-1-01user";
    entryLongDescription = @"entryLongDescription";
    entrySeverity =@5.0f;
    entryCreationDate = [NSDate date];

    testUserDilemma = [self createUserDilemmaWithName:entryKey];
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

- (void)testDilemmaModelReturnsASingleUserDilemmasIfCampaignIsWrong {


    DilemmaModel *testingSubjectCreate = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure3];

    NSArray *userDilemmaKeys = [testingSubjectCreate.userChoices allKeys];
    NSArray *userDilemmaValues = [testingSubjectCreate.userChoices allValues];
    STAssertTrue(userDilemmaKeys.count == 1, @"DilemmaModel didn't return correct number of userChoiceKeys.");
    STAssertEqualObjects(userDilemmaKeys[0], @"noUserEntries", @"DilemmaModel didn't return correct empty key designation.");
    STAssertTrue(userDilemmaValues.count == 1, @"DilemmaModel didn't return correct userChoiceValues.");
    STAssertEqualObjects(userDilemmaValues[0], @"", @"DilemmaModel didn't return correct empty value designation.");
    
}

- (void)testDilemmaModelReturnsCorrectUserDilemmaIfCampaignIsRight {

    NSArray *userDilemmaKeys = [testingSubject.userChoices allKeys];
    NSArray *userDilemmaValues = [testingSubject.userChoices allValues];
    STAssertTrue(userDilemmaKeys.count == 1, @"DilemmaModel didn't return correct number of userChoiceKeys.");
    STAssertEqualObjects(userDilemmaKeys[0], testUserDilemma.entryShortDescription, @"DilemmaModel didn't return correct userDilemma key.");
    STAssertTrue(userDilemmaValues.count == 1, @"DilemmaModel didn't return correct userChoiceValues.");
    STAssertEqualObjects(userDilemmaValues[0], testUserDilemma.entryLongDescription, @"DilemmaModel didn't return correct userDilemma key.");

}

- (void)testDilemmaModelReturnsAMultipleUserDilemmasAreSortedCorrectly {

    NSString *secondUserDilemma =  @"dile-1-02user";
    NSString *entryShortDescription2 = @"entryShortDescription2";

    UserDilemma *testUserDilemma2 = [self createUserDilemmaWithName:secondUserDilemma];
    testUserDilemma2.entryShortDescription = entryShortDescription2;
    [testModelManager saveContext];

    NSArray *userDilemmaKeys = [testingSubject.userChoices allKeys];
    NSArray *userDilemmaValues = [testingSubject.userChoices allValues];
    STAssertTrue(userDilemmaKeys.count == 2, @"DilemmaModel didn't return correct number of userChoiceKeys.");
    STAssertTrue(userDilemmaValues.count == 2, @"DilemmaModel didn't return correct userChoiceValues.");
    STAssertEqualObjects(userDilemmaKeys[0], testUserDilemma.entryShortDescription, @"DilemmaModel didn't return correct first userDilemma key.");
    STAssertEqualObjects(userDilemmaValues[0], testUserDilemma.entryLongDescription, @"DilemmaModel didn't return correct first userDilemma value.");
    STAssertEqualObjects(userDilemmaKeys[1], testUserDilemma2.entryShortDescription, @"DilemmaModel didn't return correct second userDilemma key.");
    STAssertEqualObjects(userDilemmaValues[1], testUserDilemma2.entryLongDescription, @"DilemmaModel didn't return correct second userDilemma value.");

}

- (void)testSelectDilemmaWritesToStandardUserDefaultsForViewing {

    [[userDefaultsMock expect] setObject:nameDilemma1 forKey:@"dilemmaKey"];
    [[userDefaultsMock expect] synchronize];

    [testingSubject selectDilemma:nameDilemma1];

    [userDefaultsMock verify];
}

- (Dilemma *)createDilemmaWithName:(NSString *)dilemmaName {
    Dilemma *testDilemmaLocal1 = [testModelManager create:Dilemma.class];

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
    [testModelManager saveContext];

    return testDilemmaLocal1;
}

- (UserDilemma *)createUserDilemmaWithName:(NSString *)userDilemmaName {

    UserDilemma *testUserDilemmaLocal1 = [testModelManager create:UserDilemma.class];

    testUserDilemmaLocal1.entryKey = userDilemmaName;
    testUserDilemmaLocal1.entryShortDescription = entryShortDescription;
    testUserDilemmaLocal1.entryIsGood = entryIsGood;
    testUserDilemmaLocal1.entryLongDescription = entryLongDescription;
    testUserDilemmaLocal1.entrySeverity = entrySeverity;
    testUserDilemmaLocal1.entryCreationDate = entryCreationDate;

    [testModelManager saveContext];
    
    return testUserDilemmaLocal1;
}

@end

