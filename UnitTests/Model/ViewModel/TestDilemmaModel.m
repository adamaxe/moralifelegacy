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
    id userDefaultsMock;
    NSArray *userCollection;

}

@end

@implementation TestDilemmaModel

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    userDefaultsMock = [OCMockObject niceMockForClass:NSUserDefaults.class];

    testDilemma1 = [self createDilemmaWithName:@"dile-1-01" withModelManager:testModelManager];

    [testModelManager saveContext];

    testingSubject = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure1];

}

- (void)testDilemmaModelCanBeCreated {

    DilemmaModel *testingSubjectCreate = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentCampaign:MLRequestedMorathologyAdventure1];

    STAssertNotNil(testingSubjectCreate, @"DilemmaModel can't be created.");
}

- (Dilemma *)createDilemmaWithName:(NSString *)dilemmaName withModelManager:(ModelManager *)modelManager{

    Dilemma *testDilemmaLocal1 = [modelManager create:Dilemma.class];

    testDilemmaLocal1.nameDilemma = dilemmaName;
    testDilemmaLocal1.rewardADilemma = @"dilemma reward";
    testDilemmaLocal1.choiceB = @"choiceB";
    testDilemmaLocal1.moodDilemma = @1.0f;
    testDilemmaLocal1.displayNameDilemma = @"displayNameDilemma";
    testDilemmaLocal1.surrounding = @"surrounding";
    testDilemmaLocal1.rewardBDilemma = @"rewardBDilemma";
    testDilemmaLocal1.choiceA = @"choiceA";
    testDilemmaLocal1.enthusiasmDilemma = @1.0f;
    testDilemmaLocal1.dilemmaText = @"dilemmaText";
    [modelManager saveContext];

    return testDilemmaLocal1;
}

@end

