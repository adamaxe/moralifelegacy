#import "TestCoreDataStack.h"
#import "ReferenceBelief.h"
#import "ReferencePerson.h"
#import "ReferenceText.h"

@interface TestReferenceBelief : SenTestCase {
    TestCoreDataStack *coreData;
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
    coreData = [[TestCoreDataStack alloc] initWithManagedObjectModel:@"SystemData"];
    
    typeBelief = @"typeBelief";
    shortDescriptionReference = @"short description";
    originYear = [NSNumber numberWithInt:2010];
    nameReference = @"name";
    longDescriptionReference = @"long description";
    linkReference = @"http://www.teamaxe.org";    
    displayNameReference = @"display name";
    imageNameReference = @"image name";
    
    testBelief = [coreData insert:ReferenceBelief.class];
    testBelief.typeBelief = typeBelief;
    testBelief.shortDescriptionReference = shortDescriptionReference;
    testBelief.originYear = originYear;
    testBelief.nameReference = nameReference;
    testBelief.longDescriptionReference = longDescriptionReference;
    testBelief.linkReference = linkReference;
    testBelief.displayNameReference = displayNameReference;
    testBelief.imageNameReference = imageNameReference;
    
    testPerson = [coreData insert:ReferencePerson.class];
    testPerson.shortDescriptionReference = shortDescriptionReference;
    testPerson.originYear = originYear;
    testPerson.nameReference = nameReference;
    testPerson.longDescriptionReference = longDescriptionReference;
    testPerson.linkReference = linkReference;
    testPerson.displayNameReference = displayNameReference;
    testPerson.imageNameReference = imageNameReference;
    
    testText = [coreData insert:ReferenceText.class];
    testText.shortDescriptionReference = shortDescriptionReference;
    testText.originYear = originYear;
    testText.nameReference = nameReference;
    testText.longDescriptionReference = longDescriptionReference;
    testText.linkReference = linkReference;
    testText.displayNameReference = displayNameReference;
    testText.imageNameReference = imageNameReference;  
    
}

- (void)testBeliefCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    STAssertNoThrow([coreData save], @"ReferenceBelief can't be created");
        
}

- (void)testBeliefAccessorsAreFunctional {
    
    STAssertNoThrow([coreData save], @"ReferenceBelief can't be created for Accessor test");
    
    NSArray *beliefs = [coreData fetch:ReferenceBelief.class];
    
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
    
    STAssertNoThrow([coreData save], @"ReferenceBelief/Text/Person can't be created for RI test");

    testPerson.belief = [NSSet setWithObject:testBelief];
    testText.belief = [NSSet setWithObject:testBelief];    

    STAssertNoThrow([coreData save], @"ReferencePerson/Text relationships can't be created for RI test");
    
    testBelief.figurehead = testPerson;
    testBelief.texts = [NSSet setWithObject:testText];

    STAssertNoThrow([coreData save], @"ReferenceBelief can't be updated for RI test");
    
    NSArray *beliefs = [coreData fetch:ReferenceBelief.class];
    
    STAssertEquals(beliefs.count, (NSUInteger) 1, @"There should only be 1 RefenceBelief in the context.");
    ReferenceBelief *retrieved = [beliefs objectAtIndex: 0];
    STAssertEqualObjects(retrieved.figurehead, testPerson, @"figurehead Relationship failed.");
    STAssertEqualObjects([retrieved.texts anyObject], testText, @"text Relationship failed.");
    
}

- (void)testBeliefReferentialIntegrityUpdate {
    STAssertNoThrow([coreData save], @"ReferenceBelief/Text/Person can't be created for RI Update test");
        
    testPerson.belief = [NSSet setWithObject:testBelief];
    testText.belief = [NSSet setWithObject:testBelief];    
    
    STAssertNoThrow([coreData save], @"ReferencePerson/Text relationships can't be created for RI Update test");
    
    testBelief.figurehead = testPerson;
    testBelief.texts = [NSSet setWithObject:testText];
    
    NSString *newFigureheadName = @"New figurehead name";
    testPerson.nameReference = newFigureheadName;
    NSString *newTextName = @"New text name";
    testText.nameReference = newTextName;

    STAssertNoThrow([coreData save], @"ReferencePerson can't be updated for RI Update test");
    
    NSArray *beliefs = [coreData fetch:ReferenceBelief.class];
    ReferenceBelief *retrieved = [beliefs objectAtIndex: 0];
    STAssertEqualObjects(retrieved.figurehead.nameReference, newFigureheadName, @"figurehead RI update failed.");
    STAssertEqualObjects([[retrieved.texts anyObject] nameReference], newTextName, @"text RI update failed.");
    
}

- (void)testBeliefDeletion {
    STAssertNoThrow([coreData save], @"ReferenceBelief/Text/Person can't be created for Delete test");
    
    STAssertNoThrow([coreData delete:testBelief], @"ReferenceBelief can't be deleted");
    
    NSArray *beliefs = [coreData fetch:ReferenceBelief.class];
    
    STAssertEquals(beliefs.count, (NSUInteger) 0, @"ReferenceBelief is still present after delete");
    
}

- (void)testBeliefReferentialIntegrityDelete {
    STAssertNoThrow([coreData save], @"ReferenceBelief/Text/Person can't be created for RI Delete test");
    
    testPerson.belief = [NSSet setWithObject:testBelief];
    testText.belief = [NSSet setWithObject:testBelief];    

    testBelief.figurehead = testPerson;
    testBelief.texts = [NSSet setWithObject:testText];    
    
    STAssertNoThrow([coreData save], @"ReferencePerson/Text relationships can't be created for RI Delete test");
    
    STAssertNoThrow([coreData delete:testBelief], @"ReferenceBelief can't be deleted");
    
    NSArray *texts = [coreData fetch:ReferenceText.class];
    NSArray *people = [coreData fetch:ReferencePerson.class];
    
    STAssertEquals(texts.count, (NSUInteger) 1, @"ReferenceText should not have been cascade deleted");
    STAssertEquals(people.count, (NSUInteger) 1, @"ReferencePerson should not have been cascade deleted");
    
}

- (void)testBeliefWithoutRequiredAttributes {
    ReferenceBelief *testBeliefBad = [coreData insert:ReferenceBelief.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testBeliefBad.class];

    STAssertThrows([coreData save], errorMessage);
}

@end
