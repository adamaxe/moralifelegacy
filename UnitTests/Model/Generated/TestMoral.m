#import "ModelManager.h"
#import "TestModelHelper.h"
#import "Moral.h"
#import "Dilemma.h"
#import "Character.h"

@interface TestMoral: XCTestCase {
    ModelManager *testModelManager;
    Moral *testMoral;
    Dilemma *testDilemma;
    Dilemma *testDilemma2;
    
    NSString *imageNameMoral;
    NSString *colorMoral;
    NSString *displayNameMoral;
    NSString *longDescriptionMoral;
    NSString *component;
    NSString *shortDescriptionMoral;
    NSString *linkMoral;
    NSString *nameMoral;
    NSString *definitionMoral;
    
}

@end

@implementation TestMoral

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    
    imageNameMoral = @"imageName";
    colorMoral = @"color";
    displayNameMoral = @"displayName";
    longDescriptionMoral = @"longDescription";
    component = @"component";
    shortDescriptionMoral = @"shortDescription";
    linkMoral = @"link";
    nameMoral = @"name";
    definitionMoral = @"definition"; 
    
    testMoral = [testModelManager create:Moral.class];
    
    testMoral.imageNameMoral = imageNameMoral;
    testMoral.colorMoral = colorMoral;
    testMoral.displayNameMoral = displayNameMoral;
    testMoral.longDescriptionMoral = longDescriptionMoral;
    testMoral.component = component;
    testMoral.shortDescriptionMoral = shortDescriptionMoral;
    testMoral.linkMoral = linkMoral;
    testMoral.nameMoral = nameMoral;
    testMoral.definitionMoral = definitionMoral;
    
    testDilemma = [TestModelHelper createDilemmaWithName:@"nameDilemma" withModelManager:testModelManager];
    testDilemma2 = [TestModelHelper createDilemmaWithName:@"nameDilemma2" withModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testMoralCanBeCreated {
    
    //testUserCollectable are created in setup    
    XCTAssertNoThrow([testModelManager saveContext], @"Moral can't be created.");
    
}

- (void)testMoralAccessorsAreFunctional {
    
    XCTAssertNoThrow([testModelManager saveContext], @"Moral can't be created for Accessor test.");
    
    NSArray *morals = [testModelManager readAll:Moral.class];
    
    XCTAssertEqual(morals.count, (NSUInteger) 1, @"There should only be 1 Moral in the context.");
    Moral *retrieved = morals[0];
    
    XCTAssertEqualObjects(retrieved.imageNameMoral, imageNameMoral, @"imageNameMoral Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.colorMoral, colorMoral, @"colorMoral Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.displayNameMoral, displayNameMoral, @"displayNameMoral Getter/Setter failed.");    
    XCTAssertEqualObjects(retrieved.longDescriptionMoral, longDescriptionMoral, @"longDescriptionMoral Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.component, component, @"component Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.shortDescriptionMoral, shortDescriptionMoral, @"shortDescriptionMoral Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.linkMoral, linkMoral, @"linkMoral Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.nameMoral, nameMoral, @"nameMoral Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.definitionMoral, definitionMoral, @"definitionMoral Getter/Setter failed.");    
}

- (void)testMoralReferentialIntegrity {
    
    XCTAssertNoThrow([testModelManager saveContext], @"Moral/Dilemma can't be created for RI test");

    testMoral.dillemmaA = [NSSet setWithObject:testDilemma];
    testMoral.dillemmaB = [NSSet setWithObject:testDilemma2];
    
    XCTAssertNoThrow([testModelManager saveContext], @"Moral/Dilemma relationships can't be created for RI test");
            
    NSArray *morals = [testModelManager readAll:Moral.class];
    
    Moral *retrieved = morals[0];
    XCTAssertEqualObjects([retrieved.dillemmaA anyObject], testDilemma, @"dilemmaA Relationship failed.");
    XCTAssertEqualObjects([retrieved.dillemmaB anyObject], testDilemma2, @"dilemmaB Relationship failed.");
    
}

- (void)testMoralReferentialIntegrityUpdate {
    XCTAssertNoThrow([testModelManager saveContext], @"Moral/Dilemma can't be created for RI Update test");
    
    testMoral.dillemmaA = [NSSet setWithObject:testDilemma];
    testMoral.dillemmaB = [NSSet setWithObject:testDilemma2];

    XCTAssertNoThrow([testModelManager saveContext], @"Moral/Dilemma relationships can't be created for RI Update test");
        
    NSString *newDilemmaName1 = @"New dilemma name 1";
    testDilemma.nameDilemma = newDilemmaName1;
    
    NSString *newDilemmaName2 = @"New dilemma name 2";
    testDilemma2.nameDilemma = newDilemmaName2;
    
    XCTAssertNoThrow([testModelManager saveContext], @"Dilemma can't be updated for RI Update test");
    
    NSArray *morals = [testModelManager readAll:Moral.class];
    
    Moral *retrieved = morals[0];
    XCTAssertEqualObjects([retrieved.dillemmaA anyObject], testDilemma, @"dilemmaA Relationship failed.");
    XCTAssertEqualObjects([retrieved.dillemmaB anyObject], testDilemma2, @"dilemmaB Relationship failed.");
    
}

- (void)testMoralDeletion {
    XCTAssertNoThrow([testModelManager saveContext], @"Moral can't be created for Delete test");
    
    XCTAssertNoThrow([testModelManager delete:testMoral], @"Moral can't be deleted");
    
    NSArray *morals = [testModelManager readAll:Moral.class];
    
    XCTAssertEqual(morals.count, (NSUInteger) 0, @"Moral is still present after delete");
    
}

- (void)testMoralReferentialIntegrityDelete {
    XCTAssertNoThrow([testModelManager saveContext], @"Moral/Dilemma can't be created for RI Delete test");
    
    testMoral.dillemmaA = [NSSet setWithObject:testDilemma];
    testMoral.dillemmaB = [NSSet setWithObject:testDilemma2];
    
    XCTAssertNoThrow([testModelManager saveContext], @"Moral/Dilemma relationships can't be created for RI Delete test");
    
    XCTAssertNoThrow([testModelManager delete:testMoral], @"Moral can't be deleted");
    
    NSArray *dilemmas = [testModelManager readAll:Dilemma.class];
    
    XCTAssertEqual(dilemmas.count, (NSUInteger) 0, @"Both Dilemmas should have been cascade deleted");    
    
}

- (void)testMoralWithoutRequiredAttributes {
    Dilemma *testMoralBad = [testModelManager create:Moral.class];
    
    XCTAssertThrows([testModelManager saveContext]);
    XCTAssertNotNil(testMoralBad);
}

- (void)testMoralDefaultValues {
    Moral *testMoralDefault = [testModelManager create:Moral.class];
    
    NSString *defaultLinkMoral = @"defaultLinkMoral";
        
    testMoralDefault.linkMoral = defaultLinkMoral;
    testMoralDefault.colorMoral = @"colorMoral";
    
    XCTAssertNoThrow([testModelManager saveContext]);
    
    NSError *error = nil;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"linkMoral == %@", defaultLinkMoral];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(Moral.class)];
    request.predicate = searchPredicate;
    NSArray *userChoices = [[testModelManager managedObjectContext] executeFetchRequest:request error:&error];
    
    Moral *retrieved = userChoices[0];
    XCTAssertEqualObjects(retrieved.shortDescriptionMoral, @"Virtue", @"shortDescriptionMoral default value failed.");
    XCTAssertEqualObjects(retrieved.nameMoral, @"Moral", @"nameMoral default value failed.");
    XCTAssertEqualObjects(retrieved.longDescriptionMoral, @"Moral", @"longDescriptionMoral default value failed.");
    XCTAssertEqualObjects(retrieved.imageNameMoral, @"card-nothing", @"imageNameMoral default value failed.");
    XCTAssertEqualObjects(retrieved.component, @"NA", @"component default value failed.");
    
}

@end
