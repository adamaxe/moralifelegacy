/**
 Unit Test for ReportPieModel.  Test model interaction with peristed data
 
 @class TestReportPieModel
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/09/2012
 @file
 */

#import "ReportPieModel.h"
#import "ModelManager.h"
#import "TestModelHelper.h"
#import "Moral.h"
#import "UserChoice.h"
//#import "UIColor+Utility.h"

@interface TestReportPieModel :XCTestCase {
    
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

    choiceMoral1Name = @"choiceMoral1Name";
    choiceMoral2Name = @"choiceMoral2Name";
    choiceImmoral1Name = @"choiceImmoral1Name";
    choiceImmoral2Name = @"choiceImmoral2Name";
    choiceImmoral3Name = @"choiceImmoral3Name";

    virtue1 = [TestModelHelper createMoralWithName:virtue1Name withType:@"Virtue" withModelManager:testModelManager];
    virtue2 = [TestModelHelper createMoralWithName:virtue2Name withType:@"Virtue" withModelManager:testModelManager];
    vice1 = [TestModelHelper createMoralWithName:vice1Name withType:@"Vice" withModelManager:testModelManager];
    vice2 = [TestModelHelper createMoralWithName:vice2Name withType:@"Vice" withModelManager:testModelManager];
    vice3 = [TestModelHelper createMoralWithName:vice3Name withType:@"Vice" withModelManager:testModelManager];

    choiceMoral1 = [TestModelHelper createUserEntryWithName:choiceMoral1Name withMoral:virtue1 andWeight:virtue1Weight withModelManager:testModelManager];
    choiceMoral2 = [TestModelHelper createUserEntryWithName:choiceMoral2Name withMoral:virtue2 andWeight:virtue2Weight withModelManager:testModelManager];

    choiceImmoral1 = [TestModelHelper createUserEntryWithName:choiceImmoral1Name withMoral:vice1 andWeight:vice1Weight withModelManager:testModelManager];
    choiceImmoral2 = [TestModelHelper createUserEntryWithName:choiceImmoral2Name withMoral:vice2 andWeight:vice2Weight withModelManager:testModelManager];
    choiceImmoral3 = [TestModelHelper createUserEntryWithName:choiceImmoral3Name withMoral:vice3 andWeight:vice3Weight withModelManager:testModelManager];

    testingSubject = [[ReportPieModel alloc] initWithModelManager:testModelManager];

}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];

}

- (void)testReportPieModelCanBeCreated {

    ReportPieModel *testingSubjectCreate = [[ReportPieModel alloc] initWithModelManager:testModelManager];

    XCTAssertNotNil(testingSubjectCreate, @"ReportPieModel can't be created.");

    
}

- (void)testReportPieModelDefaultValuesAreSetCorrectly {

    XCTAssertTrue(testingSubject.isGood, @"ReportPieModel isn't good by default");
    XCTAssertFalse(testingSubject.isAlphabetical, @"ReportPieModel is alpha incorrectly by default");
    XCTAssertFalse(testingSubject.isAscending, @"ReportPieModel is ascending incorrectly by default");

}

- (void)testWhenNoUserVirtuesArePresentReportIsEmpty {

    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    ReportPieModel *testingSubjectCreate = [[ReportPieModel alloc] initWithModelManager:testModelManagerCreate];

    XCTAssertEqualObjects((testingSubjectCreate.reportNames)[0], @"No Moral Entries!", @"Empty Virtue name is incorrect");


}

- (void)testWhenNoUserVicesArePresentReportIsEmpty {
    ModelManager *testModelManagerCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    ReportPieModel *testingSubjectCreate = [[ReportPieModel alloc] initWithModelManager:testModelManagerCreate];

    testingSubjectCreate.isGood = FALSE;
    
    XCTAssertEqualObjects((testingSubjectCreate.reportNames)[0], @"No Immoral Entries!", @"Empty Vice name is incorrect");
    
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

- (void)assertCorrectOrder:(NSArray *)expectedMorals expectedValues:(NSArray *)expectedValues{
    for (int i = 0; i < testingSubject.moralNames.count; i++) {

        NSString *moralName = (testingSubject.moralNames)[i];

        XCTAssertEqualObjects(moralName, expectedMorals[i], @"Moral Names are not in correct order");

        NSString *imageName = [NSString stringWithFormat:@"%@imageName", moralName];

        XCTAssertEqualObjects((testingSubject.moralImageNames)[moralName], imageName, @"Moral Image Names are not in correct order");

        /**< @TODO: Determine moral issue, then implement moralImageName tests */
//        Moral *moral = [self readMoralWithName:moralName];
//        UIColor *color = [UIColor colorWithHexString:moral.colorMoral];
//        XCTAssertTrue([color isEqual:[testingSubject.pieColors objectAtIndex:i]],  @"Moral Colors are not in correct ascending order");
    }

    for (int i = 0; i < testingSubject.pieValues.count; i++) {

        XCTAssertEqualWithAccuracy([(testingSubject.pieValues)[i] floatValue], [expectedValues[i] floatValue], 0,  @"Pie Values are not in correct order");
    }
}



@end

