#import "ModelManager.h"
#import "TestModelHelper.h"
#import "ReferenceText.h"
#import "ReferenceBelief.h"
#import "ReferencePerson.h"

@interface TestReferenceText:XCTestCase {
    ModelManager *testModelManager;
    ReferenceText *testText;    
    ReferenceBelief *testBelief;
    ReferencePerson *testPerson;

    NSString *quote;
    NSString *shortDescriptionReference;
    NSNumber *originYear;
    NSString *nameReference;
    NSString *longDescriptionReference;
    NSString *linkReference;    
    NSString *displayNameReference;
    NSString *imageNameReference;

}

@end

@implementation TestReferenceText

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    
    quote = @"quote";
    shortDescriptionReference = @"shortDescriptionReference";
    originYear = @2010;
    nameReference = @"nameReference";
    longDescriptionReference = @"longDescriptionReference";
    linkReference = @"http://www.teamaxe.org";    
    displayNameReference = @"displayNameReference";
    imageNameReference = @"imageNameReferencee";
    
    testText = [TestModelHelper createTextWithName:nameReference withModelManager:testModelManager];
    testText.quote = quote;
    testText.shortDescriptionReference = shortDescriptionReference;
    testText.originYear = originYear;
    testText.nameReference = nameReference;
    testText.longDescriptionReference = longDescriptionReference;
    testText.linkReference = linkReference;
    testText.displayNameReference = displayNameReference;
    testText.imageNameReference = imageNameReference; 

    testPerson = [TestModelHelper createPersonWithName:@"namePerson" withModelManager:testModelManager];
    testBelief = [TestModelHelper createBeliefWithName:@"nameBelief" withModelManager:testModelManager];
    
}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testTextCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceText can't be created.");
        
}

- (void)testTextAccessorsAreFunctional {
    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceText can't be created for Accessor test.");
    
    NSArray *texts = [testModelManager readAll:ReferenceText.class];
    
    XCTAssertEqual(texts.count, (NSUInteger) 1, @"There should only be 1 RefenceText in the context.");
    ReferenceText *retrieved = texts[0];
    XCTAssertEqualObjects(retrieved.quote, quote, @"typeBelief Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.shortDescriptionReference, shortDescriptionReference, @"shortDescription Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.originYear, originYear, @"originYear Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.nameReference, nameReference, @"nameReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.longDescriptionReference, longDescriptionReference, @"longDescriptionReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.linkReference, linkReference, @"linkReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.displayNameReference, displayNameReference, @"displayNameReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.imageNameReference, imageNameReference, @"imageNameReference Getter/Setter failed.");
    
}

- (void)testTextReferentialIntegrity {
    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceText/Belief/Person can't be created for RI test.");

    ReferenceText *childText1 = [TestModelHelper createTextWithName:@"child1" withModelManager:testModelManager];
    ReferenceText *childText2 = [TestModelHelper createTextWithName:@"child2" withModelManager:testModelManager];
    ReferenceText *parentText = [TestModelHelper createTextWithName:@"parent" withModelManager:testModelManager];
        
    testPerson.oeuvre = [NSSet setWithObject:testText];
    testBelief.texts = [NSSet setWithObject:testText];    

    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceText/Person/Belief relationships can't be created for RI test.");
    
    testText.childrenReference = [NSSet setWithObjects:childText1, childText2, nil];
    testText.parentReference = parentText;
    
    testText.author = testPerson;
    testText.belief = [NSSet setWithObject:testBelief];

    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceText can't be updated for RI test.");
    
    NSArray *allTexts = [testModelManager readAll:ReferenceText.class];
    XCTAssertEqual(allTexts.count, (NSUInteger) 4, @"There should be 4 ReferenceTexts in the context (parent and children).");
    
    NSError *error = nil;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"nameReference == %@", nameReference];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ReferenceText class])];
    request.predicate = searchPredicate;
    NSArray *texts = [[testModelManager managedObjectContext] executeFetchRequest:request error:&error];

    ReferenceText *retrieved = texts[0];
    NSArray *childrenTexts = [[retrieved childrenReference] allObjects];
    
    XCTAssertTrue([childrenTexts containsObject:childText1], @"child Relationship 1 failed.");
    XCTAssertTrue([childrenTexts containsObject:childText2], @"child Relationship 2 failed.");
    XCTAssertEqualObjects(retrieved.author, testPerson, @"author Relationship failed.");
    XCTAssertEqualObjects([retrieved.belief anyObject], testBelief, @"belief Relationship failed.");
    XCTAssertEqualObjects(retrieved.parentReference, parentText, @"parentReference Relationship failed.");    
    
}

- (void)testTextReferentialIntegrityUpdate {
    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceText/Belief/Person can't be created for RI Update test");
        
    testPerson.oeuvre = [NSSet setWithObject:testText];
    testBelief.texts = [NSSet setWithObject:testText];    
    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Belief relationships can't be created for RI Update test");
    
    testText.author = testPerson;
    testText.belief = [NSSet setWithObject:testBelief];
    
    NSString *newAuthorName = @"New figurehead name";
    testPerson.nameReference = newAuthorName;
    NSString *newBeliefName = @"New belief name";
    testBelief.nameReference = newBeliefName;

    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceText can't be updated for RI Update test");
    
    NSArray *texts = [testModelManager readAll:ReferenceText.class];
    ReferenceText *retrieved = texts[0];
    XCTAssertEqualObjects(retrieved.author.nameReference, newAuthorName, @"author RI update failed.");
    XCTAssertEqualObjects([[retrieved.belief anyObject] nameReference], newBeliefName, @"belief RI update failed.");
    
}

- (void)testTextDeletion {
    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceText/Belief/Person can't be created for Delete test");
    
    XCTAssertNoThrow([testModelManager delete:testText], @"ReferenceText can't be deleted");
    
    NSArray *texts = [testModelManager readAll:ReferenceText.class];
    
    XCTAssertEqual(texts.count, (NSUInteger) 0, @"ReferenceText is still present after delete");
    
}

- (void)testTextReferentialIntegrityDelete {
    XCTAssertNoThrow([testModelManager saveContext], @"ReferenceText/Belief/Person can't be created for RI Delete test");
    
    testPerson.oeuvre = [NSSet setWithObject:testText];
    testBelief.texts = [NSSet setWithObject:testText];    

    testText.author = testPerson;
    testText.belief = [NSSet setWithObject:testBelief];    
    
    XCTAssertNoThrow([testModelManager saveContext], @"ReferencePerso/Belief relationships can't be created for RI Delete test");
    
    XCTAssertNoThrow([testModelManager delete:testText], @"ReferenceText can't be deleted");
    
    NSArray *beliefs = [testModelManager readAll:ReferenceBelief.class];
    NSArray *people = [testModelManager readAll:ReferencePerson.class];
    
    XCTAssertEqual(beliefs.count, (NSUInteger) 1, @"ReferenceBelief should not have been cascade deleted");
    XCTAssertEqual(people.count, (NSUInteger) 1, @"ReferencePerson should not have been cascade deleted");
    
}

@end
