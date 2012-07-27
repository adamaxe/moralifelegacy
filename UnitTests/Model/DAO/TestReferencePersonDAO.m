#import "ModelManager.h"
#import "ReferencePerson.h"
#import "ReferencePersonDAO.h"

@interface TestReferencePersonDAO: SenTestCase {
    ModelManager *testModelManager;

    ReferencePersonDAO *testingSubject;
    
    ReferencePerson *testReferencePerson1;
    ReferencePerson *testReferencePerson2;
    
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

@implementation TestReferencePersonDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    nameAsset1 = @"Asset1";
    nameAsset2 = @"Asset2";
    nameAsset3 = @"Asset3";    
    
    shortDescription = @"short description";
    originYear = @2010;
    longDescription = @"long description";
    link = @"http://www.teamaxe.org";    
    displayName = @"display name";
    imageName = @"image name";
    
    testReferencePerson1 = [testModelManager create:ReferencePerson.class];
    testReferencePerson2 = [testModelManager create:ReferencePerson.class];

    testReferencePerson1.nameReference = nameAsset1;
    testReferencePerson1.shortDescriptionReference = shortDescription;
    testReferencePerson1.originYear = originYear;
    testReferencePerson1.longDescriptionReference = longDescription;
    testReferencePerson1.linkReference = link;
    testReferencePerson1.displayNameReference = displayName;
    testReferencePerson1.imageNameReference = imageName;

    testReferencePerson2.nameReference = nameAsset2;
    testReferencePerson2.shortDescriptionReference = shortDescription;
    testReferencePerson2.originYear = originYear;
    testReferencePerson2.longDescriptionReference = longDescription;
    testReferencePerson2.linkReference = link;
    testReferencePerson2.displayNameReference = displayName;
    testReferencePerson2.imageNameReference = imageName;

    [testModelManager saveContext];
    
    testingSubject = [[ReferencePersonDAO alloc] initWithKey:@"" andModelManager:testModelManager];

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