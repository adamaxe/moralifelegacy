#import "ModelManager.h"
#import "CharacterDAO.h"

@interface TestCharacterDAO: SenTestCase {
    ModelManager *testModelManager;

    CharacterDAO *testingSubject;
    
    Character *testCharacter1;
    Character *testCharacter2;
    
    NSString *nameCharacter1;
    NSString *nameCharacter2;
    
    NSString * characterFace;
    NSString * characterName;
    NSString * characterEye;
    NSString * characterMouth;
    NSNumber * characterEnthusiasm;
    NSNumber * characterMood;
    NSString * characterEyeColor;
    NSString * characterBrowColor;
    NSString * characterBubbleColor;
    NSDecimalNumber * characterSize;
    NSNumber * characterBubbleType;
    
}

@end

@implementation TestCharacterDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    nameCharacter1 = @"nameCharacter1";    
    nameCharacter2 = @"nameCharacter2";        
    
    characterFace = @"face";
    characterEye = @"eye";
    characterMouth = @"mouth";
    characterMood = @1.0f;
    characterEyeColor = @"eyeColor";
    characterBrowColor = @"browColor";
    characterBubbleColor = @"bubbleColor";
    characterSize = [NSDecimalNumber decimalNumberWithString:@"1.0"];
    characterBubbleType = @1.0f;
    
    testCharacter1 = [testModelManager create:Character.class];
    testCharacter2 = [testModelManager create:Character.class];

    testCharacter1.nameCharacter = nameCharacter1;    
    testCharacter1.faceCharacter = characterFace;
    testCharacter1.eyeCharacter = characterEye;
    testCharacter1.mouthCharacter = characterMouth;
    testCharacter1.eyeColor = characterEyeColor;
    testCharacter1.browColor = characterBrowColor;
    testCharacter1.bubbleColor = characterBubbleColor;
    testCharacter1.sizeCharacter = characterSize;
    testCharacter1.bubbleType = characterBubbleType;

    testCharacter2.nameCharacter = nameCharacter2;    
    testCharacter2.faceCharacter = characterFace;
    testCharacter2.eyeCharacter = characterEye;
    testCharacter2.mouthCharacter = characterMouth;
    testCharacter2.eyeColor = characterEyeColor;
    testCharacter2.browColor = characterBrowColor;
    testCharacter2.bubbleColor = characterBubbleColor;
    testCharacter2.sizeCharacter = characterSize;
    testCharacter2.bubbleType = characterBubbleType;

    [testModelManager saveContext];
    
    testingSubject = [[CharacterDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.
	[testModelManager release];
    [testingSubject release];

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