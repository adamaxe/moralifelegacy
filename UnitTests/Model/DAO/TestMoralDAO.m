#import "ModelManager.h"
#import "Moral.h"
#import "MoralDAO.h"

@interface TestMoralDAO: SenTestCase {
    ModelManager *testModelManager;

    MoralDAO *testingSubject;
    
    Moral *testMoral1;
    Moral *testMoral2;
    Moral *testMoral3;
    
    NSString * moralTypeVirtue;
    NSString * nameMoral1;
    NSString * moralTypeVice;
    NSString * nameMoral2;
    NSString * moralVirtueExtra;
    NSString * nameMoral3;
    
    NSString * imageNameMoral;
    NSString * colorMoral;
    NSString * displayNameMoral;
    NSString * longDescriptionMoral;
    NSString * component;
    NSString * linkMoral;
    NSString * definitionMoral;
    
}

@end

@implementation TestMoralDAO

- (void)setUp {
    testModelManager = [[ModelManager alloc] initWithBundle:[NSBundle bundleForClass:self.class] andIsInMemory:NO];
    
    moralTypeVirtue = @"Virtue";
    nameMoral1 = @"Virtue Name1";
    moralTypeVice = @"Vice";
    nameMoral2 = @"Vice Name2";
    moralVirtueExtra = @"Virtue";
    nameMoral3 = @"Virtue Name3";
    
    imageNameMoral = @"imageName";
    colorMoral = @"color";
    displayNameMoral = @"displayName";
    longDescriptionMoral = @"longDescription";
    component = @"component";
    linkMoral = @"link";
    definitionMoral = @"definition"; 
        
    testMoral1 = [testModelManager create:Moral.class];
    testMoral2 = [testModelManager create:Moral.class];
    testMoral3 = [testModelManager create:Moral.class];

    testMoral1.shortDescriptionMoral = moralTypeVirtue;
    testMoral1.nameMoral = nameMoral1;

    testMoral2.shortDescriptionMoral = moralTypeVice;
    testMoral2.nameMoral = nameMoral2;

    testMoral3.shortDescriptionMoral = moralVirtueExtra;
    testMoral3.nameMoral = nameMoral3;

    testMoral1.imageNameMoral = imageNameMoral;
    testMoral1.colorMoral = colorMoral;
    testMoral1.displayNameMoral = displayNameMoral;
    testMoral1.longDescriptionMoral = longDescriptionMoral;
    testMoral1.component = component;
    testMoral1.linkMoral = linkMoral;
    testMoral1.definitionMoral = definitionMoral;

    testMoral2.imageNameMoral = imageNameMoral;
    testMoral2.colorMoral = colorMoral;
    testMoral2.displayNameMoral = displayNameMoral;
    testMoral2.longDescriptionMoral = longDescriptionMoral;
    testMoral2.component = component;
    testMoral2.linkMoral = linkMoral;
    testMoral2.definitionMoral = definitionMoral;

    testMoral3.imageNameMoral = imageNameMoral;
    testMoral3.colorMoral = colorMoral;
    testMoral3.displayNameMoral = displayNameMoral;
    testMoral3.longDescriptionMoral = longDescriptionMoral;
    testMoral3.component = component;
    testMoral3.linkMoral = linkMoral;
    testMoral3.definitionMoral = definitionMoral;

    [testModelManager saveContext];
}

- (void)testMoralDAOAllTypeCanBeCreated {
    
    testingSubject = [[MoralDAO alloc] init];
        
    STAssertNotNil(testingSubject, @"MoralDAO All type can't be created.");
    [testingSubject release];
    
}

- (void)testMoralDAOVirtueTypeCanBeCreated {
    
    testingSubject = [[MoralDAO alloc] initWithMoralType:moralTypeVirtue];
    
    STAssertNotNil(testingSubject, @"MoralDAO Virtue type  can't be created.");
    [testingSubject release];
    
}

- (void)testMoralDAOViceTypeCanBeCreated {
    
    testingSubject = [[MoralDAO alloc] initWithMoralType:moralTypeVice];
    
    STAssertNotNil(testingSubject, @"MoralDAO Vice can't be created.");
    [testingSubject release];
    
}

- (void)testMoralDAOAccessorsAreFunctional {
        
    NSArray *morals = [testModelManager readAll:Moral.class];
    
    STAssertEquals(morals.count, (NSUInteger) 3, @"There should be 3 Morals in the context.");
}

@end