/**
 Unit Test for HomeModel.  Test model interaction with peristed data for the HomeViewController
 
 @class TestHomeModel
 
 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 04/14/2013
 @file
 */

#import "HomeModel.h"
#import "ModelManager.h"
#import "Moral.h"
#import "UserChoice.h"
#import "OCMock/OCMock.h"

@interface TestHomeModel : SenTestCase {
    
    HomeModel *testingSubject;
    ModelManager *testModelManager;

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

@implementation TestHomeModel

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

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

//    virtue1 = [self createMoralWithName:virtue1Name withType:@"Virtue" withModelManager:testModelManager];
//    virtue2 = [self createMoralWithName:virtue2Name withType:@"Virtue" withModelManager:testModelManager];
//    vice1 = [self createMoralWithName:vice1Name withType:@"Vice" withModelManager:testModelManager];
//    vice2 = [self createMoralWithName:vice2Name withType:@"Vice" withModelManager:testModelManager];
//    vice3 = [self createMoralWithName:vice3Name withType:@"Vice" withModelManager:testModelManager];
//
//    choiceMoral1 = [self createUserEntryWithName:choiceMoral1Name withMoral:virtue1 andSeverity:virtue1Severity andShortDescription:moralChoice1Short andLongDescription:moralChoice1Long withModelManager:testModelManager];
//    choiceMoral2 = [self createUserEntryWithName:choiceMoral2Name withMoral:virtue2 andSeverity:virtue2Severity andShortDescription:moralChoice2Short andLongDescription:moralChoice1Long withModelManager:testModelManager];
//
//    choiceImmoral1 = [self createUserEntryWithName:choiceImmoral1Name withMoral:vice1 andSeverity:vice1Severity andShortDescription:immoralChoice1Short andLongDescription:immoralChoice1Long withModelManager:testModelManager];
//    choiceImmoral2 = [self createUserEntryWithName:choiceImmoral2Name withMoral:vice2 andSeverity:vice2Severity andShortDescription:immoralChoice2Short andLongDescription:immoralChoice2Long withModelManager:testModelManager];
//    choiceImmoral3 = [self createUserEntryWithName:choiceImmoral3Name withMoral:vice3 andSeverity:vice3Severity andShortDescription:immoralChoice3Short andLongDescription:immoralChoice3Long withModelManager:testModelManager];
//
//    choiceMoral1.choiceInfluence = @(moralChoice1Influence);
//    choiceMoral1.choiceJustification = moralChoice1Justification;
//    choiceMoral1.choiceConsequences = moralChoice1Consequence;
//    choiceMoral1.entryIsGood = @(moralChoice1EntryIsGood);

    [testModelManager saveContext];

    testingSubject = [[HomeModel alloc] initWithModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];

}

- (void)testChoiceHomeModelCanBeCreated {

    HomeModel *testingSubjectCreate = [[HomeModel alloc] initWithModelManager:testModelManager];

    STAssertNotNil(testingSubjectCreate, @"HomeModel can't be created.");

    
}

- (void)testChoiceHomeModelDefaultValuesAreCorrect {

    STAssertTrue([testingSubject.greatestVirtue isEqualToString:@""], @"HomeModel greatestVirtue is not empty string.");
    STAssertTrue([testingSubject.worstVice isEqualToString:@""], @"HomeModel worstVice is not empty string.");
    NSLog(@"highest:%@", testingSubject.highestRank);
    STAssertTrue([testingSubject.highestRank isEqualToString:HOME_MODEL_BEGINNER_RANK], @"HomeModel highestRank is not default rank.");

}

- (void)testChoiceHomeModelDefaultGoodReactionsAreCorrect {

    NSMutableArray *possibleReactions = [[NSMutableArray alloc] initWithCapacity:HOME_MODEL_REACTION_COUNT];
    
    for (int i = 0; i < HOME_MODEL_REACTION_COUNT; i++) {
        possibleReactions[i] = [[NSString alloc] initWithFormat:@"%@Reaction%d%@",NSStringFromClass(testingSubject.class), i, @"Good"];
    }

    NSString *reaction = [testingSubject generateReactionWithMood:51.0 andEnthusiasm:51.0];
    STAssertTrue([possibleReactions containsObject:reaction], @"HomeModel reaction is not in Good set.");

    [possibleReactions removeAllObjects];
    for (int i = 0; i < HOME_MODEL_REACTION_COUNT; i++) {
        possibleReactions[i] = [[NSString alloc] initWithFormat:@"%@Reaction%d%@",NSStringFromClass(testingSubject.class), i, @"Bad"];
    }

    STAssertFalse([possibleReactions containsObject:reaction], @"HomeModel reaction is not incorrectly in bad set.");

}

- (void)testChoiceHomeModelDefaultBadReactionsAreCorrect {

    NSMutableArray *possibleReactions = [[NSMutableArray alloc] initWithCapacity:HOME_MODEL_REACTION_COUNT];

    for (int i = 0; i < HOME_MODEL_REACTION_COUNT; i++) {
        possibleReactions[i] = [[NSString alloc] initWithFormat:@"%@Reaction%d%@",NSStringFromClass(testingSubject.class), i, @"Bad"];
    }

    NSString *reaction = [testingSubject generateReactionWithMood:40.0 andEnthusiasm:40.0];
    STAssertTrue([possibleReactions containsObject:reaction], @"HomeModel reaction is not in Good set.");

    [possibleReactions removeAllObjects];
    for (int i = 0; i < HOME_MODEL_REACTION_COUNT; i++) {
        possibleReactions[i] = [[NSString alloc] initWithFormat:@"%@Reaction%d%@",NSStringFromClass(testingSubject.class), i, @"Good"];
    }

    STAssertFalse([possibleReactions containsObject:reaction], @"HomeModel reaction is not incorrectly in bad set.");
    
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

@end

