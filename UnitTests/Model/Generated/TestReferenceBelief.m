#import "TestCoreDataStack.h"
#import "ReferenceBelief.h"
#import "ReferencePerson.h"
#import "ReferenceText.h"

@interface TestReferenceBelief : SenTestCase {
    TestCoreDataStack *coreData;
    ReferenceBelief *testBelief;
    ReferenceText *testText;
    ReferencePerson *testPerson;

    NSString *belief;
    NSString *shortDescription;
    NSNumber *originYear;
    NSString *name;
    NSString *longDescription;
    NSString *link;    
    NSString *displayName;
    NSString *imageName;

}

@end

@implementation TestReferenceBelief

- (void)setUp {
    coreData = [[TestCoreDataStack alloc] init];
    
    belief = @"test belief";
    shortDescription = @"short description";
    originYear = [NSNumber numberWithInt:2010];
    name = @"name";
    longDescription = @"long description";
    link = @"http://www.teamaxe.org";    
    displayName = @"display name";
    imageName = @"image name";
    
    testBelief = [coreData insert:ReferenceBelief.class];
    testBelief.typeBelief = belief;
    testBelief.shortDescriptionReference = shortDescription;
    testBelief.originYear = originYear;
    testBelief.nameReference = name;
    testBelief.longDescriptionReference = longDescription;
    testBelief.linkReference = link;
    testBelief.displayNameReference = displayName;
    testBelief.imageNameReference = imageName;
    
    testPerson = [coreData insert:ReferencePerson.class];
    testPerson.shortDescriptionReference = shortDescription;
    testPerson.originYear = originYear;
    testPerson.nameReference = name;
    testPerson.longDescriptionReference = longDescription;
    testPerson.linkReference = link;
    testPerson.displayNameReference = displayName;
    testPerson.imageNameReference = imageName;
    
    testText = [coreData insert:ReferenceText.class];
    testText.shortDescriptionReference = shortDescription;
    testText.originYear = originYear;
    testText.nameReference = name;
    testText.longDescriptionReference = longDescription;
    testText.linkReference = link;
    testText.displayNameReference = displayName;
    testText.imageNameReference = imageName;  
    
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
    STAssertEqualObjects(retrieved.typeBelief, belief, @"typeBelief Getter/Setter failed.");
    STAssertEqualObjects(retrieved.shortDescriptionReference, shortDescription, @"shortDescription Getter/Setter failed.");
    STAssertEquals(retrieved.originYear, originYear, @"originYear Getter/Setter failed.");
    STAssertEqualObjects(retrieved.nameReference, name, @"nameReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.longDescriptionReference, longDescription, @"longDescriptionReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.linkReference, link, @"linkReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.displayNameReference, displayName, @"displayNameReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.imageNameReference, imageName, @"imageNameReference Getter/Setter failed.");
    
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

- (void)testBeliefWithoutRequiredTypeBelief {
    ReferenceBelief *testBeliefBad = [coreData insert:ReferenceBelief.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testBeliefBad.class];

    STAssertThrows([coreData save], errorMessage);
}

@end
