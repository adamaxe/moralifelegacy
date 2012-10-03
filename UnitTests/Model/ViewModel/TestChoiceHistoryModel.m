/**
 Unit Test for ChoiceHistoryModel.  Test model interaction with peristed data for the ChoiceHistoryViewController and ChoiceListViewController
 
 @class TestChoiceHistoryModel
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/09/2012
 @file
 */

#import "ChoiceHistoryModel.h"
#import "ModelManager.h"
#import "Moral.h"
#import "UserChoice.h"
#import "OCMock/OCMock.h"

@interface TestChoiceHistoryModel : SenTestCase {
    
    ChoiceHistoryModel *testingSubject;
    ModelManager *testModelManager;
    id userDefaultsMock;

    CGFloat virtue1Severity;
    CGFloat virtue2Severity;
    CGFloat vice1Severity;
    CGFloat vice2Severity;
    CGFloat vice3Severity;

    Moral *virtue1;
    Moral *virtue2;
    Moral *vice1;
    Moral *vice2;
    Moral *vice3;

    NSString *moralChoice1Short;
    NSString *moralChoice2Short;
    NSString *immoralChoice1Short;
    NSString *immoralChoice2Short;
    NSString *immoralChoice3Short;

    NSString *moralChoice1Long;
    NSString *moralChoice2Long;
    NSString *immoralChoice1Long;
    NSString *immoralChoice2Long;
    NSString *immoralChoice3Long;

    UserChoice *choiceMoral1;
    UserChoice *choiceMoral2;
    UserChoice *choiceImmoral1;
    UserChoice *choiceImmoral2;
    UserChoice *choiceImmoral3;

    NSString *virtue1Name;
    NSString *virtue2Name;
    NSString *vice1Name;
    NSString *vice2Name;
    NSString *vice3Name;

    NSString *choiceMoral1Name;
    NSString *choiceMoral2Name;
    NSString *choiceImmoral1Name;
    NSString *choiceImmoral2Name;
    NSString *choiceImmoral3Name;

    CGFloat moralChoice1Influence;
    NSString *moralChoice1Justification;
    NSString *moralChoice1Consequence;
    BOOL moralChoice1EntryIsGood;

}

@end

@implementation TestChoiceHistoryModel

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    userDefaultsMock = [OCMockObject niceMockForClass:NSUserDefaults.class];

    virtue1Severity = 5.0;
    virtue2Severity = 3.0;
    vice1Severity = 4.0;
    vice2Severity = 2.0;
    vice3Severity = 1.0;

    virtue1Name = @"Virtue1";
    virtue2Name = @"Virtue2";
    vice1Name = @"Vice1";
    vice2Name = @"Vice2";
    vice3Name = @"Vice3";

    moralChoice1Short = @"moralChoice1Short";
    moralChoice2Short = @"moralChoice2Short";
    immoralChoice1Short = @"immoralChoice1Short";
    immoralChoice2Short = @"immoralChoice2Short";
    immoralChoice3Short = @"immoralChoice3Short";

    moralChoice1Long = @"moralChoice1Long";
    moralChoice2Long = @"moralChoice2Long";
    immoralChoice1Long = @"immoralChoice1Long";
    immoralChoice2Long = @"immoralChoice2Long";
    immoralChoice3Long = @"immoralChoice3Long";

    choiceMoral1Name = @"choiceMoral1Name";
    choiceMoral2Name = @"choiceMoral2Name";
    choiceImmoral1Name = @"choiceImmoral1Name";
    choiceImmoral2Name = @"choiceImmoral2Name";
    choiceImmoral3Name = @"choiceImmoral3Name";

    moralChoice1Influence = 2.5;
    moralChoice1Justification = @"moralChoice1Justification";
    moralChoice1Consequence = @"moralChoice1Consequence";
    moralChoice1EntryIsGood = TRUE;

    virtue1 = [self createMoralWithName:virtue1Name withType:@"Virtue" withModelManager:testModelManager];
    virtue2 = [self createMoralWithName:virtue2Name withType:@"Virtue" withModelManager:testModelManager];
    vice1 = [self createMoralWithName:vice1Name withType:@"Vice" withModelManager:testModelManager];
    vice2 = [self createMoralWithName:vice2Name withType:@"Vice" withModelManager:testModelManager];
    vice3 = [self createMoralWithName:vice3Name withType:@"Vice" withModelManager:testModelManager];

    choiceMoral1 = [self createUserEntryWithName:choiceMoral1Name withMoral:virtue1 andSeverity:virtue1Severity andShortDescription:moralChoice1Short andLongDescription:moralChoice1Long withModelManager:testModelManager];
    choiceMoral2 = [self createUserEntryWithName:choiceMoral2Name withMoral:virtue2 andSeverity:virtue2Severity andShortDescription:moralChoice2Short andLongDescription:moralChoice1Long withModelManager:testModelManager];

    choiceImmoral1 = [self createUserEntryWithName:choiceImmoral1Name withMoral:vice1 andSeverity:vice1Severity andShortDescription:immoralChoice1Short andLongDescription:immoralChoice1Long withModelManager:testModelManager];
    choiceImmoral2 = [self createUserEntryWithName:choiceImmoral2Name withMoral:vice2 andSeverity:vice2Severity andShortDescription:immoralChoice2Short andLongDescription:immoralChoice2Long withModelManager:testModelManager];
    choiceImmoral3 = [self createUserEntryWithName:choiceImmoral3Name withMoral:vice3 andSeverity:vice3Severity andShortDescription:immoralChoice3Short andLongDescription:immoralChoice3Long withModelManager:testModelManager];

    choiceMoral1.choiceInfluence = @(moralChoice1Influence);
    choiceMoral1.choiceJustification = moralChoice1Justification;
    choiceMoral1.choiceConsequences = moralChoice1Consequence;
    choiceMoral1.entryIsGood = @(moralChoice1EntryIsGood);

    [testModelManager saveContext];

    testingSubject = [[ChoiceHistoryModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];

}

- (void)testChoiceHistoryModelCanBeCreated {

    ChoiceHistoryModel *testingSubjectCreate = [[ChoiceHistoryModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock];

    STAssertNotNil(testingSubjectCreate, @"ChoiceHistoryModel can't be created.");

    
}

- (void)testChoiceHistoryModelDefaultValuesAreSetCorrectly {

    STAssertTrue([testingSubject.choiceType isEqualToString:@""], @"ChoiceHistoryModel isn't good by default");
    STAssertFalse(testingSubject.isAscending, @"ChoiceHistoryModel is ascending incorrectly by default");

}

- (void)testWhenNoUserChoicesArePresentHistoryIsEmpty {

    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    ChoiceHistoryModel *testingSubjectCreate = [[ChoiceHistoryModel alloc] initWithModelManager:testModelManagerCreate andDefaults:userDefaultsMock];

    STAssertTrue(testingSubjectCreate.choices.count == 0, @"Choices are not empty");
    STAssertTrue(testingSubjectCreate.choicesAreGood.count == 0, @"ChoicesAreGood are not empty");
    STAssertTrue(testingSubjectCreate.choiceKeys.count == 0, @"ChoiceKeys are not empty");
    STAssertTrue(testingSubjectCreate.details.count == 0, @"Details are not empty");
    STAssertTrue(testingSubjectCreate.icons.count == 0, @"Icons are not empty");


}

- (void)testWhenDateAscendingAllChoicesAreRequestedHistoryisCorrect {

    testingSubject.choiceType = kChoiceHistoryModelTypeAll;
    testingSubject.isAscending = TRUE;

    NSArray *expectedChoices = @[choiceMoral1, choiceMoral2, choiceImmoral1, choiceImmoral2, choiceImmoral3];

    [self assertCorrectOrder:expectedChoices];

}

- (void)testWhenDateDescendingAllChoicesAreRequestedHistoryisCorrect {

    testingSubject.choiceType = kChoiceHistoryModelTypeAll;
    testingSubject.isAscending = FALSE;

    NSArray *expectedChoices = @[choiceImmoral3, choiceImmoral2, choiceImmoral1, choiceMoral2, choiceMoral1];

    [self assertCorrectOrder:expectedChoices];
    
}



- (void)testWhenDateAscendingMoralChoicesAreRequestedHistoryisCorrect {

    testingSubject.choiceType = kChoiceHistoryModelTypeIsGood;
    testingSubject.isAscending = TRUE;

    NSArray *expectedChoices = @[choiceMoral1, choiceMoral2];

    [self assertCorrectOrder:expectedChoices];

}

- (void)testWhenDateDescendingMoralChoicesAreRequestedHistoryisCorrect {

    testingSubject.choiceType = kChoiceHistoryModelTypeIsGood;
    testingSubject.isAscending = FALSE;

    NSArray *expectedChoices = @[choiceMoral2, choiceMoral1];

    [self assertCorrectOrder:expectedChoices];
    
}

- (void)testWhenDateAscendingImmoralChoicesAreRequestedHistoryisCorrect {

    testingSubject.choiceType = kChoiceHistoryModelTypeIsBad;
    testingSubject.isAscending = TRUE;

    NSArray *expectedChoices = @[choiceImmoral1, choiceImmoral2, choiceImmoral3];

    [self assertCorrectOrder:expectedChoices];

}

- (void)testWhenDateDescendingImmoralChoicesAreRequestedHistoryisCorrect {

    testingSubject.choiceType = kChoiceHistoryModelTypeIsBad;
    testingSubject.isAscending = FALSE;

    NSArray *expectedChoices = @[choiceImmoral3, choiceImmoral2, choiceImmoral1];

    [self assertCorrectOrder:expectedChoices];
    
}

- (void)testWhenNameAscendingAllChoicesAreRequestedHistoryisCorrect {

    testingSubject.choiceType = kChoiceHistoryModelTypeAll;
    testingSubject.sortKey = kChoiceListSortName;
    testingSubject.isAscending = TRUE;

    NSArray *expectedChoices = @[choiceImmoral1, choiceImmoral2, choiceImmoral3, choiceMoral1, choiceMoral2];

    [self assertCorrectOrder:expectedChoices];

}

- (void)testWhenNameDescendingAllChoicesAreRequestedHistoryisCorrect {

    testingSubject.choiceType = kChoiceHistoryModelTypeAll;
    testingSubject.sortKey = kChoiceListSortName;
    testingSubject.isAscending = FALSE;

    NSArray *expectedChoices = @[choiceMoral2, choiceMoral1, choiceImmoral3, choiceImmoral2, choiceImmoral1];

    [self assertCorrectOrder:expectedChoices];
    
}

- (void)testWhenSeverityAscendingAllChoicesAreRequestedHistoryisCorrect {

    testingSubject.choiceType = kChoiceHistoryModelTypeAll;
    testingSubject.sortKey = kChoiceListSortSeverity;
    testingSubject.isAscending = TRUE;

    NSArray *expectedChoices = @[choiceImmoral3, choiceImmoral2, choiceMoral2, choiceImmoral1, choiceMoral1];
    [self assertCorrectOrder:expectedChoices];

}

- (void)testWhenSeverityDescendingAllChoicesAreRequestedHistoryisCorrect {

    testingSubject.choiceType = kChoiceHistoryModelTypeAll;
    testingSubject.sortKey = kChoiceListSortSeverity;
    testingSubject.isAscending = FALSE;

    NSArray *expectedChoices = @[choiceMoral1, choiceImmoral1, choiceMoral2, choiceImmoral2, choiceImmoral3];
    [self assertCorrectOrder:expectedChoices];
    
}

- (void)testWhenWeightAscendingAllChoicesAreRequestedHistoryisCorrect {

    testingSubject.choiceType = kChoiceHistoryModelTypeAll;
    testingSubject.sortKey = kChoiceListSortWeight;
    testingSubject.isAscending = TRUE;

    NSArray *expectedChoices = @[choiceImmoral3, choiceImmoral2, choiceMoral2, choiceImmoral1, choiceMoral1];
    [self assertCorrectOrder:expectedChoices];

}

- (void)testWhenWeightDescendingAllChoicesAreRequestedHistoryisCorrect {

    testingSubject.choiceType = kChoiceHistoryModelTypeAll;
    testingSubject.sortKey = kChoiceListSortWeight;
    testingSubject.isAscending = FALSE;

    NSArray *expectedChoices = @[choiceMoral1, choiceImmoral1, choiceMoral2, choiceImmoral2, choiceImmoral3];
    [self assertCorrectOrder:expectedChoices];
    
}

- (void)testThatDilemmaAnswersAreNotReturnedInResults {

    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    /**< @TODO: Determine issue with sending a real choice to be parsed, most likely an actual bug in returning a nil list of choices */
//    NSString *dilemmaName = @"testName";
    NSString *dilemmaName = @"dile-test";

    UserChoice *choiceDilemma = [self createUserEntryWithName:dilemmaName withMoral:virtue1 andSeverity:virtue1Severity andShortDescription:moralChoice1Short andLongDescription:moralChoice1Long withModelManager:testModelManagerCreate];

    STAssertNotNil(choiceDilemma, @"Dilemma-based choice was unable to be created.");

    ChoiceHistoryModel *testingSubjectCreate = [[ChoiceHistoryModel alloc] initWithModelManager:testModelManagerCreate andDefaults:userDefaultsMock];


    STAssertTrue(testingSubjectCreate.choices.count == 0, @"Choices are not empty");
    STAssertTrue(testingSubjectCreate.choicesAreGood.count == 0, @"Choices are not empty");
    STAssertTrue(testingSubjectCreate.choiceKeys.count == 0, @"Choices are not empty");
    STAssertTrue(testingSubjectCreate.details.count == 0, @"Choices are not empty");
    STAssertTrue(testingSubjectCreate.icons.count == 0, @"Choices are not empty");

}

- (void)testRetrieveChoiceWritesToStandardUserDefaultsForEditing {
    NSString *moralChoice1EntryKey = [NSString stringWithFormat:@"%@key", choiceMoral1Name];

    [[userDefaultsMock expect] setObject:moralChoice1EntryKey forKey:@"entryKey"];
    [[userDefaultsMock expect] setObject:moralChoice1Short forKey:@"entryShortDescription"];
    [[userDefaultsMock expect] setObject:moralChoice1Long forKey:@"entryLongDescription"];

    [[userDefaultsMock expect] setFloat:virtue1Severity forKey:@"entrySeverity"];
    [[userDefaultsMock expect] setObject:moralChoice1Justification forKey:@"choiceJustification"];
    [[userDefaultsMock expect] setObject:moralChoice1Consequence forKey:@"choiceConsequence"];
    [[userDefaultsMock expect] setFloat:moralChoice1Influence forKey:@"choiceInfluence"];
    [[userDefaultsMock expect] setBool:moralChoice1EntryIsGood forKey:@"entryIsGood"];

    testingSubject.choiceType = kChoiceHistoryModelTypeAll;
    [testingSubject retrieveChoice:moralChoice1EntryKey forEditing:YES];

    [userDefaultsMock verify];
}

- (void)testRetrieveChoiceWritesToStandardUserDefaultsForNewRecord {

    NSString *moralChoice1EntryKey = [NSString stringWithFormat:@"%@key", choiceMoral1Name];

    [[userDefaultsMock reject] setObject:moralChoice1EntryKey forKey:@"entryKey"];
    [[userDefaultsMock expect] setObject:moralChoice1Short forKey:@"entryShortDescription"];
    [[userDefaultsMock expect] setObject:moralChoice1Long forKey:@"entryLongDescription"];

    [[userDefaultsMock expect] setFloat:virtue1Severity forKey:@"entrySeverity"];
    [[userDefaultsMock expect] setObject:moralChoice1Justification forKey:@"choiceJustification"];
    [[userDefaultsMock expect] setObject:moralChoice1Consequence forKey:@"choiceConsequence"];
    [[userDefaultsMock expect] setFloat:moralChoice1Influence forKey:@"choiceInfluence"];
    [[userDefaultsMock expect] setBool:moralChoice1EntryIsGood forKey:@"entryIsGood"];

    testingSubject.choiceType = kChoiceHistoryModelTypeAll;
    [testingSubject retrieveChoice:moralChoice1EntryKey forEditing:NO];

    [userDefaultsMock verify];
}

- (void)testRetrieveChoiceDoesNotWriteToStandardUserDefaultsIfChoiceIsNotFound {
    [[userDefaultsMock reject] setObject:OCMOCK_ANY forKey:@"entryShortDescription"];
    [[userDefaultsMock reject] setObject:OCMOCK_ANY forKey:@"entryLongDescription"];

    [[userDefaultsMock reject] setFloat:virtue1Severity forKey:@"entrySeverity"];
    [[userDefaultsMock reject] setObject:OCMOCK_ANY forKey:@"choiceJustification"];
    [[userDefaultsMock reject] setObject:OCMOCK_ANY forKey:@"choiceConsequence"];
    [[userDefaultsMock reject] setFloat:moralChoice1Influence forKey:@"choiceInfluence"];
    [[userDefaultsMock reject] setBool:moralChoice1EntryIsGood forKey:@"entryIsGood"];

    [[userDefaultsMock reject] setObject:OCMOCK_ANY forKey:@"moralKey"];
    [[userDefaultsMock reject] setObject:OCMOCK_ANY forKey:@"moralName"];
    [[userDefaultsMock reject] setObject:OCMOCK_ANY forKey:@"moralImage"];

    [testingSubject retrieveChoice:@"incorrectChoiceKey" forEditing:NO];

    [userDefaultsMock verify];
}

- (Moral *)readMoralWithName:(NSString *)moralName fromModelManager:(ModelManager *)modelManager{
    return [testModelManager read:Moral.class withKey:@"nameMoral" andValue:moralName];
}

- (Moral *)createMoralWithName:(NSString *)moralName withType:(NSString *)type withModelManager:(ModelManager *)modelManager{

    NSString *imageName = [NSString stringWithFormat:@"%@imageName", moralName];

    Moral *testMoral1 = [modelManager create:Moral.class];

    testMoral1.shortDescriptionMoral = type;
    testMoral1.nameMoral = moralName;

    testMoral1.imageNameMoral = imageName;
    testMoral1.colorMoral = @"FF0000";
    testMoral1.displayNameMoral = @"displayName";
    testMoral1.longDescriptionMoral = @"longDescription";
    testMoral1.component = @"component";
    testMoral1.linkMoral = @"link";
    testMoral1.definitionMoral = @"definition";

    [modelManager saveContext];

    return testMoral1;
    
}

- (UserChoice *)createUserEntryWithName:(NSString *)entryName withMoral:(Moral *)moral andSeverity:(CGFloat) severity andShortDescription:(NSString *) moralChoiceShort andLongDescription:(NSString *) moralChoiceLong withModelManager:(ModelManager *)modelManager{

    UserChoice *testChoice1 = [modelManager create:UserChoice.class];

    testChoice1.entryShortDescription = moralChoiceShort;
    testChoice1.entryLongDescription = moralChoiceLong;
    testChoice1.choiceMoral = moral.nameMoral;
    testChoice1.entryCreationDate = [NSDate date];
    testChoice1.entryKey = [NSString stringWithFormat:@"%@key", entryName];
    testChoice1.entryIsGood = ([moral.shortDescriptionMoral isEqualToString:@"Virtue"]) ? @1 : @0;
    testChoice1.choiceWeight = @(severity * 2);
    testChoice1.entryModificationDate = [NSDate date];
    testChoice1.entrySeverity = @(severity);

    [modelManager saveContext];

    return testChoice1;
    
}

- (void)assertCorrectOrder:(NSArray *)expectedChoices {

    for (int i = 0; i < testingSubject.choices.count; i++) {

        UserChoice *expectedUserChoice = [expectedChoices objectAtIndex:i];
        STAssertEqualObjects([testingSubject.choices objectAtIndex:i], expectedUserChoice.entryShortDescription, @"Choice shortDescriptions are not in correct order");
        STAssertEqualObjects([testingSubject.choicesAreGood objectAtIndex:i], expectedUserChoice.entryIsGood, @"Choice types are not in correct order");
        STAssertEqualObjects([testingSubject.choiceKeys objectAtIndex:i], expectedUserChoice.entryKey, @"Choice keys are not in correct order");

        /**< @TODO: figure out why moral creation crashes, then implement details and icon tests */
//        Moral *expectedMoral = [self readMoralWithName:expectedUserChoice.choiceMoral];

//        STAssertEqualObjects([testingSubject.icons objectAtIndex:i], expectedMoral.imageNameMoral, @"Choice moral icon are not in correct order");


//        STAssertEqualObjects([testingSubject.choicesAreGood objectAtIndex:i], [expectedGoodness objectAtIndex:i], @"Choices are not in correct order");

//    for (int i = 0; i < testingSubject.choiceKeys.count; i++) {
//
//        NSString *test = [testingSubject.choiceKeys objectAtIndex:i];
//        STAssertEqualObjects([testingSubject.choiceKeys objectAtIndex:i], [NSString stringWithFormat:@"%@key", [expectedValues objectAtIndex:i]],  @"Choice Keys are not in correct order");
    }
}

@end

