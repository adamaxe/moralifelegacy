#import "TestCoreDataStack.h"
#import "UserLuck.h"

@interface TestUserLuck : SenTestCase {
    TestCoreDataStack *coreData;
    UserLuck *testUserLuck;

    NSString * entryShortDescription;
    NSNumber * entryIsGood;
    NSString * entryKey;
    NSString * entryLongDescription;
    NSNumber * entrySeverity;
    NSDate * entryCreationDate;
    
    NSDate * entryModificationDate;

}

@end

@implementation TestUserLuck

- (void)setUp {
    coreData = [[TestCoreDataStack alloc] initWithManagedObjectModel:@"UserData"];
    
    entryShortDescription = @"entryShortDescription";
    entryIsGood = [NSNumber numberWithInt:1];
    entryKey = @"entryKey";
    entryLongDescription = @"entryLongDescription";
    entrySeverity =[NSNumber numberWithFloat:5];
    entryCreationDate = [NSDate date];
    
    testUserLuck = [coreData insert:UserLuck.class];
    
    testUserLuck.entryShortDescription = entryShortDescription;
    testUserLuck.entryIsGood = entryIsGood;
    testUserLuck.entryKey = entryKey;
    testUserLuck.entryLongDescription = entryLongDescription;
    testUserLuck.entrySeverity = entrySeverity;
    testUserLuck.entryCreationDate = entryCreationDate;
    testUserLuck.entryModificationDate = entryCreationDate;

        
}

- (void)testUserLuckCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    STAssertNoThrow([coreData save], @"UserLuck can't be created");
    
}

- (void)testUserLuckValidatesAttributes {
        
    testUserLuck.entrySeverity = [NSNumber numberWithInt:-6];    
    STAssertThrows([coreData save], @"entrySeverity lower bound validation failed.");
    
    testUserLuck.entrySeverity = [NSNumber numberWithInt:6];    
    STAssertThrows([coreData save], @"entrySeverity upper bound validation failed.");
    
}

- (void)testUserLuckAccessorsAreFunctional {
    
    STAssertNoThrow([coreData save], @"UserLuck can't be created for Accessor test");
    
    NSArray *UserLucks = [coreData fetch:UserLuck.class];
        
    STAssertEquals(UserLucks.count, (NSUInteger) 1, @"There should only be 1 RefenceText in the context.");
    UserLuck *retrieved = [UserLucks objectAtIndex: 0];
    STAssertEqualObjects(retrieved.entryShortDescription, entryShortDescription, @"entryShortDescription Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entryIsGood, entryIsGood, @"entryIsGood Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entryKey, entryKey, @"entryKey Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entryLongDescription, entryLongDescription, @"entryLongDescription Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entrySeverity, entrySeverity, @"entrySeverity Getter/Setter failed.");
    STAssertEqualObjects(retrieved.entryCreationDate, entryCreationDate, @"entryCreationDate Getter/Setter failed.");
}

- (void)testUserLuckDeletion {
    STAssertNoThrow([coreData save], @"UserLuck can't be created for Delete test");
    
    STAssertNoThrow([coreData delete:testUserLuck], @"UserLuck can't be deleted");
    
    NSArray *UserLucks = [coreData fetch:UserLuck.class];
    
    STAssertEquals(UserLucks.count, (NSUInteger) 0, @"UserLuck is still present after delete");
    
}

- (void)testUserLuckWithoutRequiredAttributes {
    UserLuck *testUserLuckBad = [coreData insert:UserLuck.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testUserLuckBad.class];

    testUserLuck.entryCreationDate = nil;
    STAssertThrows([coreData save], errorMessage);
}

- (void)testUserLuckDefaultValues {
    UserLuck *testUserLuckDefault = [coreData insert:UserLuck.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testUserLuckDefault.class];

    testUserLuckDefault.entryCreationDate = entryCreationDate;
    testUserLuckDefault.entryModificationDate = entryCreationDate;    
    
    STAssertNoThrow([coreData save], errorMessage);
    
    NSError *error = nil;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"entryKey == %@", @"0"];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(UserLuck.class)];
    request.predicate = searchPredicate;
    NSArray *userLucks = [[coreData managedObjectContext] executeFetchRequest:request error:&error];

    UserLuck *retrieved = [userLucks objectAtIndex: 0];
    STAssertEqualObjects(retrieved.entryShortDescription, @"0", @"entryShortDescription default value failed.");
//    STAssertEquals(retrieved.entryIsGood, [NSNumber numberWithInt:1], @"entryIsGood default value failed.");
    STAssertEqualObjects(retrieved.entryIsGood, [NSNumber numberWithInt:1], @"entryIsGood default value failed.");
    STAssertEqualObjects(retrieved.entryKey, @"0", @"entryKey default value failed.");
    STAssertEqualObjects(retrieved.entryLongDescription, @"0", @"entryLongDescription default value failed.");
    STAssertEqualObjects(retrieved.entrySeverity, [NSNumber numberWithInt:0], @"entrySeverity default value failed.");
    
}

@end
