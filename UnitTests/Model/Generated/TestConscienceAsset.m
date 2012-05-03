#import "TestCoreDataStack.h"
#import "ConscienceAsset.h"

@interface TestConscienceAsset: SenTestCase {
    TestCoreDataStack *coreData;
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
    coreData = [[TestCoreDataStack alloc] initWithManagedObjectModel:@"SystemData"];
    
    costAsset = [NSNumber numberWithFloat:1.0];
    moralValueAsset = [NSNumber numberWithFloat:2.0];
    orientationAsset = @"left";
    
    shortDescription = @"short description";
    originYear = [NSNumber numberWithInt:2010];
    name = @"name";
    longDescription = @"long description";
    link = @"http://www.teamaxe.org";    
    displayName = @"display name";
    imageName = @"image name";
    
    testAsset = [coreData insert:ConscienceAsset.class];

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

- (void)testConscienceAssetCanBeCreated {
    
    //testBelief, testPerson and testText are created in setup    
    STAssertNoThrow([coreData save], @"ConscienceAsset can't be created.");
        
}

- (void)testConscienceAssetAccessorsAreFunctional {
    
    STAssertNoThrow([coreData save], @"ConscienceAsset can't be created for Accessor test.");
    
    NSArray *assets = [coreData fetch:ConscienceAsset.class];
    
    STAssertEquals(assets.count, (NSUInteger) 1, @"There should only be 1 ConscienceAsset in the context.");
    ConscienceAsset *retrieved = [assets objectAtIndex: 0];

    STAssertEqualObjects(retrieved.costAsset, costAsset, @"costAsset Getter/Setter failed.");
    STAssertEqualObjects(retrieved.moralValueAsset, moralValueAsset, @"moralValueAsset Getter/Setter failed.");
    STAssertEqualObjects(retrieved.orientationAsset, orientationAsset, @"orientationAsset Getter/Setter failed.");
    STAssertEqualObjects(retrieved.shortDescriptionReference, shortDescription, @"shortDescription Getter/Setter failed.");
    STAssertEqualObjects(retrieved.originYear, originYear, @"originYear Getter/Setter failed.");
    STAssertEqualObjects(retrieved.nameReference, name, @"nameReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.longDescriptionReference, longDescription, @"longDescriptionReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.linkReference, link, @"linkReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.displayNameReference, displayName, @"displayNameReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.imageNameReference, imageName, @"imageNameReference Getter/Setter failed.");
    
}

- (void)testConscienceAssetDeletion {
    STAssertNoThrow([coreData save], @"ConscienceAsset/Belief/Text can't be created for Delete test");
    
    STAssertNoThrow([coreData delete:testAsset], @"ConscienceAsset can't be deleted");
    
    NSArray *assets = [coreData fetch:ConscienceAsset.class];
    
    STAssertEquals(assets.count, (NSUInteger) 0, @"ConscienceAsset is still present after delete");
    
}

- (void)testConscienceAssetWithoutRequiredAttributes {
    ConscienceAsset *testConscienceAssetBad = [coreData insert:ConscienceAsset.class];
    NSString *errorMessage = [NSString stringWithFormat:@"CD should've thrown on %@", testConscienceAssetBad.class];
    
    STAssertThrows([coreData save], errorMessage);
}

@end
