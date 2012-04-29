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
    NSString *shortDescription;
    NSNumber *originYear;
    NSString *name;
    NSString *longDescription;
    NSString *link;    
    NSString *displayName;
    NSString *imageName;

}

@end

@implementation TestReferenceText

- (void)setUp {
    coreData = [[TestCoreDataStack alloc] init];
    
    quote = @"test quote";
    shortDescription = @"short description";
    originYear = [NSNumber numberWithInt:2010];
    name = @"name";
    longDescription = @"long description";
    link = @"http://www.teamaxe.org";    
    displayName = @"display name";
    imageName = @"image name";
    
    testText = [coreData insert:ReferenceText.class];
    testText.quote = quote;
    testText.shortDescriptionReference = shortDescription;
    testText.originYear = originYear;
    testText.nameReference = name;
    testText.longDescriptionReference = longDescription;
    testText.linkReference = link;
    testText.displayNameReference = displayName;
    testText.imageNameReference = imageName; 
    
    testBelief = [coreData insert:ReferenceBelief.class];
    testBelief.typeBelief = @"belief";
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
    
}

- (void)testTextCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    STAssertNoThrow([coreData save], @"ReferenceText can't be created");
        
}

- (void)testTextAccessorsAreFunctional {
    
    STAssertNoThrow([coreData save], @"ReferenceText can't be created for Accessor test");
    
    NSArray *texts = [coreData fetch:ReferenceText.class];
    
    STAssertEquals(texts.count, (NSUInteger) 1, @"");
    ReferenceText *retrieved = [texts objectAtIndex: 0];
    STAssertEqualObjects(retrieved.quote, quote, @"typeBelief Getter/Setter failed.");
    STAssertEqualObjects(retrieved.shortDescriptionReference, shortDescription, @"shortDescription Getter/Setter failed.");
    STAssertEquals(retrieved.originYear, originYear, @"originYear Getter/Setter failed.");
    STAssertEqualObjects(retrieved.nameReference, name, @"nameReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.longDescriptionReference, longDescription, @"longDescriptionReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.linkReference, link, @"linkReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.displayNameReference, displayName, @"displayNameReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.imageNameReference, imageName, @"imageNameReference Getter/Setter failed.");
    
}

- (void)testTextReferentialIntegrity {
    
    STAssertNoThrow([coreData save], @"ReferenceText/Belief/Person can't be created for RI test");

    testPerson.oeuvre = [NSSet setWithObject:testText];
    testBelief.texts = [NSSet setWithObject:testText];    

    STAssertNoThrow([coreData save], @"ReferencePerson or ReferenceBelief relationships can't be created for RI test");
    
    testText.author = testPerson;
    testText.belief = [NSSet setWithObject:testBelief];

    STAssertNoThrow([coreData save], @"ReferenceText can't be updated for RI test");
    
    NSArray *texts = [coreData fetch:ReferenceText.class];
    
    STAssertEquals(texts.count, (NSUInteger) 1, @"");
    ReferenceText *retrieved = [texts objectAtIndex: 0];
    STAssertEqualObjects(retrieved.author, testPerson, @"author Relationship failed.");
    STAssertEqualObjects([retrieved.belief anyObject], testBelief, @"belief Relationship failed.");
    
}

- (void)testTextReferentialIntegrityUpdate {
    STAssertNoThrow([coreData save], @"ReferenceText/Belief/Person can't be created for RI Update test");
        
    testPerson.oeuvre = [NSSet setWithObject:testText];
    testBelief.texts = [NSSet setWithObject:testText];    
    
    STAssertNoThrow([coreData save], @"ReferencePerson or ReferenceBelief relationships can't be created for RI Update test");
    
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
    
    STAssertNoThrow([coreData save], @"ReferencePerson or ReferenceBelief relationships can't be created for RI Delete test");
    
    STAssertNoThrow([coreData delete:testText], @"ReferenceText can't be deleted");
    
    NSArray *beliefs = [coreData fetch:ReferenceBelief.class];
    NSArray *people = [coreData fetch:ReferencePerson.class];
    
    STAssertEquals(beliefs.count, (NSUInteger) 1, @"ReferenceText should not have been cascade deleted");
    STAssertEquals(people.count, (NSUInteger) 1, @"ReferencePerson should not have been cascade deleted");
    
}

@end
