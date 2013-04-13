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
#import "Moral.h"
#import "UserCollectable.h"
#import "OCMock/OCMock.h"

@interface TestDilemmaModel : SenTestCase {
    
    DilemmaModel *testingSubject;
    ModelManager *testModelManager;
    Dilemma *testDilemma1;
    Dilemma *testDilemma2;
    Dilemma *testDilemma3;
    Moral *testMoralA;
    Moral *testMoralB;
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

    NSString *moralTypeVirtue;
    NSString *nameMoral1;
    NSString *moralTypeVice;
    NSString *nameMoral2;
    NSString *moralTypeVirtueExtra;
    NSString *nameMoral3;
    NSString *moralTypeAll;
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

    moralTypeVirtue = @"Virtue";
    nameMoral1 = @"Virtue Name1";
    moralTypeVice = @"Vice";
    nameMoral2 = @"Vice Name2";
    moralTypeVirtueExtra = @"Virtue";
    nameMoral3 = @"Virtue Name3";
    moralTypeAll = @"all";

    testMoralA = [self createMoralWithName:nameMoral1 withType:moralTypeVirtue withModelManager:testModelManager];
    testMoralB = [self createMoralWithName:nameMoral2 withType:moralTypeVirtue withModelManager:testModelManager];

    testDilemma1.moralChoiceA = testMoralA;
    testDilemma1.moralChoiceB = testMoralB;

    testDilemma2.moralChoiceA = testMoralA;
    testDilemma2.moralChoiceB = testMoralA;

    testUserDilemma = [self createUserDilemmaWithName:entryKey];
    testingSubject = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure1];

}

- (void)testDilemmaModelCanBeCreated {

    DilemmaModel *testingSubjectCreate = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure1];

    STAssertNotNil(testingSubjectCreate, @"DilemmaModel can't be created.");
}

- (void)testDilemmaModelCanRetrieveCorrectDilemmaGivenRequestedCampaign {

    STAssertTrue(testingSubject.dilemmas.count == 1, @"DilemmaModel didn't return correct number of dilemmas.");

    STAssertEqualObjects(testingSubject.dilemmas[0], testDilemma1.nameDilemma, @"DilemmaName not correct.");
    STAssertEqualObjects(testingSubject.dilemmaDisplayNames[0], testDilemma1.displayNameDilemma, @"dilemmaDisplayName not correct.");
    STAssertEqualObjects(testingSubject.dilemmaImages[0], testDilemma1.surrounding, @"surrounding Image not correct.");
}

- (void)testRetrievedDilemmaHasCorrectDerivedDataForAChoiceType {

    NSString *vsText = [NSString stringWithFormat:@"%@ vs. %@", testDilemma1.moralChoiceA.displayNameMoral, testDilemma1.moralChoiceB.displayNameMoral];

    //test vs. dilemma
    STAssertEqualObjects(testingSubject.dilemmaDetails[0], vsText, @"DilemmaDetails not correctly displayed as the moral vs. moral.");
    STAssertTrue([testingSubject.dilemmaTypes[0] boolValue] == TRUE, @"dilemmaType not correct.");

    NSArray *moralKeys = [testingSubject.moralNames allKeys];
    NSArray *moralValues = [testingSubject.moralNames allValues];

    STAssertTrue([moralKeys containsObject:testDilemma1.moralChoiceA.nameMoral], @"Dilemma moralNames doesn't contain moralA name");
    STAssertTrue([moralValues containsObject:testDilemma1.moralChoiceA.displayNameMoral], @"Dilemma moralNames doesn't contain moralA name");
    STAssertTrue([moralKeys containsObject:testDilemma1.moralChoiceB.nameMoral], @"Dilemma moralNames doesn't contain moralB name");
    STAssertTrue([moralValues containsObject:testDilemma1.moralChoiceB.displayNameMoral], @"Dilemma moralNames doesn't contain moralB name");
}

- (void)testRetrievedDilemmaHasCorrectDerivedDataForAnActionType {
    DilemmaModel *testingSubjectCreate = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure2];

    //test action dilemma
    STAssertEqualObjects(testingSubjectCreate.dilemmaDetails[0], testDilemma2.moralChoiceA.displayNameMoral, @"DilemmaDetails not correctly displayed as the moral.");
    STAssertTrue([testingSubjectCreate.dilemmaTypes[0] boolValue] == FALSE, @"dilemmaType not correct.");

    NSArray *moralKeys = [testingSubjectCreate.moralNames allKeys];
    NSArray *moralValues = [testingSubjectCreate.moralNames allValues];

    STAssertTrue([moralKeys containsObject:testDilemma2.moralChoiceA.nameMoral], @"Dilemma moralNames doesn't contain moralA name");
    STAssertTrue([moralValues containsObject:testDilemma2.moralChoiceA.displayNameMoral], @"Dilemma moralNames doesn't contain moralA name");

    STAssertTrue(moralKeys.count == 1, @"Dilemma moralNames doesn't have a single entry (Morals aren't the same)");
    STAssertTrue(moralValues.count == 1, @"Dilemma moralDisplayNames doesn't have a single entry (Morals aren't the same)");

}

- (void)testDilemmaModelCanFilterDilemmaGivenRequestedCampaign {

    DilemmaModel *testingSubjectCreate = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure2];

    STAssertTrue(testingSubjectCreate.dilemmas.count == 1, @"DilemmaModel didn't return correct number of dilemmas.");

    STAssertEqualObjects(testingSubjectCreate.dilemmas[0], testDilemma2.nameDilemma, @"DilemmaName not correct.");
}

- (void)testDilemmaModelCanRetrieveCorrectlySortedDilemmasGivenRequestedCampaign {

    NSString *nameDilemmaOrderedSecond = @"dile-1-02";
    Dilemma *testDilemmaOrderedSecond = [self createDilemmaWithName:nameDilemmaOrderedSecond];

    DilemmaModel *testingSubjectCreate = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure1];

    STAssertTrue(testingSubjectCreate.dilemmas.count == 2, @"DilemmaModel didn't return correct number of dilemmas.");

    STAssertEqualObjects(testingSubjectCreate.dilemmas[0], testDilemma1.nameDilemma, @"DilemmaName not correct order.");
    STAssertEqualObjects(testingSubjectCreate.dilemmaDisplayNames[0], testDilemma1.displayNameDilemma, @"dilemmaDisplayName not correct order.");
    STAssertEqualObjects(testingSubjectCreate.dilemmaImages[0], testDilemma1.surrounding, @"surrounding Image not correct order.");

    STAssertEqualObjects(testingSubjectCreate.dilemmas[1], testDilemmaOrderedSecond.nameDilemma, @"DilemmaName not correct order.");
    STAssertEqualObjects(testingSubjectCreate.dilemmaDisplayNames[1], testDilemmaOrderedSecond.displayNameDilemma, @"dilemmaDisplayName not correct order.");
    STAssertEqualObjects(testingSubjectCreate.dilemmaImages[1], testDilemmaOrderedSecond.surrounding, @"surrounding Image not correct order.");

}

- (void)testDilemmaModelReturnsNoDilemmasIfCampaignIsWrong {

    DilemmaModel *testingSubjectCreate = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure3];

    STAssertTrue(testingSubjectCreate.dilemmas.count == 0, @"DilemmaModel returned dilemma it shouldn't have.");
}

- (void)testDilemmaModelReturnsASingleUserDilemmaIfCampaignIsWrong {


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

- (Moral *)createMoralWithName:(NSString *)moralName withType:(NSString *)type withModelManager:(ModelManager *)modelManager{

    NSString *imageName = [NSString stringWithFormat:@"%@imageName", moralName];

    Moral *testMoral1 = [modelManager create:Moral.class];

    testMoral1.shortDescriptionMoral = type;
    testMoral1.nameMoral = moralName;

    testMoral1.imageNameMoral = imageName;
    testMoral1.colorMoral = @"FF0000";
    testMoral1.displayNameMoral = @"displayName";
    testMoral1.longDescriptionMoral = @"longDescription";
    testMoral1.component = @"component";
    testMoral1.linkMoral = @"link";
    testMoral1.definitionMoral = @"definition";

    [modelManager saveContext];

    return testMoral1;
    
}

@end

