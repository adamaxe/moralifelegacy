#import "ModelManager.h"
#import "UserCollectable.h"

@interface TestUserCollectable: XCTestCase {
    ModelManager *testModelManager;
    UserCollectable *testUserCollectable;
    
    NSDate *collectableCreationDate;
    NSString *collectableName;
    NSString *collectableKey;
    NSNumber *collectableValue;
    
}

@end

@implementation TestUserCollectable

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    
    
    collectableCreationDate = [NSDate date];
    collectableName = @"collectable name";
    collectableKey = @"collectable key";
    collectableValue = @1.0f;
    
    testUserCollectable = [testModelManager create:UserCollectable.class];
    
    testUserCollectable.collectableCreationDate = collectableCreationDate;
    testUserCollectable.collectableName = collectableName;
    testUserCollectable.collectableKey = collectableKey;
    testUserCollectable.collectableValue = collectableValue;
}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testUserCollectableCanBeCreated {
    
    //testUserCollectable are created in setup    
    XCTAssertNoThrow([testModelManager saveContext], @"UserCollectable can't be created.");
    
}

- (void)testUserCollectableAccessorsAreFunctional {
    
    XCTAssertNoThrow([testModelManager saveContext], @"UserCollectable can't be created for Accessor test.");
    
    NSArray *collectables = [testModelManager readAll:UserCollectable.class];
    
    XCTAssertEqual(collectables.count, (NSUInteger) 1, @"There should only be 1 UserCollectable in the context.");
    UserCollectable *retrieved = collectables[0];
    
    XCTAssertEqualObjects(retrieved.collectableValue, collectableValue, @"collectableValue Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.collectableCreationDate, collectableCreationDate, @"collectableCreationDate Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.collectableName, collectableName, @"collectableName Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.collectableKey, collectableKey, @"collectableKey Getter/Setter failed.");
    
}

- (void)testUserCollectableDeletion {
    XCTAssertNoThrow([testModelManager saveContext], @"UserCollectable can't be created for Delete test");
    
    XCTAssertNoThrow([testModelManager deleteReadWrite:testUserCollectable], @"UserCollectable can't be deleted");
    
    NSArray *collectables = [testModelManager readAll:UserCollectable.class];
    
    XCTAssertEqual(collectables.count, (NSUInteger) 0, @"UserCollectable is still present after delete");
    
}

- (void)testUserCollectableWithoutRequiredAttributes {
    UserCollectable *testUserCollectableBad = [testModelManager create:UserCollectable.class];
    
    XCTAssertThrows([testModelManager saveContext]);
    XCTAssertNotNil(testUserCollectableBad);
}

@end
