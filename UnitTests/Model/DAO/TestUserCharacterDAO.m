#import "ModelManager.h"
#import "UserCharacterDAO.h"

@interface TestUserCharacterDAO: SenTestCase {
    ModelManager *testModelManager;

    UserCharacterDAO *testingSubject;
    
    UserCharacter *testCharacter1;
    UserCharacter *testCharacter2;
    
    NSString *nameCharacter1;
    NSString *nameCharacter2;
    
    NSString *characterFace;
    NSString *characterEye;
    NSString *characterMouth;
    NSNumber *characterEnthusiasm;
    NSNumber *characterMood;
    NSString *characterEyeColor;
    NSString *characterBrowColor;
    NSString *characterBubbleColor;
    NSDecimalNumber *characterSize;
    NSNumber *characterBubbleType;
    
}

@end

@implementation TestUserCharacterDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    nameCharacter1 = @"nameCharacter1";    
    nameCharacter2 = @"nameCharacter2";        
    
    characterFace = @"face";
    characterEye = @"eye";
    characterMouth = @"mouth";
    characterMood = [NSNumber numberWithFloat:1.0];
    characterEyeColor = @"eyeColor";
    characterBrowColor = @"browColor";
    characterBubbleColor = @"bubbleColor";
    characterSize = [NSDecimalNumber decimalNumberWithString:@"1.0"];
    characterBubbleType = [NSNumber numberWithFloat:1.0];
    characterEnthusiasm = [NSNumber numberWithFloat:2.0];    
    
    testCharacter1 = [testModelManager create:UserCharacter.class];
    testCharacter2 = [testModelManager create:UserCharacter.class];

    testCharacter1.characterName = nameCharacter1;
    testCharacter1.characterFace = characterFace;
    testCharacter1.characterEye = characterEye;
    testCharacter1.characterMouth = characterMouth;
    testCharacter1.characterEnthusiasm = characterEnthusiasm;
    testCharacter1.characterMood = characterMood;
    testCharacter1.characterEyeColor = characterEyeColor;
    testCharacter1.characterBrowColor = characterBrowColor;
    testCharacter1.characterBubbleColor = characterBubbleColor;
    testCharacter1.characterSize = characterSize;
    testCharacter1.characterBubbleType = characterBubbleType;    

    testCharacter2.characterName = nameCharacter2;
    testCharacter2.characterFace = characterFace;
    testCharacter2.characterEye = characterEye;
    testCharacter2.characterMouth = characterMouth;
    testCharacter2.characterEnthusiasm = characterEnthusiasm;
    testCharacter2.characterMood = characterMood;
    testCharacter2.characterEyeColor = characterEyeColor;
    testCharacter2.characterBrowColor = characterBrowColor;
    testCharacter2.characterBubbleColor = characterBubbleColor;
    testCharacter2.characterSize = characterSize;
    testCharacter2.characterBubbleType = characterBubbleType;    

    [testModelManager saveContext];
    
    testingSubject = [[UserCharacterDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)testUserCharacterDAOAllTypeCanBeCreated {
    STAssertNotNil(testingSubject, @"UserCharacterDAO All type can't be created.");
}

- (void)testUserCharacterDAORead {
        
    UserCharacter *testCharacter = [testingSubject read:nameCharacter1];
    STAssertEqualObjects(testCharacter, testCharacter1, @"UserCharacterDAO All not populated with Character 1.");    
}

- (void)testUserCharacterDAOCanBeCreated {
    
    UserCharacter *testCharacter = [testingSubject create];
        
    STAssertNotNil(testCharacter, @"UserCharacterDAO wasn't able to create.");
    
    NSString *nameCharacter3 = @"nameCharacter3";
    testCharacter.characterName = nameCharacter3;
    testCharacter.characterFace = characterFace;
    testCharacter.characterEye = characterEye;
    testCharacter.characterMouth = characterMouth;
    testCharacter.characterEnthusiasm = characterEnthusiasm;
    testCharacter.characterMood = characterMood;
    testCharacter.characterEyeColor = characterEyeColor;
    testCharacter.characterBrowColor = characterBrowColor;
    testCharacter.characterBubbleColor = characterBubbleColor;
    testCharacter.characterSize = characterSize;
    testCharacter.characterBubbleType = characterBubbleType;
        
    UserCharacter *testCharacterVerify = [testingSubject read:nameCharacter3];
    STAssertEqualObjects(testCharacter, testCharacterVerify, @"UserCharacterDAO not populated with Character 1.");
}

- (void)testUserCharacterDAOCanBeUpdated {
    
    NSString *newCharacterFace = @"newCharacterFace";
    testCharacter2.characterFace = newCharacterFace;
        
    UserCharacter *testCharacterVerify = [testingSubject read:nameCharacter2];
    STAssertEqualObjects(testCharacter2.characterFace, testCharacterVerify.characterFace, @"UserCharacterDAO All not populated with Character 2.");    
    
}

- (void)testUserCharacterDAOReadAll {
            
    NSArray *allCharacters = [testingSubject readAll];
    STAssertTrue([allCharacters containsObject:testCharacter1], @"UserCharacterDAO All not populated with Character 1.");
    STAssertTrue([allCharacters containsObject:testCharacter2], @"UserCharacterDAO All not populated with Character 2.");
}

//- (void)testUserCharacterDAOCanBeDeleted {
//        
//    BOOL isDeleteSuccessful = [testingSubject delete:testCharacter2];
//    STAssertTrue(isDeleteSuccessful, @"UserCharacterDAO wasn't able to delete.");
//    
//    UserCharacter *testDeletedCharacterVerify = [testingSubject read:nameCharacter2];
//    STAssertNil(testDeletedCharacterVerify, @"UserCharacter was deleted incorrectly.");
//    
//}

@end