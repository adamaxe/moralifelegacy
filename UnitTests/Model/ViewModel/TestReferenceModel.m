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
#import "Moral.h"
#import "OCMock/OCMock.h"

@interface TestReferenceModel : SenTestCase {
    
    ReferenceModel *testingSubject;
    ModelManager *testModelManager;
    id userDefaultsMock;
    NSArray *userCollection;

    CGFloat virtue1Severity;
    CGFloat vice1Severity;

    Moral *virtue1;
    Moral *vice1;

    NSString *moralChoice1Short;
    NSString *immoralChoice1Short;

    NSString *moralChoice1Long;
    NSString *immoralChoice1Long;

    NSString *virtue1Name;
    NSString *vice1Name;

    NSString *choiceMoral1Name;
    NSString *choiceImmoral1Name;

    CGFloat moralChoice1Influence;
    NSString *moralChoice1Justification;
    NSString *moralChoice1Consequence;
    BOOL moralChoice1EntryIsGood;

    NSString *shortDescription;
    NSNumber *originYear;
    NSString *name;
    NSString *longDescription;
    NSString *link;
    NSString *displayName;
    NSString *imageName;

}

@end

@implementation TestReferenceModel

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    userDefaultsMock = [OCMockObject niceMockForClass:NSUserDefaults.class];
    userCollection = @[];

    virtue1Severity = 5.0;
    vice1Severity = 4.0;

    virtue1Name = @"Virtue1";
    vice1Name = @"Vice1";

    moralChoice1Short = @"moralChoice1Short";
    immoralChoice1Short = @"immoralChoice1Short";

    moralChoice1Long = @"moralChoice1Long";
    immoralChoice1Long = @"immoralChoice1Long";

    choiceMoral1Name = @"choiceMoral1Name";
    choiceImmoral1Name = @"choiceImmoral1Name";

    moralChoice1Influence = 2.5;
    moralChoice1Justification = @"moralChoice1Justification";
    moralChoice1Consequence = @"moralChoice1Consequence";
    moralChoice1EntryIsGood = TRUE;

    shortDescription = @"short description";
    originYear = @2010;
    name = @"name";
    longDescription = @"long description";
    link = @"http://www.teamaxe.org";
    displayName = @"display name";
    imageName = @"image name";

//    ConscienceAsset *testAsset = [testModelManager create:ConscienceAsset.class];
//
//    testAsset.costAsset =  @1.0f;
//
//    testAsset.shortDescriptionReference = shortDescription;
//    testAsset.originYear = originYear;
//    testAsset.nameReference = name;
//    testAsset.longDescriptionReference = longDescription;
//    testAsset.linkReference = link;
//    testAsset.displayNameReference = displayName;
//    testAsset.imageNameReference = imageName;

    virtue1 = [self createMoralWithName:virtue1Name withType:@"Virtue" withModelManager:testModelManager];
    vice1 = [self createMoralWithName:vice1Name withType:@"Vice" withModelManager:testModelManager];

    [testModelManager saveContext];

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
//
//- (void)testReferenceModelDefaultValuesAreSetCorrectly {
//
//    STAssertTrue([testingSubject.choiceType isEqualToString:@""], @"ReferenceModel isn't good by default");
//    STAssertFalse(testingSubject.isAscending, @"ReferenceModel is ascending incorrectly by default");
//
//}
//
//- (void)testWhenNoUserChoicesArePresentHistoryIsEmpty {
//
//    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];
//
//    ReferenceModel *testingSubjectCreate = [[ReferenceModel alloc] initWithModelManager:testModelManagerCreate andDefaults:userDefaultsMock];
//
//    STAssertTrue(testingSubjectCreate.choices.count == 0, @"Choices are not empty");
//    STAssertTrue(testingSubjectCreate.choicesAreGood.count == 0, @"Choices are not empty");
//    STAssertTrue(testingSubjectCreate.choiceKeys.count == 0, @"Choices are not empty");
//    STAssertTrue(testingSubjectCreate.details.count == 0, @"Choices are not empty");
//    STAssertTrue(testingSubjectCreate.icons.count == 0, @"Choices are not empty");
//
//    [testingSubjectCreate release];
//    [testModelManagerCreate release];
//
//}
//
//- (void)testWhenDateAscendingAllChoicesAreRequestedHistoryisCorrect {
//
//    testingSubject.choiceType = kReferenceModelTypeAll;
//    testingSubject.isAscending = TRUE;
//
//    NSArray *expectedChoices = @[choiceMoral1, choiceMoral2, choiceImmoral1, choiceImmoral2, choiceImmoral3];
//
//    [self assertCorrectOrder:expectedChoices];
//
//}
//
//- (void)testWhenDateDescendingAllChoicesAreRequestedHistoryisCorrect {
//
//    testingSubject.choiceType = kReferenceModelTypeAll;
//    testingSubject.isAscending = FALSE;
//
//    NSArray *expectedChoices = @[choiceImmoral3, choiceImmoral2, choiceImmoral1, choiceMoral2, choiceMoral1];
//
//    [self assertCorrectOrder:expectedChoices];
//    
//}
//
//
//
//- (void)testWhenDateAscendingMoralChoicesAreRequestedHistoryisCorrect {
//
//    testingSubject.choiceType = kReferenceModelTypeIsGood;
//    testingSubject.isAscending = TRUE;
//
//    NSArray *expectedChoices = @[choiceMoral1, choiceMoral2];
//
//    [self assertCorrectOrder:expectedChoices];
//
//}
//
//- (void)testWhenDateDescendingMoralChoicesAreRequestedHistoryisCorrect {
//
//    testingSubject.choiceType = kReferenceModelTypeIsGood;
//    testingSubject.isAscending = FALSE;
//
//    NSArray *expectedChoices = @[choiceMoral2, choiceMoral1];
//
//    [self assertCorrectOrder:expectedChoices];
//    
//}
//
//- (void)testWhenDateAscendingImmoralChoicesAreRequestedHistoryisCorrect {
//
//    testingSubject.choiceType = kReferenceModelTypeIsBad;
//    testingSubject.isAscending = TRUE;
//
//    NSArray *expectedChoices = @[choiceImmoral1, choiceImmoral2, choiceImmoral3];
//
//    [self assertCorrectOrder:expectedChoices];
//
//}
//
//- (void)testWhenDateDescendingImmoralChoicesAreRequestedHistoryisCorrect {
//
//    testingSubject.choiceType = kReferenceModelTypeIsBad;
//    testingSubject.isAscending = FALSE;
//
//    NSArray *expectedChoices = @[choiceImmoral3, choiceImmoral2, choiceImmoral1];
//
//    [self assertCorrectOrder:expectedChoices];
//    
//}
//
//- (void)testWhenNameAscendingAllChoicesAreRequestedHistoryisCorrect {
//
//    testingSubject.choiceType = kReferenceModelTypeAll;
//    testingSubject.sortKey = kChoiceListSortName;
//    testingSubject.isAscending = TRUE;
//
//    NSArray *expectedChoices = @[choiceImmoral1, choiceImmoral2, choiceImmoral3, choiceMoral1, choiceMoral2];
//
//    [self assertCorrectOrder:expectedChoices];
//
//}
//
//- (void)testWhenNameDescendingAllChoicesAreRequestedHistoryisCorrect {
//
//    testingSubject.choiceType = kReferenceModelTypeAll;
//    testingSubject.sortKey = kChoiceListSortName;
//    testingSubject.isAscending = FALSE;
//
//    NSArray *expectedChoices = @[choiceMoral2, choiceMoral1, choiceImmoral3, choiceImmoral2, choiceImmoral1];
//
//    [self assertCorrectOrder:expectedChoices];
//    
//}
//
//- (void)testWhenSeverityAscendingAllChoicesAreRequestedHistoryisCorrect {
//
//    testingSubject.choiceType = kReferenceModelTypeAll;
//    testingSubject.sortKey = kChoiceListSortSeverity;
//    testingSubject.isAscending = TRUE;
//
//    NSArray *expectedChoices = @[choiceImmoral3, choiceImmoral2, choiceMoral2, choiceImmoral1, choiceMoral1];
//    [self assertCorrectOrder:expectedChoices];
//
//}
//
//- (void)testWhenSeverityDescendingAllChoicesAreRequestedHistoryisCorrect {
//
//    testingSubject.choiceType = kReferenceModelTypeAll;
//    testingSubject.sortKey = kChoiceListSortSeverity;
//    testingSubject.isAscending = FALSE;
//
//    NSArray *expectedChoices = @[choiceMoral1, choiceImmoral1, choiceMoral2, choiceImmoral2, choiceImmoral3];
//    [self assertCorrectOrder:expectedChoices];
//    
//}
//
//- (void)testWhenWeightAscendingAllChoicesAreRequestedHistoryisCorrect {
//
//    testingSubject.choiceType = kReferenceModelTypeAll;
//    testingSubject.sortKey = kChoiceListSortWeight;
//    testingSubject.isAscending = TRUE;
//
//    NSArray *expectedChoices = @[choiceImmoral3, choiceImmoral2, choiceMoral2, choiceImmoral1, choiceMoral1];
//    [self assertCorrectOrder:expectedChoices];
//
//}
//
//- (void)testWhenWeightDescendingAllChoicesAreRequestedHistoryisCorrect {
//
//    testingSubject.choiceType = kReferenceModelTypeAll;
//    testingSubject.sortKey = kChoiceListSortWeight;
//    testingSubject.isAscending = FALSE;
//
//    NSArray *expectedChoices = @[choiceMoral1, choiceImmoral1, choiceMoral2, choiceImmoral2, choiceImmoral3];
//    [self assertCorrectOrder:expectedChoices];
//    
//}
//
//- (void)testThatDilemmaAnswersAreNotReturnedInResults {
//
//    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];
//
//    /**< @TODO: Determine issue with sending a real choice to be parsed, most likely an actual bug in returning a nil list of choices */
////    NSString *dilemmaName = @"testName";
//    NSString *dilemmaName = @"dile-test";
//
//    UserChoice *choiceDilemma = [self createUserEntryWithName:dilemmaName withMoral:virtue1 andSeverity:virtue1Severity andShortDescription:moralChoice1Short andLongDescription:moralChoice1Long withModelManager:testModelManagerCreate];
//
//    STAssertNotNil(choiceDilemma, @"Dilemma-based choice was unable to be created.");
//
//    ReferenceModel *testingSubjectCreate = [[ReferenceModel alloc] initWithModelManager:testModelManagerCreate andDefaults:userDefaultsMock];
//
//
//    STAssertTrue(testingSubjectCreate.choices.count == 0, @"Choices are not empty");
//    STAssertTrue(testingSubjectCreate.choicesAreGood.count == 0, @"Choices are not empty");
//    STAssertTrue(testingSubjectCreate.choiceKeys.count == 0, @"Choices are not empty");
//    STAssertTrue(testingSubjectCreate.details.count == 0, @"Choices are not empty");
//    STAssertTrue(testingSubjectCreate.icons.count == 0, @"Choices are not empty");
//
//    [testingSubjectCreate release];
//    [testModelManagerCreate release];
//}
//
//- (void)testRetrieveChoiceWritesToStandardUserDefaults {
//    [[userDefaultsMock expect] setObject:moralChoice1Short forKey:@"entryShortDescription"];
//    [[userDefaultsMock expect] setObject:moralChoice1Long forKey:@"entryLongDescription"];
//
//    [[userDefaultsMock expect] setFloat:virtue1Severity forKey:@"entrySeverity"];
//    [[userDefaultsMock expect] setObject:moralChoice1Justification forKey:@"choiceJustification"];
//    [[userDefaultsMock expect] setObject:moralChoice1Consequence forKey:@"choiceConsequence"];
//    [[userDefaultsMock expect] setFloat:moralChoice1Influence forKey:@"choiceInfluence"];
//    [[userDefaultsMock expect] setBool:moralChoice1EntryIsGood forKey:@"entryIsGood"];
//
//    testingSubject.choiceType = kReferenceModelTypeAll;
//    [testingSubject retrieveChoice:[NSString stringWithFormat:@"%@key", choiceMoral1Name]];
//
//    [userDefaultsMock verify];
//}
//
//- (void)testRetrieveChoiceDoesNotWriteToStandardUserDefaultsIfChoiceIsNotFound {
//    [[userDefaultsMock reject] setObject:OCMOCK_ANY forKey:@"entryShortDescription"];
//    [[userDefaultsMock reject] setObject:OCMOCK_ANY forKey:@"entryLongDescription"];
//
//    [[userDefaultsMock reject] setFloat:virtue1Severity forKey:@"entrySeverity"];
//    [[userDefaultsMock reject] setObject:OCMOCK_ANY forKey:@"choiceJustification"];
//    [[userDefaultsMock reject] setObject:OCMOCK_ANY forKey:@"choiceConsequence"];
//    [[userDefaultsMock reject] setFloat:moralChoice1Influence forKey:@"choiceInfluence"];
//    [[userDefaultsMock reject] setBool:moralChoice1EntryIsGood forKey:@"entryIsGood"];
//
//    [[userDefaultsMock reject] setObject:OCMOCK_ANY forKey:@"moralKey"];
//    [[userDefaultsMock reject] setObject:OCMOCK_ANY forKey:@"moralName"];
//    [[userDefaultsMock reject] setObject:OCMOCK_ANY forKey:@"moralImage"];
//
//    [testingSubject retrieveChoice:@"incorrectChoiceKey"];
//
//    [userDefaultsMock verify];
//}
//
- (Moral *)readMoralWithName:(NSString *)moralName fromModelManager:(ModelManager *)modelManager{
    return [testModelManager read:Moral.class withKey:@"nameMoral" andValue:moralName];
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

//- (UserChoice *)createUserEntryWithName:(NSString *)entryName withMoral:(Moral *)moral andSeverity:(CGFloat) severity andShortDescription:(NSString *) moralChoiceShort andLongDescription:(NSString *) moralChoiceLong withModelManager:(ModelManager *)modelManager{
//
//    UserChoice *testChoice1 = [modelManager create:UserChoice.class];
//
//    testChoice1.entryShortDescription = moralChoiceShort;
//    testChoice1.entryLongDescription = moralChoiceLong;
//    testChoice1.choiceMoral = moral.nameMoral;
//    testChoice1.entryCreationDate = [NSDate date];
//    testChoice1.entryKey = [NSString stringWithFormat:@"%@key", entryName];
//    testChoice1.entryIsGood = ([moral.shortDescriptionMoral isEqualToString:@"Virtue"]) ? @1 : @0;
//    testChoice1.choiceWeight = @(severity * 2);
//    testChoice1.entryModificationDate = [NSDate date];
//    testChoice1.entrySeverity = @(severity);
//
//    [modelManager saveContext];
//
//    return testChoice1;
//    
//}

//- (void)assertCorrectOrder:(NSArray *)expectedChoices {
//
//    for (int i = 0; i < testingSubject.choices.count; i++) {
//
//        UserChoice *expectedUserChoice = [expectedChoices objectAtIndex:i];
//        STAssertEqualObjects([testingSubject.choices objectAtIndex:i], expectedUserChoice.entryShortDescription, @"Choice shortDescriptions are not in correct order");
//        STAssertEqualObjects([testingSubject.choicesAreGood objectAtIndex:i], expectedUserChoice.entryIsGood, @"Choice types are not in correct order");
//        STAssertEqualObjects([testingSubject.choiceKeys objectAtIndex:i], expectedUserChoice.entryKey, @"Choice keys are not in correct order");
//
//        /**< @TODO: figure out why moral creation crashes, then implement details and icon tests */
//        Moral *expectedMoral = [self readMoralWithName:expectedUserChoice.choiceMoral];

//        STAssertEqualObjects([testingSubject.icons objectAtIndex:i], expectedMoral.imageNameMoral, @"Choice moral icon are not in correct order");


//        STAssertEqualObjects([testingSubject.choicesAreGood objectAtIndex:i], [expectedGoodness objectAtIndex:i], @"Choices are not in correct order");

//    for (int i = 0; i < testingSubject.choiceKeys.count; i++) {
//
//        NSString *test = [testingSubject.choiceKeys objectAtIndex:i];
//        STAssertEqualObjects([testingSubject.choiceKeys objectAtIndex:i], [NSString stringWithFormat:@"%@key", [expectedValues objectAtIndex:i]],  @"Choice Keys are not in correct order");
//    }
//}

@end

