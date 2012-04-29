#import "TestCoreDataStack.h"
#import "ReferenceBelief.h"
//#import "ReferencePerson.h"
//#import "ReferenceAsset.h"

@interface TestReferenceBelief : SenTestCase {
    TestCoreDataStack *coreData;
}

@end

@implementation TestReferenceBelief


- (void)setUp {
    coreData = [[TestCoreDataStack alloc] init];
}

-(void)tearDown {
    [coreData release];
}

- (void)testBeliefCanBeCreated {
    NSString *belief = @"test belief";
    NSString *shortDescription = @"short description";
    NSNumber *originYear = [NSNumber numberWithInt:2010];
    NSString *name = @"name";
    NSString *longDescription = @"long description";
    NSString *link = @"http://www.teamaxe.org";    
    NSString *displayName = @"display name";
    NSString *imageName = @"image name";
    
    ReferenceBelief *testBelief = [coreData insert:ReferenceBelief.class];
    testBelief.typeBelief = belief;
    testBelief.shortDescriptionReference = shortDescription;
    testBelief.originYear = originYear;
    testBelief.nameReference = name;
    testBelief.longDescriptionReference = longDescription;
    testBelief.linkReference = link;
    testBelief.displayNameReference = displayName;
    testBelief.imageNameReference = imageName;
    
    [coreData save];
    
    NSArray *beliefs = [coreData fetch:ReferenceBelief.class];
    
    STAssertEquals(beliefs.count, (NSUInteger) 1, @"");
    ReferenceBelief *retrieved = [beliefs objectAtIndex: 0];
    STAssertEqualObjects(retrieved.typeBelief, belief, @"Belief Getter/Setter failed.");
    STAssertEqualObjects(retrieved.shortDescriptionReference, shortDescription, @"shortDescription Getter/Setter failed.");
    STAssertEquals(retrieved.originYear, originYear, @"originYear Getter/Setter failed.");
    STAssertEqualObjects(retrieved.nameReference, name, @"nameReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.longDescriptionReference, longDescription, @"longDescriptionReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.linkReference, link, @"linkReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.displayNameReference, displayName, @"displayNameReference Getter/Setter failed.");
    STAssertEqualObjects(retrieved.imageNameReference, imageName, @"imageNameReference Getter/Setter failed.");

    
}

- (void)testBeliefWithoutRequiredTypeBelief {
    ReferenceBelief *testBelief = [coreData insert:ReferenceBelief.class];
    [testBelief class];

    STAssertThrows([coreData save], @"CD should've thrown on ReferenceBelief");
}

//- (void)testBeliefAttributeAccessors {
//    NSString *userUri = @"http://example.com/user.json";
//    NSString *username = @"user1";
//    NSString *firstName = @"Han";
//    NSString *lastName = @"Solo";
//    NSString *boardUri = @"http://example.com/board.json";
//    NSString *boardname = @"board1";    
//    
//    RDRBoard *testBoard = [coreData insert:RDRBoard.class];
//    testBoard.uri = boardUri;
//    testBoard.name = boardname;
//    [coreData save];    
//    
//    RDRUser *testUser = [coreData insert:RDRUser.class];
//    testUser.uri = userUri;
//    testUser.username = username;
//    testUser.firstName = firstName;
//    testUser.lastName = lastName;
//    [coreData save];
//    
//    testBoard.users = [NSSet setWithObject:testUser];
//    
//    NSArray *boards = [coreData fetch:RDRBoard.class];
//    
//    RDRBoard *retrievedBoard = [boards objectAtIndex: 0];
//    RDRUser *retrievedBoardsUser = [retrievedBoard.users anyObject];
//    GHAssertEqualStrings(retrievedBoardsUser.uri, userUri, @"");
//    GHAssertEqualStrings(retrievedBoardsUser.username, username, @"");
//}

@end
