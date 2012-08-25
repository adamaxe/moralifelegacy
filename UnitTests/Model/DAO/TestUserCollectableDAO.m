#import "ModelManager.h"
#import "UserCollectableDAO.h"

@interface TestUserCollectableDAO: SenTestCase {
    ModelManager *testModelManager;

    UserCollectableDAO *testingSubject;
    
    UserCollectable *testCollectable1;
    UserCollectable *testCollectable2;
    
    NSString *keyCollectable1;
    NSString *keyCollectable2;
    
    NSString *collectableName1;
    NSString *collectableName2;
    NSDate *collectableCreateDate;
    
}

@end

@implementation TestUserCollectableDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    keyCollectable1 = @"nameCollectable1";    
    keyCollectable2 = @"nameCollectable2";        
    
    collectableName1 = @"collectableName1";
    collectableName2 = @"collectableName2";
    collectableCreateDate = [NSDate date];
    
    testCollectable1 = [testModelManager create:UserCollectable.class];
    testCollectable2 = [testModelManager create:UserCollectable.class];

    testCollectable1.collectableName = collectableName1;
    testCollectable1.collectableKey = keyCollectable1;
    testCollectable1.collectableCreationDate = collectableCreateDate;

    testCollectable2.collectableName = collectableName2;
    testCollectable2.collectableKey = keyCollectable2;
    testCollectable2.collectableCreationDate = collectableCreateDate;

    [testModelManager saveContext];
    
    testingSubject = [[UserCollectableDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.
	[testModelManager release];
    [testingSubject release];

	[super tearDown];
    
}

- (void)testUserCollectableDAOAllTypeCanBeCreated {
    STAssertNotNil(testingSubject, @"UserCollectableDAO All type can't be created.");
}

- (void)testUserCollectableDAORead {
        
    UserCollectable *testCollectable = [testingSubject read:keyCollectable1];
    STAssertEqualObjects(testCollectable, testCollectable1, @"UserCollectableDAO All not populated with Collectable 1.");    
}

- (void)testUserCollectableDAOCanBeCreated {
    
    UserCollectable *testCollectable = [testingSubject create];
        
    STAssertNotNil(testCollectable, @"UserCollectableDAO wasn't able to create.");
    
    NSString *keyCollectable3 = @"keyCollectable3";
    NSString *nameCollectable3 = @"nameCollectable3";

    testCollectable.collectableName = nameCollectable3;
    testCollectable.collectableKey = keyCollectable3;
    testCollectable.collectableCreationDate = collectableCreateDate;
        
    UserCollectable *testCollectableVerify = [testingSubject read:keyCollectable3];
    STAssertEqualObjects(testCollectable, testCollectableVerify, @"UserCollectableDAO not populated with Collectable 1.");
}

- (void)testUserCollectableDAOCanBeUpdated {
    
    NSString *newCollectableName = @"newCollectableName";
    testCollectable2.collectableName = newCollectableName;
        
    UserCollectable *testCollectableVerify = [testingSubject read:keyCollectable2];
    STAssertEqualObjects(testCollectable2.collectableName, testCollectableVerify.collectableName, @"UserCollectableDAO All not populated with Collectable 2.");    
    
}

- (void)testUserCollectableDAOReadAll {
            
    NSArray *allCollectables = [testingSubject readAll];
    STAssertTrue([allCollectables containsObject:testCollectable1], @"UserCollectableDAO All not populated with Collectable 1.");
    STAssertTrue([allCollectables containsObject:testCollectable2], @"UserCollectableDAO All not populated with Collectable 2.");
}

//- (void)testUserCollectableDAOCanBeDeleted {
//        
//    BOOL isDeleteSuccessful = [testingSubject delete:testCollectable2];
//    STAssertTrue(isDeleteSuccessful, @"UserCollectableDAO wasn't able to delete.");
//    
//    UserCollectable *testDeletedCollectableVerify = [testingSubject read:keyCollectable2];
//    STAssertNil(testDeletedCollectableVerify, @"UserCollectable was deleted incorrectly.");
//    
//}

@end