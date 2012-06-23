#import "TestCoreDataStack.h"
#import "Moral.h"
#import "MoralDAO.h"

@interface TestMoralDAO: SenTestCase {
    TestCoreDataStack *coreData;
    Moral *testMoral;
    
    NSString * imageNameMoral;
    NSString * colorMoral;
    NSString * displayNameMoral;
    NSString * longDescriptionMoral;
    NSString * component;
    NSString * shortDescriptionMoral;
    NSString * linkMoral;
    NSString * nameMoral;
    NSString * definitionMoral;
    
}

@end

@implementation TestMoralDAO

- (void)setUp {
    coreData = [[TestCoreDataStack alloc] initWithManagedObjectModel:@"SystemData"];
    
    imageNameMoral = @"imageName";
    colorMoral = @"color";
    displayNameMoral = @"displayName";
    longDescriptionMoral = @"longDescription";
    component = @"component";
    shortDescriptionMoral = @"shortDescription";
    linkMoral = @"link";
    nameMoral = @"name";
    definitionMoral = @"definition"; 
        
    testMoral = [coreData insert:Moral.class];
    
    testMoral.imageNameMoral = imageNameMoral;
    testMoral.colorMoral = colorMoral;
    testMoral.displayNameMoral = displayNameMoral;
    testMoral.longDescriptionMoral = longDescriptionMoral;
    testMoral.component = component;
    testMoral.shortDescriptionMoral = shortDescriptionMoral;
    testMoral.linkMoral = linkMoral;
    testMoral.nameMoral = nameMoral;
    testMoral.definitionMoral = definitionMoral;
    
}
//TODO: Cannot test DAO until test CoreData stack can be referenced from DAO
//- (void)testMoralDAOCanBeCreated {
//    
//    //testUserCollectable are created in setup    
//    STAssertNoThrow([coreData save], @"Moral can't be created.");
//    
//}
//
//- (void)testMoralDAOAccessorsAreFunctional {
//    
//    STAssertNoThrow([coreData save], @"Moral can't be created for Accessor test.");
//    
//    NSArray *morals = [coreData fetch:Moral.class];
//    
//    STAssertEquals(morals.count, (NSUInteger) 1, @"There should only be 1 Moral in the context.");
//    Moral *retrieved = [morals objectAtIndex: 0];
//    
//    STAssertEqualObjects(retrieved.imageNameMoral, imageNameMoral, @"imageNameMoral Getter/Setter failed.");
//    STAssertEqualObjects(retrieved.colorMoral, colorMoral, @"colorMoral Getter/Setter failed.");
//    STAssertEqualObjects(retrieved.displayNameMoral, displayNameMoral, @"displayNameMoral Getter/Setter failed.");    
//    STAssertEqualObjects(retrieved.longDescriptionMoral, longDescriptionMoral, @"longDescriptionMoral Getter/Setter failed.");
//    STAssertEqualObjects(retrieved.component, component, @"component Getter/Setter failed.");
//    STAssertEqualObjects(retrieved.shortDescriptionMoral, shortDescriptionMoral, @"shortDescriptionMoral Getter/Setter failed.");
//    STAssertEqualObjects(retrieved.linkMoral, linkMoral, @"linkMoral Getter/Setter failed.");
//    STAssertEqualObjects(retrieved.nameMoral, nameMoral, @"nameMoral Getter/Setter failed.");
//    STAssertEqualObjects(retrieved.definitionMoral, definitionMoral, @"definitionMoral Getter/Setter failed.");    
//}

@end