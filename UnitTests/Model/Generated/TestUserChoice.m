#import "ModelManager.h"
#import "UserChoice.h"

@interface TestUserChoice : SenTestCase {
    ModelManager *testModelManager;
    UserChoice *testChoice;

    NSString * entryShortDescription;
    NSNumber * entryIsGood;
    NSString * entryKey;
    NSString * entryLongDescription;
    NSNumber * entrySeverity;
    NSDate * entryCreationDate;
    
    NSDate * entryModificationDate;
    NSNumber * choiceInfluence;
    NSString * choiceConsequences;
    NSString * choiceJustification;
    NSString * choiceMoral;
    NSNumber * choiceWeight;

}

@end

@implementation TestUserChoice

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithBundle:[NSBundle bundleForClass:self.class] andIsInMemory:YES];
    
    entryShortDescription = @"entryShortDescription";
    entryIsGood = [NSNumber numberWithInt:1];
    entryKey = @"entryKey";
    entryLongDescription = @"entryLongDescription";
    entrySeverity =[NSNumber numberWithFloat:5];
    entryCreationDate = [NSDate date];

    entryModificationDate = [NSDate date];
    choiceInfluence = [NSNumber numberWithInt:2];
    choiceConsequences = @"choiceConsequences";
    choiceJustification = @"choiceJustification";
    choiceMoral = @"choiceMoral";
    choiceWeight = [NSNumber numberWithFloat:5];    
    
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

- (void)testUserChoiceCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    STAssertNoThrow([testModelManager saveContext], @"UserChoice can't be created");
    
}

- (void)testUserChoiceValidatesAttributes {
    
    testChoice.choiceInfluence = [NSNumber numberWithInt:0];    
    STAssertThrows([testModelManager saveContext], @"choiceInfluence lower bound validation failed.");
    
    testChoice.choiceInfluence = [NSNumber numberWithInt:6];    
    STAssertThrows([testModelManager saveContext], @"choiceInfluence upper bound validation failed.");
    
    testChoice.entrySeverity = [NSNumber numberWithInt:-6];    
    STAssertThrows([testModelManager saveContext], @"entrySeverity lower bound validation failed.");
    
    testChoice.entrySeverity = [NSNumber numberWithInt:6];    
    STAssertThrows([testModelManager saveContext], @"entrySeverity upper bound validation failed.");
    
}

- (void)testUserChoiceAccessorsAreFunctional {
    
    STAssertNoThrow([testModelManager saveContext], @"UserChoice can't be created for Accessor test");
    
    NSArray *userChoices = [testModelManager readAll:UserChoice.class];
        
    STAssertEquals(userChoices.count, (NSUInteger) 1, @"There should only be 1 RefenceText in the context.");
    UserChoice *retrieved = [userChoices objectAtIndex: 0];
    STAssertEqualObjects(retrieved.entryShortDescription, entryShortDescription, @"entryShortDescription Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entryIsGood, entryIsGood, @"entryIsGood Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entryKey, entryKey, @"entryKey Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entryLongDescription, entryLongDescription, @"entryLongDescription Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entrySeverity, entrySeverity, @"entrySeverity Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entryCreationDate, entryCreationDate, @"entryCreationDate Getter/Setter failed.");
    
    STAssertEqualObjects(retrieved.entryModificationDate, entryModificationDate, @"entryModificationDate Getter/Setter failed.");
    STAssertEqualObjects(retrieved.choiceInfluence, choiceInfluence, @"choiceInfluence Getter/Setter failed.");
    STAssertEqualObjects(retrieved.choiceConsequences, choiceConsequences, @"choiceConsequences Getter/Setter failed.");
    STAssertEqualObjects(retrieved.choiceJustification, choiceJustification, @"choiceJustification Getter/Setter failed.");
    STAssertEqualObjects(retrieved.choiceMoral, choiceMoral, @"choiceMoral Getter/Setter failed.");
    STAssertEqualObjects(retrieved.choiceWeight, choiceWeight, @"choiceWeight Getter/Setter failed.");
    
}

- (void)testUserChoiceDeletion {
    STAssertNoThrow([testModelManager saveContext], @"UserChoice can't be created for Delete test");
    
    STAssertNoThrow([testModelManager delete:testChoice], @"UserChoice can't be deleted");
    
    NSArray *userChoices = [testModelManager readAll:UserChoice.class];
    
    STAssertEquals(userChoices.count, (NSUInteger) 0, @"UserChoice is still present after delete");
    
}

- (void)testUserChoiceWithoutRequiredAttributes {
    UserChoice *testUserChoiceBad = [testModelManager create:UserChoice.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testUserChoiceBad.class];

    STAssertThrows([testModelManager saveContext], errorMessage);
}

- (void)testUserChoiceDefaultValues {
    UserChoice *testUserChoiceDefault = [testModelManager create:UserChoice.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testUserChoiceDefault.class];

    testUserChoiceDefault.entryCreationDate = entryCreationDate;
    testUserChoiceDefault.entryModificationDate = entryModificationDate;
    
    STAssertNoThrow([testModelManager saveContext], errorMessage);
    
    NSError *error = nil;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"entryKey == %@", @"0"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(UserChoice.class)];
    request.predicate = searchPredicate;
    NSArray *userChoices = [[testModelManager managedObjectContext] executeFetchRequest:request error:&error];

    UserChoice *retrieved = [userChoices objectAtIndex: 0];
    STAssertEqualObjects(retrieved.entryShortDescription, @"0", @"entryShortDescription default value failed.");
    STAssertEqualObjects(retrieved.entryIsGood, [NSNumber numberWithInt:1], @"entryIsGood default value failed.");
    STAssertEqualObjects(retrieved.entryKey, @"0", @"entryKey default value failed.");
    STAssertEqualObjects(retrieved.entryLongDescription, @"0", @"entryLongDescription default value failed.");
    STAssertEqualObjects(retrieved.entrySeverity, [NSNumber numberWithInt:0], @"entrySeverity default value failed.");
    
    STAssertEqualObjects(retrieved.choiceInfluence, [NSNumber numberWithInt:1], @"choiceInfluence default value failed.");
    STAssertEqualObjects(retrieved.choiceConsequences, @"0", @"choiceConsequences default value failed.");
    STAssertEqualObjects(retrieved.choiceJustification, @"0", @"choiceJustification default value failed.");
    STAssertEqualObjects(retrieved.choiceMoral, @"NA", @"choiceMoral default value failed.");
    STAssertEqualObjects(retrieved.choiceWeight, [NSNumber numberWithFloat:0], @"choiceWeight default value failed.");

}

@end
