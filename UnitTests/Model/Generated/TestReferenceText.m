#import "ModelManager.h"
#import "TestModelHelper.h"
#import "ReferenceText.h"
#import "ReferenceBelief.h"
#import "ReferencePerson.h"

@interface TestReferenceText: SenTestCase {
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
    STAssertNoThrow([testModelManager saveContext], @"ReferenceText can't be created.");
        
}

- (void)testTextAccessorsAreFunctional {
    
    STAssertNoThrow([testModelManager saveContext], @"ReferenceText can't be created for Accessor test.");
    
    NSArray *texts = [testModelManager readAll:ReferenceText.class];
    
    STAssertEquals(texts.count, (NSUInteger) 1, @"There should only be 1 RefenceText in the context.");
    ReferenceText *retrieved = texts[0];
    STAssertEqualObjects(retrieved.quote, quote, @"typeBelief Getter/Setter failed.");
    STAssertEqualObjects(retrieved.shortDescriptionReference, shortDescriptionReference, @"shortDescription Getter/Setter failed.");
    STAssertEqualObjects(retrieved.originYear, originYear, @"originYear Getter/Setter failed.");
    STAssertEqualObjects(retrieved.nameReference, nameReference, @"nameReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.longDescriptionReference, longDescriptionReference, @"longDescriptionReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.linkReference, linkReference, @"linkReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.displayNameReference, displayNameReference, @"displayNameReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.imageNameReference, imageNameReference, @"imageNameReference Getter/Setter failed.");
    
}

- (void)testTextReferentialIntegrity {
    
    STAssertNoThrow([testModelManager saveContext], @"ReferenceText/Belief/Person can't be created for RI test.");

    ReferenceText *childText1 = [TestModelHelper createTextWithName:@"child1" withModelManager:testModelManager];
    ReferenceText *childText2 = [TestModelHelper createTextWithName:@"child2" withModelManager:testModelManager];
    ReferenceText *parentText = [TestModelHelper createTextWithName:@"parent" withModelManager:testModelManager];
        
    testPerson.oeuvre = [NSSet setWithObject:testText];
    testBelief.texts = [NSSet setWithObject:testText];    

    STAssertNoThrow([testModelManager saveContext], @"ReferenceText/Person/Belief relationships can't be created for RI test.");
    
    testText.childrenReference = [NSSet setWithObjects:childText1, childText2, nil];
    testText.parentReference = parentText;
    
    testText.author = testPerson;
    testText.belief = [NSSet setWithObject:testBelief];

    STAssertNoThrow([testModelManager saveContext], @"ReferenceText can't be updated for RI test.");
    
    NSArray *allTexts = [testModelManager readAll:ReferenceText.class];
    STAssertEquals(allTexts.count, (NSUInteger) 4, @"There should be 4 ReferenceTexts in the context (parent and children).");
    
    NSError *error = nil;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"nameReference == %@", nameReference];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ReferenceText class])];
    request.predicate = searchPredicate;
    NSArray *texts = [[testModelManager managedObjectContext] executeFetchRequest:request error:&error];

    ReferenceText *retrieved = texts[0];
    NSArray *childrenTexts = [[retrieved childrenReference] allObjects];
    
    STAssertTrue([childrenTexts containsObject:childText1], @"child Relationship 1 failed.");
    STAssertTrue([childrenTexts containsObject:childText2], @"child Relationship 2 failed.");
    STAssertEqualObjects(retrieved.author, testPerson, @"author Relationship failed.");
    STAssertEqualObjects([retrieved.belief anyObject], testBelief, @"belief Relationship failed.");
    STAssertEqualObjects(retrieved.parentReference, parentText, @"parentReference Relationship failed.");    
    
}

- (void)testTextReferentialIntegrityUpdate {
    STAssertNoThrow([testModelManager saveContext], @"ReferenceText/Belief/Person can't be created for RI Update test");
        
    testPerson.oeuvre = [NSSet setWithObject:testText];
    testBelief.texts = [NSSet setWithObject:testText];    
    
    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Belief relationships can't be created for RI Update test");
    
    testText.author = testPerson;
    testText.belief = [NSSet setWithObject:testBelief];
    
    NSString *newAuthorName = @"New figurehead name";
    testPerson.nameReference = newAuthorName;
    NSString *newBeliefName = @"New belief name";
    testBelief.nameReference = newBeliefName;

    STAssertNoThrow([testModelManager saveContext], @"ReferenceText can't be updated for RI Update test");
    
    NSArray *texts = [testModelManager readAll:ReferenceText.class];
    ReferenceText *retrieved = texts[0];
    STAssertEqualObjects(retrieved.author.nameReference, newAuthorName, @"author RI update failed.");
    STAssertEqualObjects([[retrieved.belief anyObject] nameReference], newBeliefName, @"belief RI update failed.");
    
}

- (void)testTextDeletion {
    STAssertNoThrow([testModelManager saveContext], @"ReferenceText/Belief/Person can't be created for Delete test");
    
    STAssertNoThrow([testModelManager delete:testText], @"ReferenceText can't be deleted");
    
    NSArray *texts = [testModelManager readAll:ReferenceText.class];
    
    STAssertEquals(texts.count, (NSUInteger) 0, @"ReferenceText is still present after delete");
    
}

- (void)testTextReferentialIntegrityDelete {
    STAssertNoThrow([testModelManager saveContext], @"ReferenceText/Belief/Person can't be created for RI Delete test");
    
    testPerson.oeuvre = [NSSet setWithObject:testText];
    testBelief.texts = [NSSet setWithObject:testText];    

    testText.author = testPerson;
    testText.belief = [NSSet setWithObject:testBelief];    
    
    STAssertNoThrow([testModelManager saveContext], @"ReferencePerso/Belief relationships can't be created for RI Delete test");
    
    STAssertNoThrow([testModelManager delete:testText], @"ReferenceText can't be deleted");
    
    NSArray *beliefs = [testModelManager readAll:ReferenceBelief.class];
    NSArray *people = [testModelManager readAll:ReferencePerson.class];
    
    STAssertEquals(beliefs.count, (NSUInteger) 1, @"ReferenceBelief should not have been cascade deleted");
    STAssertEquals(people.count, (NSUInteger) 1, @"ReferencePerson should not have been cascade deleted");
    
}

@end
