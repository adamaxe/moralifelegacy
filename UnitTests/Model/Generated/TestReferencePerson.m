#import "ModelManager.h"
#import "ReferencePerson.h"
#import "ReferenceText.h"
#import "ReferenceBelief.h"

@interface TestReferencePerson: SenTestCase {
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
    
    testPerson = [testModelManager create:ReferencePerson.class];
    testPerson.quotePerson = quote;
    testPerson.deathYearPerson = originYear;
    testPerson.shortDescriptionReference = shortDescription;
    testPerson.originYear = originYear;
    testPerson.nameReference = name;
    testPerson.longDescriptionReference = longDescription;
    testPerson.linkReference = link;
    testPerson.displayNameReference = displayName;
    testPerson.imageNameReference = imageName;
    
    testText = [testModelManager create:ReferenceText.class];
    testText.quote = quote;
    testText.shortDescriptionReference = shortDescription;
    testText.originYear = originYear;
    testText.nameReference = name;
    testText.longDescriptionReference = longDescription;
    testText.linkReference = link;
    testText.displayNameReference = displayName;
    testText.imageNameReference = imageName; 
    
    testBelief = [testModelManager create:ReferenceBelief.class];
    testBelief.typeBelief = @"belief";
    testBelief.shortDescriptionReference = shortDescription;
    testBelief.originYear = originYear;
    testBelief.nameReference = name;
    testBelief.longDescriptionReference = longDescription;
    testBelief.linkReference = link;
    testBelief.displayNameReference = displayName;
    testBelief.imageNameReference = imageName;
}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testPersonCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson can't be created.");
        
}

- (void)testPersonAccessorsAreFunctional {
    
    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson can't be created for Accessor test.");
    
    NSArray *people = [testModelManager readAll:ReferencePerson.class];
    
    STAssertEquals(people.count, (NSUInteger) 1, @"There should only be 1 ReferencePerson in the context.");
    ReferencePerson *retrieved = people[0];
    STAssertEqualObjects(retrieved.quotePerson, quote, @"quotePerson Getter/Setter failed.");
    STAssertEqualObjects(retrieved.shortDescriptionReference, shortDescription, @"shortDescription Getter/Setter failed.");
    STAssertEqualObjects(retrieved.originYear, originYear, @"originYear Getter/Setter failed.");
    STAssertEqualObjects(retrieved.deathYearPerson, originYear, @"deathYearPerson Getter/Setter failed.");
    STAssertEqualObjects(retrieved.nameReference, name, @"nameReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.longDescriptionReference, longDescription, @"longDescriptionReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.linkReference, link, @"linkReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.displayNameReference, displayName, @"displayNameReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.imageNameReference, imageName, @"imageNameReference Getter/Setter failed.");
    
}

- (void)testPersonReferentialIntegrity {
    
    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Belief/Text can't be created for RI test.");
        
    testText.author = testPerson;
    testBelief.figurehead = testPerson;    

    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Belief/Text relationships can't be created for RI test.");
        
    testPerson.oeuvre = [NSSet setWithObject:testText];
    testPerson.belief = [NSSet setWithObject:testBelief];

    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson can't be updated for RI test.");
    
    NSArray *people = [testModelManager readAll:ReferencePerson.class];
    STAssertEquals(people.count, (NSUInteger) 1, @"There should be 1 ReferencePeople in the context.");
    
    ReferencePerson *retrieved = people[0];
    
    STAssertEqualObjects([retrieved.oeuvre anyObject], testText, @"oeuvre Relationship failed.");
    STAssertEqualObjects([retrieved.belief anyObject], testBelief, @"belief Relationship failed.");
    
}

- (void)testPersonReferentialIntegrityUpdate {
    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Belief/Text can't be created for RI Update test");

    testText.author = testPerson;
    testBelief.figurehead = testPerson;    
    
    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Belief relationships can't be created for RI Update test");
    
    testPerson.oeuvre = [NSSet setWithObject:testText];
    testPerson.belief = [NSSet setWithObject:testBelief];
    
    NSString *newOeuvreName = @"New oeuvre name";
    testText.nameReference = newOeuvreName;
    NSString *newBeliefName = @"New belief name";
    testBelief.nameReference = newBeliefName;

    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson can't be updated for RI Update test");
    
    NSArray *people = [testModelManager readAll:ReferencePerson.class];
    ReferencePerson *retrieved = people[0];
    STAssertEqualObjects([[retrieved.oeuvre anyObject] nameReference], newOeuvreName, @"author RI update failed.");
    STAssertEqualObjects([[retrieved.belief anyObject] nameReference], newBeliefName, @"belief RI update failed.");
    
}

- (void)testPersonDeletion {
    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Belief/Text can't be created for Delete test");
    
    STAssertNoThrow([testModelManager delete:testPerson], @"ReferencePerson can't be deleted");
    
    NSArray *people = [testModelManager readAll:ReferencePerson.class];
    
    STAssertEquals(people.count, (NSUInteger) 0, @"ReferencePerson is still present after delete");
    
}

- (void)testPersonReferentialIntegrityDelete {
    STAssertNoThrow([testModelManager saveContext], @"ReferencePerson/Belief/Text can't be created for RI Delete test");
    
    testText.author = testPerson;
    testBelief.figurehead = testPerson;    

    testPerson.oeuvre = [NSSet setWithObject:testText];
    testPerson.belief = [NSSet setWithObject:testBelief];    
    
    STAssertNoThrow([testModelManager saveContext], @"ReferenceTexts/Belief relationships can't be created for RI Delete test");
    
    STAssertNoThrow([testModelManager delete:testPerson], @"ReferencePerson can't be deleted");
    
    NSArray *beliefs = [testModelManager readAll:ReferenceBelief.class];
    NSArray *texts = [testModelManager readAll:ReferenceText.class];
    
    STAssertEquals(beliefs.count, (NSUInteger) 1, @"ReferenceBelief should not have been cascade deleted");
    STAssertEquals(texts.count, (NSUInteger) 1, @"ReferenceText should not have been cascade deleted");
    
}

@end
