#import "ModelManager.h"
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
    
    costAsset = @1.0f;
    moralValueAsset = @2.0f; 
    orientationAsset = @"left";
    shortDescription = @"short description";
    originYear = @2010;
    longDescription = @"long description";
    link = @"http://www.teamaxe.org";    
    displayName = @"display name";
    imageName = @"image name";
    
    testConscienceAsset1 = [testModelManager create:ConscienceAsset.class];
    testConscienceAsset2 = [testModelManager create:ConscienceAsset.class];

    testConscienceAsset1.nameReference = nameAsset1;
    testConscienceAsset1.costAsset = costAsset;
    testConscienceAsset1.orientationAsset = orientationAsset;
    testConscienceAsset1.moralValueAsset = moralValueAsset;
    testConscienceAsset1.shortDescriptionReference = shortDescription;
    testConscienceAsset1.originYear = originYear;
    testConscienceAsset1.longDescriptionReference = longDescription;
    testConscienceAsset1.linkReference = link;
    testConscienceAsset1.displayNameReference = displayName;
    testConscienceAsset1.imageNameReference = imageName;

    testConscienceAsset2.nameReference = nameAsset2;
    testConscienceAsset2.costAsset = costAsset;
    testConscienceAsset2.orientationAsset = orientationAsset;
    testConscienceAsset2.moralValueAsset = moralValueAsset;
    testConscienceAsset2.shortDescriptionReference = shortDescription;
    testConscienceAsset2.originYear = originYear;
    testConscienceAsset2.longDescriptionReference = longDescription;
    testConscienceAsset2.linkReference = link;
    testConscienceAsset2.displayNameReference = displayName;
    testConscienceAsset2.imageNameReference = imageName;

    [testModelManager saveContext];
    
    testingSubject = [[ConscienceAssetDAO alloc] initWithKey:@"" andModelManager:testModelManager];

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