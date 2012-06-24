#import "ModelManager.h"
#import "Moral.h"
#import "Dilemma.h"
#import "Character.h"

@interface TestMoral: SenTestCase {
    ModelManager *testModelManager;
    Moral *testMoral;
    Dilemma *testDilemma;
    Dilemma *testDilemma2;
    
    NSString * imageNameMoral;
    NSString * colorMoral;
    NSString * displayNameMoral;
    NSString * longDescriptionMoral;
    NSString * component;
    NSString * shortDescriptionMoral;
    NSString * linkMoral;
    NSString * nameMoral;
    NSString * definitionMoral;
    
    NSString * rewardADilemma;
    NSString * choiceB;
    NSNumber * moodDilemma;
    NSString * displayNameDilemma;
    NSString * surrounding;
    NSString * nameDilemma;
    NSString * nameDilemma2;    
    NSString * rewardBDilemma;
    NSString * choiceA;
    NSNumber * enthusiasmDilemma;
    NSString * dilemmaText;

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
    
    rewardADilemma = @"rewardADilemma";
    choiceB = @"choiceB";
    moodDilemma  = [NSNumber numberWithFloat:1.0];
    displayNameDilemma = @"displayNameDilemma";
    surrounding = @"surrounding";
    nameDilemma = @"nameDilemma";
    nameDilemma2 = @"nameDilemma2";
    rewardBDilemma = @"rewardBDilemma";
    choiceA = @"choiceA";
    enthusiasmDilemma = [NSNumber numberWithFloat:1.0];
    dilemmaText = @"MoralText";
    
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
    
    testDilemma = [testModelManager create:Dilemma.class];
    testDilemma.rewardADilemma = rewardADilemma;
    testDilemma.choiceB = choiceB;
    testDilemma.moodDilemma = moodDilemma;
    testDilemma.displayNameDilemma = displayNameDilemma;
    testDilemma.surrounding = surrounding;
    testDilemma.nameDilemma = nameDilemma;
    testDilemma.rewardBDilemma = rewardBDilemma;
    testDilemma.choiceA = choiceA;
    testDilemma.enthusiasmDilemma = enthusiasmDilemma;
    testDilemma.dilemmaText = dilemmaText;
    
    testDilemma2 = [testModelManager create:Dilemma.class];
    testDilemma2.rewardADilemma = rewardADilemma;
    testDilemma2.choiceB = choiceB;
    testDilemma2.moodDilemma = moodDilemma;
    testDilemma2.displayNameDilemma = displayNameDilemma;
    testDilemma2.surrounding = surrounding;
    testDilemma2.nameDilemma = nameDilemma;
    testDilemma2.rewardBDilemma = rewardBDilemma;
    testDilemma2.choiceA = choiceA;
    testDilemma2.enthusiasmDilemma = enthusiasmDilemma;
    testDilemma2.dilemmaText = dilemmaText;

}

- (void)testMoralCanBeCreated {
    
    //testUserCollectable are created in setup    
    STAssertNoThrow([testModelManager saveContext], @"Moral can't be created.");
    
}

- (void)testMoralAccessorsAreFunctional {
    
    STAssertNoThrow([testModelManager saveContext], @"Moral can't be created for Accessor test.");
    
    NSArray *morals = [testModelManager readAll:Moral.class];
    
    STAssertEquals(morals.count, (NSUInteger) 1, @"There should only be 1 Moral in the context.");
    Moral *retrieved = [morals objectAtIndex: 0];
    
    STAssertEqualObjects(retrieved.imageNameMoral, imageNameMoral, @"imageNameMoral Getter/Setter failed.");
    STAssertEqualObjects(retrieved.colorMoral, colorMoral, @"colorMoral Getter/Setter failed.");
    STAssertEqualObjects(retrieved.displayNameMoral, displayNameMoral, @"displayNameMoral Getter/Setter failed.");    
    STAssertEqualObjects(retrieved.longDescriptionMoral, longDescriptionMoral, @"longDescriptionMoral Getter/Setter failed.");
    STAssertEqualObjects(retrieved.component, component, @"component Getter/Setter failed.");
    STAssertEqualObjects(retrieved.shortDescriptionMoral, shortDescriptionMoral, @"shortDescriptionMoral Getter/Setter failed.");
    STAssertEqualObjects(retrieved.linkMoral, linkMoral, @"linkMoral Getter/Setter failed.");
    STAssertEqualObjects(retrieved.nameMoral, nameMoral, @"nameMoral Getter/Setter failed.");
    STAssertEqualObjects(retrieved.definitionMoral, definitionMoral, @"definitionMoral Getter/Setter failed.");    
}

- (void)testMoralReferentialIntegrity {
    
    STAssertNoThrow([testModelManager saveContext], @"Moral/Dilemma can't be created for RI test");

    testMoral.dillemmaA = [NSSet setWithObject:testDilemma];
    testMoral.dillemmaB = [NSSet setWithObject:testDilemma2];
    
    STAssertNoThrow([testModelManager saveContext], @"Moral/Dilemma relationships can't be created for RI test");
            
    NSArray *morals = [testModelManager readAll:Moral.class];
    
    Moral *retrieved = [morals objectAtIndex: 0];
    STAssertEqualObjects([retrieved.dillemmaA anyObject], testDilemma, @"dilemmaA Relationship failed.");
    STAssertEqualObjects([retrieved.dillemmaB anyObject], testDilemma2, @"dilemmaB Relationship failed.");
    
}

- (void)testMoralReferentialIntegrityUpdate {
    STAssertNoThrow([testModelManager saveContext], @"Moral/Dilemma can't be created for RI Update test");
    
    testMoral.dillemmaA = [NSSet setWithObject:testDilemma];
    testMoral.dillemmaB = [NSSet setWithObject:testDilemma2];
    
    STAssertNoThrow([testModelManager saveContext], @"Moral/Dilemma relationships can't be created for RI Update test");
        
    NSString *newDilemmaName1 = @"New dilemma name 1";
    testDilemma.nameDilemma = newDilemmaName1;
    
    NSString *newDilemmaName2 = @"New dilemma name 2";
    testDilemma2.nameDilemma = newDilemmaName2;
    
    STAssertNoThrow([testModelManager saveContext], @"Dilemma can't be updated for RI Update test");
    
    NSArray *morals = [testModelManager readAll:Moral.class];
    
    Moral *retrieved = [morals objectAtIndex: 0];
    STAssertEqualObjects([retrieved.dillemmaA anyObject], testDilemma, @"dilemmaA Relationship failed.");
    STAssertEqualObjects([retrieved.dillemmaB anyObject], testDilemma2, @"dilemmaB Relationship failed.");
    
}

- (void)testMoralDeletion {
    STAssertNoThrow([testModelManager saveContext], @"Moral can't be created for Delete test");
    
    STAssertNoThrow([testModelManager delete:testMoral], @"Moral can't be deleted");
    
    NSArray *morals = [testModelManager readAll:Moral.class];
    
    STAssertEquals(morals.count, (NSUInteger) 0, @"Moral is still present after delete");
    
}

- (void)testMoralReferentialIntegrityDelete {
    STAssertNoThrow([testModelManager saveContext], @"Moral/Dilemma can't be created for RI Delete test");
    
    testMoral.dillemmaA = [NSSet setWithObject:testDilemma];
    testMoral.dillemmaB = [NSSet setWithObject:testDilemma2];
    
    STAssertNoThrow([testModelManager saveContext], @"Moral/Dilemma relationships can't be created for RI Delete test");
    
    STAssertNoThrow([testModelManager delete:testMoral], @"Moral can't be deleted");
    
    NSArray *dilemmas = [testModelManager readAll:Dilemma.class];
    
    STAssertEquals(dilemmas.count, (NSUInteger) 0, @"Both Dilemmas should have been cascade deleted");    
    
}

- (void)testMoralWithoutRequiredAttributes {
    Dilemma *testMoralBad = [testModelManager create:Moral.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testMoralBad.class];
    
    STAssertThrows([testModelManager saveContext], errorMessage);
}

- (void)testMoralDefaultValues {
    Moral *testMoralDefault = [testModelManager create:Moral.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testMoralDefault.class];
    
    NSString *defaultLinkMoral = @"defaultLinkMoral";
        
    testMoralDefault.linkMoral = defaultLinkMoral;
    testMoralDefault.colorMoral = @"colorMoral";
    
    STAssertNoThrow([testModelManager saveContext], errorMessage);
    
    NSError *error = nil;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"linkMoral == %@", defaultLinkMoral];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(Moral.class)];
    request.predicate = searchPredicate;
    NSArray *userChoices = [[testModelManager managedObjectContext] executeFetchRequest:request error:&error];
    
    Moral *retrieved = [userChoices objectAtIndex: 0];
    STAssertEqualObjects(retrieved.shortDescriptionMoral, @"Virtue", @"shortDescriptionMoral default value failed.");
    STAssertEqualObjects(retrieved.nameMoral, @"Moral", @"nameMoral default value failed.");
    STAssertEqualObjects(retrieved.longDescriptionMoral, @"Moral", @"longDescriptionMoral default value failed.");
    STAssertEqualObjects(retrieved.imageNameMoral, @"card-nothing", @"imageNameMoral default value failed.");
    STAssertEqualObjects(retrieved.component, @"NA", @"component default value failed.");
    
}

@end