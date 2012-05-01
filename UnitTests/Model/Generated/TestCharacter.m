#import "TestCoreDataStack.h"
#import "Character.h"

@interface TestCharacter: SenTestCase {
    TestCoreDataStack *coreData;
    Character *testCharacter;
    
    NSString * characterAccessoryPrimary;
    NSString * characterAccessorySecondary;
    NSString * characterAccessoryTop;
    NSString * characterAccessoryBottom;
    NSString * characterFace;
    NSString * characterName;
    NSString * characterEye;
    NSString * characterMouth;
    NSNumber * characterEnthusiasm;
    NSNumber * characterAge;
    NSNumber * characterMood;
    NSString * characterEyeColor;
    NSString * characterBrowColor;
    NSString * characterBubbleColor;
    NSDecimalNumber * characterSize;
    NSNumber * characterBubbleType;    
}

@end

@implementation TestCharacter

- (void)setUp {
    coreData = [[TestCoreDataStack alloc] initWithManagedObjectModel:@"SystemData"];
    
    characterAccessoryPrimary = @"accessoryPrimary";
    characterAccessorySecondary = @"accessorySecondary";
    characterAccessoryTop = @"accessoryTop";
    characterAccessoryBottom = @"accessoryBottom";
    characterFace = @"face";
    characterName = @"name";
    characterEye = @"eye";
    characterMouth = @"mouth";
    characterAge = [NSNumber numberWithFloat:1.0];
    characterMood = [NSNumber numberWithFloat:1.0];
    characterEyeColor = @"eyeColor";
    characterBrowColor = @"browColor";
    characterBubbleColor = @"bubbleColor";
    characterSize = [NSDecimalNumber decimalNumberWithString:@"1.0"];
    characterBubbleType = [NSNumber numberWithFloat:1.0];
    
    testCharacter = [coreData insert:Character.class];
    
    testCharacter.accessoryPrimaryCharacter = characterAccessoryPrimary;
    testCharacter.accessorySecondaryCharacter = characterAccessorySecondary;
    testCharacter.accessoryTopCharacter = characterAccessoryTop;
    testCharacter.accessoryBottomCharacter = characterAccessoryBottom;
    testCharacter.faceCharacter = characterFace;
    testCharacter.nameCharacter = characterName;
    testCharacter.eyeCharacter = characterEye;
    testCharacter.mouthCharacter = characterMouth;
    testCharacter.ageCharacter = characterAge;
    testCharacter.eyeColor = characterEyeColor;
    testCharacter.browColor = characterBrowColor;
    testCharacter.bubbleColor = characterBubbleColor;
    testCharacter.sizeCharacter = characterSize;
    testCharacter.bubbleType = characterBubbleType;
    
}

- (void)testCharacterCanBeCreated {
    
    //testUserCollectable are created in setup    
    STAssertNoThrow([coreData save], @"Character can't be created.");
    
}

- (void)testCharacterAccessorsAreFunctional {
    
    STAssertNoThrow([coreData save], @"Character can't be created for Accessor test.");
    
    NSArray *characters = [coreData fetch:Character.class];
    
    STAssertEquals(characters.count, (NSUInteger) 1, @"There should only be 1 UserCollectable in the context.");
    Character *retrieved = [characters objectAtIndex: 0];
    
    STAssertEquals(retrieved.ageCharacter, characterAge, @"characterAge Getter/Setter failed.");
    STAssertEquals(retrieved.sizeCharacter, characterSize, @"characterSize Getter/Setter failed.");
    STAssertEquals(retrieved.bubbleType, characterBubbleType, @"characterBubbleType Getter/Setter failed.");    
    STAssertEqualObjects(retrieved.accessoryPrimaryCharacter, characterAccessoryPrimary, @"characterAccessoryPrimary Getter/Setter failed.");
    STAssertEqualObjects(retrieved.accessorySecondaryCharacter, characterAccessorySecondary, @"characterAccessorySecondary Getter/Setter failed.");
    STAssertEqualObjects(retrieved.accessoryTopCharacter, characterAccessoryTop, @"characterAccessoryTop Getter/Setter failed.");
    STAssertEqualObjects(retrieved.accessoryBottomCharacter, characterAccessoryBottom, @"characterAccessoryBottom Getter/Setter failed.");
    STAssertEqualObjects(retrieved.faceCharacter, characterFace, @"characterFace Getter/Setter failed.");
    STAssertEqualObjects(retrieved.nameCharacter, characterName, @"characterName Getter/Setter failed.");
    STAssertEqualObjects(retrieved.eyeCharacter, characterEye, @"characterEye Getter/Setter failed.");
    STAssertEqualObjects(retrieved.mouthCharacter, characterMouth, @"characterMouth Getter/Setter failed.");
    STAssertEqualObjects(retrieved.eyeColor, characterEyeColor, @"characterEyeColor Getter/Setter failed.");
    STAssertEqualObjects(retrieved.browColor, characterBrowColor, @"characterBrowColor Getter/Setter failed.");
    STAssertEqualObjects(retrieved.bubbleColor, characterBubbleColor, @"characterBubbleColor Getter/Setter failed.");
    
}

- (void)testCharacterDeletion {
    STAssertNoThrow([coreData save], @"Character can't be created for Delete test");
    
    STAssertNoThrow([coreData delete:testCharacter], @"Character can't be deleted");
    
    NSArray *characters = [coreData fetch:Character.class];
    
    STAssertEquals(characters.count, (NSUInteger) 0, @"Character is still present after delete");
    
}

- (void)testCharacterWithoutRequiredAttributes {
    Character *testCharacterBad = [coreData insert:Character.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testCharacterBad.class];
    
    STAssertThrows([coreData save], errorMessage);
}

@end