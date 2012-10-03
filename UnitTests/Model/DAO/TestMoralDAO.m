#import "ModelManager.h"
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
    NSString *imageName;
    NSString *color;
    NSString *displayName;
    NSString *longDescription;
    NSString *component;
    NSString *link;
    NSString *definition;
    
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
    imageName = @"imageName";
    color = @"color";
    displayName = @"displayName";
    longDescription = @"longDescription";
    component = @"component";
    link = @"link";
    definition = @"definition"; 
        
    testMoral1 = [testModelManager create:Moral.class];
    testMoral2 = [testModelManager create:Moral.class];
    testMoral3 = [testModelManager create:Moral.class];

    testMoral1.shortDescriptionMoral = moralTypeVirtue;
    testMoral1.nameMoral = nameMoral1;

    testMoral2.shortDescriptionMoral = moralTypeVice;
    testMoral2.nameMoral = nameMoral2;

    testMoral3.shortDescriptionMoral = moralTypeVirtueExtra;
    testMoral3.nameMoral = nameMoral3;

    testMoral1.imageNameMoral = imageName;
    testMoral1.colorMoral = color;
    testMoral1.displayNameMoral = displayName;
    testMoral1.longDescriptionMoral = longDescription;
    testMoral1.component = component;
    testMoral1.linkMoral = link;
    testMoral1.definitionMoral = definition;

    testMoral2.imageNameMoral = imageName;
    testMoral2.colorMoral = color;
    testMoral2.displayNameMoral = displayName;
    testMoral2.longDescriptionMoral = longDescription;
    testMoral2.component = component;
    testMoral2.linkMoral = link;
    testMoral2.definitionMoral = definition;

    testMoral3.imageNameMoral = imageName;
    testMoral3.colorMoral = color;
    testMoral3.displayNameMoral = displayName;
    testMoral3.longDescriptionMoral = longDescription;
    testMoral3.component = component;
    testMoral3.linkMoral = link;
    testMoral3.definitionMoral = definition;

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