#import "ModelManager.h"
#import "DilemmaDAO.h"

@interface TestDilemmaDAO: SenTestCase {
    ModelManager *testModelManager;

    DilemmaDAO *testingSubject;
    
    Dilemma *testDilemma1;
    Dilemma *testDilemma2;
    
    NSString *nameDilemma1;
    NSString *nameDilemma2;
    
    NSString *choiceB;
    NSNumber *moodDilemma;
    NSString *displayNameDilemma;
    NSString *choiceA;
    NSNumber *enthusiasmDilemma;
    NSString *dilemmaText;
    
}

@end

@implementation TestDilemmaDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    nameDilemma1 = @"nameDilemma1";    
    nameDilemma2 = @"nameDilemma2";        
    
    choiceB = @"choiceB";
    moodDilemma  = @1.0f;
    displayNameDilemma = @"displayNameDilemma";
    choiceA = @"choiceA";
    enthusiasmDilemma = @1.0f;
    dilemmaText = @"dilemmaText";
        
    testDilemma1 = [testModelManager create:Dilemma.class];
    testDilemma2 = [testModelManager create:Dilemma.class];

    testDilemma1.nameDilemma = nameDilemma1;    
    testDilemma1.choiceB = choiceB;
    testDilemma1.moodDilemma = moodDilemma;
    testDilemma1.displayNameDilemma = displayNameDilemma;
    testDilemma1.choiceA = choiceA;
    testDilemma1.enthusiasmDilemma = enthusiasmDilemma;
    testDilemma1.dilemmaText = dilemmaText;

    testDilemma2.nameDilemma = nameDilemma2;
    testDilemma2.choiceB = choiceB;
    testDilemma2.moodDilemma = moodDilemma;
    testDilemma2.displayNameDilemma = displayNameDilemma;
    testDilemma2.choiceA = choiceA;
    testDilemma2.enthusiasmDilemma = enthusiasmDilemma;
    testDilemma2.dilemmaText = dilemmaText;

    [testModelManager saveContext];
    
    testingSubject = [[DilemmaDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)testDilemmaDAOAllTypeCanBeCreated {
    STAssertNotNil(testingSubject, @"DilemmaDAO All type can't be created.");
}

- (void)testDilemmaDAORead {
        
    Dilemma *testDilemma = [testingSubject read:nameDilemma1];
    STAssertEqualObjects(testDilemma, testDilemma1, @"DilemmaDAO All not populated with dilemma 1.");    
}

- (void)testDilemmaDAOCreateFailsCorrectly {
    
    id testDilemma = [testingSubject createObject];
    STAssertNil(testDilemma, @"DilemmaDAO was able to create incorrectly.");    
}

- (void)testDilemmaDAOUpdateFailsCorrectly {
    
    BOOL isUpdateSuccessful = [testingSubject update];
    STAssertFalse(isUpdateSuccessful, @"DilemmaDAO was able to update incorrectly.");    
}

- (void)testDilemmaDAOReadAll {
            
    NSArray *allDilemmas = [testingSubject readAll];
    STAssertTrue([allDilemmas containsObject:testDilemma1], @"DilemmaDAO All not populated with Dilemma 1.");
    STAssertTrue([allDilemmas containsObject:testDilemma2], @"DilemmaDAO All not populated with Dilemma 2.");
}

- (void)testDilemmaDAODeleteFailsCorrectly {
        
    BOOL isDeleteSuccessful = [testingSubject delete:testDilemma2];
    STAssertFalse(isDeleteSuccessful, @"DilemmaDAO was able to delete incorrectly.");
    
    Dilemma *testDeletedDilemmaVerify = [testingSubject read:nameDilemma2];
    STAssertEqualObjects(testDilemma2, testDeletedDilemmaVerify, @"Dilemma was deleted incorrectly.");
    
}

@end