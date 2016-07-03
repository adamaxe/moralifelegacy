#import "ModelManager.h"
#import "TestModelHelper.h"
#import "ConscienceAsset.h"
#import "ConscienceAssetDAO.h"

@interface TestConscienceAssetDAO: XCTestCase {
    ModelManager *testModelManager;

    ConscienceAssetDAO *testingSubject;
    
    ConscienceAsset *testConscienceAsset1;
    ConscienceAsset *testConscienceAsset2;
    
    NSString *nameAsset1;
    NSString *nameAsset2;
    
    NSNumber *costAsset;
    NSString *orientationAsset;
    NSNumber *moralValueAsset; 
    NSString *shortDescription;
    NSNumber *originYear;
    NSString *longDescription;
    NSString *link;
    NSString *displayName;
    NSString *imageName;
}

@end

@implementation TestConscienceAssetDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    nameAsset1 = @"Asset1";
    nameAsset2 = @"Asset2";
        
    testConscienceAsset1 = [TestModelHelper createAssetWithName:nameAsset1 withModelManager:testModelManager];
    testConscienceAsset2 = [TestModelHelper createAssetWithName:nameAsset2 withModelManager:testModelManager];

    [testModelManager saveContext];
    
    testingSubject = [[ConscienceAssetDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testConscienceDAOAllTypeCanBeCreated {
    
    XCTAssertNotNil(testingSubject, @"ConscienceDAO can't be created.");
}

- (void)testConscienceAssetDAORead {
    
    ConscienceAsset *testAsset = [testingSubject read:nameAsset1];
    XCTAssertEqualObjects(testAsset, testConscienceAsset1, @"ConscienceAssetDAO not populated with asset 1."); 
    
    testAsset = [testingSubject read:nameAsset2];
    XCTAssertEqualObjects(testAsset, testConscienceAsset2, @"ConscienceAssetDAO not populated with asset 2."); 
}

- (void)testConscienceAssetDAOReadAll {
        
    NSArray *allAssets = [testingSubject readAll];
    XCTAssertTrue([allAssets containsObject:testConscienceAsset1], @"ConscienceAssetDAO All not populated with asset 1.");
    XCTAssertTrue([allAssets containsObject:testConscienceAsset2], @"ConscienceAssetDAO All not populated with asset 2.");
    
}

- (void)testConscienceAssetDAOCreateFailsCorrectly {
    
    id testMoral = [testingSubject createObject];
    XCTAssertNil(testMoral, @"ConscienceAssetDAO was able to create incorrectly.");    
}

- (void)testConscienceAssetDAOUpdateFailsCorrectly {
    
    BOOL isUpdateSuccessful = [testingSubject update];
    XCTAssertFalse(isUpdateSuccessful, @"ConscienceAssetDAO was able to update incorrectly.");    
}

- (void)testConscienceAssetDAODeleteFailsCorrectly {
    
    BOOL isDeleteSuccessful = [testingSubject delete:testConscienceAsset2];
    XCTAssertFalse(isDeleteSuccessful, @"ConscienceAssetDAO was able to delete incorrectly.");
    
    ConscienceAsset *testDeletedAssetVerify = [testingSubject read:nameAsset2];
    XCTAssertEqualObjects(testConscienceAsset2, testDeletedAssetVerify, @"ConscienceAsset was deleted incorrectly.");
    
}

@end