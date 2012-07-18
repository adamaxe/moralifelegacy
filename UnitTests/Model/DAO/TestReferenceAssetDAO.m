#import "ModelManager.h"
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
    
    NSString *shortDescription;
    NSNumber *originYear;
    NSString *longDescription;
    NSString *link;
    NSString *displayName;
    NSString *imageName;
}

@end

@implementation TestReferenceAssetDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    nameAsset1 = @"Asset1";
    nameAsset2 = @"Asset2";
    nameAsset3 = @"Asset3";    
    
    shortDescription = @"short description";
    originYear = [NSNumber numberWithInt:2010];
    longDescription = @"long description";
    link = @"http://www.teamaxe.org";    
    displayName = @"display name";
    imageName = @"image name";
    
    testReferenceAsset1 = [testModelManager create:ReferenceAsset.class];
    testReferenceAsset2 = [testModelManager create:ReferenceAsset.class];

    testReferenceAsset1.nameReference = nameAsset1;
    testReferenceAsset1.shortDescriptionReference = shortDescription;
    testReferenceAsset1.originYear = originYear;
    testReferenceAsset1.longDescriptionReference = longDescription;
    testReferenceAsset1.linkReference = link;
    testReferenceAsset1.displayNameReference = displayName;
    testReferenceAsset1.imageNameReference = imageName;

    testReferenceAsset2.nameReference = nameAsset2;
    testReferenceAsset2.shortDescriptionReference = shortDescription;
    testReferenceAsset2.originYear = originYear;
    testReferenceAsset2.longDescriptionReference = longDescription;
    testReferenceAsset2.linkReference = link;
    testReferenceAsset2.displayNameReference = displayName;
    testReferenceAsset2.imageNameReference = imageName;

    [testModelManager saveContext];
    
    testingSubject = [[ReferenceAssetDAO alloc] initWithKey:@"" andModelManager:testModelManager];

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