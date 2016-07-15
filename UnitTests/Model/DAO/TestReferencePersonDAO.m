#import "ModelManager.h"
#import "TestModelHelper.h"
#import "ReferencePerson.h"
#import "ReferencePersonDAO.h"

@interface TestReferencePersonDAO: XCTestCase {
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
    
    XCTAssertNotNil(testingSubject, @"ReferencePersonDAO can't be created.");
}

- (void)testReferencePersonDAORead {
    
    ReferencePerson *testAsset = [testingSubject read:nameAsset1];
    XCTAssertEqualObjects(testAsset, testReferencePerson1, @"ReferencePersonDAO not populated with person 1."); 
    
    testAsset = [testingSubject read:nameAsset2];
    XCTAssertEqualObjects(testAsset, testReferencePerson2, @"ReferencePersonDAO not populated with person 2."); 
}

- (void)testReferencePersonDAOReadAll {
        
    NSArray *allAssets = [testingSubject readAll];
    XCTAssertTrue([allAssets containsObject:testReferencePerson1], @"ReferencePersonDAO All not populated with person 1.");
    XCTAssertTrue([allAssets containsObject:testReferencePerson2], @"ReferencePersonDAO All not populated with person 2.");
    
}

- (void)testReferencePersonDAOCreateFailsCorrectly {
    
    id testMoral = [testingSubject createObject];
    XCTAssertNil(testMoral, @"ReferencePersonDAO was able to create incorrectly.");    
}

- (void)testReferencePersonDAOUpdateFailsCorrectly {
    
    BOOL isUpdateSuccessful = [testingSubject update];
    XCTAssertFalse(isUpdateSuccessful, @"ReferencePersonDAO was able to update incorrectly.");    
}

- (void)testReferencePersonDAODeleteFailsCorrectly {
    
    BOOL isDeleteSuccessful = [testingSubject delete:testReferencePerson2];
    XCTAssertFalse(isDeleteSuccessful, @"ReferencePersonDAO was able to delete incorrectly.");
    
    ReferencePerson *testDeletedAssetVerify = [testingSubject read:nameAsset2];
    XCTAssertEqualObjects(testReferencePerson2, testDeletedAssetVerify, @"ReferencePerson was deleted incorrectly.");
    
}

#warning Implement testing default readonly behavior

@end
