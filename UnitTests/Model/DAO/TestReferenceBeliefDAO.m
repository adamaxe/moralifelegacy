#import "ModelManager.h"
#import "ReferenceBelief.h"
#import "ReferenceBeliefDAO.h"

@interface TestReferenceBeliefDAO: SenTestCase {
    ModelManager *testModelManager;

    ReferenceBeliefDAO *testingSubject;
    
    ReferenceBelief *testReferenceBelief1;
    ReferenceBelief *testReferenceBelief2;
    
    NSString *nameAsset1;
    NSString *nameAsset2;
    NSString *nameAsset3;

    NSString *type;
    NSString *shortDescription;
    NSNumber *originYear;
    NSString *longDescription;
    NSString *link;
    NSString *displayName;
    NSString *imageName;
}

@end

@implementation TestReferenceBeliefDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    nameAsset1 = @"Asset1";
    nameAsset2 = @"Asset2";
    nameAsset3 = @"Asset3";    
    
    type = @"type";
    shortDescription = @"short description";
    originYear = [NSNumber numberWithInt:2010];
    longDescription = @"long description";
    link = @"http://www.teamaxe.org";    
    displayName = @"display name";
    imageName = @"image name";
    
    testReferenceBelief1 = [testModelManager create:ReferenceBelief.class];
    testReferenceBelief2 = [testModelManager create:ReferenceBelief.class];

    testReferenceBelief1.nameReference = nameAsset1;
    testReferenceBelief1.typeBelief = type;
    testReferenceBelief1.shortDescriptionReference = shortDescription;
    testReferenceBelief1.originYear = originYear;
    testReferenceBelief1.longDescriptionReference = longDescription;
    testReferenceBelief1.linkReference = link;
    testReferenceBelief1.displayNameReference = displayName;
    testReferenceBelief1.imageNameReference = imageName;

    testReferenceBelief2.nameReference = nameAsset2;
    testReferenceBelief2.typeBelief = type;
    testReferenceBelief2.shortDescriptionReference = shortDescription;
    testReferenceBelief2.originYear = originYear;
    testReferenceBelief2.longDescriptionReference = longDescription;
    testReferenceBelief2.linkReference = link;
    testReferenceBelief2.displayNameReference = displayName;
    testReferenceBelief2.imageNameReference = imageName;

    [testModelManager saveContext];
    
    testingSubject = [[ReferenceBeliefDAO alloc] initWithKey:@"" andModelManager:testModelManager];

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