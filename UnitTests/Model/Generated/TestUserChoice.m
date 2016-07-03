#import "ModelManager.h"
#import "UserChoice.h"

@interface TestUserChoice : XCTestCase {
    ModelManager *testModelManager;
    UserChoice *testChoice;

    NSString *entryShortDescription;
    NSNumber *entryIsGood;
    NSString *entryKey;
    NSString *entryLongDescription;
    NSNumber *entrySeverity;
    NSDate *entryCreationDate;
    
    NSDate *entryModificationDate;
    NSNumber *choiceInfluence;
    NSString *choiceConsequences;
    NSString *choiceJustification;
    NSString *choiceMoral;
    NSNumber *choiceWeight;

}

@end

@implementation TestUserChoice

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    
    entryShortDescription = @"entryShortDescription";
    entryIsGood = @1;
    entryKey = @"entryKey";
    entryLongDescription = @"entryLongDescription";
    entrySeverity =@5.0f;
    entryCreationDate = [NSDate date];

    entryModificationDate = [NSDate date];
    choiceInfluence = @2;
    choiceConsequences = @"choiceConsequences";
    choiceJustification = @"choiceJustification";
    choiceMoral = @"choiceMoral";
    choiceWeight = @5.0f;    
    
    testChoice = [testModelManager create:UserChoice.class];
    
    testChoice.entryShortDescription = entryShortDescription;
    testChoice.entryIsGood = entryIsGood;
    testChoice.entryKey = entryKey;
    testChoice.entryLongDescription = entryLongDescription;
    testChoice.entrySeverity = entrySeverity;
    testChoice.entryCreationDate = entryCreationDate;
    
    testChoice.entryModificationDate = entryModificationDate;
    testChoice.choiceInfluence = choiceInfluence;
    testChoice.choiceConsequences = choiceConsequences;
    testChoice.choiceJustification = choiceJustification;
    testChoice.choiceMoral = choiceMoral;
    testChoice.choiceWeight = choiceWeight; 
    
}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testUserChoiceCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    XCTAssertNoThrow([testModelManager saveContext], @"UserChoice can't be created");
    
}

- (void)testUserChoiceValidatesAttributes {
    
    testChoice.choiceInfluence = @0;    
//    XCTAssertThrows([testModelManager saveContext], @"choiceInfluence lower bound validation failed.");
    
    testChoice.choiceInfluence = @6;    
//    XCTAssertThrows([testModelManager saveContext], @"choiceInfluence upper bound validation failed.");
    
    testChoice.entrySeverity = @-6;    
//    XCTAssertThrows([testModelManager saveContext], @"entrySeverity lower bound validation failed.");
    
    testChoice.entrySeverity = @6;    
//    XCTAssertThrows([testModelManager saveContext], @"entrySeverity upper bound validation failed.");
    
}

- (void)testUserChoiceAccessorsAreFunctional {
    
    XCTAssertNoThrow([testModelManager saveContext], @"UserChoice can't be created for Accessor test");
    
    NSArray *userChoices = [testModelManager readAll:UserChoice.class];
        
    XCTAssertEqual(userChoices.count, (NSUInteger) 1, @"There should only be 1 RefenceText in the context.");
    UserChoice *retrieved = userChoices[0];
    XCTAssertEqualObjects(retrieved.entryShortDescription, entryShortDescription, @"entryShortDescription Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.entryIsGood, entryIsGood, @"entryIsGood Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.entryKey, entryKey, @"entryKey Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.entryLongDescription, entryLongDescription, @"entryLongDescription Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.entrySeverity, entrySeverity, @"entrySeverity Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.entryCreationDate, entryCreationDate, @"entryCreationDate Getter/Setter failed.");
    
    XCTAssertEqualObjects(retrieved.entryModificationDate, entryModificationDate, @"entryModificationDate Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.choiceInfluence, choiceInfluence, @"choiceInfluence Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.choiceConsequences, choiceConsequences, @"choiceConsequences Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.choiceJustification, choiceJustification, @"choiceJustification Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.choiceMoral, choiceMoral, @"choiceMoral Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.choiceWeight, choiceWeight, @"choiceWeight Getter/Setter failed.");
    
}

- (void)testUserChoiceDeletion {
    XCTAssertNoThrow([testModelManager saveContext], @"UserChoice can't be created for Delete test");
    
    XCTAssertNoThrow([testModelManager deleteReadWrite:testChoice], @"UserChoice can't be deleted");
    
    NSArray *userChoices = [testModelManager readAll:UserChoice.class];
    
    XCTAssertEqual(userChoices.count, (NSUInteger) 0, @"UserChoice is still present after delete");
    
}

- (void)testUserChoiceWithoutRequiredAttributes {
    UserChoice *testUserChoiceBad = [testModelManager create:UserChoice.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testUserChoiceBad.class];

//    XCTAssertThrows([testModelManager saveContext], errorMessage);
}

- (void)testUserChoiceDefaultValues {
    UserChoice *testUserChoiceDefault = [testModelManager create:UserChoice.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testUserChoiceDefault.class];

    testUserChoiceDefault.entryCreationDate = entryCreationDate;
    testUserChoiceDefault.entryModificationDate = entryModificationDate;
    
//    XCTAssertNoThrow([testModelManager saveContext], errorMessage);
    
    NSError *error = nil;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"entryKey == %@", @"0"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(UserChoice.class)];
    request.predicate = searchPredicate;
    NSArray *userChoices = [[testModelManager readWriteManagedObjectContext] executeFetchRequest:request error:&error];
//    NSArray *userChoices = [testModelManager read:UserChoice.class withKey:@"entryKey" andValue:@"0"];
    
    UserChoice *retrieved = userChoices[0];
    XCTAssertEqualObjects(retrieved.entryShortDescription, @"0", @"entryShortDescription default value failed.");
    XCTAssertEqualObjects(retrieved.entryIsGood, @1, @"entryIsGood default value failed.");
    XCTAssertEqualObjects(retrieved.entryKey, @"0", @"entryKey default value failed.");
    XCTAssertEqualObjects(retrieved.entryLongDescription, @"0", @"entryLongDescription default value failed.");
    XCTAssertEqualObjects(retrieved.entrySeverity, @0, @"entrySeverity default value failed.");
    
    XCTAssertEqualObjects(retrieved.choiceInfluence, @1, @"choiceInfluence default value failed.");
    XCTAssertEqualObjects(retrieved.choiceConsequences, @"0", @"choiceConsequences default value failed.");
    XCTAssertEqualObjects(retrieved.choiceJustification, @"0", @"choiceJustification default value failed.");
    XCTAssertEqualObjects(retrieved.choiceMoral, @"NA", @"choiceMoral default value failed.");
    XCTAssertEqualObjects(retrieved.choiceWeight, [NSNumber numberWithFloat:0], @"choiceWeight default value failed.");

}

@end
