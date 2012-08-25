#import "ModelManager.h"
#import "ReferenceBelief.h"
#import "ReferencePerson.h"
#import "ReferenceText.h"

@interface TestReferenceBelief : SenTestCase {
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
    
    testBelief = [testModelManager create:ReferenceBelief.class];
    testBelief.typeBelief = typeBelief;
    testBelief.shortDescriptionReference = shortDescriptionReference;
    testBelief.originYear = originYear;
    testBelief.nameReference = nameReference;
    testBelief.longDescriptionReference = longDescriptionReference;
    testBelief.linkReference = linkReference;
    testBelief.displayNameReference = displayNameReference;
    testBelief.imageNameReference = imageNameReference;
    
    testPerson = [testModelManager create:ReferencePerson.class];
    testPerson.shortDescriptionReference = shortDescriptionReference;
    testPerson.originYear = originYear;
    testPerson.nameReference = nameReference;
    testPerson.longDescriptionReference = longDescriptionReference;
    testPerson.linkReference = linkReference;
    testPerson.displayNameReference = displayNameReference;
    testPerson.imageNameReference = imageNameReference;
    
    testText = [testModelManager create:ReferenceText.class];
    testText.shortDescriptionReference = shortDescriptionReference;
    testText.originYear = originYear;
    testText.nameReference = nameReference;
    testText.longDescriptionReference = longDescriptionReference;
    testText.linkReference = linkReference;
    testText.displayNameReference = displayNameReference;
    testText.imageNameReference = imageNameReference;  
    
}

- (void)tearDown{

	//Tear-down code here.
	[testModelManager release];

	[super tearDown];
    
}

- (void)testBeliefCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    STAssertNoThrow([testModelManager saveContext], @"ReferenceBelief can't be created");
        
}

- (void)testBeliefAccessorsAreFunctional {
    
    STAssertNoThrow([testModelManager saveContext], @"ReferenceBelief can't be created for Accessor test");
    
    NSArray *beliefs = [testModelManager readAll:ReferenceBelief.class];
    
    STAssertEquals(beliefs.count, (NSUInteger) 1, @"There should only be 1 RefenceText in the context.");
    ReferenceBelief *retrieved = [beliefs objectAtIndex: 0];
    STAssertEqualObjects(retrieved.typeBelief, typeBelief, @"typeBelief Getter/Setter failed.");
    STAssertEqualObjects(retrieved.shortDescriptionReference, shortDescriptionReference, @"shortDescription Getter/Setter failed.");
    STAssertEqualObjects(retrieved.originYear, originYear, @"originYear Getter/Setter failed.");
    STAssertEqualObjects(retrieved.nameReference, nameReference, @"nameReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.longDescriptionReference, longDescriptionReference, @"longDescriptionReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.linkReference, linkReference, @"linkReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.displayNameReference, displayNameReference, @"displayNameReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.imageNameReference, imageNameReference, @"imageNameReference Getter/Setter failed.");
    
}

- (void)testBeliefReferentialIntegrity {
    
    STAssertNoThrow([testModelManager saveContext], @"ReferenceBelief/Text/Person can't be created for RI test");

    testPerson.belief = [NSSet setWithObject:testBelief];
    testText.belief = [NSSet setWithObject:testBelief];    

    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Text relationships can't be created for RI test");
    
    testBelief.figurehead = testPerson;
    testBelief.texts = [NSSet setWithObject:testText];

    STAssertNoThrow([testModelManager saveContext], @"ReferenceBelief can't be updated for RI test");
    
    NSArray *beliefs = [testModelManager readAll:ReferenceBelief.class];
    
    STAssertEquals(beliefs.count, (NSUInteger) 1, @"There should only be 1 RefenceBelief in the context.");
    ReferenceBelief *retrieved = [beliefs objectAtIndex: 0];
    STAssertEqualObjects(retrieved.figurehead, testPerson, @"figurehead Relationship failed.");
    STAssertEqualObjects([retrieved.texts anyObject], testText, @"text Relationship failed.");
    
}

- (void)testBeliefReferentialIntegrityUpdate {
    STAssertNoThrow([testModelManager saveContext], @"ReferenceBelief/Text/Person can't be created for RI Update test");
        
    testPerson.belief = [NSSet setWithObject:testBelief];
    testText.belief = [NSSet setWithObject:testBelief];    
    
    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Text relationships can't be created for RI Update test");
    
    testBelief.figurehead = testPerson;
    testBelief.texts = [NSSet setWithObject:testText];
    
    NSString *newFigureheadName = @"New figurehead name";
    testPerson.nameReference = newFigureheadName;
    NSString *newTextName = @"New text name";
    testText.nameReference = newTextName;

    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson can't be updated for RI Update test");
    
    NSArray *beliefs = [testModelManager readAll:ReferenceBelief.class];
    ReferenceBelief *retrieved = [beliefs objectAtIndex: 0];
    STAssertEqualObjects(retrieved.figurehead.nameReference, newFigureheadName, @"figurehead RI update failed.");
    STAssertEqualObjects([[retrieved.texts anyObject] nameReference], newTextName, @"text RI update failed.");
    
}

- (void)testBeliefDeletion {
    STAssertNoThrow([testModelManager saveContext], @"ReferenceBelief/Text/Person can't be created for Delete test");
    
    STAssertNoThrow([testModelManager delete:testBelief], @"ReferenceBelief can't be deleted");
    
    NSArray *beliefs = [testModelManager readAll:ReferenceBelief.class];
    
    STAssertEquals(beliefs.count, (NSUInteger) 0, @"ReferenceBelief is still present after delete");
    
}

- (void)testBeliefReferentialIntegrityDelete {
    STAssertNoThrow([testModelManager saveContext], @"ReferenceBelief/Text/Person can't be created for RI Delete test");
    
    testPerson.belief = [NSSet setWithObject:testBelief];
    testText.belief = [NSSet setWithObject:testBelief];    

    testBelief.figurehead = testPerson;
    testBelief.texts = [NSSet setWithObject:testText];    
    
    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Text relationships can't be created for RI Delete test");
    
    STAssertNoThrow([testModelManager delete:testBelief], @"ReferenceBelief can't be deleted");
    
    NSArray *texts = [testModelManager readAll:ReferenceText.class];
    NSArray *people = [testModelManager readAll:ReferencePerson.class];
    
    STAssertEquals(texts.count, (NSUInteger) 1, @"ReferenceText should not have been cascade deleted");
    STAssertEquals(people.count, (NSUInteger) 1, @"ReferencePerson should not have been cascade deleted");
    
}

- (void)testBeliefWithoutRequiredAttributes {
    ReferenceBelief *testBeliefBad = [testModelManager create:ReferenceBelief.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testBeliefBad.class];

    STAssertThrows([testModelManager saveContext], errorMessage);
}

@end
