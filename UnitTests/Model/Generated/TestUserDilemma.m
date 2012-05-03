#import "TestCoreDataStack.h"
#import "UserDilemma.h"

@interface TestUserDilemma : SenTestCase {
    TestCoreDataStack *coreData;
    UserDilemma *testUserDilemma;

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

@implementation TestUserDilemma

- (void)setUp {
    coreData = [[TestCoreDataStack alloc] initWithManagedObjectModel:@"UserData"];
    
    entryShortDescription = @"entryShortDescription";
    entryIsGood = [NSNumber numberWithInt:1];
    entryKey = @"entryKey";
    entryLongDescription = @"entryLongDescription";
    entrySeverity =[NSNumber numberWithFloat:5];
    entryCreationDate = [NSDate date];
    
    testUserDilemma = [coreData insert:UserDilemma.class];
    
    testUserDilemma.entryShortDescription = entryShortDescription;
    testUserDilemma.entryIsGood = entryIsGood;
    testUserDilemma.entryKey = entryKey;
    testUserDilemma.entryLongDescription = entryLongDescription;
    testUserDilemma.entrySeverity = entrySeverity;
    testUserDilemma.entryCreationDate = entryCreationDate;
        
}

- (void)testUserDilemmaCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    STAssertNoThrow([coreData save], @"UserDilemma can't be created");
    
}

- (void)testUserDilemmaValidatesAttributes {
        
    testUserDilemma.entrySeverity = [NSNumber numberWithInt:-6];    
    STAssertThrows([coreData save], @"entrySeverity lower bound validation failed.");
    
    testUserDilemma.entrySeverity = [NSNumber numberWithInt:6];    
    STAssertThrows([coreData save], @"entrySeverity upper bound validation failed.");
    
}

- (void)testUserDilemmaAccessorsAreFunctional {
    
    STAssertNoThrow([coreData save], @"UserDilemma can't be created for Accessor test");
    
    NSArray *userDilemmas = [coreData fetch:UserDilemma.class];
        
    STAssertEquals(userDilemmas.count, (NSUInteger) 1, @"There should only be 1 RefenceText in the context.");
    UserDilemma *retrieved = [userDilemmas objectAtIndex: 0];
    STAssertEqualObjects(retrieved.entryShortDescription, entryShortDescription, @"entryShortDescription Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entryIsGood, entryIsGood, @"entryIsGood Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entryKey, entryKey, @"entryKey Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entryLongDescription, entryLongDescription, @"entryLongDescription Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entrySeverity, entrySeverity, @"entrySeverity Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entryCreationDate, entryCreationDate, @"entryCreationDate Getter/Setter failed.");
}

- (void)testUserDilemmaDeletion {
    STAssertNoThrow([coreData save], @"UserDilemma can't be created for Delete test");
    
    STAssertNoThrow([coreData delete:testUserDilemma], @"UserDilemma can't be deleted");
    
    NSArray *userDilemmas = [coreData fetch:UserDilemma.class];
    
    STAssertEquals(userDilemmas.count, (NSUInteger) 0, @"UserDilemma is still present after delete");
    
}

- (void)testUserDilemmaWithoutRequiredAttributes {
    UserDilemma *testUserDilemmaBad = [coreData insert:UserDilemma.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testUserDilemmaBad.class];

    testUserDilemma.entryCreationDate = nil;
    STAssertThrows([coreData save], errorMessage);
}

- (void)testUserDilemmaDefaultValues {
    UserDilemma *testUserDilemmaDefault = [coreData insert:UserDilemma.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testUserDilemmaDefault.class];

    testUserDilemmaDefault.entryCreationDate = entryCreationDate;
    
    STAssertNoThrow([coreData save], errorMessage);
    
    NSError *error = nil;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"entryKey == %@", @"0"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(UserDilemma.class)];
    request.predicate = searchPredicate;
    NSArray *userDilemmas = [[coreData managedObjectContext] executeFetchRequest:request error:&error];

    UserDilemma *retrieved = [userDilemmas objectAtIndex: 0];
    STAssertEqualObjects(retrieved.entryShortDescription, @"0", @"entryShortDescription default value failed.");
    STAssertEquals(retrieved.entryIsGood, [NSNumber numberWithInt:1], @"entryIsGood default value failed.");
    STAssertEqualObjects(retrieved.entryKey, @"0", @"entryKey default value failed.");
    STAssertEqualObjects(retrieved.entryLongDescription, @"0", @"entryLongDescription default value failed.");
    STAssertEqualObjects(retrieved.entrySeverity, [NSNumber numberWithInt:0], @"entrySeverity default value failed.");
    
}

@end
