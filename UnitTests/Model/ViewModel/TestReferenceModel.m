/**
 Unit Test for ReferenceModel.  Test model interaction with peristed data for ReferenceViewController and ReferenceListViewController
 
 @class TestReferenceModel
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/09/2012
 @file
 */

#import "ReferenceModel.h"
#import "TestModelHelper.h"
#import "ConscienceAsset.h"
#import "ReferencePerson.h"
#import "ReferenceAsset.h"
#import "UserCollectable.h"
#import "Moral.h"
#import "OCMock/OCMock.h"

@interface TestReferenceModel :XCTestCase {
    
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

    virtue1 = [TestModelHelper createMoralWithName:@"Virtue1" withType:@"Virtue" withModelManager:testModelManager];
    vice1 = [TestModelHelper createMoralWithName:@"Vice1" withType:@"Vice" withModelManager:testModelManager];
    testAsset1 = [TestModelHelper createAssetWithName:@"Asset1" withModelManager:testModelManager];
    testAsset2 = [TestModelHelper createAssetWithName:@"Asset2" withModelManager:testModelManager];
    testPerson1 = [TestModelHelper createPersonWithName:@"Person1" withModelManager:testModelManager];
    testPerson2 = [TestModelHelper createPersonWithName:@"Person2" withModelManager:testModelManager];
    [testModelManager saveContext];

    //Don't add testPerson2 to ensure that ReferenceModel only returns things owned by User
    userCollection = @[testPerson1.nameReference, testAsset1.nameReference, testAsset2.nameReference, [virtue1 nameMoral], [vice1 nameMoral]];

    testingSubject = [[ReferenceModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andUserCollection:userCollection];

}

- (void)testReferenceModelCanBeCreated {

    ReferenceModel *testingSubjectCreate = [[ReferenceModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andUserCollection:userCollection];

    XCTAssertNotNil(testingSubjectCreate, @"ReferenceModel can't be created.");

    
}

- (void)testReferenceModelDefaultValuesAreSetCorrectly {

    XCTAssertEqual(testingSubject.referenceType, MLReferenceModelTypeConscienceAsset, @"ReferenceModel referenceType isn't ConscienceAsset by default");
//    XCTAssertEqual(testingSubject.title, NSLocalizedString(@"ReferenceDetailScreenAccessoriesTitle",@"Title for Accessories Button"), nil);
    XCTAssertFalse(testingSubject.hasLink, @"ReferenceModel hasLink is true incorrectly");
    XCTAssertFalse(testingSubject.hasQuote, @"ReferenceModel hasQuote is true incorrectly");

}

- (void)testReferenceModelReferenceTypeCanBeSet {

    testingSubject.referenceType = MLReferenceModelTypePerson;
    XCTAssertEqual(testingSubject.referenceType, MLReferenceModelTypePerson, @"ReferenceModel referenceType can't be set");

}

- (void)testWhenNoSystemDataIsPresentReferencesAreEmpty {

    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    ReferenceModel *testingSubjectCreate = [[ReferenceModel alloc] initWithModelManager:testModelManagerCreate andDefaults:userDefaultsMock andUserCollection:userCollection];

    XCTAssertTrue(testingSubjectCreate.references.count == 0, @"References are not empty");
    XCTAssertTrue(testingSubjectCreate.referenceKeys.count == 0, @"ReferenceKeys are not empty");
    XCTAssertTrue(testingSubjectCreate.details.count == 0, @"Details are not empty");
    XCTAssertTrue(testingSubjectCreate.icons.count == 0, @"Icons are not empty");


}

- (void)testWhenSystemDataIsPresentButNoUserDataIsPresentReferencesAreEmpty {

    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    ReferenceModel *testingSubjectCreate = [[ReferenceModel alloc] initWithModelManager:testModelManagerCreate andDefaults:userDefaultsMock andUserCollection:@[]];

    XCTAssertTrue(testingSubjectCreate.references.count == 0, @"References are not empty");
    XCTAssertTrue(testingSubjectCreate.referenceKeys.count == 0, @"ReferenceKeys are not empty");
    XCTAssertTrue(testingSubjectCreate.details.count == 0, @"Details are not empty");
    XCTAssertTrue(testingSubjectCreate.icons.count == 0, @"Icons are not empty");


}

- (void)testWhenSystemAndUserDataIsPresentReferencePeopleMetadataIsCorrect {

    testingSubject.referenceType = MLReferenceModelTypePerson;

    XCTAssertEqual(testingSubject.title, NSLocalizedString(@"ReferenceDetailScreenPeopleTitle",nil), @"ReferenceModel title isn't Person");
    XCTAssertTrue(testingSubject.hasLink, @"ReferenceModel hasLink is false incorrectly");
    XCTAssertTrue(testingSubject.hasQuote, @"ReferenceModel hasQuote is false incorrectly");

}

- (void)testWhenSystemAndUserDataIsPresentReferencePeopleAreCorrect {

    testingSubject.referenceType = MLReferenceModelTypePerson;

    XCTAssertTrue(testingSubject.references.count == 1, @"ReferencePerson references count is incorrect");
    XCTAssertTrue(testingSubject.referenceKeys.count == 1, @"ReferencePerson referenceKeys count is incorrect");
    XCTAssertTrue(testingSubject.details.count == 1, @"ReferencePerson details count is incorrect");
    XCTAssertTrue(testingSubject.icons.count == 1, @"ReferencePerson icons count is incorrect");

    XCTAssertEqualObjects([testingSubject.references lastObject], [testPerson1 displayNameReference], @"ReferencePerson displayName is wrong");
    XCTAssertEqualObjects([testingSubject.icons lastObject], [testPerson1 imageNameReference], @"ReferencePerson icon is wrong");
    XCTAssertEqualObjects([testingSubject.referenceKeys lastObject], [testPerson1 nameReference], @"ReferencePerson referenceKey is wrong");
    XCTAssertEqualObjects([testingSubject.details lastObject], [testPerson1 shortDescriptionReference], @"ReferencePerson detail is wrong");

}

- (void)testWhenSystemAndUserDataIsPresentConscienceAssetsMetadataIsCorrect {

    testingSubject.referenceType = MLReferenceModelTypeConscienceAsset;

    XCTAssertEqual(testingSubject.title, NSLocalizedString(@"ReferenceDetailScreenAccessoriesTitle",nil), @"ReferenceModel title isn't Accessory");
    XCTAssertFalse(testingSubject.hasLink, @"ReferenceModel hasLink is true incorrectly");
    XCTAssertFalse(testingSubject.hasQuote, @"ReferenceModel hasQuote is true incorrectly");
}

- (void)testWhenSystemAndUserDataIsPresentConscienceAssetsAreCorrect {

    testingSubject.referenceType = MLReferenceModelTypeConscienceAsset;

    XCTAssertTrue(testingSubject.references.count == 2, @"ConscienceAsset references count is incorrect");
    XCTAssertTrue(testingSubject.referenceKeys.count == 2, @"ConscienceAsset referenceKeys count is incorrect");
    XCTAssertTrue(testingSubject.details.count == 2, @"ConscienceAsset details count is incorrect");
    XCTAssertTrue(testingSubject.icons.count == 2, @"ConscienceAsset icons count is incorrect");

    XCTAssertTrue([testingSubject.references containsObject:[testAsset1 displayNameReference]], @"ConscienceAsset1 displayName not present");
    XCTAssertTrue([testingSubject.icons containsObject:[testAsset1 imageNameReference]],  @"ConscienceAsset1 icon not present");
    XCTAssertTrue([testingSubject.referenceKeys containsObject:[testAsset1 nameReference]], @"ConscienceAsset1 referenceKey not present");
    XCTAssertTrue([testingSubject.details containsObject:[testAsset1 shortDescriptionReference]], @"ConscienceAsset1 detail not present");

    XCTAssertTrue([testingSubject.references containsObject:[testAsset2 displayNameReference]], @"ConscienceAsset2 displayName not present");
    XCTAssertTrue([testingSubject.icons containsObject:[testAsset2 imageNameReference]],  @"ConscienceAsset2 icon not present");
    XCTAssertTrue([testingSubject.referenceKeys containsObject:[testAsset2 nameReference]], @"ConscienceAsset2 referenceKey not present");
    XCTAssertTrue([testingSubject.details containsObject:[testAsset2 shortDescriptionReference]], @"ConscienceAsset2 detail not present");
    
}

- (void)testWhenSystemAndUserDataIsPresentMoralsMetadataIsCorrect {

    testingSubject.referenceType = MLReferenceModelTypeMoral;

    XCTAssertEqual(testingSubject.title, NSLocalizedString(@"ReferenceDetailScreenMoralsTitle",nil), @"ReferenceModel title isn't Moral");
    XCTAssertTrue(testingSubject.hasLink, @"ReferenceModel hasLink is false incorrectly");
    XCTAssertFalse(testingSubject.hasQuote, @"ReferenceModel hasQuote is true incorrectly");
}

- (void)testWhenSystemAndUserDataIsPresentMoralsAreCorrect {

    testingSubject.referenceType = MLReferenceModelTypeMoral;

    XCTAssertTrue(testingSubject.references.count == 2, @"Moral references count is incorrect");
    XCTAssertTrue(testingSubject.referenceKeys.count == 2, @"Moral referenceKeys count is incorrect");
    XCTAssertTrue(testingSubject.details.count == 2, @"Moral details count is incorrect");
    XCTAssertTrue(testingSubject.icons.count == 2, @"Moral icons count is incorrect");

    NSString *virtueLongDescription = [NSString stringWithFormat:@"%@\n\nDefinition: %@", [virtue1 longDescriptionMoral], [virtue1 definitionMoral]];

    XCTAssertTrue([testingSubject.references containsObject:[virtue1 displayNameMoral]], @"Virtue displayName not present");
    XCTAssertTrue([testingSubject.icons containsObject:[virtue1 imageNameMoral]],  @"Virtue icon not present");
    XCTAssertTrue([testingSubject.referenceKeys containsObject:[virtue1 nameMoral]], @"Virtue referenceKey not present");
    XCTAssertTrue([testingSubject.details containsObject:[virtue1 shortDescriptionMoral]], @"Virtue detail not correct");
    XCTAssertTrue([testingSubject.longDescriptions containsObject:virtueLongDescription], @"Virtue longDescription not correct");

    NSString *viceLongDescription = [NSString stringWithFormat:@"%@\n\nDefinition: %@", [vice1 longDescriptionMoral], [vice1 definitionMoral]];

    XCTAssertTrue([testingSubject.references containsObject:[vice1 displayNameMoral]], @"Vice displayName not present");
    XCTAssertTrue([testingSubject.icons containsObject:[vice1 imageNameMoral]],  @"Vice icon not present");
    XCTAssertTrue([testingSubject.referenceKeys containsObject:[vice1 nameMoral]], @"Vice referenceKey not present");
    XCTAssertTrue([testingSubject.details containsObject:[vice1 shortDescriptionMoral]], @"Vice detail not correct");
    XCTAssertTrue([testingSubject.longDescriptions containsObject:viceLongDescription], @"Vice longDescription not correct");

}

- (void)testWhenSystemAndUserDataIsPresentConscienceAssetsAreSortedByShortDescription {

    testingSubject.referenceType = MLReferenceModelTypeConscienceAsset;

    XCTAssertEqualObjects([testingSubject.referenceKeys objectAtIndex:0], [testAsset1 nameReference], @"ConscienceAsset1 referenceKey ordered incorrectly");
    XCTAssertEqualObjects([testingSubject.details objectAtIndex:0], [testAsset1 shortDescriptionReference], @"ConscienceAsset1 detail ordered incorrectly");

    XCTAssertEqualObjects([testingSubject.referenceKeys objectAtIndex:1], [testAsset2 nameReference], @"ConscienceAsset2 referenceKey ordered incorrectly");
    XCTAssertEqualObjects([testingSubject.details objectAtIndex:1], [testAsset2 shortDescriptionReference], @"ConscienceAsset2 detail ordered incorrectly");

}

- (void)testSelectConscienceAssetWritesToStandardUserDefaultsForViewing {

    testingSubject.referenceType = MLReferenceModelTypeConscienceAsset;

    [[userDefaultsMock expect] setInteger:testingSubject.referenceType forKey:@"referenceType"];
    [[userDefaultsMock expect] setObject:testAsset1.nameReference forKey:@"referenceKey"];
    [[userDefaultsMock expect] synchronize];

    [testingSubject selectReference:testAsset1.nameReference];

    [userDefaultsMock verify];
}

- (void)testSelectVirtueWritesToStandardUserDefaultsForViewing {

    testingSubject.referenceType = MLReferenceModelTypeMoral;

    [[userDefaultsMock expect] setInteger:testingSubject.referenceType forKey:@"referenceType"];
    [[userDefaultsMock expect] setObject:virtue1.nameMoral forKey:@"referenceKey"];
    [[userDefaultsMock expect] synchronize];

    [testingSubject selectReference:virtue1.nameMoral];

    [userDefaultsMock verify];
}

- (void)testSelectViceWritesToStandardUserDefaultsForViewing {

    testingSubject.referenceType = MLReferenceModelTypeMoral;

    [[userDefaultsMock expect] setInteger:testingSubject.referenceType forKey:@"referenceType"];
    [[userDefaultsMock expect] setObject:vice1.nameMoral forKey:@"referenceKey"];
    [[userDefaultsMock expect] synchronize];

    [testingSubject selectReference:vice1.nameMoral];
    
    [userDefaultsMock verify];
}

@end

