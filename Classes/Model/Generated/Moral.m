//
//  Moral.m
//  MoraLife
//
//  Created by aaxe on 5/14/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import "Moral.h"
#import "Dilemma.h"
#import "ReferenceAsset.h"


@implementation Moral
@dynamic imageNameMoral;
@dynamic colorMoral;
@dynamic displayNameMoral;
@dynamic longDescriptionMoral;
@dynamic component;
@dynamic shortDescriptionMoral;
@dynamic linkMoral;
@dynamic nameMoral;
@dynamic definitionMoral;
@dynamic dillemmaB;
@dynamic dillemmaA;
@dynamic relatedReference;

- (void)addDillemmaBObject:(Dilemma *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"dillemmaB" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"dillemmaB"] addObject:value];
    [self didChangeValueForKey:@"dillemmaB" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeDillemmaBObject:(Dilemma *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"dillemmaB" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"dillemmaB"] removeObject:value];
    [self didChangeValueForKey:@"dillemmaB" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addDillemmaB:(NSSet *)value {    
    [self willChangeValueForKey:@"dillemmaB" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"dillemmaB"] unionSet:value];
    [self didChangeValueForKey:@"dillemmaB" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeDillemmaB:(NSSet *)value {
    [self willChangeValueForKey:@"dillemmaB" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"dillemmaB"] minusSet:value];
    [self didChangeValueForKey:@"dillemmaB" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addDillemmaAObject:(Dilemma *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"dillemmaA" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"dillemmaA"] addObject:value];
    [self didChangeValueForKey:@"dillemmaA" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeDillemmaAObject:(Dilemma *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"dillemmaA" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"dillemmaA"] removeObject:value];
    [self didChangeValueForKey:@"dillemmaA" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addDillemmaA:(NSSet *)value {    
    [self willChangeValueForKey:@"dillemmaA" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"dillemmaA"] unionSet:value];
    [self didChangeValueForKey:@"dillemmaA" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeDillemmaA:(NSSet *)value {
    [self willChangeValueForKey:@"dillemmaA" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"dillemmaA"] minusSet:value];
    [self didChangeValueForKey:@"dillemmaA" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addRelatedReferenceObject:(ReferenceAsset *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"relatedReference" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"relatedReference"] addObject:value];
    [self didChangeValueForKey:@"relatedReference" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeRelatedReferenceObject:(ReferenceAsset *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"relatedReference" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"relatedReference"] removeObject:value];
    [self didChangeValueForKey:@"relatedReference" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addRelatedReference:(NSSet *)value {    
    [self willChangeValueForKey:@"relatedReference" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"relatedReference"] unionSet:value];
    [self didChangeValueForKey:@"relatedReference" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeRelatedReference:(NSSet *)value {
    [self willChangeValueForKey:@"relatedReference" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"relatedReference"] minusSet:value];
    [self didChangeValueForKey:@"relatedReference" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
