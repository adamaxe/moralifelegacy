#import "ModelManager.h"
#import "UserDilemma.h"

@interface TestUserDilemma :XCTestCase {
    ModelManager *testModelManager;
    UserDilemma *testUserDilemma;

    NSString *entryShortDescription;
    NSNumber *entryIsGood;
    NSString *entryKey;
    NSString *entryLongDescription;
    NSNumber *entrySeverity;
    NSDate *entryCreationDate;

}

@end

@implementation TestUserDilemma

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
        
    entryShortDescription = @"entryShortDescription";
    entryIsGood = @1;
    entryKey = @"entryKey";
    entryLongDescription = @"entryLongDescription";
    entrySeverity =@5.0f;
    entryCreationDate = [NSDate date];
    
    testUserDilemma = [testModelManager create:UserDilemma.class];
    
    testUserDilemma.entryShortDescription = entryShortDescription;
    testUserDilemma.entryIsGood = entryIsGood;
    testUserDilemma.entryKey = entryKey;
    testUserDilemma.entryLongDescription = entryLongDescription;
    testUserDilemma.entrySeverity = entrySeverity;
    testUserDilemma.entryCreationDate = entryCreationDate;
        
}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testUserDilemmaCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    XCTAssertNoThrow([testModelManager saveContext], @"UserDilemma can't be created");
    
}

- (void)testUserDilemmaValidatesAttributes {
        
    testUserDilemma.entrySeverity = @-6;    
    XCTAssertThrows([testModelManager saveContext], @"entrySeverity lower bound validation failed.");
    
    testUserDilemma.entrySeverity = @6;    
    XCTAssertThrows([testModelManager saveContext], @"entrySeverity upper bound validation failed.");
    
}

- (void)testUserDilemmaAccessorsAreFunctional {
    
    XCTAssertNoThrow([testModelManager saveContext], @"UserDilemma can't be created for Accessor test");
    
    NSArray *userDilemmas = [testModelManager readAll:UserDilemma.class];
        
    XCTAssertEqual(userDilemmas.count, (NSUInteger) 1, @"There should only be 1 RefenceText in the context.");
    UserDilemma *retrieved = userDilemmas[0];
    XCTAssertEqualObjects(retrieved.entryShortDescription, entryShortDescription, @"entryShortDescription Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.entryIsGood, entryIsGood, @"entryIsGood Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.entryKey, entryKey, @"entryKey Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.entryLongDescription, entryLongDescription, @"entryLongDescription Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.entrySeverity, entrySeverity, @"entrySeverity Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.entryCreationDate, entryCreationDate, @"entryCreationDate Getter/Setter failed.");
}

- (void)testUserDilemmaDeletion {
    XCTAssertNoThrow([testModelManager saveContext], @"UserDilemma can't be created for Delete test");
    
    XCTAssertNoThrow([testModelManager deleteReadWrite:testUserDilemma], @"UserDilemma can't be deleted");
    
    NSArray *userDilemmas = [testModelManager readAll:UserDilemma.class];
    
    XCTAssertEqual(userDilemmas.count, (NSUInteger) 0, @"UserDilemma is still present after delete");
    
}

- (void)testUserDilemmaWithoutRequiredAttributes {
    UserDilemma *testUserDilemmaBad = [testModelManager create:UserDilemma.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testUserDilemmaBad.class];

    testUserDilemma.entryCreationDate = nil;
    XCTAssertThrows([testModelManager saveContext], errorMessage);
}

- (void)testUserDilemmaDefaultValues {
    UserDilemma *testUserDilemmaDefault = [testModelManager create:UserDilemma.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testUserDilemmaDefault.class];

    testUserDilemmaDefault.entryCreationDate = entryCreationDate;
    
    XCTAssertNoThrow([testModelManager saveContext], errorMessage);
    
    NSError *error = nil;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"entryKey == %@", @"0"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(UserDilemma.class)];
    request.predicate = searchPredicate;
    NSArray *userDilemmas = [[testModelManager readWriteManagedObjectContext] executeFetchRequest:request error:&error];

    UserDilemma *retrieved = userDilemmas[0];
    XCTAssertEqualObjects(retrieved.entryShortDescription, @"0", @"entryShortDescription default value failed.");
    XCTAssertEqualObjects(retrieved.entryIsGood, @1, @"entryIsGood default value failed.");
    XCTAssertEqualObjects(retrieved.entryKey, @"0", @"entryKey default value failed.");
    XCTAssertEqualObjects(retrieved.entryLongDescription, @"0", @"entryLongDescription default value failed.");
    XCTAssertEqualObjects(retrieved.entrySeverity, @0, @"entrySeverity default value failed.");
    
}

@end
