#import "ModelManager.h"
#import "TestModelHelper.h"
#import "ReferencePerson.h"
#import "ReferenceText.h"
#import "ReferenceBelief.h"

@interface TestReferencePerson: XCTestCase {
    ModelManager *testModelManager;
    ReferencePerson *testPerson;
    ReferenceText *testText;    
    ReferenceBelief *testBelief;

    NSString *quote;
    NSString *shortDescription;
    NSNumber *originYear;
    NSString *name;
    NSString *longDescription;
    NSString *link;    
    NSString *displayName;
    NSString *imageName;

}

@end

@implementation TestReferencePerson

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    
    quote = @"test quote";
    shortDescription = @"short description";
    originYear = @2010;
    name = @"name";
    longDescription = @"long description";
    link = @"http://www.teamaxe.org";    
    displayName = @"display name";
    imageName = @"image name";
    
    testPerson = [TestModelHelper createPersonWithName:name withModelManager:testModelManager];
    testPerson.quotePerson = quote;
    testPerson.deathYearPerson = originYear;
    testPerson.shortDescriptionReference = shortDescription;
    testPerson.originYear = originYear;
    testPerson.nameReference = name;
    testPerson.longDescriptionReference = longDescription;
    testPerson.linkReference = link;
    testPerson.displayNameReference = displayName;
    testPerson.imageNameReference = imageName;
    
    testText = [TestModelHelper createTextWithName:@"nameText" withModelManager:testModelManager];
    testBelief = [TestModelHelper createBeliefWithName:@"nameBelief" withModelManager:testModelManager];
}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testPersonCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson can't be created.");
        
}

- (void)testPersonAccessorsAreFunctional {
    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson can't be created for Accessor test.");
    
    NSArray *people = [testModelManager readAll:ReferencePerson.class];
    
    XCTAssertEqual(people.count, (NSUInteger) 1, @"There should only be 1 ReferencePerson in the context.");
    ReferencePerson *retrieved = people[0];
    XCTAssertEqualObjects(retrieved.quotePerson, quote, @"quotePerson Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.shortDescriptionReference, shortDescription, @"shortDescription Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.originYear, originYear, @"originYear Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.deathYearPerson, originYear, @"deathYearPerson Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.nameReference, name, @"nameReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.longDescriptionReference, longDescription, @"longDescriptionReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.linkReference, link, @"linkReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.displayNameReference, displayName, @"displayNameReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.imageNameReference, imageName, @"imageNameReference Getter/Setter failed.");
    
}

- (void)testPersonReferentialIntegrity {
    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Belief/Text can't be created for RI test.");
        
    testText.author = testPerson;
    testBelief.figurehead = testPerson;    

    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Belief/Text relationships can't be created for RI test.");
        
    testPerson.oeuvre = [NSSet setWithObject:testText];
    testPerson.belief = [NSSet setWithObject:testBelief];

    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson can't be updated for RI test.");
    
    NSArray *people = [testModelManager readAll:ReferencePerson.class];
    XCTAssertEqual(people.count, (NSUInteger) 1, @"There should be 1 ReferencePeople in the context.");
    
    ReferencePerson *retrieved = people[0];
    
    XCTAssertEqualObjects([retrieved.oeuvre anyObject], testText, @"oeuvre Relationship failed.");
    XCTAssertEqualObjects([retrieved.belief anyObject], testBelief, @"belief Relationship failed.");
    
}

- (void)testPersonReferentialIntegrityUpdate {
    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Belief/Text can't be created for RI Update test");

    testText.author = testPerson;
    testBelief.figurehead = testPerson;    
    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Belief relationships can't be created for RI Update test");
    
    testPerson.oeuvre = [NSSet setWithObject:testText];
    testPerson.belief = [NSSet setWithObject:testBelief];
    
    NSString *newOeuvreName = @"New oeuvre name";
    testText.nameReference = newOeuvreName;
    NSString *newBeliefName = @"New belief name";
    testBelief.nameReference = newBeliefName;

    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson can't be updated for RI Update test");
    
    NSArray *people = [testModelManager readAll:ReferencePerson.class];
    ReferencePerson *retrieved = people[0];
    XCTAssertEqualObjects([[retrieved.oeuvre anyObject] nameReference], newOeuvreName, @"author RI update failed.");
    XCTAssertEqualObjects([[retrieved.belief anyObject] nameReference], newBeliefName, @"belief RI update failed.");
    
}

- (void)testPersonDeletion {
    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Belief/Text can't be created for Delete test");
    
    XCTAssertNoThrow([testModelManager delete:testPerson], @"ReferencePerson can't be deleted");
    
    NSArray *people = [testModelManager readAll:ReferencePerson.class];
    
    XCTAssertEqual(people.count, (NSUInteger) 0, @"ReferencePerson is still present after delete");
    
}

- (void)testPersonReferentialIntegrityDelete {
    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Belief/Text can't be created for RI Delete test");
    
    testText.author = testPerson;
    testBelief.figurehead = testPerson;    

    testPerson.oeuvre = [NSSet setWithObject:testText];
    testPerson.belief = [NSSet setWithObject:testBelief];    
    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceTexts/Belief relationships can't be created for RI Delete test");
    
    XCTAssertNoThrow([testModelManager delete:testPerson], @"ReferencePerson can't be deleted");
    
    NSArray *beliefs = [testModelManager readAll:ReferenceBelief.class];
    NSArray *texts = [testModelManager readAll:ReferenceText.class];
    
    XCTAssertEqual(beliefs.count, (NSUInteger) 1, @"ReferenceBelief should not have been cascade deleted");
    XCTAssertEqual(texts.count, (NSUInteger) 1, @"ReferenceText should not have been cascade deleted");
    
}

@end
