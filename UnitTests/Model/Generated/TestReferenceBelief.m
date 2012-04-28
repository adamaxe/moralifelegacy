#import "TestCoreDataStack.h"
#import "ReferenceBelief.h"
#import "ReferencePerson.h"
#import "ReferenceAsset.h"

@interface TestReferenceBelief : SenTestCase {
    __strong TestCoreDataStack *coreData;
}

@end

@implementation TestReferenceBelief


- (void)setUp {
    coreData = [[TestCoreDataStack alloc] init];
}

- (void)testBeliefCanBeCreated {
    NSString *belief = @"test belief";

    ReferenceBelief *testBelief = [coreData insert:ReferenceBelief.class];
    testBelief.typeBelief = belief;
    [coreData save];
    
    NSArray *beliefs = [coreData fetch:ReferenceBelief.class];
    
    STAssertEquals(beliefs.count, (NSUInteger) 1, @"");
    ReferenceBelief *retrieved = [beliefs objectAtIndex: 0];
    STAssertEqualObjects(retrieved.typeBelief, testBelief, @"Belief Getter/Setter failed.");
}

- (void)testBeliefWithoutRequiredTypeBelief {
    ReferenceBelief *testBelief = [coreData insert:ReferenceBelief.class];
    
//    STAssertThrows([coreData save], @"CoreData should have thrown, but didn't.");
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
