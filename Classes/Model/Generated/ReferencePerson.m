//
//  ReferencePerson.m
//  Moralife
//
//  Created by aaxe on 2/23/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import "ReferencePerson.h"
#import "ReferenceBelief.h"
#import "ReferenceText.h"


@implementation ReferencePerson
@dynamic deathYearPerson;
@dynamic quotePerson;
@dynamic oeuvre;
@dynamic belief;

- (void)addOeuvreObject:(ReferenceText *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"oeuvre" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"oeuvre"] addObject:value];
    [self didChangeValueForKey:@"oeuvre" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
}

- (void)removeOeuvreObject:(ReferenceText *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"oeuvre" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"oeuvre"] removeObject:value];
    [self didChangeValueForKey:@"oeuvre" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
}

- (void)addOeuvre:(NSSet *)value {    
    [self willChangeValueForKey:@"oeuvre" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"oeuvre"] unionSet:value];
    [self didChangeValueForKey:@"oeuvre" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeOeuvre:(NSSet *)value {
    [self willChangeValueForKey:@"oeuvre" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"oeuvre"] minusSet:value];
    [self didChangeValueForKey:@"oeuvre" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addBeliefObject:(ReferenceBelief *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"belief" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"belief"] addObject:value];
    [self didChangeValueForKey:@"belief" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
}

- (void)removeBeliefObject:(ReferenceBelief *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"belief" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"belief"] removeObject:value];
    [self didChangeValueForKey:@"belief" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
}

- (void)addBelief:(NSSet *)value {    
    [self willChangeValueForKey:@"belief" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"belief"] unionSet:value];
    [self didChangeValueForKey:@"belief" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeBelief:(NSSet *)value {
    [self willChangeValueForKey:@"belief" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"belief"] minusSet:value];
    [self didChangeValueForKey:@"belief" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
