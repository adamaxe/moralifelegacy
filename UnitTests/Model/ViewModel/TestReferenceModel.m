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

    STAssertNotNil(testingSubjectCreate, @"ReferenceModel can't be created.");

    
}

- (void)testReferenceModelDefaultValuesAreSetCorrectly {

    STAssertEquals(testingSubject.referenceType, MLReferenceModelTypeConscienceAsset, @"ReferenceModel referenceType isn't ConscienceAsset by default");
    STAssertEquals(testingSubject.title, NSLocalizedString(@"ReferenceDetailScreenAccessoriesTitle",@"Title for Accessories Button"), nil);
    STAssertFalse(testingSubject.hasLink, @"ReferenceModel hasLink is true incorrectly");
    STAssertFalse(testingSubject.hasQuote, @"ReferenceModel hasQuote is true incorrectly");

}

- (void)testReferenceModelReferenceTypeCanBeSet {

    testingSubject.referenceType = MLReferenceModelTypePerson;
    STAssertEquals(testingSubject.referenceType, MLReferenceModelTypePerson, @"ReferenceModel referenceType can't be set");

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

- (void)testWhenSystemAndUserDataIsPresentReferencePeopleMetadataIsCorrect {

    testingSubject.referenceType = MLReferenceModelTypePerson;

    STAssertEquals(testingSubject.title, NSLocalizedString(@"ReferenceDetailScreenPeopleTitle",nil), @"ReferenceModel title isn't Person");
    STAssertTrue(testingSubject.hasLink, @"ReferenceModel hasLink is false incorrectly");
    STAssertTrue(testingSubject.hasQuote, @"ReferenceModel hasQuote is false incorrectly");

}

- (void)testWhenSystemAndUserDataIsPresentReferencePeopleAreCorrect {

    testingSubject.referenceType = MLReferenceModelTypePerson;

    STAssertTrue(testingSubject.references.count == 1, @"ReferencePerson references count is incorrect");
    STAssertTrue(testingSubject.referenceKeys.count == 1, @"ReferencePerson referenceKeys count is incorrect");
    STAssertTrue(testingSubject.details.count == 1, @"ReferencePerson details count is incorrect");
    STAssertTrue(testingSubject.icons.count == 1, @"ReferencePerson icons count is incorrect");

    STAssertEqualObjects([testingSubject.references lastObject], [testPerson1 displayNameReference], @"ReferencePerson displayName is wrong");
    STAssertEqualObjects([testingSubject.icons lastObject], [testPerson1 imageNameReference], @"ReferencePerson icon is wrong");
    STAssertEqualObjects([testingSubject.referenceKeys lastObject], [testPerson1 nameReference], @"ReferencePerson referenceKey is wrong");
    STAssertEqualObjects([testingSubject.details lastObject], [testPerson1 shortDescriptionReference], @"ReferencePerson detail is wrong");

}

- (void)testWhenSystemAndUserDataIsPresentConscienceAssetsMetadataIsCorrect {

    testingSubject.referenceType = MLReferenceModelTypeConscienceAsset;

    STAssertEquals(testingSubject.title, NSLocalizedString(@"ReferenceDetailScreenAccessoriesTitle",nil), @"ReferenceModel title isn't Accessory");
    STAssertFalse(testingSubject.hasLink, @"ReferenceModel hasLink is true incorrectly");
    STAssertFalse(testingSubject.hasQuote, @"ReferenceModel hasQuote is true incorrectly");
}

- (void)testWhenSystemAndUserDataIsPresentConscienceAssetsAreCorrect {

    testingSubject.referenceType = MLReferenceModelTypeConscienceAsset;

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

- (void)testWhenSystemAndUserDataIsPresentMoralsMetadataIsCorrect {

    testingSubject.referenceType = MLReferenceModelTypeMoral;

    STAssertEquals(testingSubject.title, NSLocalizedString(@"ReferenceDetailScreenMoralsTitle",nil), @"ReferenceModel title isn't Moral");
    STAssertTrue(testingSubject.hasLink, @"ReferenceModel hasLink is false incorrectly");
    STAssertFalse(testingSubject.hasQuote, @"ReferenceModel hasQuote is true incorrectly");
}

- (void)testWhenSystemAndUserDataIsPresentMoralsAreCorrect {

    testingSubject.referenceType = MLReferenceModelTypeMoral;

    STAssertTrue(testingSubject.references.count == 2, @"Moral references count is incorrect");
    STAssertTrue(testingSubject.referenceKeys.count == 2, @"Moral referenceKeys count is incorrect");
    STAssertTrue(testingSubject.details.count == 2, @"Moral details count is incorrect");
    STAssertTrue(testingSubject.icons.count == 2, @"Moral icons count is incorrect");

    NSString *virtueLongDescription = [NSString stringWithFormat:@"%@\n\nDefinition: %@", [virtue1 longDescriptionMoral], [virtue1 definitionMoral]];

    STAssertTrue([testingSubject.references containsObject:[virtue1 displayNameMoral]], @"Virtue displayName not present");
    STAssertTrue([testingSubject.icons containsObject:[virtue1 imageNameMoral]],  @"Virtue icon not present");
    STAssertTrue([testingSubject.referenceKeys containsObject:[virtue1 nameMoral]], @"Virtue referenceKey not present");
    STAssertTrue([testingSubject.details containsObject:[virtue1 shortDescriptionMoral]], @"Virtue detail not correct");
    STAssertTrue([testingSubject.longDescriptions containsObject:virtueLongDescription], @"Virtue longDescription not correct");

    NSString *viceLongDescription = [NSString stringWithFormat:@"%@\n\nDefinition: %@", [vice1 longDescriptionMoral], [vice1 definitionMoral]];

    STAssertTrue([testingSubject.references containsObject:[vice1 displayNameMoral]], @"Vice displayName not present");
    STAssertTrue([testingSubject.icons containsObject:[vice1 imageNameMoral]],  @"Vice icon not present");
    STAssertTrue([testingSubject.referenceKeys containsObject:[vice1 nameMoral]], @"Vice referenceKey not present");
    STAssertTrue([testingSubject.details containsObject:[vice1 shortDescriptionMoral]], @"Vice detail not correct");
    STAssertTrue([testingSubject.longDescriptions containsObject:viceLongDescription], @"Vice longDescription not correct");

}

- (void)testWhenSystemAndUserDataIsPresentConscienceAssetsAreSortedByShortDescription {

    testingSubject.referenceType = MLReferenceModelTypeConscienceAsset;

    STAssertEqualObjects([testingSubject.referenceKeys objectAtIndex:0], [testAsset1 nameReference], @"ConscienceAsset1 referenceKey ordered incorrectly");
    STAssertEqualObjects([testingSubject.details objectAtIndex:0], [testAsset1 shortDescriptionReference], @"ConscienceAsset1 detail ordered incorrectly");

    STAssertEqualObjects([testingSubject.referenceKeys objectAtIndex:1], [testAsset2 nameReference], @"ConscienceAsset2 referenceKey ordered incorrectly");
    STAssertEqualObjects([testingSubject.details objectAtIndex:1], [testAsset2 shortDescriptionReference], @"ConscienceAsset2 detail ordered incorrectly");

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

