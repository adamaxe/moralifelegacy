#import "ModelManager.h"
#import "ReferenceText.h"
#import "ReferenceTextDAO.h"

@interface TestReferenceTextDAO: SenTestCase {
    ModelManager *testModelManager;

    ReferenceTextDAO *testingSubject;
    
    ReferenceText *testReferenceText1;
    ReferenceText *testReferenceText2;
    
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

@implementation TestReferenceTextDAO

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
    
    testReferenceText1 = [testModelManager create:ReferenceText.class];
    testReferenceText2 = [testModelManager create:ReferenceText.class];

    testReferenceText1.nameReference = nameAsset1;
    testReferenceText1.shortDescriptionReference = shortDescription;
    testReferenceText1.originYear = originYear;
    testReferenceText1.longDescriptionReference = longDescription;
    testReferenceText1.linkReference = link;
    testReferenceText1.displayNameReference = displayName;
    testReferenceText1.imageNameReference = imageName;

    testReferenceText2.nameReference = nameAsset2;
    testReferenceText2.shortDescriptionReference = shortDescription;
    testReferenceText2.originYear = originYear;
    testReferenceText2.longDescriptionReference = longDescription;
    testReferenceText2.linkReference = link;
    testReferenceText2.displayNameReference = displayName;
    testReferenceText2.imageNameReference = imageName;

    [testModelManager saveContext];
    
    testingSubject = [[ReferenceTextDAO alloc] initWithKey:@"" andModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.
	[testModelManager release];
    [testingSubject release];

	[super tearDown];
    
}

- (void)testReferenceTextDAOAllTypeCanBeCreated {
    
    STAssertNotNil(testingSubject, @"ReferenceTextDAO can't be created.");
}

- (void)testReferenceTextDAORead {
    
    ReferenceText *testAsset = [testingSubject read:nameAsset1];
    STAssertEqualObjects(testAsset, testReferenceText1, @"ReferenceTextDAO not populated with text 1."); 
    
    testAsset = [testingSubject read:nameAsset2];
    STAssertEqualObjects(testAsset, testReferenceText2, @"ReferenceTextDAO not populated with text 2."); 
}

- (void)testReferenceTextDAOReadAll {
        
    NSArray *allAssets = [testingSubject readAll];
    STAssertTrue([allAssets containsObject:testReferenceText1], @"ReferenceTextDAO All not populated with text 1.");
    STAssertTrue([allAssets containsObject:testReferenceText2], @"ReferenceTextDAO All not populated with text 2.");
    
}

- (void)testReferenceTextDAOCreateFailsCorrectly {
    
    id testMoral = [testingSubject createObject];
    STAssertNil(testMoral, @"ReferenceTextDAO was able to create incorrectly.");    
}

- (void)testReferenceTextDAOUpdateFailsCorrectly {
    
    BOOL isUpdateSuccessful = [testingSubject update];
    STAssertFalse(isUpdateSuccessful, @"ReferenceTextDAO was able to update incorrectly.");    
}

- (void)testReferenceTextDAODeleteFailsCorrectly {
    
    BOOL isDeleteSuccessful = [testingSubject delete:testReferenceText2];
    STAssertFalse(isDeleteSuccessful, @"ReferenceTextDAO was able to delete incorrectly.");
    
    ReferenceText *testDeletedAssetVerify = [testingSubject read:nameAsset2];
    STAssertEqualObjects(testReferenceText2, testDeletedAssetVerify, @"ReferenceText was deleted incorrectly.");
    
}

@end