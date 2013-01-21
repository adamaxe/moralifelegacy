/**
 Basic queue structure.  Can accept single items, Arrays, Dictionaries and OrderedSets.  Supports enqueue, dequeue, peek, isEmpty, size and clear.

 @class TAQueue

 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 01/17/2013
 @file
 */

@interface TAQueue : NSObject <NSCopying>

@property (nonatomic, assign) BOOL isEmpty;

/**
 Remove all items from the queue.
 */
- (void) clear;

/**
 Return the top of the queue without dequeueing it.  Returns nil if empty.

 @return id returned item
 */
- (id) peek;

/**
 Return the top of the queue and removes it from the queue.  Returns nil if empty.

 @return id returned item
 */
- (id) dequeue;

/**
 Enqueues an item onto the queue.

 @param id item to be enqueued
 */
- (void) enqueue:(id) item;

/**
 Enqueuees all items from an NSArray onto the queue from 1st element to last.
 @param NSArray collection to be enqueued
 */
- (void) enqueueItemsFromArray:(NSArray *) items;

/**
 Enqueues all items from an NSDictionary onto the queue from 1st element to last alphabetically by key.
 @param NSArray collection to be enqueued
 */
- (void) enqueueItemsFromDictionary:(NSDictionary *) items;

/**
 Enqueues all items from an NSOrderedSet onto the queue.
 @param NSOrderedSet collection to be enqueued
 */
- (void) enqueueItemsFromOrderedSet:(NSOrderedSet *) items;

/**
 Enqueues all items from a queue.  Original queue remains untouched.
 @param TAQueue collection to be enqueued
 */
- (void) enqueueItemsFromQueue:(TAQueue *) items;

/**
The current size of the queue.  Returns 0 if empty.

 @return NSUInteger unsigned integer representing size
 */
- (NSUInteger) size;

@end
