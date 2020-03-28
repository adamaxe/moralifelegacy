#import "ModelManager.h"
#import "TestModelHelper.h"
#import "Character.h"
#import "Dilemma.h"

@interface TestCharacter:XCTestCase {
    ModelManager *testModelManager;
    Character *testCharacter;
    Dilemma *testDilemma;

    NSString *characterName;
    
}

@end

@implementation TestCharacter

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    characterName = @"characterName";

    testCharacter = [TestModelHelper createCharacterWithName:characterName withModelManager:testModelManager];
        
    testDilemma = [TestModelHelper createDilemmaWithName:@"dilemmaName" withModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];

}

- (void)testCharacterCanBeCreated {
    
    //testUserCollectable are created in setup    
    XCTAssertNoThrow([testModelManager saveContext], @"Character can't be created.");
    
}

- (void)testCharacterAccessorsAreFunctional {
    
    XCTAssertNoThrow([testModelManager saveContext], @"Character can't be created for Accessor test.");
    
    NSArray *characters = [testModelManager readAll:Character.class];
    
    XCTAssertEqual(characters.count, (NSUInteger) 1, @"There should only be 1 UserCollectable in the context.");
    Character *retrieved = characters[0];
    
    XCTAssertEqualObjects(retrieved.nameCharacter, characterName, @"characterName Getter/Setter failed.");    
}

- (void)testCharacterReferentialIntegrity {
    
    XCTAssertNoThrow([testModelManager saveContext], @"Character/Dilemma can't be created for RI test");

    testDilemma.antagonist = testCharacter;
    
    XCTAssertNoThrow([testModelManager saveContext], @"Character/Dilemma relationships can't be created for RI test");
            
    NSArray *characters = [testModelManager readAll:Character.class];
    
    Character *retrieved = characters[0];
    XCTAssertEqualObjects([retrieved.story anyObject], testDilemma, @"story Relationship failed.");
    
}

- (void)testCharacterReferentialIntegrityUpdate {
    XCTAssertNoThrow([testModelManager saveContext], @"Character/Dilemma can't be created for RI Update test");
    
    testCharacter.story = [NSSet setWithObject:testDilemma];
    
    XCTAssertNoThrow([testModelManager saveContext], @"Character/Dilemma relationships can't be created for RI Update test");
        
    NSString *newDilemmadName = @"New dilemma name";
    testDilemma.nameDilemma = newDilemmadName;
    
    XCTAssertNoThrow([testModelManager saveContext], @"Dilemma can't be updated for RI Update test");
    
    NSArray *characters = [testModelManager readAll:Character.class];
    Character *retrieved = characters[0];
    XCTAssertEqualObjects([[retrieved.story anyObject] nameDilemma], newDilemmadName, @"story RI update failed.");
    
}


- (void)testCharacterDeletion {
    XCTAssertNoThrow([testModelManager saveContext], @"Character can't be created for Delete test");
    
    XCTAssertNoThrow([testModelManager delete:testCharacter], @"Character can't be deleted");
    
    NSArray *characters = [testModelManager readAll:Character.class];
    
    XCTAssertEqual(characters.count, (NSUInteger) 0, @"Character is still present after delete");
    
}

- (void)testCharacterReferentialIntegrityDelete {
    XCTAssertNoThrow([testModelManager saveContext], @"Character/Dilemma can't be created for RI Delete test");
    
    testCharacter.story = [NSSet setWithObject:testDilemma];
    
    XCTAssertNoThrow([testModelManager saveContext], @"Character/Dilemma relationships can't be created for RI Delete test");
    
    XCTAssertNoThrow([testModelManager delete:testCharacter], @"Character can't be deleted");
    
    NSArray *stories = [testModelManager readAll:Dilemma.class];
    
    XCTAssertEqual(stories.count, (NSUInteger) 1, @"Dilemma should not have been cascade deleted");
    
}

- (void)testCharacterWithoutRequiredAttributes {
    Character *testCharacterBad = [testModelManager create:Character.class];
    
    XCTAssertThrows([testModelManager saveContext]);
}

@end
