#import "ModelManager.h"
#import "UserCharacter.h"

@interface TestUserCharacter:XCTestCase {
    ModelManager *testModelManager;
    UserCharacter *testUserCharacter;
    
    NSString *characterAccessoryPrimary;
    NSString *characterAccessorySecondary;
    NSString *characterAccessoryTop;
    NSString *characterAccessoryBottom;
    NSString *characterFace;
    NSString *characterName;
    NSString *characterEye;
    NSString *characterMouth;
    NSNumber *characterEnthusiasm;
    NSNumber *characterAge;
    NSNumber *characterMood;
    NSString *characterEyeColor;
    NSString *characterBrowColor;
    NSString *characterBubbleColor;
    NSNumber *characterSize;
    NSNumber *characterBubbleType;    
}

@end

@implementation TestUserCharacter

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    
    characterAccessoryPrimary = @"accessoryPrimary";
    characterAccessorySecondary = @"accessorySecondary";
    characterAccessoryTop = @"accessoryTop";
    characterAccessoryBottom = @"accessoryBottom";
    characterFace = @"face";
    characterName = @"name";
    characterEye = @"eye";
    characterMouth = @"mouth";
    characterEnthusiasm = @1.0f;
    characterAge = @1.0f;
    characterMood = @1.0f;
    characterEyeColor = @"eyeColor";
    characterBrowColor = @"browColor";
    characterBubbleColor = @"bubbleColor";
    characterSize = @1.0f;
    characterBubbleType = @1.0f;
    
    testUserCharacter = [testModelManager create:UserCharacter.class];
    
    testUserCharacter.characterAccessoryPrimary = characterAccessoryPrimary;
    testUserCharacter.characterAccessorySecondary = characterAccessorySecondary;
    testUserCharacter.characterAccessoryTop = characterAccessoryTop;
    testUserCharacter.characterAccessoryBottom = characterAccessoryBottom;
    testUserCharacter.characterFace = characterFace;
    testUserCharacter.characterName = characterName;
    testUserCharacter.characterEye = characterEye;
    testUserCharacter.characterMouth = characterMouth;
    testUserCharacter.characterEnthusiasm = characterEnthusiasm;
    testUserCharacter.characterAge = characterAge;
    testUserCharacter.characterMood = characterMood;
    testUserCharacter.characterEyeColor = characterEyeColor;
    testUserCharacter.characterBrowColor = characterBrowColor;
    testUserCharacter.characterBubbleColor = characterBubbleColor;
    testUserCharacter.characterSize = characterSize;
    testUserCharacter.characterBubbleType = characterBubbleType;
    
}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testUserCharacterCanBeCreated {
    
    //testUserCollectable are created in setup    
    XCTAssertNoThrow([testModelManager saveContext], @"UserCharacter can't be created.");
    
}

- (void)testUserCharacterAccessorsAreFunctional {
    
    XCTAssertNoThrow([testModelManager saveContext], @"UserCharacter can't be created for Accessor test.");
    
    NSArray *characters = [testModelManager readAll:UserCharacter.class];
    
    XCTAssertEqual(characters.count, (NSUInteger) 1, @"There should only be 1 UserCollectable in the context.");
    UserCharacter *retrieved = characters[0];
    
    XCTAssertEqualObjects(retrieved.characterEnthusiasm, characterEnthusiasm, @"characterEnthusiasm Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.characterAge, characterAge, @"characterAge Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.characterMood, characterMood, @"characterMood Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.characterSize, characterSize, @"characterSize Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.characterBubbleType, characterBubbleType, @"characterBubbleType Getter/Setter failed.");    
    XCTAssertEqualObjects(retrieved.characterAccessoryPrimary, characterAccessoryPrimary, @"characterAccessoryPrimary Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.characterAccessorySecondary, characterAccessorySecondary, @"characterAccessorySecondary Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.characterAccessoryTop, characterAccessoryTop, @"characterAccessoryTop Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.characterAccessoryBottom, characterAccessoryBottom, @"characterAccessoryBottom Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.characterFace, characterFace, @"characterFace Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.characterName, characterName, @"characterName Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.characterEye, characterEye, @"characterEye Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.characterMouth, characterMouth, @"characterMouth Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.characterEyeColor, characterEyeColor, @"characterEyeColor Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.characterBrowColor, characterBrowColor, @"characterBrowColor Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.characterBubbleColor, characterBubbleColor, @"characterBubbleColor Getter/Setter failed.");
    
}

- (void)testUserCharacterDeletion {
    XCTAssertNoThrow([testModelManager saveContext], @"UserCharacter can't be created for Delete test");
    
    XCTAssertNoThrow([testModelManager deleteReadWrite:testUserCharacter], @"UserCharacter can't be deleted");
    
    NSArray *characters = [testModelManager readAll:UserCharacter.class];
    
    XCTAssertEqual(characters.count, (NSUInteger) 0, @"UserCharacter is still present after delete");
    
}

- (void)testUserCharacterWithoutRequiredAttributes {
    UserCharacter *testUserCharacterBad = [testModelManager create:UserCharacter.class];
    
    XCTAssertThrows([testModelManager saveContext]);
}

@end
