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

@interface TestReportPieModel : SenTestCase {
    
    ReportPieModel *testingSubject;
    ModelManager *testModelManager;

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

    virtue1Name = @"Virtue1";
    virtue2Name = @"Virtue2";
    vice1Name = @"Vice1";
    vice2Name = @"Vice2";
    vice3Name = @"Vice3";

    virtue1 = [self createMoralWithName:virtue1Name withType:@"Virtue"];
    virtue2 = [self createMoralWithName:virtue2Name withType:@"Virtue"];
    vice1 = [self createMoralWithName:vice1Name withType:@"Vice"];
    vice2 = [self createMoralWithName:vice2Name withType:@"Vice"];
    vice3 = [self createMoralWithName:vice3Name withType:@"Vice"];

    [testModelManager saveContext];

    testingSubject = [[ReportPieModel alloc] initWithModelManager:testModelManager];

}

- (void)testReportPieModelCanBeCreated {

    ReportPieModel *testingSubjectCreate = [[ReportPieModel alloc] initWithModelManager:testModelManager];

    STAssertNotNil(testingSubjectCreate, @"ReportPieModel can't be created.");

    [testingSubjectCreate release];
    
}

- (void)testReportPieModelDefaultValuesAreSetCorrectly {

    STAssertTrue(testingSubject.isGood, @"ReportPieModel isn't good by default");
    STAssertFalse(testingSubject.isAlphabetical, @"ReportPieModel is alpha incorrectly by default");
    STAssertFalse(testingSubject.isAscending, @"ReportPieModel is ascending incorrectly by default");

}

- (void)testWhenNoUserVirtuesArePresentReportIsEmpty {

    STAssertEqualObjects([testingSubject.reportNames objectAtIndex:0], @"No Moral Entries!", @"Empty Virtue name is incorrect");

}

- (void)testWhenNoUserVicesArePresentReportIsEmpty {

    testingSubject.isGood = FALSE;
    
    STAssertEqualObjects([testingSubject.reportNames objectAtIndex:0], @"No Immoral Entries!", @"Empty Vice name is incorrect");
    
}

- (void)testWhenAlphabeticAscendingVirtuesAreRequestedReportisCorrect {

    choiceMoral1 = [self createUserEntryWithName:choiceMoral1Name withMoral:virtue1Name andWeight:1.0];
    choiceMoral2 = [self createUserEntryWithName:choiceMoral2Name withMoral:virtue2Name andWeight:2.0];

    [testModelManager saveContext];

    NSArray *expectedMorals = @[virtue2Name, virtue1Name];
    NSArray *expectedValues = @[@(1/3 *360), @(2/3*360)];

    for (int i = 0; i < testingSubject.moralNames.count; i++) {

        STAssertEqualObjects([testingSubject.moralNames objectAtIndex:i], [expectedMorals objectAtIndex:i], @"Moral Names are not in correct ascending order");
    }
    for (int i = 0; i < testingSubject.pieValues.count; i++) {

        STAssertEqualObjects([testingSubject.pieValues objectAtIndex:i], [expectedValues objectAtIndex:i], @"Moral Names are not in correct ascending order");
    }

}

- (void)testWhenAlphabeticDescendingVirtuesAreRequestedReportisCorrect {

    testingSubject.isAscending = FALSE;
    choiceMoral1 = [self createUserEntryWithName:choiceMoral1Name withMoral:virtue1Name andWeight:1.0];
    choiceMoral2 = [self createUserEntryWithName:choiceMoral2Name withMoral:virtue2Name andWeight:2.0];

    [testModelManager saveContext];

    NSArray *expectedMorals = @[virtue1Name, virtue2Name];
    NSArray *expectedValues = @[@(1/3 *360), @(2/3*360)];

    for (int i = 0; i < testingSubject.moralNames.count; i++) {

        STAssertEqualObjects([testingSubject.moralNames objectAtIndex:i], [expectedMorals objectAtIndex:i], @"Moral Names are not in correct descending order");
    }
    for (int i = 0; i < testingSubject.pieValues.count; i++) {

        STAssertEqualObjects([testingSubject.pieValues objectAtIndex:i], [expectedValues objectAtIndex:i], @"Moral Names are not in correct descending order");
    }
    
}

//- (void)testWhenAlphabeticAscendingVicesAreRequestedReportisCorrect {
//
//    choiceImmoral1 = [self createUserEntryWithName:choiceImmoral1Name withMoral:vice1Name andWeight:1.0];
//    choiceImmoral2 = [self createUserEntryWithName:choiceImmoral2Name withMoral:vice2Name andWeight:2.0];
//    choiceImmoral3 = [self createUserEntryWithName:choiceImmoral3Name withMoral:vice3Name andWeight:3.0];
//
//    [testModelManager saveContext];
//
//    
//    
//}


- (Moral *)createMoralWithName:(NSString *)moralName withType:(NSString *)type {

    NSString *imageName = [NSString stringWithFormat:@"%@imageName", moralName];
    NSString *color = @"#FF00FF";

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

- (UserChoice *)createUserEntryWithName:(NSString *)entryName withMoral:(NSString *)moral andWeight:(CGFloat) weight{

    UserChoice *testChoice1 = [testModelManager create:UserChoice.class];

    testChoice1.entryShortDescription = @"shortDescription";
    testChoice1.choiceMoral = moral;
    testChoice1.entryCreationDate = [NSDate date];
    testChoice1.entryKey = [NSString stringWithFormat:@"%@key", entryName];
    testChoice1.entryIsGood = @1;
    testChoice1.choiceWeight = @(weight);
    testChoice1.entryModificationDate = [NSDate date];

    [testModelManager saveContext];

    return testChoice1;
    
}

@end

