#import "ModelManager.h"
#import "UserDilemmaDAO.h"

@interface TestUserDilemmaDAO:XCTestCase {
    ModelManager *testModelManager;

    UserDilemmaDAO *testingSubject;
    
    UserDilemma *testUserDilemma1;
    UserDilemma *testUserDilemma2;
    
    NSString *keyDilemma1;
    NSString *keyDilemma2;
    
    NSString *entryShortDescription;
    NSNumber *entryIsGood;
    NSString *entryKey;
    NSString *entryLongDescription;
    NSNumber *entrySeverity;
    NSDate *entryCreationDate;
    
}

@end

@implementation TestUserDilemmaDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    keyDilemma1 = @"nameDilemma1";    
    keyDilemma2 = @"nameDilemma2";        
    
    entryShortDescription = @"entryShortDescription";
    entryIsGood = @1;
    entryLongDescription = @"entryLongDescription";
    entrySeverity =@5.0f;
    entryCreationDate = [NSDate date];
        
    testUserDilemma1 = [testModelManager create:UserDilemma.class];
    testUserDilemma2 = [testModelManager create:UserDilemma.class];
    
    testUserDilemma1.entryShortDescription = entryShortDescription;
    testUserDilemma1.entryIsGood = entryIsGood;
    testUserDilemma1.entryKey = keyDilemma1;
    testUserDilemma1.entryLongDescription = entryLongDescription;
    testUserDilemma1.entrySeverity = entrySeverity;
    testUserDilemma1.entryCreationDate = entryCreationDate;

    testUserDilemma2.entryShortDescription = entryShortDescription;
    testUserDilemma2.entryIsGood = entryIsGood;
    testUserDilemma2.entryKey = keyDilemma2;
    testUserDilemma2.entryLongDescription = entryLongDescription;
    testUserDilemma2.entrySeverity = entrySeverity;
    testUserDilemma2.entryCreationDate = entryCreationDate;
    
    [testModelManager saveContext];
    
    testingSubject = [[UserDilemmaDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testUserDilemmaDAOAllTypeCanBeCreated {
    XCTAssertNotNil(testingSubject, @"UserDilemmaDAO All type can't be created.");
}

- (void)testUserDilemmaDAORead {
        
    UserDilemma *testDilemma = [testingSubject read:keyDilemma1];
    XCTAssertEqualObjects(testDilemma, testUserDilemma1, @"UserDilemmaDAO All not populated with Dilemma 1.");    
}

- (void)testUserDilemmaDAOCanBeCreated {
    
    UserDilemma *testUserDilemma = [testingSubject create];
        
    XCTAssertNotNil(testUserDilemma, @"UserDilemmaDAO wasn't able to create.");
    
    NSString *keyDilemma3 = @"keyDilemma3";
    
    testUserDilemma.entryShortDescription = entryShortDescription;
    testUserDilemma.entryIsGood = entryIsGood;
    testUserDilemma.entryKey = keyDilemma3;
    testUserDilemma.entryLongDescription = entryLongDescription;
    testUserDilemma.entrySeverity = entrySeverity;
    testUserDilemma.entryCreationDate = entryCreationDate;
        
    UserDilemma *testDilemmaVerify = [testingSubject read:keyDilemma3];
    XCTAssertEqualObjects(testUserDilemma, testDilemmaVerify, @"UserDilemmaDAO not populated with Dilemma 1.");
}

- (void)testUserDilemmaDAOCanBeUpdated {
    
    NSString *newShortDescription = @"newShortDescription";
    testUserDilemma2.entryShortDescription = newShortDescription;
        
    UserDilemma *testDilemmaVerify = [testingSubject read:keyDilemma2];
    XCTAssertEqualObjects(testUserDilemma2.entryShortDescription, testDilemmaVerify.entryShortDescription, @"UserDilemmaDAO All not populated with Dilemma 2.");    
    
}

- (void)testUserDilemmaDAOReadAll {
            
    NSArray *allDilemmas = [testingSubject readAll];
    XCTAssertTrue([allDilemmas containsObject:testUserDilemma1], @"UserDilemmaDAO All not populated with Dilemma 1.");
    XCTAssertTrue([allDilemmas containsObject:testUserDilemma2], @"UserDilemmaDAO All not populated with Dilemma 2.");
}

//- (void)testUserDilemmaDAOCanBeDeleted {
//        
//    BOOL isDeleteSuccessful = [testingSubject delete:testUserDilemma2];
//    XCTAssertTrue(isDeleteSuccessful, @"UserDilemmaDAO wasn't able to delete.");
//    
//    UserDilemma *testDeletedDilemmaVerify = [testingSubject read:keyDilemma2];
//    XCTAssertNil(testDeletedDilemmaVerify, @"UserDilemma was deleted incorrectly.");
//    
//}

@end
