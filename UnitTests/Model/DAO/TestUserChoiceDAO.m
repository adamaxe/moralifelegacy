#import "ModelManager.h"
#import "UserChoiceDAO.h"

@interface TestUserChoiceDAO: SenTestCase {
    ModelManager *testModelManager;

    UserChoiceDAO *testingSubject;
    
    UserChoice *testUserChoice1;
    UserChoice *testUserChoice2;
    
    NSString *keyChoice1;
    NSString *keyChoice2;
    
    NSString *entryShortDescription;
    NSNumber *entryIsGood;
    NSString *entryKey;
    NSString *entryLongDescription;
    NSNumber *entrySeverity;
    NSDate *entryCreationDate;
    
    NSDate *entryModificationDate;
    NSString *choiceMoral;
    NSNumber *choiceWeight;
    
}

@end

@implementation TestUserChoiceDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    keyChoice1 = @"nameChoice1";    
    keyChoice2 = @"nameChoice2";        
    
    entryShortDescription = @"entryShortDescription";
    entryIsGood = @1;
    entryLongDescription = @"entryLongDescription";
    entrySeverity =@5.0f;
    entryCreationDate = [NSDate date];
    
    entryModificationDate = [NSDate date];
    choiceMoral = @"choiceMoral";
    choiceWeight = @5.0f;        
        
    testUserChoice1 = [testModelManager create:UserChoice.class];
    testUserChoice2 = [testModelManager create:UserChoice.class];
    
    testUserChoice1.entryShortDescription = entryShortDescription;
    testUserChoice1.entryIsGood = entryIsGood;
    testUserChoice1.entryKey = keyChoice1;
    testUserChoice1.entryLongDescription = entryLongDescription;
    testUserChoice1.entrySeverity = entrySeverity;
    testUserChoice1.entryCreationDate = entryCreationDate;

    testUserChoice1.entryModificationDate = entryModificationDate;
    testUserChoice1.choiceMoral = choiceMoral;
    testUserChoice1.choiceWeight = choiceWeight; 
    
    testUserChoice2.entryShortDescription = entryShortDescription;
    testUserChoice2.entryIsGood = entryIsGood;
    testUserChoice2.entryKey = keyChoice2;
    testUserChoice2.entryLongDescription = entryLongDescription;
    testUserChoice2.entrySeverity = entrySeverity;
    testUserChoice2.entryCreationDate = entryCreationDate;
    
    testUserChoice2.entryModificationDate = entryModificationDate;
    testUserChoice2.choiceMoral = choiceMoral;
    testUserChoice2.choiceWeight = choiceWeight; 
    
    [testModelManager saveContext];
    
    testingSubject = [[UserChoiceDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testUserChoiceDAOAllTypeCanBeCreated {
    STAssertNotNil(testingSubject, @"UserChoiceDAO All type can't be created.");
}

- (void)testUserChoiceDAORead {
        
    UserChoice *testChoice = [testingSubject read:keyChoice1];
    STAssertEqualObjects(testChoice, testUserChoice1, @"UserChoiceDAO All not populated with Choice 1.");    
}

- (void)testUserChoiceDAOCanBeCreated {
    
    UserChoice *testUserChoice = [testingSubject create];
        
    STAssertNotNil(testUserChoice, @"UserChoiceDAO wasn't able to create.");
    
    NSString *keyChoice3 = @"keyChoice3";
    
    testUserChoice.entryShortDescription = entryShortDescription;
    testUserChoice.entryIsGood = entryIsGood;
    testUserChoice.entryKey = keyChoice3;
    testUserChoice.entryLongDescription = entryLongDescription;
    testUserChoice.entrySeverity = entrySeverity;
    testUserChoice.entryCreationDate = entryCreationDate;
    
    testUserChoice.entryModificationDate = entryModificationDate;
    testUserChoice.choiceMoral = choiceMoral;
    testUserChoice.choiceWeight = choiceWeight; 
        
    UserChoice *testChoiceVerify = [testingSubject read:keyChoice3];
    STAssertEqualObjects(testUserChoice, testChoiceVerify, @"UserChoiceDAO not populated with Choice 1.");
}

- (void)testUserChoiceDAOCanBeUpdated {
    
    NSString *newChoiceMoral = @"newChoiceMoral";
    testUserChoice2.choiceMoral = newChoiceMoral;
        
    UserChoice *testChoiceVerify = [testingSubject read:keyChoice2];
    STAssertEqualObjects(testUserChoice2.choiceMoral, testChoiceVerify.choiceMoral, @"UserChoiceDAO All not populated with Choice 2.");    
    
}

- (void)testUserChoiceDAOReadAll {
            
    NSArray *allChoices = [testingSubject readAll];
    STAssertTrue([allChoices containsObject:testUserChoice1], @"UserChoiceDAO All not populated with Choice 1.");
    STAssertTrue([allChoices containsObject:testUserChoice2], @"UserChoiceDAO All not populated with Choice 2.");
}

//- (void)testUserChoiceDAOCanBeDeleted {
//        
//    BOOL isDeleteSuccessful = [testingSubject delete:testUserChoice2];
//    STAssertTrue(isDeleteSuccessful, @"UserChoiceDAO wasn't able to delete.");
//    
//    UserChoice *testDeletedChoiceVerify = [testingSubject read:keyChoice2];
//    STAssertNil(testDeletedChoiceVerify, @"UserChoice was deleted incorrectly.");
//    
//}

@end