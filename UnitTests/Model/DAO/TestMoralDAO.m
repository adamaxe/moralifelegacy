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
    NSString * moralTypeVirtueExtra;
    NSString * nameMoral3;
    NSString * moralTypeAll;
    
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
    testModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    
    moralTypeVirtue = @"Virtue";
    nameMoral1 = @"Virtue Name1";
    moralTypeVice = @"Vice";
    nameMoral2 = @"Vice Name2";
    moralTypeVirtueExtra = @"Virtue";
    nameMoral3 = @"Virtue Name3";
    moralTypeAll = @"all";
    
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

    testMoral3.shortDescriptionMoral = moralTypeVirtueExtra;
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
    
    testingSubject = [[MoralDAO alloc] initWithType:moralTypeAll andInMemory:YES];
}

- (void)testMoralDAOAllTypeCanBeCreated {
    
    MoralDAO *testingSubjectAll = [[MoralDAO alloc] initWithType:moralTypeAll andInMemory:YES]; 

    STAssertNotNil(testingSubjectAll, @"MoralDAO All type can't be created.");
    [testingSubjectAll release];
    
}

- (void)testMoralDAOVirtueTypeCanBeCreated {
    
    MoralDAO *testingSubjectVirtue = [[MoralDAO alloc] initWithType:moralTypeVirtue andInMemory:YES];
    
    STAssertNotNil(testingSubjectVirtue, @"MoralDAO Virtue type can't be created.");
    [testingSubjectVirtue release];
    
}

- (void)testMoralDAOViceTypeCanBeCreated {
    
    MoralDAO *testingSubjectVice = [[MoralDAO alloc] initWithType:moralTypeVice andInMemory:YES];
    
    STAssertNotNil(testingSubjectVice, @"MoralDAO Vice can't be created.");
    [testingSubjectVice release];
    
}

- (void)testMoralDAOColor {
    STAssertEquals([testingSubject readColor:nameMoral1], colorMoral, @"Color couldn't be set/read.");
}

@end