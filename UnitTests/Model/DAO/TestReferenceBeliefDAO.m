#import "ModelManager.h"
#import "TestModelHelper.h"
#import "ReferenceBelief.h"
#import "ReferenceBeliefDAO.h"

@interface TestReferenceBeliefDAO: SenTestCase {
    ModelManager *testModelManager;

    ReferenceBeliefDAO *testingSubject;
    
    ReferenceBelief *testReferenceBelief1;
    ReferenceBelief *testReferenceBelief2;
    
    NSString *nameAsset1;
    NSString *nameAsset2;

}

@end

@implementation TestReferenceBeliefDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    nameAsset1 = @"Asset1";
    nameAsset2 = @"Asset2";
        
    testReferenceBelief1 = [TestModelHelper createBeliefWithName:nameAsset1 withModelManager:testModelManager];
    testReferenceBelief2 = [TestModelHelper createBeliefWithName:nameAsset2 withModelManager:testModelManager];
    
    testingSubject = [[ReferenceBeliefDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testReferenceBeliefDAOAllTypeCanBeCreated {
    
    STAssertNotNil(testingSubject, @"ReferenceBeliefDAO can't be created.");
}

- (void)testReferenceBeliefDAORead {
    
    ReferenceBelief *testAsset = [testingSubject read:nameAsset1];
    STAssertEqualObjects(testAsset, testReferenceBelief1, @"ReferenceBeliefDAO not populated with belief 1."); 
    
    testAsset = [testingSubject read:nameAsset2];
    STAssertEqualObjects(testAsset, testReferenceBelief2, @"ReferenceBeliefDAO not populated with belief 2."); 
}

- (void)testReferenceBeliefDAOReadAll {
        
    NSArray *allAssets = [testingSubject readAll];
    STAssertTrue([allAssets containsObject:testReferenceBelief1], @"ReferenceBeliefDAO All not populated with belief 1.");
    STAssertTrue([allAssets containsObject:testReferenceBelief2], @"ReferenceBeliefDAO All not populated with belief 2.");
    
}

- (void)testReferenceBeliefDAOCreateFailsCorrectly {
    
    id testMoral = [testingSubject createObject];
    STAssertNil(testMoral, @"ReferenceBeliefDAO was able to create incorrectly.");    
}

- (void)testReferenceBeliefDAOUpdateFailsCorrectly {
    
    BOOL isUpdateSuccessful = [testingSubject update];
    STAssertFalse(isUpdateSuccessful, @"ReferenceBeliefDAO was able to update incorrectly.");    
}

- (void)testReferenceBeliefDAODeleteFailsCorrectly {
    
    BOOL isDeleteSuccessful = [testingSubject delete:testReferenceBelief2];
    STAssertFalse(isDeleteSuccessful, @"ReferenceBeliefDAO was able to delete incorrectly.");
    
    ReferenceBelief *testDeletedAssetVerify = [testingSubject read:nameAsset2];
    STAssertEqualObjects(testReferenceBelief2, testDeletedAssetVerify, @"ReferenceBelief was deleted incorrectly.");
    
}

@end