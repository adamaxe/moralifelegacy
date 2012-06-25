#import "ModelManager.h"
#import "Moral.h"
#import "MoralDAO.h"

@interface TestMoralDAO: SenTestCase {
    ModelManager *testModelManager;

    MoralDAO *testingSubject;
    
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
    
    imageName = @"imageName";
    color = @"color";
    displayName = @"displayName";
    longDescription = @"longDescription";
    component = @"component";
    link = @"link";
    definition = @"definition"; 
        
    testMoral1 = [testModelManager create:Moral.class];
    testMoral2 = [testModelManager create:Moral.class];
    testMoral3 = [testModelManager create:Moral.class];

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

    [testModelManager saveContext];
    
    testingSubject = [[MoralDAO alloc] initWithType:moralTypeAll andModelManager:testModelManager];
}

- (void)testMoralDAOAllTypeCanBeCreated {
    
    MoralDAO *testingSubjectAll = [[MoralDAO alloc] initWithType:moralTypeAll andModelManager:testModelManager]; 
    
    STAssertNotNil(testingSubjectAll, @"MoralDAO All type can't be created.");
    
    [testingSubjectAll release];
    
}

- (void)testMoralDAOVirtueTypeCanBeCreated {
    
    MoralDAO *testingSubjectVirtue = [[MoralDAO alloc] initWithType:moralTypeVirtue andModelManager:testModelManager];
    
    STAssertNotNil(testingSubjectVirtue, @"MoralDAO Virtue type can't be created.");
    
    [testingSubjectVirtue release];
    
}

- (void)testMoralDAOViceTypeCanBeCreated {
    
    MoralDAO *testingSubjectVice = [[MoralDAO alloc] initWithType:moralTypeVice andModelManager:testModelManager];
    
    STAssertNotNil(testingSubjectVice, @"MoralDAO Vice can't be created.");
    [testingSubjectVice release];
    
}


- (void)testMoralDAOAllTypeContainsVirtuesAndVices {
    
    MoralDAO *testingSubjectAll = [[MoralDAO alloc] initWithType:moralTypeAll andModelManager:testModelManager]; 

    STAssertTrue([[testingSubjectAll readAllNames] containsObject:nameMoral1], @"MoralDAO All not populated with virtue 1.");
    STAssertTrue([[testingSubjectAll readAllNames] containsObject:nameMoral2], @"MoralDAO All not populated with vices.");
    STAssertTrue([[testingSubjectAll readAllNames] containsObject:nameMoral3], @"MoralDAO All not populated with virtue 2.");
    
    [testingSubjectAll release];
    
}

- (void)testMoralDAOVirtueTypeContainsOnlyVirtues {
    
    MoralDAO *testingSubjectVirtue = [[MoralDAO alloc] initWithType:moralTypeVirtue andModelManager:testModelManager];
    
    STAssertTrue([[testingSubjectVirtue readAllNames] containsObject:nameMoral1], @"MoralDAO Virtue not populated with virtue 1.");
    STAssertFalse([[testingSubjectVirtue readAllNames] containsObject:nameMoral2], @"MoralDAO Virtue populated with vices.");
    STAssertTrue([[testingSubjectVirtue readAllNames] containsObject:nameMoral3], @"MoralDAO Virtue not populated with virtue 2.");

    [testingSubjectVirtue release];
    
}

- (void)testMoralDAOViceTypedContainsOnlyVice {
    
    MoralDAO *testingSubjectVice = [[MoralDAO alloc] initWithType:moralTypeVice andModelManager:testModelManager];
    
    STAssertTrue([[testingSubjectVice readAllNames] containsObject:nameMoral2], @"MoralDAO Vice not populated with vices.");
    STAssertFalse([[testingSubjectVice readAllNames] containsObject:nameMoral1], @"MoralDAO Vice populated with virtues.");
    STAssertFalse([[testingSubjectVice readAllNames] containsObject:nameMoral3], @"MoralDAO Vice populated with virtues.");
    [testingSubjectVice release];
    
}

- (void)testMoralDAOReadColor {
    STAssertEquals([testingSubject readColor:nameMoral1], color, @"Color couldn't be read.");
}

- (void)testMoralDAOReadDefinition {
    STAssertEquals([testingSubject readDefinition:nameMoral1], definition, @"Definition couldn't be read.");
}

- (void)testMoralDAOReadLongDescription {
    STAssertEquals([testingSubject readLongDescription:nameMoral1], longDescription, @"longDescription couldn't be read.");
}

- (void)testMoralDAOReadDisplayName {
    STAssertEquals([testingSubject readDisplayName:nameMoral1], displayName, @"displayName couldn't be read.");
}

- (void)testMoralDAOReadImageName {
    STAssertEquals([testingSubject readImageName:nameMoral1], imageName, @"imageName couldn't be read.");
}

- (void)testMoralDAOReadColorAfterChange {
    NSString *changeTest = @"color5";
    
    testMoral1.colorMoral = changeTest;
    
    [testModelManager saveContext];
    
    STAssertEquals([testingSubject readColor:nameMoral1], changeTest, @"Color couldn't be changed.");
}

- (void)testMoralDAOReadDefinitionAfterChange {
    NSString *changeTest = @"def5";
    
    testMoral1.definitionMoral = changeTest;
    
    [testModelManager saveContext];
    
    STAssertEquals([testingSubject readDefinition:nameMoral1], changeTest, @"Defintion couldn't be changed.");
}

- (void)testMoralDAOReadLongDescriptionAfterChange {
    NSString *changeTest = @"ld5";
    
    testMoral1.longDescriptionMoral = changeTest;
    
    [testModelManager saveContext];
    
    STAssertEquals([testingSubject readLongDescription:nameMoral1], changeTest, @"longDescription couldn't be changed.");
}

- (void)testMoralDAOReadDisplayNameAfterChange {
    NSString *changeTest = @"dn5";
    
    testMoral1.displayNameMoral = changeTest;
    
    [testModelManager saveContext];
    
    STAssertEquals([testingSubject readDisplayName:nameMoral1], changeTest, @"displayName couldn't be changed.");
}

- (void)testMoralDAOReadImageNameAfterChange {
    NSString *changeTest = @"in5";
    
    testMoral1.imageNameMoral = changeTest;
    
    [testModelManager saveContext];
    
    STAssertEquals([testingSubject readImageName:nameMoral1], changeTest, @"imageName couldn't be changed.");
}


- (void)testMoralDAOReadAllDetails {
    NSString *longDescription2 = @"ld2";
    NSString *longDescription3 = @"ld3";
    NSString *longDescription4 = @"ld4";
    
    testMoral2.longDescriptionMoral = longDescription2;
    testMoral3.longDescriptionMoral = longDescription3;    
    
    [testModelManager saveContext];
    
    NSArray *details = [testingSubject readAllDetails];

    STAssertTrue([details containsObject:longDescription], @"1st longDescription couldn't be read.");
    STAssertTrue([details containsObject:longDescription2], @"2nd longDescription couldn't be read.");
    STAssertTrue([details containsObject:longDescription3], @"3rd longDescription couldn't be read.");
    STAssertFalse([details containsObject:longDescription4], @"1st longDescription rejection correct.");

}

- (void)testMoralDAOReadAllNames {
    NSString *name4 = @"def4";
            
    NSArray *names = [testingSubject readAllNames];
    
    STAssertTrue([names containsObject:nameMoral1], @"1st name couldn't be read.");
    STAssertTrue([names containsObject:nameMoral2], @"2nd name couldn't be read.");
    STAssertTrue([names containsObject:nameMoral3], @"3rd name couldn't be read.");
    STAssertFalse([names containsObject:name4], @"1st name rejection correct.");
}

- (void)testMoralDAOReadAllDisplayNames {
    NSString *displayName2 = @"dn2";
    NSString *displayName3 = @"dn3";
    NSString *displayName4 = @"dn4";
    
    testMoral2.displayNameMoral = displayName2;
    testMoral3.displayNameMoral = displayName3;    
    
    [testModelManager saveContext];
    
    NSArray *displayNames = [testingSubject readAllDisplayNames];
    
    STAssertTrue([displayNames containsObject:displayName], @"1st displayName couldn't be read.");
    STAssertTrue([displayNames containsObject:displayName2], @"2nd displayName couldn't be read.");
    STAssertTrue([displayNames containsObject:displayName3], @"3rd displayName couldn't be read.");
    STAssertFalse([displayNames containsObject:displayName4], @"1st displayName rejection correct.");
}

- (void)testMoralDAOReadAllImageNames {
    NSString *imageName2 = @"in2";
    NSString *imageName3 = @"in3";
    NSString *imageName4 = @"in4";
    
    testMoral2.imageNameMoral = imageName2;
    testMoral3.imageNameMoral = imageName3;    
    
    [testModelManager saveContext];
    
    NSArray *displayNames = [testingSubject readAllImageNames];
    
    STAssertTrue([displayNames containsObject:imageName], @"1st imageName couldn't be read.");
    STAssertTrue([displayNames containsObject:imageName2], @"2nd imageName couldn't be read.");
    STAssertTrue([displayNames containsObject:imageName3], @"3rd imageName couldn't be read.");
    STAssertFalse([displayNames containsObject:imageName4], @"1st imageName rejection correct.");
}

- (void)testMoralDAOViceTypeCanBeCreatedWithNoPersistedMorals {
        
    ModelManager *testEmptyModelManager = [[ModelManager alloc] initWithInMemoryStore:YES];
    
    MoralDAO *testingEmptySubject = [[MoralDAO alloc] initWithType:moralTypeAll andModelManager:testEmptyModelManager];
    
    STAssertNotNil(testingEmptySubject, @"MoralDAO Empty can't be created.");
    
    NSArray *allNames = [testingEmptySubject readAllNames];
    int count = [allNames count];
    STAssertEquals(count, 0, @"MoralDAO Empty is not empty.");
    [testingEmptySubject release];
    
}

@end