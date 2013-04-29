#import "ModelManager.h"
#import "TestModelHelper.h"
#import "DilemmaDAO.h"

@interface TestDilemmaDAO: SenTestCase {
    ModelManager *testModelManager;

    DilemmaDAO *testingSubject;
    
    Dilemma *testDilemma1;
    Dilemma *testDilemma2;
    
    NSString *nameDilemma1;
    NSString *nameDilemma2;
    
}

@end

@implementation TestDilemmaDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    nameDilemma1 = @"nameDilemma1";    
    nameDilemma2 = @"nameDilemma2";        
            
    testDilemma1 = [TestModelHelper createDilemmaWithName:nameDilemma1 withModelManager:testModelManager];
    testDilemma2 = [TestModelHelper createDilemmaWithName:nameDilemma2 withModelManager:testModelManager];

    
    testingSubject = [[DilemmaDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
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