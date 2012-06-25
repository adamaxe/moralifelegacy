#import "ModelManager.h"
#import "UserDilemma.h"

@interface TestUserDilemma : SenTestCase {
    ModelManager *testModelManager;
    UserDilemma *testUserDilemma;

    NSString * entryShortDescription;
    NSNumber * entryIsGood;
    NSString * entryKey;
    NSString * entryLongDescription;
    NSNumber * entrySeverity;
    NSDate * entryCreationDate;

}

@end

@implementation TestUserDilemma

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
        
    entryShortDescription = @"entryShortDescription";
    entryIsGood = [NSNumber numberWithInt:1];
    entryKey = @"entryKey";
    entryLongDescription = @"entryLongDescription";
    entrySeverity =[NSNumber numberWithFloat:5];
    entryCreationDate = [NSDate date];
    
    testUserDilemma = [testModelManager create:UserDilemma.class];
    
    testUserDilemma.entryShortDescription = entryShortDescription;
    testUserDilemma.entryIsGood = entryIsGood;
    testUserDilemma.entryKey = entryKey;
    testUserDilemma.entryLongDescription = entryLongDescription;
    testUserDilemma.entrySeverity = entrySeverity;
    testUserDilemma.entryCreationDate = entryCreationDate;
        
}

- (void)testUserDilemmaCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    STAssertNoThrow([testModelManager saveContext], @"UserDilemma can't be created");
    
}

- (void)testUserDilemmaValidatesAttributes {
        
    testUserDilemma.entrySeverity = [NSNumber numberWithInt:-6];    
    STAssertThrows([testModelManager saveContext], @"entrySeverity lower bound validation failed.");
    
    testUserDilemma.entrySeverity = [NSNumber numberWithInt:6];    
    STAssertThrows([testModelManager saveContext], @"entrySeverity upper bound validation failed.");
    
}

- (void)testUserDilemmaAccessorsAreFunctional {
    
    STAssertNoThrow([testModelManager saveContext], @"UserDilemma can't be created for Accessor test");
    
    NSArray *userDilemmas = [testModelManager readAll:UserDilemma.class];
        
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
    STAssertNoThrow([testModelManager saveContext], @"UserDilemma can't be created for Delete test");
    
    STAssertNoThrow([testModelManager delete:testUserDilemma], @"UserDilemma can't be deleted");
    
    NSArray *userDilemmas = [testModelManager readAll:UserDilemma.class];
    
    STAssertEquals(userDilemmas.count, (NSUInteger) 0, @"UserDilemma is still present after delete");
    
}

- (void)testUserDilemmaWithoutRequiredAttributes {
    UserDilemma *testUserDilemmaBad = [testModelManager create:UserDilemma.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testUserDilemmaBad.class];

    testUserDilemma.entryCreationDate = nil;
    STAssertThrows([testModelManager saveContext], errorMessage);
}

- (void)testUserDilemmaDefaultValues {
    UserDilemma *testUserDilemmaDefault = [testModelManager create:UserDilemma.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testUserDilemmaDefault.class];

    testUserDilemmaDefault.entryCreationDate = entryCreationDate;
    
    STAssertNoThrow([testModelManager saveContext], errorMessage);
    
    NSError *error = nil;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"entryKey == %@", @"0"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(UserDilemma.class)];
    request.predicate = searchPredicate;
    NSArray *userDilemmas = [[testModelManager managedObjectContext] executeFetchRequest:request error:&error];

    UserDilemma *retrieved = [userDilemmas objectAtIndex: 0];
    STAssertEqualObjects(retrieved.entryShortDescription, @"0", @"entryShortDescription default value failed.");
    STAssertEqualObjects(retrieved.entryIsGood, [NSNumber numberWithInt:1], @"entryIsGood default value failed.");
    STAssertEqualObjects(retrieved.entryKey, @"0", @"entryKey default value failed.");
    STAssertEqualObjects(retrieved.entryLongDescription, @"0", @"entryLongDescription default value failed.");
    STAssertEqualObjects(retrieved.entrySeverity, [NSNumber numberWithInt:0], @"entrySeverity default value failed.");
    
}

@end
