#import "ModelManager.h"
#import "TestModelHelper.h"
#import "ConscienceAsset.h"
#import "ConscienceAssetDAO.h"

@interface TestConscienceAssetDAO: SenTestCase {
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
    
    STAssertNotNil(testingSubject, @"ConscienceDAO can't be created.");
}

- (void)testConscienceAssetDAORead {
    
    ConscienceAsset *testAsset = [testingSubject read:nameAsset1];
    STAssertEqualObjects(testAsset, testConscienceAsset1, @"ConscienceAssetDAO not populated with asset 1."); 
    
    testAsset = [testingSubject read:nameAsset2];
    STAssertEqualObjects(testAsset, testConscienceAsset2, @"ConscienceAssetDAO not populated with asset 2."); 
}

- (void)testConscienceAssetDAOReadAll {
        
    NSArray *allAssets = [testingSubject readAll];
    STAssertTrue([allAssets containsObject:testConscienceAsset1], @"ConscienceAssetDAO All not populated with asset 1.");
    STAssertTrue([allAssets containsObject:testConscienceAsset2], @"ConscienceAssetDAO All not populated with asset 2.");
    
}

- (void)testConscienceAssetDAOCreateFailsCorrectly {
    
    id testMoral = [testingSubject createObject];
    STAssertNil(testMoral, @"ConscienceAssetDAO was able to create incorrectly.");    
}

- (void)testConscienceAssetDAOUpdateFailsCorrectly {
    
    BOOL isUpdateSuccessful = [testingSubject update];
    STAssertFalse(isUpdateSuccessful, @"ConscienceAssetDAO was able to update incorrectly.");    
}

- (void)testConscienceAssetDAODeleteFailsCorrectly {
    
    BOOL isDeleteSuccessful = [testingSubject delete:testConscienceAsset2];
    STAssertFalse(isDeleteSuccessful, @"ConscienceAssetDAO was able to delete incorrectly.");
    
    ConscienceAsset *testDeletedAssetVerify = [testingSubject read:nameAsset2];
    STAssertEqualObjects(testConscienceAsset2, testDeletedAssetVerify, @"ConscienceAsset was deleted incorrectly.");
    
}

@end