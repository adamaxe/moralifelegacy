/**
 Unit Test for ModelManager.  Test to see if persistence stack can be setup and saved.
 
 @class TestModelManager
 
 @author Copyright 2012 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 06/09/2012
 @file
 */

#import "ModelManager.h"
#import "Moral.h"

@interface TestModelManager : SenTestCase {
    
    ModelManager *testingSubject;
        
    Moral *testMoral1;
    Moral *testMoral2;
    Moral *testMoral3;
    
    NSString *moralTypeVirtue;
    NSString *nameMoral1;
    NSString *moralTypeVice;
    NSString *nameMoral2;
    NSString *moralTypeVirtueExtra;
    NSString *nameMoral3;
    NSString *moralTypeAll;
    
    NSString *imageName;
    NSString *color;
    NSString *displayName;
    NSString *longDescription;
    NSString *component;
    NSString *link;
    NSString *definition;
    
}

@end

@implementation TestModelManager

- (void)setUp {
    
    testingSubject = [[ModelManager alloc] initWithInMemoryStore:YES];    
    
    moralTypeVirtue = @"Virtue";
    nameMoral1 = @"Virtue Name1";
    moralTypeVice = @"Vice";
    nameMoral2 = @"Vice Name2";
    moralTypeVirtueExtra = @"Virtue";
    nameMoral3 = @"Virtue Name3";
    moralTypeAll = @"all";
    
    imageName = @"imageName";
    color = @"color";
    displayName = @"displayName";
    longDescription = @"longDescription";
    component = @"component";
    link = @"link";
    definition = @"definition"; 
    
    testMoral1 = [testingSubject create:Moral.class];
    testMoral2 = [testingSubject create:Moral.class];
    testMoral3 = [testingSubject create:Moral.class];
    
    testMoral1.shortDescriptionMoral = moralTypeVirtue;
    testMoral1.nameMoral = nameMoral1;
    
    testMoral2.shortDescriptionMoral = moralTypeVice;
    testMoral2.nameMoral = nameMoral2;
    
    testMoral3.shortDescriptionMoral = moralTypeVirtueExtra;
    testMoral3.nameMoral = nameMoral3;
    
    testMoral1.imageNameMoral = imageName;
    testMoral1.colorMoral = color;
    testMoral1.displayNameMoral = displayName;
    testMoral1.longDescriptionMoral = longDescription;
    testMoral1.component = component;
    testMoral1.linkMoral = link;
    testMoral1.definitionMoral = definition;
    
    testMoral2.imageNameMoral = imageName;
    testMoral2.colorMoral = color;
    testMoral2.displayNameMoral = displayName;
    testMoral2.longDescriptionMoral = longDescription;
    testMoral2.component = component;
    testMoral2.linkMoral = link;
    testMoral2.definitionMoral = definition;
    
    testMoral3.imageNameMoral = imageName;
    testMoral3.colorMoral = color;
    testMoral3.displayNameMoral = displayName;
    testMoral3.longDescriptionMoral = longDescription;
    testMoral3.component = component;
    testMoral3.linkMoral = link;
    testMoral3.definitionMoral = definition;
    
    [testingSubject saveContext];
}

- (void)testModelManagerCanBeCreated {
        
    ModelManager *testingSubjectCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    STAssertNotNil(testingSubjectCreate, @"ModelManager can't be created.");
    
    [testingSubjectCreate release];
    
}

- (void)testNSManagedObjectCanBeCreated {
    
    Moral *testMoral4 = [testingSubject create:Moral.class];
    testMoral4.shortDescriptionMoral = moralTypeVirtue;
    testMoral4.nameMoral = @"nameMoral4";
    testMoral4.imageNameMoral = imageName;
    testMoral4.colorMoral = color;
    testMoral4.displayNameMoral = displayName;
    testMoral4.longDescriptionMoral = longDescription;
    testMoral4.component = component;
    testMoral4.linkMoral = link;
    testMoral4.definitionMoral = definition;
    
    STAssertNoThrow([testingSubject saveContext], @"Object can't be created.");

    NSArray *retrievedMorals = [testingSubject readAll:testMoral1.class];
        
    STAssertTrue([retrievedMorals containsObject:testMoral4], @"Created Object is not in the returned array.");

}

- (void)testAllNSManagedObjectsCanBeRead {
        
    NSArray *retrievedMorals = [testingSubject readAll:testMoral1.class];

    STAssertNotNil(retrievedMorals, @"Objects can't be read.");
    
    int count = [retrievedMorals count];
    STAssertEquals(count, 3, @"The amount of NSManagedObjects is wrong.");
}

- (void)testAllReturnedNSManagedObjectsAreCorrect {
    
    NSArray *retrievedMorals = [testingSubject readAll:testMoral1.class];
    
    STAssertNotNil(retrievedMorals, @"Objects can't be read.");
    
    STAssertTrue([retrievedMorals containsObject:testMoral1], @"1st Object is not in the returned array.");
    STAssertTrue([retrievedMorals containsObject:testMoral2], @"2nd Object is not in the returned array.");
    STAssertTrue([retrievedMorals containsObject:testMoral3], @"3rd Object not in the returned array.");
    
}

- (void)testNSManagedObjectCanBeDeleted {
    [testingSubject delete:testMoral3];
    [testingSubject saveContext];
    
    NSArray *retrievedMorals = [testingSubject readAll:testMoral1.class];
    STAssertFalse([retrievedMorals containsObject:testMoral3], @"Object was not deleted.");

}

@end

