#import "ModelManager.h"
#import "TestModelHelper.h"
#import "CharacterDAO.h"

@interface TestCharacterDAO: SenTestCase {
    ModelManager *testModelManager;

    CharacterDAO *testingSubject;
    
    Character *testCharacter1;
    Character *testCharacter2;
    
    NSString *nameCharacter1;
    NSString *nameCharacter2;
        
}

@end

@implementation TestCharacterDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    nameCharacter1 = @"nameCharacter1";    
    nameCharacter2 = @"nameCharacter2";        

    testCharacter1 = [TestModelHelper createCharacterWithName:nameCharacter1 withModelManager:testModelManager];
    testCharacter2 = [TestModelHelper createCharacterWithName:nameCharacter2 withModelManager:testModelManager];

    [testModelManager saveContext];
    
    testingSubject = [[CharacterDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testCharacterDAOAllTypeCanBeCreated {
    STAssertNotNil(testingSubject, @"CharacterDAO All type can't be created.");
}

- (void)testCharacterDAORead {
        
    Character *testCharacter = [testingSubject read:nameCharacter1];
    STAssertEqualObjects(testCharacter, testCharacter1, @"CharacterDAO All not populated with Character 1.");    
}

- (void)testCharacterDAOCreateFailsCorrectly {
    
    id testCharacter = [testingSubject createObject];
    STAssertNil(testCharacter, @"CharacterDAO was able to create incorrectly.");    
}

- (void)testCharacterDAOUpdateFailsCorrectly {
    
    BOOL isUpdateSuccessful = [testingSubject update];
    STAssertFalse(isUpdateSuccessful, @"CharacterDAO was able to update incorrectly.");    
}

- (void)testCharacterDAOReadAll {
            
    NSArray *allCharacters = [testingSubject readAll];
    STAssertTrue([allCharacters containsObject:testCharacter1], @"CharacterDAO All not populated with Character 1.");
    STAssertTrue([allCharacters containsObject:testCharacter2], @"CharacterDAO All not populated with Character 2.");
}

//- (void)testCharacterDAODeleteFailsCorrectly {
//        
//    BOOL isDeleteSuccessful = [testingSubject delete:testCharacter2];
//    STAssertFalse(isDeleteSuccessful, @"CharacterDAO was able to delete incorrectly.");
//    
//    Character *testDeletedCharacterVerify = [testingSubject read:nameCharacter2];
//    STAssertEqualObjects(testCharacter2, testDeletedCharacterVerify, @"Character was deleted incorrectly.");
//    
//}

@end