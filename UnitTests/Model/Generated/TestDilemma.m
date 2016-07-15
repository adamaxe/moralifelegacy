#import "ModelManager.h"
#import "TestModelHelper.h"
#import "Dilemma.h"
#import "Character.h"
#import "Moral.h"

@interface TestDilemma: XCTestCase {
    ModelManager *testModelManager;
    Dilemma *testDilemma;
    Character *testCharacter;
    Moral *testMoral;
    Moral *testMoral2;
    
    NSString *rewardADilemma;
    NSString *choiceB;
    NSNumber *moodDilemma;
    NSString *displayNameDilemma;
    NSString *surrounding;
    NSString *nameDilemma;
    NSString *rewardBDilemma;
    NSString *choiceA;
    NSNumber *enthusiasmDilemma;
    NSString *dilemmaText;

}

@end

@implementation TestDilemma

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    
    rewardADilemma = @"dilemma reward";
    choiceB = @"choiceB";
    moodDilemma  = @1.0f;
    displayNameDilemma = @"displayNameDilemma";
    surrounding = @"surrounding";
    nameDilemma = @"nameDilemma";
    rewardBDilemma = @"rewardBDilemma";
    choiceA = @"choiceA";
    enthusiasmDilemma = @1.0f;
    dilemmaText = @"dilemmaText";
    
    testDilemma = [testModelManager create:Dilemma.class];
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

    testCharacter = [TestModelHelper createCharacterWithName:@"characterName" withModelManager:testModelManager];
            
    testMoral = [TestModelHelper createMoralWithName:@"nameMoral1" withType:@"virtue" withModelManager:testModelManager];
    testMoral2 = [TestModelHelper createMoralWithName:@"nameMoral2" withType:@"vice" withModelManager:testModelManager];
}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testDilemmaCanBeCreated {
    
    //testUserCollectable are created in setup    
    XCTAssertNoThrow([testModelManager saveContext], @"Dilemma can't be created.");
    
}

- (void)testDilemmaAccessorsAreFunctional {
    
    XCTAssertNoThrow([testModelManager saveContext], @"Dilemma can't be created for Accessor test.");
    
    NSArray *dilemmas = [testModelManager readAll:Dilemma.class];
    
    XCTAssertEqual(dilemmas.count, (NSUInteger) 1, @"There should only be 1 Dilemma in the context.");
    Dilemma *retrieved = dilemmas[0];
        
    XCTAssertEqualObjects(retrieved.enthusiasmDilemma, enthusiasmDilemma, @"enthusiasmDilemma Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.moodDilemma, moodDilemma, @"moodDilemma Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.rewardADilemma, rewardADilemma, @"rewardADilemma Getter/Setter failed.");    
    XCTAssertEqualObjects(retrieved.choiceB, choiceB, @"choiceB Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.displayNameDilemma, displayNameDilemma, @"displayNameDilemma Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.surrounding, surrounding, @"surrounding Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.nameDilemma, nameDilemma, @"nameDilemma Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.rewardBDilemma, rewardBDilemma, @"rewardBDilemma Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.choiceA, choiceA, @"choiceA Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.dilemmaText, dilemmaText, @"dilemmaText Getter/Setter failed.");    
}

- (void)testDilemmaReferentialIntegrity {
    
    XCTAssertNoThrow([testModelManager saveContext], @"Dilemma/Character/Moral can't be created for RI test");

    testDilemma.antagonist = testCharacter;
    testDilemma.moralChoiceA = testMoral;
    testDilemma.moralChoiceB = testMoral2;

    
    XCTAssertNoThrow([testModelManager saveContext], @"Dilemma/Character/Moral relationships can't be created for RI test");
            
    NSArray *dilemmas = [testModelManager readAll:Dilemma.class];
    
    Dilemma *retrieved = dilemmas[0];
    XCTAssertEqualObjects(retrieved.antagonist, testCharacter, @"antagonist Relationship failed.");
    XCTAssertEqualObjects(retrieved.moralChoiceA, testMoral, @"moralChoiceA Relationship failed.");
    XCTAssertEqualObjects(retrieved.moralChoiceB, testMoral2, @"moralChoiceB Relationship failed.");
    
}

- (void)testDilemmaReferentialIntegrityUpdate {
    XCTAssertNoThrow([testModelManager saveContext], @"Dilemma/Character/Moral can't be created for RI Update test");
    
    testDilemma.antagonist = testCharacter;
    testDilemma.moralChoiceA = testMoral;
    testDilemma.moralChoiceB = testMoral2;

    
    XCTAssertNoThrow([testModelManager saveContext], @"Dilemma/Character/Moral relationships can't be created for RI Update test");
        
    NSString *newCharacterName = @"New character name";
    testCharacter.nameCharacter = newCharacterName;
    
    NSString *newMoralName = @"New moral name";
    testMoral.nameMoral = newMoralName;

    NSString *newMoralName2 = @"New moral name 2";
    testMoral2.nameMoral = newMoralName2;

    
    XCTAssertNoThrow([testModelManager saveContext], @"Character can't be updated for RI Update test");
    
    NSArray *dilemmas = [testModelManager readAll:Dilemma.class];
    Dilemma *retrieved = dilemmas[0];
    XCTAssertEqualObjects(retrieved.antagonist.nameCharacter, newCharacterName, @"story RI update failed.");
    XCTAssertEqualObjects(retrieved.moralChoiceA.nameMoral, newMoralName, @"moralChoiceA RI update failed.");    
    XCTAssertEqualObjects(retrieved.moralChoiceB.nameMoral, newMoralName2, @"moralChoiceB RI update failed.");    
    
}

- (void)testDilemmaDeletion {
    XCTAssertNoThrow([testModelManager saveContext], @"Dilemma can't be created for Delete test");
    
    XCTAssertNoThrow([testModelManager delete:testDilemma], @"Dilemma can't be deleted");
    
    NSArray *dilemmas = [testModelManager readAll:Dilemma.class];
    
    XCTAssertEqual(dilemmas.count, (NSUInteger) 0, @"Dilemma is still present after delete");
    
}

- (void)testDilemmaReferentialIntegrityDelete {
    XCTAssertNoThrow([testModelManager saveContext], @"Dilemma/Character/Moral can't be created for RI Delete test");
    
    testDilemma.antagonist = testCharacter;
    testDilemma.moralChoiceA = testMoral;  
    testDilemma.moralChoiceB = testMoral2;    
    
    XCTAssertNoThrow([testModelManager saveContext], @"Dilemma/Character/Moral relationships can't be created for RI Delete test");
    
    XCTAssertNoThrow([testModelManager delete:testDilemma], @"Dilemma can't be deleted");
    
    NSArray *characters = [testModelManager readAll:Character.class];
    NSArray *morals = [testModelManager readAll:Moral.class];

    XCTAssertEqual(characters.count, (NSUInteger) 1, @"Character should not have been cascade deleted");
    
    XCTAssertEqual(morals.count, (NSUInteger) 2, @"Neither Moral should not have been cascade deleted");    
    
}

- (void)testDilemmaWithoutRequiredAttributes {
    Dilemma *testDilemmaBad = [testModelManager create:Dilemma.class];
    
    XCTAssertThrows([testModelManager saveContext]);
    XCTAssertNotNil(testDilemmaBad);
}

@end
