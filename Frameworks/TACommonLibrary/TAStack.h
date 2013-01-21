/**
 Basic stack structure.  Can accept single items, Arrays, Dictionaries and OrderedSets.  Supports push, pop, peek, isEmpty, size and clear.

 @class TAStack

 @author Copyright 2013 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
 @date 01/17/2013
 @file
 */

@interface TAStack : NSObject <NSCopying>

@property (nonatomic, assign) BOOL isEmpty;

/**
 Remove all items from the stack.
 */
- (void) clear;

/**
 Return the top of the stack without popping it.  Returns nil if empty.

 @return id returned item
 */
- (id) peek;

/**
 Return the top of the stack and removes it from the stack.  Returns nil if empty.

 @return id returned item
 */
- (id) pop;

/**
 Pushes an item onto the stack.

 @param id item to be pushed onto stack
 */
- (void) push:(id) item;

/**
 Pushes all items from an NSArray onto the stack from 1st element to last.  Allows you to reverse your array.
 @param NSArray collection to be pushed onto stack
 */
- (void) pushItemsFromArray:(NSArray *) items;

/**
 Pushes all items from an NSDictionary onto the stack from 1st element to last alphabetically by key.  Allows you to reverse your NSDictionary.
 @param NSArray collection to be pushed onto stack
 */
- (void) pushItemsFromDictionary:(NSDictionary *) items;

/**
 Pushes all items from an NSOrderedSet onto the stack.  Allows you to reverse your NSOrderedSet.
 @param NSOrderedSet collection to be pushed onto stack
 */
- (void) pushItemsFromOrderedSet:(NSOrderedSet *) items;

/**
 Pushes all items from a stack onto the stack.  Original stack remains untouched.
 @param TAStack collection to be pushed onto stack
 */
- (void) pushItemsFromStack:(TAStack *) items;

/**
The current size of the stack.  Returns 0 if empty.

 @return NSUInteger unsigned integer representing size
 */
- (NSUInteger) size;

@end
