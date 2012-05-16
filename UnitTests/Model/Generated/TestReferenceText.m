#import "TestCoreDataStack.h"
#import "ReferenceText.h"
#import "ReferenceBelief.h"
#import "ReferencePerson.h"

@interface TestReferenceText: SenTestCase {
    TestCoreDataStack *coreData;
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
    coreData = [[TestCoreDataStack alloc] initWithManagedObjectModel:@"SystemData"];
    
    quote = @"quote";
    shortDescriptionReference = @"shortDescriptionReference";
    originYear = [NSNumber numberWithInt:2010];
    nameReference = @"nameReference";
    longDescriptionReference = @"longDescriptionReference";
    linkReference = @"http://www.teamaxe.org";    
    displayNameReference = @"displayNameReference";
    imageNameReference = @"imageNameReferencee";
    
    testText = [coreData insert:ReferenceText.class];
    testText.quote = quote;
    testText.shortDescriptionReference = shortDescriptionReference;
    testText.originYear = originYear;
    testText.nameReference = nameReference;
    testText.longDescriptionReference = longDescriptionReference;
    testText.linkReference = linkReference;
    testText.displayNameReference = displayNameReference;
    testText.imageNameReference = imageNameReference; 
    
    testBelief = [coreData insert:ReferenceBelief.class];
    testBelief.typeBelief = @"belief";
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
    
}

- (void)testTextCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    STAssertNoThrow([coreData save], @"ReferenceText can't be created.");
        
}

- (void)testTextAccessorsAreFunctional {
    
    STAssertNoThrow([coreData save], @"ReferenceText can't be created for Accessor test.");
    
    NSArray *texts = [coreData fetch:ReferenceText.class];
    
    STAssertEquals(texts.count, (NSUInteger) 1, @"There should only be 1 RefenceText in the context.");
    ReferenceText *retrieved = [texts objectAtIndex: 0];
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
    
    STAssertNoThrow([coreData save], @"ReferenceText/Belief/Person can't be created for RI test.");

    ReferenceText *childText1 = [coreData insert:ReferenceText.class];
    ReferenceText *childText2 = [coreData insert:ReferenceText.class];    
    ReferenceText *parentText = [coreData insert:ReferenceText.class];

    childText1.shortDescriptionReference = shortDescriptionReference;
    childText1.originYear = originYear;
    childText1.nameReference = @"child1";
    childText1.longDescriptionReference = longDescriptionReference;
    childText1.linkReference = linkReference;
    childText1.displayNameReference = displayNameReference;
    childText1.imageNameReference = imageNameReference;
    childText1.parentReference = testText;
   
    childText2.shortDescriptionReference = shortDescriptionReference;
    childText2.originYear = originYear;
    childText2.nameReference = @"child2";
    childText2.longDescriptionReference = longDescriptionReference;
    childText2.linkReference = linkReference;
    childText2.displayNameReference = displayNameReference;
    childText2.imageNameReference = imageNameReference;   
    childText1.parentReference = testText;    
    
    parentText.shortDescriptionReference = shortDescriptionReference;
    parentText.originYear = originYear;
    parentText.nameReference = @"parent";
    parentText.longDescriptionReference = longDescriptionReference;
    parentText.linkReference = linkReference;
    parentText.displayNameReference = displayNameReference;
    parentText.imageNameReference = imageNameReference; 
        
    testPerson.oeuvre = [NSSet setWithObject:testText];
    testBelief.texts = [NSSet setWithObject:testText];    

    STAssertNoThrow([coreData save], @"ReferenceText/Person/Belief relationships can't be created for RI test.");
    
    testText.childrenReference = [NSSet setWithObjects:childText1, childText2, nil];
    testText.parentReference = parentText;
    
    testText.author = testPerson;
    testText.belief = [NSSet setWithObject:testBelief];

    STAssertNoThrow([coreData save], @"ReferenceText can't be updated for RI test.");
    
    NSArray *allTexts = [coreData fetch:ReferenceText.class];
    STAssertEquals(allTexts.count, (NSUInteger) 4, @"There should be 4 ReferenceTexts in the context (parent and children).");
    
    NSError *error = nil;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"nameReference == %@", nameReference];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([ReferenceText class])];
    request.predicate = searchPredicate;
    NSArray *texts = [[coreData managedObjectContext] executeFetchRequest:request error:&error];

    ReferenceText *retrieved = [texts objectAtIndex: 0];
    NSArray *childrenTexts = [[retrieved childrenReference] allObjects];
    
    STAssertTrue([childrenTexts containsObject:childText1], @"child Relationship 1 failed.");
    STAssertTrue([childrenTexts containsObject:childText2], @"child Relationship 2 failed.");
    STAssertEqualObjects(retrieved.author, testPerson, @"author Relationship failed.");
    STAssertEqualObjects([retrieved.belief anyObject], testBelief, @"belief Relationship failed.");
    STAssertEqualObjects(retrieved.parentReference, parentText, @"parentReference Relationship failed.");    
    
}

- (void)testTextReferentialIntegrityUpdate {
    STAssertNoThrow([coreData save], @"ReferenceText/Belief/Person can't be created for RI Update test");
        
    testPerson.oeuvre = [NSSet setWithObject:testText];
    testBelief.texts = [NSSet setWithObject:testText];    
    
    STAssertNoThrow([coreData save], @"ReferencePerson/Belief relationships can't be created for RI Update test");
    
    testText.author = testPerson;
    testText.belief = [NSSet setWithObject:testBelief];
    
    NSString *newAuthorName = @"New figurehead name";
    testPerson.nameReference = newAuthorName;
    NSString *newBeliefName = @"New belief name";
    testBelief.nameReference = newBeliefName;

    STAssertNoThrow([coreData save], @"ReferenceText can't be updated for RI Update test");
    
    NSArray *texts = [coreData fetch:ReferenceText.class];
    ReferenceText *retrieved = [texts objectAtIndex: 0];
    STAssertEqualObjects(retrieved.author.nameReference, newAuthorName, @"author RI update failed.");
    STAssertEqualObjects([[retrieved.belief anyObject] nameReference], newBeliefName, @"belief RI update failed.");
    
}

- (void)testTextDeletion {
    STAssertNoThrow([coreData save], @"ReferenceText/Belief/Person can't be created for Delete test");
    
    STAssertNoThrow([coreData delete:testText], @"ReferenceText can't be deleted");
    
    NSArray *texts = [coreData fetch:ReferenceText.class];
    
    STAssertEquals(texts.count, (NSUInteger) 0, @"ReferenceText is still present after delete");
    
}

- (void)testTextReferentialIntegrityDelete {
    STAssertNoThrow([coreData save], @"ReferenceText/Belief/Person can't be created for RI Delete test");
    
    testPerson.oeuvre = [NSSet setWithObject:testText];
    testBelief.texts = [NSSet setWithObject:testText];    

    testText.author = testPerson;
    testText.belief = [NSSet setWithObject:testBelief];    
    
    STAssertNoThrow([coreData save], @"ReferencePerso/Belief relationships can't be created for RI Delete test");
    
    STAssertNoThrow([coreData delete:testText], @"ReferenceText can't be deleted");
    
    NSArray *beliefs = [coreData fetch:ReferenceBelief.class];
    NSArray *people = [coreData fetch:ReferencePerson.class];
    
    STAssertEquals(beliefs.count, (NSUInteger) 1, @"ReferenceBelief should not have been cascade deleted");
    STAssertEquals(people.count, (NSUInteger) 1, @"ReferencePerson should not have been cascade deleted");
    
}

@end