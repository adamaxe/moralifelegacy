/**
 Unit Test for ReferenceModel.  Test model interaction with peristed data for ReferenceDetailViewController and ReferenceListViewController
 
 @class TestReferenceModel
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/09/2012
 @file
 */

#import "ReferenceModel.h"
#import "ModelManager.h"
#import "ConscienceAsset.h"
#import "ReferencePerson.h"
#import "ReferenceAsset.h"
#import "UserCollectable.h"
#import "Moral.h"
#import "OCMock/OCMock.h"

@interface TestReferenceModel : SenTestCase {
    
    ReferenceModel *testingSubject;
    ModelManager *testModelManager;
    id userDefaultsMock;
    NSArray *userCollection;

    Moral *virtue1;
    Moral *vice1;
    ConscienceAsset *testAsset1;
    ConscienceAsset *testAsset2;
    ReferencePerson *testPerson1;
    ReferencePerson *testPerson2;

}

@end

@implementation TestReferenceModel

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    userDefaultsMock = [OCMockObject niceMockForClass:NSUserDefaults.class];

    virtue1 = [self createMoralWithName:@"Virtue1" withType:@"Virtue" withModelManager:testModelManager];
    vice1 = [self createMoralWithName:@"Vice1" withType:@"Vice" withModelManager:testModelManager];
    testAsset1 = [self createAssetWithName:@"Asset1" withModelManager:testModelManager];
    testAsset2 = [self createAssetWithName:@"Asset2" withModelManager:testModelManager];
    testPerson1 = [self createPersonWithName:@"Person1" withModelManager:testModelManager];
    testPerson2 = [self createPersonWithName:@"Person2" withModelManager:testModelManager];

    //Don't add testPerson2 to ensure that ReferenceModel only returns things owned by User
    userCollection = @[[testPerson1 nameReference], [testAsset1 nameReference], [testAsset2 nameReference], [virtue1 nameMoral], [vice1 nameMoral]];

    testingSubject = [[ReferenceModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andUserCollection:userCollection];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];

}

- (void)testReferenceModelCanBeCreated {

    ReferenceModel *testingSubjectCreate = [[ReferenceModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andUserCollection:userCollection];

    STAssertNotNil(testingSubjectCreate, @"ReferenceModel can't be created.");

    
}

- (void)testReferenceModelDefaultValuesAreSetCorrectly {

    STAssertEquals(testingSubject.referenceType, kReferenceModelTypeConscienceAsset, @"ReferenceModel referenceType isn't ConscienceAsset by default");

}
- (void)testReferenceModelReferenceTypeCanBeSet {

    testingSubject.referenceType = kReferenceModelTypePerson;
    STAssertEquals(testingSubject.referenceType, kReferenceModelTypePerson, @"ReferenceModel referenceType can't be set");

}

- (void)testWhenNoSystemDataIsPresentReferencesAreEmpty {

    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    ReferenceModel *testingSubjectCreate = [[ReferenceModel alloc] initWithModelManager:testModelManagerCreate andDefaults:userDefaultsMock andUserCollection:userCollection];

    STAssertTrue(testingSubjectCreate.references.count == 0, @"References are not empty");
    STAssertTrue(testingSubjectCreate.referenceKeys.count == 0, @"ReferenceKeys are not empty");
    STAssertTrue(testingSubjectCreate.details.count == 0, @"Details are not empty");
    STAssertTrue(testingSubjectCreate.icons.count == 0, @"Icons are not empty");


}

- (void)testWhenSystemDataIsPresentButNoUserDataIsPresentReferencesAreEmpty {

    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    ReferenceModel *testingSubjectCreate = [[ReferenceModel alloc] initWithModelManager:testModelManagerCreate andDefaults:userDefaultsMock andUserCollection:@[]];

    STAssertTrue(testingSubjectCreate.references.count == 0, @"References are not empty");
    STAssertTrue(testingSubjectCreate.referenceKeys.count == 0, @"ReferenceKeys are not empty");
    STAssertTrue(testingSubjectCreate.details.count == 0, @"Details are not empty");
    STAssertTrue(testingSubjectCreate.icons.count == 0, @"Icons are not empty");


}

- (void)testWhenSystemAndUserDataIsPresentReferencePersonsAreCorrect {

    testingSubject.referenceType = kReferenceModelTypePerson;

    STAssertTrue(testingSubject.references.count == 1, @"ReferencePerson references count is incorrect");
    STAssertTrue(testingSubject.referenceKeys.count == 1, @"ReferencePerson referenceKeys count is incorrect");
    STAssertTrue(testingSubject.details.count == 1, @"ReferencePerson details count is incorrect");
    STAssertTrue(testingSubject.icons.count == 1, @"ReferencePerson icons count is incorrect");

    STAssertEqualObjects([testingSubject.references lastObject], [testPerson1 displayNameReference], @"ReferencePerson displayName is wrong");
    STAssertEqualObjects([testingSubject.icons lastObject], [testPerson1 imageNameReference], @"ReferencePerson icon is wrong");
    STAssertEqualObjects([testingSubject.referenceKeys lastObject], [testPerson1 nameReference], @"ReferencePerson referenceKey is wrong");
    STAssertEqualObjects([testingSubject.details lastObject], [testPerson1 shortDescriptionReference], @"ReferencePerson detail is wrong");

}

- (void)testWhenSystemAndUserDataIsPresentConscienceAssetsAreCorrect {

    testingSubject.referenceType = kReferenceModelTypeConscienceAsset;

    STAssertTrue(testingSubject.references.count == 2, @"ConscienceAsset references count is incorrect");
    STAssertTrue(testingSubject.referenceKeys.count == 2, @"ConscienceAsset referenceKeys count is incorrect");
    STAssertTrue(testingSubject.details.count == 2, @"ConscienceAsset details count is incorrect");
    STAssertTrue(testingSubject.icons.count == 2, @"ConscienceAsset icons count is incorrect");

    STAssertTrue([testingSubject.references containsObject:[testAsset1 displayNameReference]], @"ConscienceAsset1 displayName not present");
    STAssertTrue([testingSubject.icons containsObject:[testAsset1 imageNameReference]],  @"ConscienceAsset1 icon not present");
    STAssertTrue([testingSubject.referenceKeys containsObject:[testAsset1 nameReference]], @"ConscienceAsset1 referenceKey not present");
    STAssertTrue([testingSubject.details containsObject:[testAsset1 shortDescriptionReference]], @"ConscienceAsset1 detail not present");

    STAssertTrue([testingSubject.references containsObject:[testAsset2 displayNameReference]], @"ConscienceAsset2 displayName not present");
    STAssertTrue([testingSubject.icons containsObject:[testAsset2 imageNameReference]],  @"ConscienceAsset2 icon not present");
    STAssertTrue([testingSubject.referenceKeys containsObject:[testAsset2 nameReference]], @"ConscienceAsset2 referenceKey not present");
    STAssertTrue([testingSubject.details containsObject:[testAsset2 shortDescriptionReference]], @"ConscienceAsset2 detail not present");
    
}

- (void)testWhenSystemAndUserDataIsPresentMoralsAreCorrect {

    testingSubject.referenceType = kReferenceModelTypeMoral;

    STAssertTrue(testingSubject.references.count == 2, @"Moral references count is incorrect");
    STAssertTrue(testingSubject.referenceKeys.count == 2, @"Moral referenceKeys count is incorrect");
    STAssertTrue(testingSubject.details.count == 2, @"Moral details count is incorrect");
    STAssertTrue(testingSubject.icons.count == 2, @"Moral icons count is incorrect");

    NSString *virtueDetail = [NSString stringWithFormat:@"%@: %@", [virtue1 shortDescriptionMoral], [virtue1 longDescriptionMoral]];

    STAssertTrue([testingSubject.references containsObject:[virtue1 displayNameMoral]], @"Virtue displayName not present");
    STAssertTrue([testingSubject.icons containsObject:[virtue1 imageNameMoral]],  @"Virtue icon not present");
    STAssertTrue([testingSubject.referenceKeys containsObject:[virtue1 nameMoral]], @"Virtue referenceKey not present");
    STAssertTrue([testingSubject.details containsObject:virtueDetail], @"Virtue detail not present");

    NSString *viceDetail = [NSString stringWithFormat:@"%@: %@", [vice1 shortDescriptionMoral], [vice1 longDescriptionMoral]];

    STAssertTrue([testingSubject.references containsObject:[vice1 displayNameMoral]], @"Vice displayName not present");
    STAssertTrue([testingSubject.icons containsObject:[vice1 imageNameMoral]],  @"Vice icon not present");
    STAssertTrue([testingSubject.referenceKeys containsObject:[vice1 nameMoral]], @"Vice referenceKey not present");
    STAssertTrue([testingSubject.details containsObject:viceDetail], @"Vice detail not present");
}

- (void)testWhenSystemAndUserDataIsPresentConscienceAssetsAreSortedByShortDescription {

    testingSubject.referenceType = kReferenceModelTypeConscienceAsset;

    STAssertEqualObjects([testingSubject.referenceKeys objectAtIndex:0], [testAsset1 nameReference], @"ConscienceAsset1 referenceKey ordered incorrectly");
    STAssertEqualObjects([testingSubject.details objectAtIndex:0], [testAsset1 shortDescriptionReference], @"ConscienceAsset1 detail ordered incorrectly");

    STAssertEqualObjects([testingSubject.referenceKeys objectAtIndex:1], [testAsset2 nameReference], @"ConscienceAsset2 referenceKey ordered incorrectly");
    STAssertEqualObjects([testingSubject.details objectAtIndex:1], [testAsset2 shortDescriptionReference], @"ConscienceAsset2 detail ordered incorrectly");

}

- (void)testRetrieveConscienceAssetWritesToStandardUserDefaultsForViewing {

    testingSubject.referenceType = kReferenceModelTypeConscienceAsset;

    [[userDefaultsMock expect] setInteger:testingSubject.referenceType forKey:@"referenceType"];
    [[userDefaultsMock expect] setObject:testAsset1.nameReference forKey:@"referenceKey"];
    [[userDefaultsMock expect] synchronize];

    [testingSubject retrieveReference:testAsset1.nameReference];

    [userDefaultsMock verify];
}

- (void)testRetrieveVirtueWritesToStandardUserDefaultsForViewing {

    testingSubject.referenceType = kReferenceModelTypeMoral;

    [[userDefaultsMock expect] setInteger:testingSubject.referenceType forKey:@"referenceType"];
    [[userDefaultsMock expect] setObject:virtue1.nameMoral forKey:@"referenceKey"];
    [[userDefaultsMock expect] synchronize];

    [testingSubject retrieveReference:virtue1.nameMoral];

    [userDefaultsMock verify];
}

- (void)testRetrieveViceWritesToStandardUserDefaultsForViewing {

    testingSubject.referenceType = kReferenceModelTypeMoral;

    [[userDefaultsMock expect] setInteger:testingSubject.referenceType forKey:@"referenceType"];
    [[userDefaultsMock expect] setObject:vice1.nameMoral forKey:@"referenceKey"];
    [[userDefaultsMock expect] synchronize];

    [testingSubject retrieveReference:vice1.nameMoral];

    [userDefaultsMock verify];
}

- (Moral *)createMoralWithName:(NSString *)moralName withType:(NSString *)type withModelManager:(ModelManager *)modelManager{

    NSString *imageNameGenerated = [NSString stringWithFormat:@"%@imageName", moralName];

    Moral *testMoral1 = [modelManager create:Moral.class];

    testMoral1.shortDescriptionMoral = type;
    testMoral1.nameMoral = moralName;

    testMoral1.imageNameMoral = imageNameGenerated;
    testMoral1.colorMoral = @"FF0000";
    testMoral1.displayNameMoral = @"displayName";
    testMoral1.longDescriptionMoral = @"longDescription";
    testMoral1.component = @"component";
    testMoral1.linkMoral = @"link";
    testMoral1.definitionMoral = @"definition";

    [modelManager saveContext];

    return testMoral1;
}

- (ReferencePerson *)createPersonWithName:(NSString *)personName withModelManager:(ModelManager *)modelManager{

    ReferencePerson *testPersonLocal1 = [modelManager create:ReferencePerson.class];

    testPersonLocal1.nameReference = personName;

    testPersonLocal1.imageNameReference = @"imageNamePerson";
    testPersonLocal1.displayNameReference = @"displayNamePerson";
    testPersonLocal1.longDescriptionReference = @"longDescriptionPerson";
    testPersonLocal1.originYear = @2012;
    testPersonLocal1.linkReference = @"linkPerson";
    testPersonLocal1.shortDescriptionReference = [NSString stringWithFormat:@"%@shortDescriptionPerson", personName];

    [modelManager saveContext];

    return testPersonLocal1;
}

- (ConscienceAsset *)createAssetWithName:(NSString *)assetName withModelManager:(ModelManager *)modelManager{

    ConscienceAsset *testAssetLocal1 = [modelManager create:ConscienceAsset.class];

    testAssetLocal1.nameReference = assetName;

    testAssetLocal1.costAsset = @20;
    testAssetLocal1.imageNameReference = @"imageNameAsset";
    testAssetLocal1.displayNameReference = @"displayNameAsset";
    testAssetLocal1.longDescriptionReference = @"longDescriptionAsset";
    testAssetLocal1.originYear = @2011;
    testAssetLocal1.linkReference = @"linkAsset";
    testAssetLocal1.shortDescriptionReference = [NSString stringWithFormat:@"%@shortDescriptionAsset", assetName];

    [modelManager saveContext];

    return testAssetLocal1;
}

@end

