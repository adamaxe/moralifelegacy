#import "ModelManager.h"
#import "TestModelHelper.h"
#import "ReferenceAsset.h"
#import "ReferenceAssetDAO.h"

@interface TestReferenceAssetDAO: SenTestCase {
    ModelManager *testModelManager;

    ReferenceAssetDAO *testingSubject;
    
    ReferenceAsset *testReferenceAsset1;
    ReferenceAsset *testReferenceAsset2;
    
    NSString *nameAsset1;
    NSString *nameAsset2;
    NSString *nameAsset3;

}

@end

@implementation TestReferenceAssetDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    nameAsset1 = @"Asset1";
    nameAsset2 = @"Asset2";
    nameAsset3 = @"Asset3";    

    testReferenceAsset1 = [TestModelHelper createReferenceAssetWithName:nameAsset1 withModelManager:testModelManager];
    testReferenceAsset2 = [TestModelHelper createReferenceAssetWithName:nameAsset2 withModelManager:testModelManager];
    
    testingSubject = [[ReferenceAssetDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testReferenceDAOAllTypeCanBeCreated {
    
    STAssertNotNil(testingSubject, @"ReferenceDAO can't be created.");
}

- (void)testReferenceAssetDAORead {
    
    ReferenceAsset *testAsset = [testingSubject read:nameAsset1];
    STAssertEqualObjects(testAsset, testReferenceAsset1, @"ReferenceAssetDAO not populated with asset 1."); 
    
    testAsset = [testingSubject read:nameAsset2];
    STAssertEqualObjects(testAsset, testReferenceAsset2, @"ReferenceAssetDAO not populated with asset 2."); 
}

- (void)testReferenceAssetDAOReadAll {
        
    NSArray *allAssets = [testingSubject readAll];
    STAssertTrue([allAssets containsObject:testReferenceAsset1], @"ReferenceAssetDAO All not populated with asset 1.");
    STAssertTrue([allAssets containsObject:testReferenceAsset2], @"ReferenceAssetDAO All not populated with asset 2.");
    
}

- (void)testReferenceAssetDAOCreateFailsCorrectly {
    
    id testMoral = [testingSubject createObject];
    STAssertNil(testMoral, @"ReferenceAssetDAO was able to create incorrectly.");    
}

- (void)testReferenceAssetDAOUpdateFailsCorrectly {
    
    BOOL isUpdateSuccessful = [testingSubject update];
    STAssertFalse(isUpdateSuccessful, @"ReferenceAssetDAO was able to update incorrectly.");    
}

- (void)testReferenceAssetDAODeleteFailsCorrectly {
    
    BOOL isDeleteSuccessful = [testingSubject delete:testReferenceAsset2];
    STAssertFalse(isDeleteSuccessful, @"ReferenceAssetDAO was able to delete incorrectly.");
    
    ReferenceAsset *testDeletedAssetVerify = [testingSubject read:nameAsset2];
    STAssertEqualObjects(testReferenceAsset2, testDeletedAssetVerify, @"ReferenceAsset was deleted incorrectly.");
    
}

@end