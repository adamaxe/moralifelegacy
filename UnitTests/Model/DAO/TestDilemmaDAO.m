#import "ModelManager.h"
#import "TestModelHelper.h"
#import "DilemmaDAO.h"

@interface TestDilemmaDAO: XCTestCase {
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
    XCTAssertNotNil(testingSubject, @"DilemmaDAO All type can't be created.");
}

- (void)testDilemmaDAORead {
        
    Dilemma *testDilemma = [testingSubject read:nameDilemma1];
    XCTAssertEqualObjects(testDilemma, testDilemma1, @"DilemmaDAO All not populated with dilemma 1.");    
}

- (void)testDilemmaDAOCreateFailsCorrectly {
    
    id testDilemma = [testingSubject createObject];
    XCTAssertNil(testDilemma, @"DilemmaDAO was able to create incorrectly.");    
}

- (void)testDilemmaDAOUpdateFailsCorrectly {
    
    BOOL isUpdateSuccessful = [testingSubject update];
    XCTAssertFalse(isUpdateSuccessful, @"DilemmaDAO was able to update incorrectly.");    
}

- (void)testDilemmaDAOReadAll {
            
    NSArray *allDilemmas = [testingSubject readAll];
    XCTAssertTrue([allDilemmas containsObject:testDilemma1], @"DilemmaDAO All not populated with Dilemma 1.");
    XCTAssertTrue([allDilemmas containsObject:testDilemma2], @"DilemmaDAO All not populated with Dilemma 2.");
}

- (void)testDilemmaDAODeleteFailsCorrectly {
        
    BOOL isDeleteSuccessful = [testingSubject delete:testDilemma2];
    XCTAssertFalse(isDeleteSuccessful, @"DilemmaDAO was able to delete incorrectly.");
    
    Dilemma *testDeletedDilemmaVerify = [testingSubject read:nameDilemma2];
    XCTAssertEqualObjects(testDilemma2, testDeletedDilemmaVerify, @"Dilemma was deleted incorrectly.");
    
}

@end