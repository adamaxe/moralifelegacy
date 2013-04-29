#import "ModelManager.h"
#import "TestModelHelper.h"
#import "ReferencePerson.h"
#import "ReferencePersonDAO.h"

@interface TestReferencePersonDAO: SenTestCase {
    ModelManager *testModelManager;

    ReferencePersonDAO *testingSubject;
    
    ReferencePerson *testReferencePerson1;
    ReferencePerson *testReferencePerson2;
    
    NSString *nameAsset1;
    NSString *nameAsset2;
}

@end

@implementation TestReferencePersonDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    nameAsset1 = @"Asset1";
    nameAsset2 = @"Asset2";

    testReferencePerson1 = [TestModelHelper createPersonWithName:nameAsset1 withModelManager:testModelManager];
    testReferencePerson2 = [TestModelHelper createPersonWithName:nameAsset2 withModelManager:testModelManager];
    
    testingSubject = [[ReferencePersonDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testReferencePersonDAOAllTypeCanBeCreated {
    
    STAssertNotNil(testingSubject, @"ReferencePersonDAO can't be created.");
}

- (void)testReferencePersonDAORead {
    
    ReferencePerson *testAsset = [testingSubject read:nameAsset1];
    STAssertEqualObjects(testAsset, testReferencePerson1, @"ReferencePersonDAO not populated with person 1."); 
    
    testAsset = [testingSubject read:nameAsset2];
    STAssertEqualObjects(testAsset, testReferencePerson2, @"ReferencePersonDAO not populated with person 2."); 
}

- (void)testReferencePersonDAOReadAll {
        
    NSArray *allAssets = [testingSubject readAll];
    STAssertTrue([allAssets containsObject:testReferencePerson1], @"ReferencePersonDAO All not populated with person 1.");
    STAssertTrue([allAssets containsObject:testReferencePerson2], @"ReferencePersonDAO All not populated with person 2.");
    
}

- (void)testReferencePersonDAOCreateFailsCorrectly {
    
    id testMoral = [testingSubject createObject];
    STAssertNil(testMoral, @"ReferencePersonDAO was able to create incorrectly.");    
}

- (void)testReferencePersonDAOUpdateFailsCorrectly {
    
    BOOL isUpdateSuccessful = [testingSubject update];
    STAssertFalse(isUpdateSuccessful, @"ReferencePersonDAO was able to update incorrectly.");    
}

- (void)testReferencePersonDAODeleteFailsCorrectly {
    
    BOOL isDeleteSuccessful = [testingSubject delete:testReferencePerson2];
    STAssertFalse(isDeleteSuccessful, @"ReferencePersonDAO was able to delete incorrectly.");
    
    ReferencePerson *testDeletedAssetVerify = [testingSubject read:nameAsset2];
    STAssertEqualObjects(testReferencePerson2, testDeletedAssetVerify, @"ReferencePerson was deleted incorrectly.");
    
}

@end