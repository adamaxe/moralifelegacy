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
    ConscienceAsset *testAsset;
    ReferencePerson *testPerson;
    
}

@end

@implementation TestReferenceModel

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    userDefaultsMock = [OCMockObject niceMockForClass:NSUserDefaults.class];

    virtue1 = [self createMoralWithName:@"Virtue1" withType:@"Virtue" withModelManager:testModelManager];
    vice1 = [self createMoralWithName:@"Vice1" withType:@"Vice" withModelManager:testModelManager];
    testAsset = [self createAssetWithName:@"Asset1" withModelManager:testModelManager];
    testPerson = [self createPersonWithName:@"Person1" withModelManager:testModelManager];

    userCollection = @[[testPerson nameReference], [testAsset nameReference], [virtue1 nameMoral], [vice1 nameMoral]];

    testingSubject = [[ReferenceModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andUserCollection:userCollection];

}

- (void)tearDown{

	//Tear-down code here.
    [testModelManager release];
	[testingSubject release];

	[super tearDown];

}

- (void)testReferenceModelCanBeCreated {

    ReferenceModel *testingSubjectCreate = [[ReferenceModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andUserCollection:userCollection];

    STAssertNotNil(testingSubjectCreate, @"ReferenceModel can't be created.");

    [testingSubjectCreate release];
    
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

    [testingSubjectCreate release];
    [testModelManagerCreate release];

}

- (void)testWhenSystemDataIsPresentButNoUserDataIsPresentReferencesAreEmpty {

    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    ReferenceModel *testingSubjectCreate = [[ReferenceModel alloc] initWithModelManager:testModelManagerCreate andDefaults:userDefaultsMock andUserCollection:@[]];

    STAssertTrue(testingSubjectCreate.references.count == 0, @"References are not empty");
    STAssertTrue(testingSubjectCreate.referenceKeys.count == 0, @"ReferenceKeys are not empty");
    STAssertTrue(testingSubjectCreate.details.count == 0, @"Details are not empty");
    STAssertTrue(testingSubjectCreate.icons.count == 0, @"Icons are not empty");

    [testingSubjectCreate release];
    [testModelManagerCreate release];

}

- (void)testWhenSystemAndUserDataIsPresentReferencePersonsAreCorrect {

    testingSubject.referenceType = kReferenceModelTypePerson;

    STAssertTrue(testingSubject.references.count == 1, @"ReferencePerson references count is incorrect");
    STAssertTrue(testingSubject.referenceKeys.count == 1, @"ReferencePerson referenceKeys count is incorrect");
    STAssertTrue(testingSubject.details.count == 1, @"ReferencePerson details count is incorrect");
    STAssertTrue(testingSubject.icons.count == 1, @"ReferencePerson icons count is incorrect");

    STAssertEqualObjects([testingSubject.references lastObject], [testPerson displayNameReference], @"ReferencePerson displayName is wrong");
    STAssertEqualObjects([testingSubject.icons lastObject], [testPerson imageNameReference], @"ReferencePerson icon is wrong");
    STAssertEqualObjects([testingSubject.referenceKeys lastObject], [testPerson nameReference], @"ReferencePerson referenceKey is wrong");
    STAssertEqualObjects([testingSubject.details lastObject], [testPerson shortDescriptionReference], @"ReferencePerson detail is wrong");

}

- (void)testWhenSystemAndUserDataIsPresentConscienceAssetsAreCorrect {

    testingSubject.referenceType = kReferenceModelTypeConscienceAsset;

    STAssertTrue(testingSubject.references.count == 1, @"ConscienceAsset references count is incorrect");
    STAssertTrue(testingSubject.referenceKeys.count == 1, @"ConscienceAsset referenceKeys count is incorrect");
    STAssertTrue(testingSubject.details.count == 1, @"ConscienceAsset details count is incorrect");
    STAssertTrue(testingSubject.icons.count == 1, @"ConscienceAsset icons count is incorrect");

    STAssertEqualObjects([testingSubject.references lastObject], [testAsset displayNameReference], @"ConscienceAsset displayName is wrong");
    STAssertEqualObjects([testingSubject.icons lastObject], [testAsset imageNameReference], @"ConscienceAsset icon is wrong");
    STAssertEqualObjects([testingSubject.referenceKeys lastObject], [testAsset nameReference], @"ConscienceAsset referenceKey is wrong");
    STAssertEqualObjects([testingSubject.details lastObject], [testAsset shortDescriptionReference], @"ConscienceAsset detail is wrong");
    
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

- (void)testRetrieveConscienceAssetWritesToStandardUserDefaultsForViewing {

    testingSubject.referenceType = kReferenceModelTypeConscienceAsset;

    [[userDefaultsMock expect] setInteger:testingSubject.referenceType forKey:@"referenceType"];
    [[userDefaultsMock expect] setObject:testAsset.nameReference forKey:@"referenceKey"];
    [[userDefaultsMock expect] synchronize];

    [testingSubject retrieveReference:testAsset.nameReference];

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

    ReferencePerson *testPerson1 = [modelManager create:ReferencePerson.class];

    testPerson1.nameReference = personName;

    testPerson1.imageNameReference = @"imageNamePerson";
    testPerson1.displayNameReference = @"displayNamePerson";
    testPerson1.longDescriptionReference = @"longDescriptionPerson";
    testPerson1.originYear = @2012;
    testPerson1.linkReference = @"linkPerson";
    testPerson1.shortDescriptionReference = @"shortDescriptionPerson";

    [modelManager saveContext];

    return testPerson1;
}

- (ConscienceAsset *)createAssetWithName:(NSString *)assetName withModelManager:(ModelManager *)modelManager{

    ConscienceAsset *testAsset1 = [modelManager create:ConscienceAsset.class];

    testAsset1.nameReference = assetName;

    testAsset1.costAsset = @20;
    testAsset1.imageNameReference = @"imageNameAsset";
    testAsset1.displayNameReference = @"displayNameAsset";
    testAsset1.longDescriptionReference = @"longDescriptionAsset";
    testAsset1.originYear = @2011;
    testAsset1.linkReference = @"linkAsset";
    testAsset1.shortDescriptionReference = @"shortDescriptionAsset";

    [modelManager saveContext];

    return testAsset1;
}

@end

