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

    testMoral1 = [self createMoralWithName:nameMoral1 withType:moralTypeVirtue];
    testMoral2 = [self createMoralWithName:nameMoral2 withType:moralTypeVice];
    testMoral3 = [self createMoralWithName:nameMoral3 withType:moralTypeAll];
    
    [testingSubject saveContext];
}

- (void)testModelManagerCanBeCreated {
        
    ModelManager *testingSubjectCreate = [[ModelManager alloc] initWithInMemoryStore:YES];

    STAssertNotNil(testingSubjectCreate, @"ModelManager can't be created.");
    
    
}

- (void)testNSManagedObjectCanBeCreated {

    Moral *testMoral4 = [self createMoralWithName:@"nameMoral4" withType:moralTypeVirtue];

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

- (Moral *)createMoralWithName:(NSString *)moralName withType:(NSString *)type {

    Moral *moral1 = [testingSubject create:Moral.class];

    moral1.shortDescriptionMoral = type;
    moral1.nameMoral = moralName;

    moral1.imageNameMoral =  @"imageName";
    moral1.colorMoral = @"#FF00FF";
    moral1.displayNameMoral = @"displayName";
    moral1.longDescriptionMoral = @"longDescription";
    moral1.component = @"component";
    moral1.linkMoral = @"link";
    moral1.definitionMoral = @"definition";

    [testingSubject saveContext];

    return moral1;
    
}

@end

