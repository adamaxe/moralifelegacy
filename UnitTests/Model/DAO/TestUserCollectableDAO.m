#import "ModelManager.h"
#import "UserCollectableDAO.h"

@interface TestUserCollectableDAO: SenTestCase {
    ModelManager *testModelManager;

    UserCollectableDAO *testingSubject;
    
    UserCollectable *testCollectable1;
    UserCollectable *testCollectable2;
    UserCollectable *testCollectable3;

    NSString *keyCollectable1;
    NSString *keyCollectable2;
    NSString *keyCollectable3;

    NSString *collectableName1;
    NSString *collectableName2;
    NSString *collectableName3;
    NSDate *collectableCreateDate;
    
}

@end

@implementation TestUserCollectableDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    keyCollectable1 = @"nameCollectable1";    
    keyCollectable2 = @"nameCollectable2";        
    keyCollectable3 = @"nameCollectable3";

    collectableName1 = @"collectableName1";
    collectableName2 = @"collectableName2";
    collectableName3 = kCollectableEthicals;
    collectableCreateDate = [NSDate date];
    
    testCollectable1 = [testModelManager create:UserCollectable.class];
    testCollectable2 = [testModelManager create:UserCollectable.class];
    testCollectable3 = [testModelManager create:UserCollectable.class];

    testCollectable1.collectableName = collectableName1;
    testCollectable1.collectableKey = keyCollectable1;
    testCollectable1.collectableCreationDate = collectableCreateDate;

    testCollectable2.collectableName = collectableName2;
    testCollectable2.collectableKey = keyCollectable2;
    testCollectable2.collectableCreationDate = collectableCreateDate;

    testCollectable3.collectableName = collectableName3;
    testCollectable3.collectableKey = keyCollectable3;
    testCollectable3.collectableCreationDate = collectableCreateDate;

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
        
    UserCollectable *testCollectable1Retrieve = [testingSubject read:keyCollectable1];
    STAssertEqualObjects(testCollectable1Retrieve, testCollectable1, @"UserCollectableDAO All not populated with Collectable 1.");

    UserCollectable *testCollectable2Retrieve = [testingSubject read:keyCollectable2];
    STAssertEqualObjects(testCollectable2Retrieve, testCollectable2, @"UserCollectableDAO All not populated with Collectable 2.");

    UserCollectable *testCollectable3Retrieve = [testingSubject read:keyCollectable3];
    STAssertEqualObjects(testCollectable3Retrieve, testCollectable3, @"UserCollectableDAO All not populated with Collectable 3.");

}

- (void)testUserCollectableDAOEthicalRead {

    testingSubject.predicates = @[[NSPredicate predicateWithFormat:@"collectableName == %@", kCollectableEthicals]];

    UserCollectable *testCollectable1Retrieve = [testingSubject read:@""];
    STAssertEqualObjects(testCollectable1Retrieve, testCollectable3, @"Ethicals not populated with Collectable 1.");
}

- (void)testUserCollectableDAOCanBeCreated {
    
    UserCollectable *testCollectable = [testingSubject create];
        
    STAssertNotNil(testCollectable, @"UserCollectableDAO wasn't able to create.");
    
    NSString *keyCollectable4 = @"keyCollectable4";
    NSString *nameCollectable4 = @"nameCollectable4";

    testCollectable.collectableName = nameCollectable4;
    testCollectable.collectableKey = keyCollectable4;
    testCollectable.collectableCreationDate = collectableCreateDate;
        
    UserCollectable *testCollectableVerify = [testingSubject read:keyCollectable4];
    STAssertEqualObjects(testCollectable, testCollectableVerify, @"UserCollectableDAO not populated with Collectable 4.");
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
    STAssertTrue([allCollectables containsObject:testCollectable3], @"UserCollectableDAO All not populated with Collectable 3.");

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