#import "TestCoreDataStack.h"
#import "Dilemma.h"
#import "Character.h"
#import "Moral.h"

@interface TestDilemma: SenTestCase {
    TestCoreDataStack *coreData;
    Dilemma *testDilemma;
    Character *testCharacter;
    Moral *testMoral;
    
    NSString * rewardADilemma;
    NSString * choiceB;
    NSNumber * moodDilemma;
    NSString * displayNameDilemma;
    NSString * surrounding;
    NSString * nameDilemma;
    NSString * rewardBDilemma;
    NSString * choiceA;
    NSNumber * enthusiasmDilemma;
    NSString * dilemmaText;
    
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

@implementation TestDilemma

- (void)setUp {
    coreData = [[TestCoreDataStack alloc] initWithManagedObjectModel:@"SystemData"];
    
    rewardADilemma = @"dilemma";
    choiceB = @"choiceB";
    moodDilemma  = [NSNumber numberWithFloat:1.0];
    displayNameDilemma = @"displayName";
    surrounding = @"surrounding";
    nameDilemma = @"name";
    rewardBDilemma = @"reward";
    choiceA = @"choice";
    enthusiasmDilemma = [NSNumber numberWithFloat:1.0];
    dilemmaText = @"text";
    
    testDilemma = [coreData insert:Dilemma.class];
    testDilemma.rewardADilemma = rewardADilemma;
    testDilemma.choiceB = choiceB;
    testDilemma.moodDilemma = moodDilemma;
    testDilemma.displayNameDilemma = displayNameDilemma;
    testDilemma.surrounding = surrounding;
    testDilemma.nameDilemma = nameDilemma;
    testDilemma.rewardBDilemma = rewardBDilemma;
    testDilemma.choiceA = choiceA;
    testDilemma.enthusiasmDilemma = enthusiasmDilemma;
    testDilemma.dilemmaText = dilemmaText;
    
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

- (void)testDilemmaCanBeCreated {
    
    //testUserCollectable are created in setup    
    STAssertNoThrow([coreData save], @"Dilemma can't be created.");
    
}

- (void)testDilemmaAccessorsAreFunctional {
    
    STAssertNoThrow([coreData save], @"Dilemma can't be created for Accessor test.");
    
    NSArray *dilemmas = [coreData fetch:Dilemma.class];
    
    STAssertEquals(dilemmas.count, (NSUInteger) 1, @"There should only be 1 Dilemma in the context.");
    Dilemma *retrieved = [dilemmas objectAtIndex: 0];
        
    STAssertEquals(retrieved.enthusiasmDilemma, enthusiasmDilemma, @"enthusiasmDilemma Getter/Setter failed.");
    STAssertEquals(retrieved.moodDilemma, moodDilemma, @"moodDilemma Getter/Setter failed.");
    STAssertEquals(retrieved.rewardADilemma, rewardADilemma, @"rewardADilemma Getter/Setter failed.");    
    STAssertEqualObjects(retrieved.choiceB, choiceB, @"choiceB Getter/Setter failed.");
    STAssertEqualObjects(retrieved.displayNameDilemma, displayNameDilemma, @"displayNameDilemma Getter/Setter failed.");
    STAssertEqualObjects(retrieved.surrounding, surrounding, @"surrounding Getter/Setter failed.");
    STAssertEqualObjects(retrieved.nameDilemma, nameDilemma, @"nameDilemma Getter/Setter failed.");
    STAssertEqualObjects(retrieved.rewardBDilemma, rewardBDilemma, @"rewardBDilemma Getter/Setter failed.");
    STAssertEqualObjects(retrieved.choiceA, choiceA, @"choiceA Getter/Setter failed.");
    STAssertEqualObjects(retrieved.dilemmaText, dilemmaText, @"dilemmaText Getter/Setter failed.");    
}

- (void)testDilemmaReferentialIntegrity {
    
    STAssertNoThrow([coreData save], @"Dilemma/Character/Moral can't be created for RI test");

    testDilemma.antagonist = testCharacter;
    
    STAssertNoThrow([coreData save], @"Dilemma/Character/Moral relationships can't be created for RI test");
            
    NSArray *dilemmas = [coreData fetch:Dilemma.class];
    
    Dilemma *retrieved = [dilemmas objectAtIndex: 0];
    STAssertEqualObjects(retrieved.antagonist, testCharacter, @"antagonist Relationship failed.");
    
}

- (void)testDilemmaReferentialIntegrityUpdate {
    STAssertNoThrow([coreData save], @"Dilemma/Character/Moral can't be created for RI Update test");
    
    testDilemma.antagonist = testCharacter;
    
    STAssertNoThrow([coreData save], @"Dilemma/Character/Moral relationships can't be created for RI Update test");
        
    NSString *newCharacterName = @"New character name";
    testCharacter.nameCharacter = newCharacterName;
    
    STAssertNoThrow([coreData save], @"Character can't be updated for RI Update test");
    
    NSArray *dilemmas = [coreData fetch:Dilemma.class];
    Dilemma *retrieved = [dilemmas objectAtIndex: 0];
    STAssertEqualObjects(retrieved.antagonist.nameCharacter, newCharacterName, @"story RI update failed.");
    
}

- (void)testDilemmaDeletion {
    STAssertNoThrow([coreData save], @"Dilemma can't be created for Delete test");
    
    STAssertNoThrow([coreData delete:testDilemma], @"Dilemma can't be deleted");
    
    NSArray *dilemmas = [coreData fetch:Dilemma.class];
    
    STAssertEquals(dilemmas.count, (NSUInteger) 0, @"Dilemma is still present after delete");
    
}

- (void)testDilemmaReferentialIntegrityDelete {
    STAssertNoThrow([coreData save], @"Dilemma/Character/Moral can't be created for RI Delete test");
    
    testDilemma.antagonist = testCharacter;
    
    STAssertNoThrow([coreData save], @"Dilemma/Character/Moral relationships can't be created for RI Delete test");
    
    STAssertNoThrow([coreData delete:testDilemma], @"Dilemma can't be deleted");
    
    NSArray *characters = [coreData fetch:Character.class];
    
    STAssertEquals(characters.count, (NSUInteger) 1, @"Character should not have been cascade deleted");
    
}

- (void)testDilemmaWithoutRequiredAttributes {
    Dilemma *testDilemmaBad = [coreData insert:Dilemma.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testDilemmaBad.class];
    
    STAssertThrows([coreData save], errorMessage);
}

@end