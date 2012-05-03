#import "TestCoreDataStack.h"
#import "UserChoice.h"

@interface TestUserChoice : SenTestCase {
    TestCoreDataStack *coreData;
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
    coreData = [[TestCoreDataStack alloc] initWithManagedObjectModel:@"UserData"];
    
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
    
    testChoice = [coreData insert:UserChoice.class];
    
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
    STAssertNoThrow([coreData save], @"UserChoice can't be created");
    
}

- (void)testUserChoiceValidatesChoiceWeight {
    
    testChoice.choiceInfluence = [NSNumber numberWithInt:0];    
    STAssertThrows([coreData save], @"choiceInfluence lower bound validation failed.");
    
    testChoice.choiceInfluence = [NSNumber numberWithInt:6];    
    STAssertThrows([coreData save], @"choiceInfluence upper bound validation failed.");
    
    testChoice.entrySeverity = [NSNumber numberWithInt:-6];    
    STAssertThrows([coreData save], @"entrySeverity lower bound validation failed.");
    
    testChoice.entrySeverity = [NSNumber numberWithInt:6];    
    STAssertThrows([coreData save], @"entrySeverity upper bound validation failed.");
    
}

- (void)testUserChoiceAccessorsAreFunctional {
    
    STAssertNoThrow([coreData save], @"UserChoice can't be created for Accessor test");
    
    NSArray *userChoices = [coreData fetch:UserChoice.class];
        
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
    STAssertNoThrow([coreData save], @"UserChoice can't be created for Delete test");
    
    STAssertNoThrow([coreData delete:testChoice], @"UserChoice can't be deleted");
    
    NSArray *userChoices = [coreData fetch:UserChoice.class];
    
    STAssertEquals(userChoices.count, (NSUInteger) 0, @"UserChoice is still present after delete");
    
}

- (void)testUserChoiceWithoutRequiredAttributes {
    UserChoice *testUserChoiceBad = [coreData insert:UserChoice.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testUserChoiceBad.class];

    STAssertThrows([coreData save], errorMessage);
}

@end
