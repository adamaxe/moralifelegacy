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

@interface TestReportPieModel : SenTestCase {
    
    ReportPieModel *testingSubject;
    ModelManager *testModelManager;

    Moral *virtue1;
    Moral *virtue2;
    Moral *vice1;
    Moral *vice2;
    Moral *vice3;
}

@end

@implementation TestReportPieModel

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

    virtue1 = [self createMoralWithName:@"Virtue1" withType:@"Virtue"];
    virtue2 = [self createMoralWithName:@"Virtue2" withType:@"Virtue"];
    vice1 = [self createMoralWithName:@"Vice1" withType:@"Vice"];
    vice2 = [self createMoralWithName:@"Vice2" withType:@"Vice"];
    vice3 = [self createMoralWithName:@"Vice3" withType:@"Vice"];

    [testModelManager saveContext];

    testingSubject = [[ReportPieModel alloc] initWithModelManager:testModelManager];

}

- (void)testReportPieModelCanBeCreated {

    ReportPieModel *testingSubjectCreate = [[ReportPieModel alloc] initWithModelManager:testModelManager];

    STAssertNotNil(testingSubjectCreate, @"ReportPieModel can't be created.");

    STAssertTrue(testingSubjectCreate.isGood, @"ReportPieModel isn't good by default");

    [testingSubjectCreate release];
    
}

- (void)testReportPieModelDefaultValuesAreSetCorrectly {

    STAssertTrue(testingSubject.isGood, @"ReportPieModel isn't good by default");
    STAssertFalse(testingSubject.isAlphabetical, @"ReportPieModel is alpha incorrectly by default");
    STAssertFalse(testingSubject.isAscending, @"ReportPieModel is ascending incorrectly by default");

}

//- (void)testWhenNoUserVirtuesArePresentReportIsEmpty {
//
//}

- (Moral *)createMoralWithName:(NSString *)moralName withType:(NSString *)type {

    NSString *imageName = [NSString stringWithFormat:@"%@imageName", moralName];
    NSString *color = @"#FF00FF";
    NSString *displayName = @"displayName";
    NSString *longDescription = @"longDescription";
    NSString *component = @"component";
    NSString *link = @"link";
    NSString *definition = @"definition";

    Moral *testMoral1 = [testModelManager create:Moral.class];

    testMoral1.shortDescriptionMoral = type;
    testMoral1.nameMoral = moralName;

    testMoral1.imageNameMoral = imageName;
    testMoral1.colorMoral = color;
    testMoral1.displayNameMoral = displayName;
    testMoral1.longDescriptionMoral = longDescription;
    testMoral1.component = component;
    testMoral1.linkMoral = link;
    testMoral1.definitionMoral = definition;

    [testModelManager saveContext];

    return testMoral1;
    
}

@end

