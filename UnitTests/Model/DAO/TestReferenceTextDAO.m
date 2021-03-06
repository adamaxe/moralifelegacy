#import "ModelManager.h"
#import "TestModelHelper.h"
#import "ReferenceText.h"
#import "ReferenceTextDAO.h"

@interface TestReferenceTextDAO:XCTestCase {
    ModelManager *testModelManager;

    ReferenceTextDAO *testingSubject;
    
    ReferenceText *testReferenceText1;
    ReferenceText *testReferenceText2;
    
    NSString *nameAsset1;
    NSString *nameAsset2;
    
}

@end

@implementation TestReferenceTextDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    nameAsset1 = @"Asset1";
    nameAsset2 = @"Asset2";
    
    testReferenceText1 = [TestModelHelper createTextWithName:nameAsset1 withModelManager:testModelManager];
    testReferenceText2 = [TestModelHelper createTextWithName:nameAsset2 withModelManager:testModelManager];
    
    testingSubject = [[ReferenceTextDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testReferenceTextDAOAllTypeCanBeCreated {
    
    XCTAssertNotNil(testingSubject, @"ReferenceTextDAO can't be created.");
}

- (void)testReferenceTextDAORead {
    
    ReferenceText *testAsset = [testingSubject read:nameAsset1];
    XCTAssertEqualObjects(testAsset, testReferenceText1, @"ReferenceTextDAO not populated with text 1."); 
    
    testAsset = [testingSubject read:nameAsset2];
    XCTAssertEqualObjects(testAsset, testReferenceText2, @"ReferenceTextDAO not populated with text 2."); 
}

- (void)testReferenceTextDAOReadAll {
        
    NSArray *allAssets = [testingSubject readAll];
    XCTAssertTrue([allAssets containsObject:testReferenceText1], @"ReferenceTextDAO All not populated with text 1.");
    XCTAssertTrue([allAssets containsObject:testReferenceText2], @"ReferenceTextDAO All not populated with text 2.");
    
}

- (void)testReferenceTextDAOCreateFailsCorrectly {
    
    id testMoral = [testingSubject createObject];
    XCTAssertNil(testMoral, @"ReferenceTextDAO was able to create incorrectly.");    
}

- (void)testReferenceTextDAOUpdateFailsCorrectly {
    
    BOOL isUpdateSuccessful = [testingSubject update];
    XCTAssertFalse(isUpdateSuccessful, @"ReferenceTextDAO was able to update incorrectly.");    
}

- (void)testReferenceTextDAODeleteFailsCorrectly {
    
    BOOL isDeleteSuccessful = [testingSubject delete:testReferenceText2];
    XCTAssertFalse(isDeleteSuccessful, @"ReferenceTextDAO was able to delete incorrectly.");
    
    ReferenceText *testDeletedAssetVerify = [testingSubject read:nameAsset2];
    XCTAssertEqualObjects(testReferenceText2, testDeletedAssetVerify, @"ReferenceText was deleted incorrectly.");
    
}

@end
