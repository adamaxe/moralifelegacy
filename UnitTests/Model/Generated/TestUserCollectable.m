#import "ModelManager.h"
#import "UserCollectable.h"

@interface TestUserCollectable: SenTestCase {
    ModelManager *testModelManager;
    UserCollectable *testUserCollectable;
    
    NSDate * collectableCreationDate;
    NSString * collectableName;
    NSString * collectableKey;
    NSNumber * collectableValue;
    
}

@end

@implementation TestUserCollectable

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    
    
    collectableCreationDate = [NSDate date];
    collectableName = @"collectable name";
    collectableKey = @"collectable key";
    collectableValue = [NSNumber numberWithFloat:1.0];
    
    testUserCollectable = [testModelManager create:UserCollectable.class];
    
    testUserCollectable.collectableCreationDate = collectableCreationDate;
    testUserCollectable.collectableName = collectableName;
    testUserCollectable.collectableKey = collectableKey;
    testUserCollectable.collectableValue = collectableValue;
}

- (void)testUserCollectableCanBeCreated {
    
    //testUserCollectable are created in setup    
    STAssertNoThrow([testModelManager saveContext], @"UserCollectable can't be created.");
    
}

- (void)testUserCollectableAccessorsAreFunctional {
    
    STAssertNoThrow([testModelManager saveContext], @"UserCollectable can't be created for Accessor test.");
    
    NSArray *collectables = [testModelManager readAll:UserCollectable.class];
    
    STAssertEquals(collectables.count, (NSUInteger) 1, @"There should only be 1 UserCollectable in the context.");
    UserCollectable *retrieved = [collectables objectAtIndex: 0];
    
    STAssertEqualObjects(retrieved.collectableValue, collectableValue, @"collectableValue Getter/Setter failed.");
    STAssertEqualObjects(retrieved.collectableCreationDate, collectableCreationDate, @"collectableCreationDate Getter/Setter failed.");
    STAssertEqualObjects(retrieved.collectableName, collectableName, @"collectableName Getter/Setter failed.");
    STAssertEqualObjects(retrieved.collectableKey, collectableKey, @"collectableKey Getter/Setter failed.");
    
}

- (void)testUserCollectableDeletion {
    STAssertNoThrow([testModelManager saveContext], @"UserCollectable can't be created for Delete test");
    
    STAssertNoThrow([testModelManager delete:testUserCollectable], @"UserCollectable can't be deleted");
    
    NSArray *collectables = [testModelManager readAll:UserCollectable.class];
    
    STAssertEquals(collectables.count, (NSUInteger) 0, @"UserCollectable is still present after delete");
    
}

- (void)testUserCollectableWithoutRequiredAttributes {
    UserCollectable *testUserCollectableBad = [testModelManager create:UserCollectable.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testUserCollectableBad.class];
    
    STAssertThrows([testModelManager saveContext], errorMessage);
}

@end