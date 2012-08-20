/**
 Unit Test for ReportPieModel.  Test model interaction with peristed data
 
 @class TestReportPieModel
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/09/2012
 @file
 */

#import "ReportPieModel.h"
#import "ModelManager.h"

@interface TestReportPieModel : SenTestCase {
    
    ReportPieModel *testingSubject;
    ModelManager *testModelManager;
    

}

@end

@implementation TestReportPieModel

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];

//    nameMoral1 = @"Virtue Name1";
//    nameMoral2 = @"Vice Name2";
//    nameMoral3 = @"Virtue Name3";
//
//    moralTypeVirtue = @"Virtue";
//    moralTypeVice = @"Vice";
//    moralTypeVirtueExtra = @"Virtue";
//    imageName = @"imageName";
//    color = @"color";
//    displayName = @"displayName";
//    longDescription = @"longDescription";
//    component = @"component";
//    link = @"link";
//    definition = @"definition";
//
//    testMoral1 = [testModelManager create:Moral.class];
//    testMoral2 = [testModelManager create:Moral.class];
//    testMoral3 = [testModelManager create:Moral.class];
//
//    testMoral1.shortDescriptionMoral = moralTypeVirtue;
//    testMoral1.nameMoral = nameMoral1;
//
//    testMoral2.shortDescriptionMoral = moralTypeVice;
//    testMoral2.nameMoral = nameMoral2;
//
//    testMoral3.shortDescriptionMoral = moralTypeVirtueExtra;
//    testMoral3.nameMoral = nameMoral3;
//
//    testMoral1.imageNameMoral = imageName;
//    testMoral1.colorMoral = color;
//    testMoral1.displayNameMoral = displayName;
//    testMoral1.longDescriptionMoral = longDescription;
//    testMoral1.component = component;
//    testMoral1.linkMoral = link;
//    testMoral1.definitionMoral = definition;
//
//    testMoral2.imageNameMoral = imageName;
//    testMoral2.colorMoral = color;
//    testMoral2.displayNameMoral = displayName;
//    testMoral2.longDescriptionMoral = longDescription;
//    testMoral2.component = component;
//    testMoral2.linkMoral = link;
//    testMoral2.definitionMoral = definition;
//
//    testMoral3.imageNameMoral = imageName;
//    testMoral3.colorMoral = color;
//    testMoral3.displayNameMoral = displayName;
//    testMoral3.longDescriptionMoral = longDescription;
//    testMoral3.component = component;
//    testMoral3.linkMoral = link;
//    testMoral3.definitionMoral = definition;

    [testModelManager saveContext];


    testingSubject = [[ReportPieModel alloc] initWithModelManager:testModelManager];

}

- (void)testReportPieModelCanBeCreated {
        
    ReportPieModel *testingSubjectCreate = [[ReportPieModel alloc] initWithModelManager:testModelManager];

    STAssertNotNil(testingSubjectCreate, @"ReportPieModel can't be created.");
    
    [testingSubjectCreate release];
    
}

@end

