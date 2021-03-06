/**
Implementation: Conscience Mind Collection.  Object to be populated state of emotion for Conscience.
Data derived from User's actions
 
@todo VERSION 2.0 implement CD interaction in setter/getter, see ConscienceAction, ChoiceView and Dilemma
@class ConscienceMind ConscienceMind.h
 */

#import "ConscienceMind.h"

float const MLConscienceEnthusiasmDefault = 50.0;
float const MLConscienceMoodDefault = 55.0;

@implementation ConscienceMind

- (id)init
{
    self = [super init];
    if (self) {
        //In case of first time run, or User does not supply configuration, default gradient        
        [self setEnthusiasm:MLConscienceEnthusiasmDefault];
        [self setMood:MLConscienceMoodDefault];
		_enthusiasmMemories = [[NSMutableDictionary alloc] init];
		_moodMemories = [[NSMutableDictionary alloc] init];
    }

    return self;
}

/**
Implemenation:  Determine prior state of mind for mood.  Retrieve top of Dictionary
@todo VERSION 2.0 implement
 */
- (CGFloat) priorMood{
	/*
	NSArray *myKeys = [myDictionary allKeys];
	NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];

	//get object for first (sorted) key:
	id firstObject = [moodMemories objectForKey: [sortedKeys objectAtIndex:0]];

	//get object for last (sorted) key:
	id lastObject = [enthusiasmMemories objectForKey: [sortedKeys lastObject];

	[return [(NSNumber*)lastObject floatValue]];
	*/
	
	return 0;

}

/**
Implemenation:  Determine prior state of mind for enthusiasm.  Retrieve top of Dictionary
@todo VERSION 2.0 implement
 */
- (CGFloat) priorEnthusiasm{
	/*
	NSArray *myKeys = [myDictionary allKeys];
	NSArray *sortedKeys = [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];

	//get object for first (sorted) key:
	id firstObject = [enthusiasmMemoryDictionary objectForKey: [sortedKeys objectAtIndex:0]];

	//get object for last (sorted) key:
	id lastObject = [enthusiasmMemoryDictionary objectForKey: [sortedKeys lastObject]];

	[return [(NSNumber*)lastObject floatValue]];
	*/
	return 0;
}



@end