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

    testingSubject = [[ReportPieModel alloc] initWithModelManager:testModelManager];
    
}

- (void)testReportPieModelCanBeCreated {
        
    ReportPieModel *testingSubjectCreate = [[ReportPieModel alloc] initWithModelManager:testModelManager];

    STAssertNotNil(testingSubjectCreate, @"ReportPieModel can't be created.");
    
    [testingSubjectCreate release];
    
}

@end

