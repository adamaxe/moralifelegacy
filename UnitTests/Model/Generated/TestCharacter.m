#import "TestCoreDataStack.h"
#import "Character.h"
#import "Dilemma.h"

@interface TestCharacter: SenTestCase {
    TestCoreDataStack *coreData;
    Character *testCharacter;
    Dilemma *testDilemma;
    
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
    
    testDilemma = [coreData insert:Dilemma.class];
    testDilemma.rewardADilemma = @"dilemma";
    testDilemma.choiceB = @"choiceB";
    testDilemma.moodDilemma  = [NSNumber numberWithFloat:1.0];
    testDilemma.displayNameDilemma = @"displayName";
    testDilemma.surrounding = @"surrounding";
    testDilemma.nameDilemma = @"name";
    testDilemma.rewardBDilemma = @"reward";
    testDilemma.choiceA = @"choice";
    testDilemma.enthusiasmDilemma = [NSNumber numberWithFloat:1.0];
    testDilemma.dilemmaText = @"text";
    
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
    
    STAssertEqualObjects(retrieved.ageCharacter, characterAge, @"characterAge Getter/Setter failed.");
    STAssertEqualObjects(retrieved.sizeCharacter, characterSize, @"characterSize Getter/Setter failed.");
    STAssertEqualObjects(retrieved.bubbleType, characterBubbleType, @"characterBubbleType Getter/Setter failed.");    
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

- (void)testCharacterReferentialIntegrity {
    
    STAssertNoThrow([coreData save], @"Character/Dilemma can't be created for RI test");

    testDilemma.antagonist = testCharacter;
    
    STAssertNoThrow([coreData save], @"Character/Dilemma relationships can't be created for RI test");
            
    NSArray *characters = [coreData fetch:Character.class];
    
    Character *retrieved = [characters objectAtIndex: 0];
    STAssertEqualObjects([retrieved.story anyObject], testDilemma, @"story Relationship failed.");
    
}

- (void)testCharacterReferentialIntegrityUpdate {
    STAssertNoThrow([coreData save], @"Character/Dilemma can't be created for RI Update test");
    
    testCharacter.story = [NSSet setWithObject:testDilemma];
    
    STAssertNoThrow([coreData save], @"Character/Dilemma relationships can't be created for RI Update test");
        
    NSString *newDilemmadName = @"New dilemma name";
    testDilemma.nameDilemma = newDilemmadName;
    
    STAssertNoThrow([coreData save], @"Dilemma can't be updated for RI Update test");
    
    NSArray *characters = [coreData fetch:Character.class];
    Character *retrieved = [characters objectAtIndex: 0];
    STAssertEqualObjects([[retrieved.story anyObject] nameDilemma], newDilemmadName, @"story RI update failed.");
    
}


- (void)testCharacterDeletion {
    STAssertNoThrow([coreData save], @"Character can't be created for Delete test");
    
    STAssertNoThrow([coreData delete:testCharacter], @"Character can't be deleted");
    
    NSArray *characters = [coreData fetch:Character.class];
    
    STAssertEquals(characters.count, (NSUInteger) 0, @"Character is still present after delete");
    
}

- (void)testCharacterReferentialIntegrityDelete {
    STAssertNoThrow([coreData save], @"Character/Dilemma can't be created for RI Delete test");
    
    testCharacter.story = [NSSet setWithObject:testDilemma];
    
    STAssertNoThrow([coreData save], @"Character/Dilemma relationships can't be created for RI Delete test");
    
    STAssertNoThrow([coreData delete:testCharacter], @"Character can't be deleted");
    
    NSArray *stories = [coreData fetch:Dilemma.class];
    
    STAssertEquals(stories.count, (NSUInteger) 1, @"Dilemma should not have been cascade deleted");
    
}

- (void)testCharacterWithoutRequiredAttributes {
    Character *testCharacterBad = [coreData insert:Character.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testCharacterBad.class];
    
    STAssertThrows([coreData save], errorMessage);
}

@end