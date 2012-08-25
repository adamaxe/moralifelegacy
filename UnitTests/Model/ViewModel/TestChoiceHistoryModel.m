/**
 Unit Test for ChoiceHistoryModel.  Test model interaction with peristed data
 
 @class TestChoiceHistoryModel
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/09/2012
 @file
 */

#import "ChoiceHistoryModel.h"
#import "ModelManager.h"
#import "Moral.h"
#import "UserChoice.h"

@interface TestChoiceHistoryModel : SenTestCase {
    
    ChoiceHistoryModel *testingSubject;
    ModelManager *testModelManager;

    CGFloat virtue1Weight;
    CGFloat virtue2Weight;
    CGFloat vice1Weight;
    CGFloat vice2Weight;
    CGFloat vice3Weight;

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

}

@end

@implementation TestChoiceHistoryModel

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    virtue1Weight = 1.0;
    virtue2Weight = 2.0;
    vice1Weight = 1.0;
    vice2Weight = 2.0;
    vice3Weight = 3.0;

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

    virtue1 = [self createMoralWithName:virtue1Name withType:@"Virtue" withModelManager:testModelManager];
    virtue2 = [self createMoralWithName:virtue2Name withType:@"Virtue" withModelManager:testModelManager];
    vice1 = [self createMoralWithName:vice1Name withType:@"Vice" withModelManager:testModelManager];
    vice2 = [self createMoralWithName:vice2Name withType:@"Vice" withModelManager:testModelManager];
    vice3 = [self createMoralWithName:vice3Name withType:@"Vice" withModelManager:testModelManager];

    choiceMoral1 = [self createUserEntryWithName:choiceMoral1Name withMoral:virtue1 andWeight:virtue1Weight andShortDescription:moralChoice1Short andLongDescription:moralChoice1Long withModelManager:testModelManager];
    choiceMoral2 = [self createUserEntryWithName:choiceMoral2Name withMoral:virtue2 andWeight:virtue2Weight andShortDescription:moralChoice2Short andLongDescription:moralChoice1Long withModelManager:testModelManager];

    choiceImmoral1 = [self createUserEntryWithName:choiceImmoral1Name withMoral:vice1 andWeight:vice1Weight andShortDescription:immoralChoice1Short andLongDescription:immoralChoice1Long withModelManager:testModelManager];
    choiceImmoral2 = [self createUserEntryWithName:choiceImmoral2Name withMoral:vice2 andWeight:vice2Weight andShortDescription:immoralChoice2Short andLongDescription:immoralChoice2Long withModelManager:testModelManager];
    choiceImmoral3 = [self createUserEntryWithName:choiceImmoral3Name withMoral:vice3 andWeight:vice3Weight andShortDescription:immoralChoice3Short andLongDescription:immoralChoice3Long withModelManager:testModelManager];

    [testModelManager saveContext];

    testingSubject = [[ChoiceHistoryModel alloc] initWithModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.
    [testModelManager release];
	[testingSubject release];

	[super tearDown];

}

- (void)testChoiceHistoryModelCanBeCreated {

    ChoiceHistoryModel *testingSubjectCreate = [[ChoiceHistoryModel alloc] initWithModelManager:testModelManager];

    STAssertNotNil(testingSubjectCreate, @"ChoiceHistoryModel can't be created.");

    [testingSubjectCreate release];
    
}

- (void)testChoiceHistoryModelDefaultValuesAreSetCorrectly {

    STAssertTrue(testingSubject.isGood, @"ChoiceHistoryModel isn't good by default");
    STAssertFalse(testingSubject.isAscending, @"ChoiceHistoryModel is ascending incorrectly by default");

}

- (void)testWhenNoUserChoicesArePresentHistoryIsEmpty {

    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    ChoiceHistoryModel *testingSubjectCreate = [[ChoiceHistoryModel alloc] initWithModelManager:testModelManagerCreate];

    STAssertTrue(testingSubjectCreate.choices.count == 0, @"Choices are not empty");
    STAssertTrue(testingSubjectCreate.choicesAreGood.count == 0, @"Choices are not empty");
    STAssertTrue(testingSubjectCreate.choiceKeys.count == 0, @"Choices are not empty");
    STAssertTrue(testingSubjectCreate.details.count == 0, @"Choices are not empty");
    STAssertTrue(testingSubjectCreate.icons.count == 0, @"Choices are not empty");

    [testingSubjectCreate release];
    [testModelManagerCreate release];

}

- (void)testWhenAscendingMoralChoicesAreRequestedHistoryisCorrect {

    testingSubject.isGood = TRUE;
    testingSubject.isAscending = TRUE;

    NSArray *expectedChoices = @[choiceMoral1, choiceMoral2];

    [self assertCorrectOrder:expectedChoices];

}

- (void)testWhenDescendingMoralChoicesAreRequestedHistoryisCorrect {

    testingSubject.isGood = TRUE;
    testingSubject.isAscending = FALSE;

    NSArray *expectedChoices = @[choiceMoral2, choiceMoral1];

    [self assertCorrectOrder:expectedChoices];
    
}

- (void)testWhenAscendingImmoralChoicesAreRequestedHistoryisCorrect {

    testingSubject.isGood = FALSE;
    testingSubject.isAscending = TRUE;

    NSArray *expectedChoices = @[choiceImmoral1, choiceImmoral2, choiceImmoral3];

    [self assertCorrectOrder:expectedChoices];

}

- (void)testWhenDescendingImmoralChoicesAreRequestedHistoryisCorrect {

    testingSubject.isGood = FALSE;
    testingSubject.isAscending = FALSE;

    NSArray *expectedChoices = @[choiceImmoral3, choiceImmoral2, choiceImmoral1];

    [self assertCorrectOrder:expectedChoices];
    
}

- (void)testThatDilemmaAnswersAreNotReturnedInResults {

    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    /**< @TODO: Determine issue with sending a real choice to be parsed */
//    NSString *dilemmaName = @"testName";
    NSString *dilemmaName = @"dile-test";

    UserChoice *choiceDilemma = [self createUserEntryWithName:dilemmaName withMoral:virtue1 andWeight:virtue1Weight andShortDescription:moralChoice1Short andLongDescription:moralChoice1Long withModelManager:testModelManagerCreate];

    STAssertNotNil(choiceDilemma, @"Dilemma-based choice was unable to be created.");

    ChoiceHistoryModel *testingSubjectCreate = [[ChoiceHistoryModel alloc] initWithModelManager:testModelManagerCreate];


    STAssertTrue(testingSubjectCreate.choices.count == 0, @"Choices are not empty");
    STAssertTrue(testingSubjectCreate.choicesAreGood.count == 0, @"Choices are not empty");
    STAssertTrue(testingSubjectCreate.choiceKeys.count == 0, @"Choices are not empty");
    STAssertTrue(testingSubjectCreate.details.count == 0, @"Choices are not empty");
    STAssertTrue(testingSubjectCreate.icons.count == 0, @"Choices are not empty");

    [testingSubjectCreate release];
    [testModelManagerCreate release];
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

- (UserChoice *)createUserEntryWithName:(NSString *)entryName withMoral:(Moral *)moral andWeight:(CGFloat) weight andShortDescription:(NSString *) moralChoiceShort andLongDescription:(NSString *) moralChoiceLong withModelManager:(ModelManager *)modelManager{

    UserChoice *testChoice1 = [modelManager create:UserChoice.class];

    testChoice1.entryShortDescription = moralChoiceShort;
    testChoice1.entryLongDescription = moralChoiceLong;
    testChoice1.choiceMoral = moral.nameMoral;
    testChoice1.entryCreationDate = [NSDate date];
    testChoice1.entryKey = [NSString stringWithFormat:@"%@key", entryName];
    testChoice1.entryIsGood = ([moral.shortDescriptionMoral isEqualToString:@"Virtue"]) ? @1 : @0;
    testChoice1.choiceWeight = @(weight);
    testChoice1.entryModificationDate = [NSDate date];

    [modelManager saveContext];

    return testChoice1;
    
}

- (void)assertCorrectOrder:(NSArray *)expectedChoices {

    for (int i = 0; i < testingSubject.choices.count; i++) {

        UserChoice *expectedUserChoice = [expectedChoices objectAtIndex:i];
        STAssertEqualObjects([testingSubject.choices objectAtIndex:i], expectedUserChoice.entryShortDescription, @"Choice shortDescriptions are not in correct order");
        STAssertEqualObjects([testingSubject.choicesAreGood objectAtIndex:i], expectedUserChoice.entryIsGood, @"Choice types are not in correct order");
        STAssertEqualObjects([testingSubject.choiceKeys objectAtIndex:i], expectedUserChoice.entryKey, @"Choice keys are not in correct order");

        /**< @TODO: figure out why moral creation crashes */
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

