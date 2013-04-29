#import "ModelManager.h"
#import "TestModelHelper.h"
#import "MoralDAO.h"

@interface TestMoralDAO: SenTestCase {
    ModelManager *testModelManager;

    MoralDAO *testingSubject;
    
    Moral *testMoral1;
    Moral *testMoral2;
    Moral *testMoral3;
    
    NSString *nameMoral1;
    NSString *nameMoral2;
    NSString *nameMoral3;
    
    NSString *moralTypeVirtue;
    NSString *moralTypeVice;
    NSString *moralTypeVirtueExtra;
}

@end

@implementation TestMoralDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    
    nameMoral1 = @"Virtue Name1";
    nameMoral2 = @"Vice Name2";
    nameMoral3 = @"Virtue Name3";
    
    moralTypeVirtue = @"Virtue";
    moralTypeVice = @"Vice";
    moralTypeVirtueExtra = @"Virtue";
        
    testMoral1 = [TestModelHelper createMoralWithName:nameMoral1 withType:moralTypeVirtue withModelManager:testModelManager];
    testMoral2 = [TestModelHelper createMoralWithName:nameMoral2 withType:moralTypeVice withModelManager:testModelManager];
    testMoral3 = [TestModelHelper createMoralWithName:nameMoral3 withType:moralTypeVirtueExtra withModelManager:testModelManager];

    [testModelManager saveContext];
    
    testingSubject = [[MoralDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testMoralDAOAllTypeCanBeCreated {
        
    STAssertNotNil(testingSubject, @"MoralDAO All type can't be created.");
        
}

- (void)testMoralDAOVirtueTypeCanBeCreated {
    
    MoralDAO *testingSubjectVirtue = [[MoralDAO alloc] initWithKey:@"" andModelManager:testModelManager];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"shortDescriptionMoral == %@", moralTypeVirtue];
    testingSubjectVirtue.predicates = @[pred];

    STAssertNotNil(testingSubjectVirtue, @"MoralDAO Virtue type can't be created.");
    
    
}

- (void)testMoralDAOViceTypeCanBeCreated {
    
    MoralDAO *testingSubjectVice = [[MoralDAO alloc] initWithKey:@"" andModelManager:testModelManager];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"shortDescriptionMoral == %@", moralTypeVice];
    testingSubjectVice.predicates = @[pred];
    
    STAssertNotNil(testingSubjectVice, @"MoralDAO Vice can't be created.");
    
}

- (void)testMoralDAORead {
        
    Moral *testMoral = [testingSubject read:nameMoral1];
    STAssertEqualObjects(testMoral, testMoral1, @"MoralDAO All not populated with virtue 1.");    
}

- (void)testMoralDAOCreateFailsCorrectly {
    
    id testMoral = [testingSubject createObject];
    STAssertNil(testMoral, @"MoralDAO was able to create incorrectly.");    
}

- (void)testMoralDAOUpdateFailsCorrectly {
    
    BOOL isUpdateSuccessful = [testingSubject update];
    STAssertFalse(isUpdateSuccessful, @"MoralDAO was able to update incorrectly.");    
}

- (void)testMoralDAOAllTypeContainsVirtuesAndVices {
    
    MoralDAO *testingSubjectAll = [[MoralDAO alloc] initWithKey:@"" andModelManager:testModelManager];
        
    NSArray *allMorals = [testingSubjectAll readAll];
    STAssertTrue([allMorals containsObject:testMoral1], @"MoralDAO All not populated with virtue 1.");
    STAssertTrue([allMorals containsObject:testMoral2], @"MoralDAO All not populated with vices.");
    STAssertTrue([allMorals containsObject:testMoral3], @"MoralDAO All not populated with virtue 2.");
    
    
}

- (void)testMoralDAOVirtueTypeContainsOnlyVirtues {
    
    MoralDAO *testingSubjectVirtue = [[MoralDAO alloc] initWithKey:@"" andModelManager:testModelManager];
    NSPredicate *virtuePred = [NSPredicate predicateWithFormat:@"shortDescriptionMoral == %@", @"Virtue"];
    testingSubjectVirtue.predicates = @[virtuePred];
    
    NSArray *allMorals = [testingSubjectVirtue readAll];

    STAssertTrue([allMorals containsObject:testMoral1], @"MoralDAO Virtue not populated with virtue 1.");
    STAssertFalse([allMorals containsObject:testMoral2], @"MoralDAO Virtue populated with vices.");
    STAssertTrue([allMorals containsObject:testMoral3], @"MoralDAO Virtue not populated with virtue 2.");

    
}

- (void)testMoralDAOViceTypedContainsOnlyVice {
    
    MoralDAO *testingSubjectVice = [[MoralDAO alloc] initWithKey:@"" andModelManager:testModelManager];
    
    NSPredicate *vicePred = [NSPredicate predicateWithFormat:@"shortDescriptionMoral == %@", @"Vice"];
    testingSubjectVice.predicates = @[vicePred];

    NSArray *allMorals = [testingSubjectVice readAll];
    
    STAssertTrue([allMorals containsObject:testMoral2], @"MoralDAO Vice not populated with vices.");
    STAssertFalse([allMorals containsObject:testMoral1], @"MoralDAO Vice populated with virtues.");
    STAssertFalse([allMorals containsObject:testMoral3], @"MoralDAO Vice populated with virtues.");
    
}

- (void)testMoralDAOViceTypeCanBeCreatedWithNoPersistedMorals {
        
    ModelManager *testEmptyModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    
    MoralDAO *testingEmptySubject = [[MoralDAO alloc] initWithKey:@"" andModelManager:testEmptyModelManager];
    
    STAssertNotNil(testingEmptySubject, @"MoralDAO Empty can't be created.");
    
    NSArray *allNames = [testingEmptySubject readAll];
    int count = [allNames count];
    STAssertEquals(count, 0, @"MoralDAO Empty is not empty.");
    
}

- (void)testMoralDAODeleteFailsCorrectly {
        
    BOOL isDeleteSuccessful = [testingSubject delete:testMoral3];
    STAssertFalse(isDeleteSuccessful, @"MoralDAO was able to delete incorrectly.");
    
    Moral *testDeletedMoralVerify = [testingSubject read:nameMoral3];
    STAssertEqualObjects(testMoral3, testDeletedMoralVerify, @"Moral was deleted incorrectly.");
    
}

@end