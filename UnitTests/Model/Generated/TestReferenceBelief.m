#import "ModelManager.h"
#import "TestModelHelper.h"
#import "ReferenceBelief.h"
#import "ReferencePerson.h"
#import "ReferenceText.h"

@interface TestReferenceBelief :XCTestCase {
    ModelManager *testModelManager;
    ReferenceBelief *testBelief;
    ReferenceText *testText;
    ReferencePerson *testPerson;

    NSString *typeBelief;
    NSString *shortDescriptionReference;
    NSNumber *originYear;
    NSString *nameReference;
    NSString *longDescriptionReference;
    NSString *linkReference;    
    NSString *displayNameReference;
    NSString *imageNameReference;

}

@end

@implementation TestReferenceBelief

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    
    typeBelief = @"typeBelief";
    shortDescriptionReference = @"short description";
    originYear = @2010;
    nameReference = @"name";
    longDescriptionReference = @"long description";
    linkReference = @"http://www.teamaxe.org";    
    displayNameReference = @"display name";
    imageNameReference = @"image name";
    
    testBelief = [TestModelHelper createBeliefWithName:@"nameBelief" withModelManager:testModelManager];
    testBelief.typeBelief = typeBelief;
    testBelief.shortDescriptionReference = shortDescriptionReference;
    testBelief.originYear = originYear;
    testBelief.nameReference = nameReference;
    testBelief.longDescriptionReference = longDescriptionReference;
    testBelief.linkReference = linkReference;
    testBelief.displayNameReference = displayNameReference;
    testBelief.imageNameReference = imageNameReference;

    testPerson = [TestModelHelper createPersonWithName:@"namePerson" withModelManager:testModelManager];
    testText = [TestModelHelper createTextWithName:@"nameText" withModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testBeliefCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceBelief can't be created");
        
}

- (void)testBeliefAccessorsAreFunctional {
    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceBelief can't be created for Accessor test");
    
    NSArray *beliefs = [testModelManager readAll:ReferenceBelief.class];
    
    XCTAssertEqual(beliefs.count, (NSUInteger) 1, @"There should only be 1 RefenceText in the context.");
    ReferenceBelief *retrieved = beliefs[0];
    XCTAssertEqualObjects(retrieved.typeBelief, typeBelief, @"typeBelief Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.shortDescriptionReference, shortDescriptionReference, @"shortDescription Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.originYear, originYear, @"originYear Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.nameReference, nameReference, @"nameReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.longDescriptionReference, longDescriptionReference, @"longDescriptionReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.linkReference, linkReference, @"linkReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.displayNameReference, displayNameReference, @"displayNameReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.imageNameReference, imageNameReference, @"imageNameReference Getter/Setter failed.");
    
}

- (void)testBeliefReferentialIntegrity {
    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceBelief/Text/Person can't be created for RI test");

    testPerson.belief = [NSSet setWithObject:testBelief];
    testText.belief = [NSSet setWithObject:testBelief];    

    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Text relationships can't be created for RI test");
    
    testBelief.figurehead = testPerson;
    testBelief.texts = [NSSet setWithObject:testText];

    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceBelief can't be updated for RI test");
    
    NSArray *beliefs = [testModelManager readAll:ReferenceBelief.class];
    
    XCTAssertEqual(beliefs.count, (NSUInteger) 1, @"There should only be 1 RefenceBelief in the context.");
    ReferenceBelief *retrieved = beliefs[0];
    XCTAssertEqualObjects(retrieved.figurehead, testPerson, @"figurehead Relationship failed.");
    XCTAssertEqualObjects([retrieved.texts anyObject], testText, @"text Relationship failed.");
    
}

- (void)testBeliefReferentialIntegrityUpdate {
    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceBelief/Text/Person can't be created for RI Update test");
        
    testPerson.belief = [NSSet setWithObject:testBelief];
    testText.belief = [NSSet setWithObject:testBelief];    
    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Text relationships can't be created for RI Update test");
    
    testBelief.figurehead = testPerson;
    testBelief.texts = [NSSet setWithObject:testText];
    
    NSString *newFigureheadName = @"New figurehead name";
    testPerson.nameReference = newFigureheadName;
    NSString *newTextName = @"New text name";
    testText.nameReference = newTextName;

    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson can't be updated for RI Update test");
    
    NSArray *beliefs = [testModelManager readAll:ReferenceBelief.class];
    ReferenceBelief *retrieved = beliefs[0];
    XCTAssertEqualObjects(retrieved.figurehead.nameReference, newFigureheadName, @"figurehead RI update failed.");
    XCTAssertEqualObjects([[retrieved.texts anyObject] nameReference], newTextName, @"text RI update failed.");
    
}

- (void)testBeliefDeletion {
    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceBelief/Text/Person can't be created for Delete test");
    
    XCTAssertNoThrow([testModelManager delete:testBelief], @"ReferenceBelief can't be deleted");
    
    NSArray *beliefs = [testModelManager readAll:ReferenceBelief.class];
    
    XCTAssertEqual(beliefs.count, (NSUInteger) 0, @"ReferenceBelief is still present after delete");
    
}

- (void)testBeliefReferentialIntegrityDelete {
    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceBelief/Text/Person can't be created for RI Delete test");
    
    testPerson.belief = [NSSet setWithObject:testBelief];
    testText.belief = [NSSet setWithObject:testBelief];    

    testBelief.figurehead = testPerson;
    testBelief.texts = [NSSet setWithObject:testText];    
    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Text relationships can't be created for RI Delete test");
    
    XCTAssertNoThrow([testModelManager delete:testBelief], @"ReferenceBelief can't be deleted");
    
    NSArray *texts = [testModelManager readAll:ReferenceText.class];
    NSArray *people = [testModelManager readAll:ReferencePerson.class];
    
    XCTAssertEqual(texts.count, (NSUInteger) 1, @"ReferenceText should not have been cascade deleted");
    XCTAssertEqual(people.count, (NSUInteger) 1, @"ReferencePerson should not have been cascade deleted");
    
}

- (void)testBeliefWithoutRequiredAttributes {
    ReferenceBelief *testBeliefBad = [testModelManager create:ReferenceBelief.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testBeliefBad.class];

    XCTAssertThrows([testModelManager saveContext], errorMessage);
}

@end
