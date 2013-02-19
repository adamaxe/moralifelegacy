/**
 Unit Test for DilemmaModel.  Test model interaction with peristed data for DilemmaViewController and DilemmaListViewController
 
 @class TestDilemmaModel
 
 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 02/18/2013
 @file
 */

#import "DilemmaModel.h"
#import "Dilemma.h"
#import "UserCollectable.h"
#import "OCMock/OCMock.h"

@interface TestDilemmaModel : SenTestCase {
    
    DilemmaModel *testingSubject;
    ModelManager *testModelManager;
    id userDefaultsMock;
    NSArray *userCollection;

}

@end

@implementation TestDilemmaModel

//- (void)setUp {
//    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
//    userDefaultsMock = [OCMockObject niceMockForClass:NSUserDefaults.class];
//
//    [testModelManager saveContext];
//
//    testingSubject = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentDilemma:0];
//
//}
//
//- (void)testReferenceModelCanBeCreated {
//
//    DilemmaModel *testingSubjectCreate = [[DilemmaModel alloc] initWithModelManager:testModelManager andDefaults:userDefaultsMock andCurrentDilemma:0];
//
//    STAssertNotNil(testingSubjectCreate, @"DilemmaModel can't be created.");
//}

@end

