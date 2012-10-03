/**
 Unit Test for ReportPieModel.  Test model interaction with peristed data
 
 @class TestReportPieModel
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/09/2012
 @file
 */

#import "ReportPieModel.h"
#import "ModelManager.h"
#import "Moral.h"
#import "UserChoice.h"
//#import "UIColor+Utility.h"

@interface TestReportPieModel : SenTestCase {
    
    ReportPieModel *testingSubject;
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

    NSString *virtue1Color;
    NSString *virtue2Color;
    NSString *vice1Color;
    NSString *vice2Color;
    NSString *vice3Color;

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

@implementation TestReportPieModel

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

    virtue1Color = @"FF0000";
    virtue2Color = @"00FF00";
    vice1Color = @"0000FF";
    vice2Color = @"FFFF00";
    vice3Color = @"FF00FF";

    choiceMoral1Name = @"choiceMoral1Name";
    choiceMoral2Name = @"choiceMoral2Name";
    choiceImmoral1Name = @"choiceImmoral1Name";
    choiceImmoral2Name = @"choiceImmoral2Name";
    choiceImmoral3Name = @"choiceImmoral3Name";

    virtue1 = [self createMoralWithName:virtue1Name withType:@"Virtue" andColor:virtue1Color];
    virtue2 = [self createMoralWithName:virtue2Name withType:@"Virtue" andColor:virtue2Color];
    vice1 = [self createMoralWithName:vice1Name withType:@"Vice" andColor:vice1Color];
    vice2 = [self createMoralWithName:vice2Name withType:@"Vice" andColor:vice2Color];
    vice3 = [self createMoralWithName:vice3Name withType:@"Vice" andColor:vice3Color];

    choiceMoral1 = [self createUserEntryWithName:choiceMoral1Name withMoral:virtue1 andWeight:virtue1Weight];
    choiceMoral2 = [self createUserEntryWithName:choiceMoral2Name withMoral:virtue2 andWeight:virtue2Weight];

    choiceImmoral1 = [self createUserEntryWithName:choiceImmoral1Name withMoral:vice1 andWeight:vice1Weight];
    choiceImmoral2 = [self createUserEntryWithName:choiceImmoral2Name withMoral:vice2 andWeight:vice2Weight];
    choiceImmoral3 = [self createUserEntryWithName:choiceImmoral3Name withMoral:vice3 andWeight:vice3Weight];


    [testModelManager saveContext];

    testingSubject = [[ReportPieModel alloc] initWithModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];

}

- (void)testReportPieModelCanBeCreated {

    ReportPieModel *testingSubjectCreate = [[ReportPieModel alloc] initWithModelManager:testModelManager];

    STAssertNotNil(testingSubjectCreate, @"ReportPieModel can't be created.");

    
}

- (void)testReportPieModelDefaultValuesAreSetCorrectly {

    STAssertTrue(testingSubject.isGood, @"ReportPieModel isn't good by default");
    STAssertFalse(testingSubject.isAlphabetical, @"ReportPieModel is alpha incorrectly by default");
    STAssertFalse(testingSubject.isAscending, @"ReportPieModel is ascending incorrectly by default");

}

- (void)testWhenNoUserVirtuesArePresentReportIsEmpty {

    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    ReportPieModel *testingSubjectCreate = [[ReportPieModel alloc] initWithModelManager:testModelManagerCreate];

    STAssertEqualObjects((testingSubjectCreate.reportNames)[0], @"No Moral Entries!", @"Empty Virtue name is incorrect");


}

- (void)testWhenNoUserVicesArePresentReportIsEmpty {
    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    ReportPieModel *testingSubjectCreate = [[ReportPieModel alloc] initWithModelManager:testModelManagerCreate];

    testingSubjectCreate.isGood = FALSE;
    
    STAssertEqualObjects((testingSubjectCreate.reportNames)[0], @"No Immoral Entries!", @"Empty Vice name is incorrect");
    
}

- (void)testWhenAlphabeticAscendingVirtuesAreRequestedReportisCorrect {

    testingSubject.isGood = TRUE;
    testingSubject.isAlphabetical = TRUE;
    testingSubject.isAscending = TRUE;

    CGFloat total = virtue1Weight + virtue2Weight;

    NSArray *expectedMorals = @[virtue2Name, virtue1Name];
    NSArray *expectedValues = @[@(virtue2Weight/total * 360.0), @(virtue1Weight/total *360.0)];

    [self assertCorrectOrder:expectedMorals expectedValues:expectedValues];

}

- (void)testWhenAlphabeticDescendingVirtuesAreRequestedReportisCorrect {

    testingSubject.isGood = TRUE;
    testingSubject.isAlphabetical = TRUE;
    testingSubject.isAscending = FALSE;

    CGFloat total = virtue1Weight + virtue2Weight;

    NSArray *expectedMorals = @[virtue1Name, virtue2Name];
    NSArray *expectedValues = @[@(virtue1Weight/total *360.0), @(virtue2Weight/total * 360.0)];

    [self assertCorrectOrder:expectedMorals expectedValues:expectedValues];
    
}

- (void)testWhenNumericAscendingVirtuesAreRequestedReportisCorrect {

    testingSubject.isGood = TRUE;
    testingSubject.isAlphabetical = FALSE;
    testingSubject.isAscending = TRUE;

    CGFloat total = virtue1Weight + virtue2Weight;

    NSArray *expectedMorals = @[virtue1Name, virtue2Name];
    NSArray *expectedValues = @[@(virtue1Weight/total *360.0), @(virtue2Weight/total * 360.0)];

    [self assertCorrectOrder:expectedMorals expectedValues:expectedValues];


}

- (void)testWhenNumericDescendingVirtuesAreRequestedReportisCorrect {

    testingSubject.isGood = TRUE;
    testingSubject.isAlphabetical = FALSE;
    testingSubject.isAscending = FALSE;

    CGFloat total = virtue1Weight + virtue2Weight;

    NSArray *expectedMorals = @[virtue2Name, virtue1Name];
    NSArray *expectedValues = @[@(virtue2Weight/total * 360.0), @(virtue1Weight/total *360.0)];

    [self assertCorrectOrder:expectedMorals expectedValues:expectedValues];
    
}

- (void)testWhenAlphabeticAscendingVicesAreRequestedReportisCorrect {

    testingSubject.isGood = FALSE;
    testingSubject.isAlphabetical = TRUE;
    testingSubject.isAscending = TRUE;

    CGFloat total = vice3Weight + vice2Weight + vice1Weight;

    NSArray *expectedMorals = @[vice3Name, vice2Name, vice1Name];
    NSArray *expectedValues = @[@(vice3Weight/total * 360.0), @(virtue2Weight/total * 360.0), @(virtue1Weight/total *360.0)];


    [self assertCorrectOrder:expectedMorals expectedValues:expectedValues];
    
}

- (void)testWhenAlphabeticDescendingVicesAreRequestedReportisCorrect {

    testingSubject.isGood = FALSE;
    testingSubject.isAlphabetical = TRUE;
    testingSubject.isAscending = FALSE;

    CGFloat total = vice1Weight + vice2Weight + vice3Weight;

    NSArray *expectedMorals = @[vice1Name, vice2Name, vice3Name];
    NSArray *expectedValues = @[@(virtue1Weight/total *360.0), @(virtue2Weight/total * 360.0), @(vice3Weight/total * 360.0)];
    
    [self assertCorrectOrder:expectedMorals expectedValues:expectedValues];
    
}

- (void)testWhenNumericAscendingVicesAreRequestedReportisCorrect {

    testingSubject.isGood = FALSE;
    testingSubject.isAlphabetical = FALSE;
    testingSubject.isAscending = TRUE;

    CGFloat total = vice1Weight + vice2Weight + vice3Weight;

    NSArray *expectedMorals = @[vice1Name, vice2Name, vice3Name];
    NSArray *expectedValues = @[@(virtue1Weight/total *360.0), @(virtue2Weight/total * 360.0), @(vice3Weight/total * 360.0)];

    [self assertCorrectOrder:expectedMorals expectedValues:expectedValues];

}

- (void)testWhenNumericDescendingVicesAreRequestedReportisCorrect {

    testingSubject.isGood = FALSE;
    testingSubject.isAlphabetical = FALSE;
    testingSubject.isAscending = FALSE;

    CGFloat total = vice3Weight + vice2Weight + vice1Weight;

    NSArray *expectedMorals = @[vice3Name, vice2Name, vice1Name];
    NSArray *expectedValues = @[@(vice3Weight/total * 360.0), @(virtue2Weight/total * 360.0), @(virtue1Weight/total *360.0)];

    [self assertCorrectOrder:expectedMorals expectedValues:expectedValues];
    
}

- (Moral *)readMoralWithName:(NSString *)moralName {
    return [testModelManager read:Moral.class withKey:@"nameMoral" andValue:moralName];
}

- (Moral *)createMoralWithName:(NSString *)moralName withType:(NSString *)type andColor:(NSString *)color {

    NSString *imageName = [NSString stringWithFormat:@"%@imageName", moralName];

    Moral *testMoral1 = [testModelManager create:Moral.class];

    testMoral1.shortDescriptionMoral = type;
    testMoral1.nameMoral = moralName;

    testMoral1.imageNameMoral = imageName;
    testMoral1.colorMoral = color;
    testMoral1.displayNameMoral = @"displayName";
    testMoral1.longDescriptionMoral = @"longDescription";
    testMoral1.component = @"component";
    testMoral1.linkMoral = @"link";
    testMoral1.definitionMoral = @"definition";

    [testModelManager saveContext];

    return testMoral1;
    
}

- (UserChoice *)createUserEntryWithName:(NSString *)entryName withMoral:(Moral *)moral andWeight:(CGFloat) weight{

    UserChoice *testChoice1 = [testModelManager create:UserChoice.class];

    testChoice1.entryShortDescription = @"shortDescription";
    testChoice1.choiceMoral = moral.nameMoral;
    testChoice1.entryCreationDate = [NSDate date];
    testChoice1.entryKey = [NSString stringWithFormat:@"%@key", entryName];
    testChoice1.entryIsGood = ([moral.shortDescriptionMoral isEqualToString:@"Virtue"]) ? @1 : @0;
    testChoice1.choiceWeight = @(weight);
    testChoice1.entryModificationDate = [NSDate date];

    [testModelManager saveContext];

    return testChoice1;
    
}

- (void)assertCorrectOrder:(NSArray *)expectedMorals expectedValues:(NSArray *)expectedValues{
    for (int i = 0; i < testingSubject.moralNames.count; i++) {

        NSString *moralName = (testingSubject.moralNames)[i];

        STAssertEqualObjects(moralName, expectedMorals[i], @"Moral Names are not in correct order");

        NSString *imageName = [NSString stringWithFormat:@"%@imageName", moralName];

        STAssertEqualObjects((testingSubject.moralImageNames)[moralName], imageName, @"Moral Image Names are not in correct order");

        /**< @TODO: Determine moral issue, then implement moralImageName tests */
//        Moral *moral = [self readMoralWithName:moralName];
//        UIColor *color = [UIColor colorWithHexString:moral.colorMoral];
//        STAssertTrue([color isEqual:[testingSubject.pieColors objectAtIndex:i]],  @"Moral Colors are not in correct ascending order");
    }

    for (int i = 0; i < testingSubject.pieValues.count; i++) {

        STAssertEqualsWithAccuracy([(testingSubject.pieValues)[i] floatValue], [expectedValues[i] floatValue], 0,  @"Moral Values are not in correct order");
    }
}



@end

