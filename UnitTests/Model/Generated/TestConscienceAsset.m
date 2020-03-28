#import "ModelManager.h"
#import "TestModelHelper.h"
#import "ConscienceAsset.h"

@interface TestConscienceAsset:XCTestCase {
    ModelManager *testModelManager;
    ConscienceAsset *testAsset;

    NSNumber *costAsset;
    NSNumber *moralValueAsset;
    NSString *orientationAsset;
    
    NSString *shortDescription;
    NSNumber *originYear;
    NSString *name;
    NSString *longDescription;
    NSString *link;    
    NSString *displayName;
    NSString *imageName;
}

@end

@implementation TestConscienceAsset

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    
    costAsset = @1.0f;
    moralValueAsset = @2.0f;
    orientationAsset = @"left";
    
    shortDescription = @"short description";
    originYear = @2010;
    name = @"name";
    longDescription = @"long description";
    link = @"http://www.teamaxe.org";    
    displayName = @"display name";
    imageName = @"image name";
    
    testAsset = [TestModelHelper createAssetWithName:name withModelManager:testModelManager];

    testAsset.costAsset = costAsset;
    testAsset.moralValueAsset = moralValueAsset;
    testAsset.orientationAsset = orientationAsset;

    testAsset.shortDescriptionReference = shortDescription;
    testAsset.originYear = originYear;
    testAsset.nameReference = name;
    testAsset.longDescriptionReference = longDescription;
    testAsset.linkReference = link;
    testAsset.displayNameReference = displayName;
    testAsset.imageNameReference = imageName;
    
}

- (void)tearDown{

	//Tear-down code here.

	[super tearDown];
    
}

- (void)testConscienceAssetCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    XCTAssertNoThrow([testModelManager saveContext], @"ConscienceAsset can't be created.");
        
}

- (void)testConscienceAssetAccessorsAreFunctional {
    
    XCTAssertNoThrow([testModelManager saveContext], @"ConscienceAsset can't be created for Accessor test.");
    
    NSArray *assets = [testModelManager readAll:ConscienceAsset.class];
    
    XCTAssertEqual(assets.count, (NSUInteger) 1, @"There should only be 1 ConscienceAsset in the context.");
    ConscienceAsset *retrieved = assets[0];

    XCTAssertEqualObjects(retrieved.costAsset, costAsset, @"costAsset Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.moralValueAsset, moralValueAsset, @"moralValueAsset Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.orientationAsset, orientationAsset, @"orientationAsset Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.shortDescriptionReference, shortDescription, @"shortDescription Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.originYear, originYear, @"originYear Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.nameReference, name, @"nameReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.longDescriptionReference, longDescription, @"longDescriptionReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.linkReference, link, @"linkReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.displayNameReference, displayName, @"displayNameReference Getter/Setter failed.");
    XCTAssertEqualObjects(retrieved.imageNameReference, imageName, @"imageNameReference Getter/Setter failed.");
    
}

- (void)testConscienceAssetDeletion {
    XCTAssertNoThrow([testModelManager saveContext], @"ConscienceAsset/Belief/Text can't be created for Delete test");
    
    XCTAssertNoThrow([testModelManager delete:testAsset], @"ConscienceAsset can't be deleted");
    
    NSArray *assets = [testModelManager readAll:ConscienceAsset.class];
    
    XCTAssertEqual(assets.count, (NSUInteger) 0, @"ConscienceAsset is still present after delete");
    
}

- (void)testConscienceAssetWithoutRequiredAttributes {
    ConscienceAsset *testConscienceAssetBad = [testModelManager create:ConscienceAsset.class];
    
    XCTAssertThrows([testModelManager saveContext]);
}

@end
