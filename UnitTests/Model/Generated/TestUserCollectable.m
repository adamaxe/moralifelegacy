#import "TestCoreDataStack.h"
#import "UserCollectable.h"

@interface TestUserCollectable: SenTestCase {
    TestCoreDataStack *coreData;
    UserCollectable *testUserCollectable;

    NSDate * collectableCreationDate;
    NSString * collectableName;
    NSString * collectableKey;
    NSNumber * collectableValue;
    
}

@end

@implementation TestUserCollectable

- (void)setUp {
    coreData = [[TestCoreDataStack alloc] initWithManagedObjectModel:@"UserData"];
    
    
    collectableCreationDate = [NSDate date];
    collectableName = @"collectable name";
    collectableKey = @"collectable key";
    collectableValue = [NSNumber numberWithFloat:1.0];
    
    testUserCollectable = [coreData insert:UserCollectable.class];

    testUserCollectable.collectableCreationDate = collectableCreationDate;
    testUserCollectable.collectableName = collectableName;
    testUserCollectable.collectableKey = collectableKey;
    testUserCollectable.collectableValue = collectableValue;
}

- (void)testUserCollectableCanBeCreated {
    
    //testUserCollectable are created in setup    
    STAssertNoThrow([coreData save], @"UserCollectable can't be created.");
        
}

- (void)testUserCollectableAccessorsAreFunctional {
    
    STAssertNoThrow([coreData save], @"UserCollectable can't be created for Accessor test.");
    
    NSArray *collectables = [coreData fetch:UserCollectable.class];
    
    STAssertEquals(collectables.count, (NSUInteger) 1, @"There should only be 1 UserCollectable in the context.");
    UserCollectable *retrieved = [collectables objectAtIndex: 0];

    STAssertEquals(retrieved.collectableValue, collectableValue, @"collectableValue Getter/Setter failed.");
    STAssertEqualObjects(retrieved.collectableCreationDate, collectableCreationDate, @"collectableCreationDate Getter/Setter failed.");
    STAssertEqualObjects(retrieved.collectableName, collectableName, @"collectableName Getter/Setter failed.");
    STAssertEqualObjects(retrieved.collectableKey, collectableKey, @"collectableKey Getter/Setter failed.");
    
}

- (void)testUserCollectableDeletion {
    STAssertNoThrow([coreData save], @"UserCollectable can't be created for Delete test");
    
    STAssertNoThrow([coreData delete:testUserCollectable], @"UserCollectable can't be deleted");
    
    NSArray *assets = [coreData fetch:UserCollectable.class];
    
    STAssertEquals(assets.count, (NSUInteger) 0, @"UserCollectable is still present after delete");
    
}

@end
