//
//  Character.m
//  MoraLife
//
//  Created by aaxe on 5/15/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import "Character.h"
#import "Dilemma.h"


@implementation Character
@dynamic sizeCharacter;
@dynamic faceCharacter;
@dynamic eyeColor;
@dynamic accessoryBottomCharacter;
@dynamic eyeCharacter;
@dynamic browColor;
@dynamic mouthCharacter;
@dynamic ageCharacter;
@dynamic accessoryTopCharacter;
@dynamic accessoryPrimaryCharacter;
@dynamic accessorySecondaryCharacter;
@dynamic nameCharacter;
@dynamic bubbleColor;
@dynamic bubbleType;
@dynamic story;

- (void)addStoryObject:(Dilemma *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"story" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"story"] addObject:value];
    [self didChangeValueForKey:@"story" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeStoryObject:(Dilemma *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"story" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"story"] removeObject:value];
    [self didChangeValueForKey:@"story" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addStory:(NSSet *)value {    
    [self willChangeValueForKey:@"story" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"story"] unionSet:value];
    [self didChangeValueForKey:@"story" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeStory:(NSSet *)value {
    [self willChangeValueForKey:@"story" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"story"] minusSet:value];
    [self didChangeValueForKey:@"story" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
