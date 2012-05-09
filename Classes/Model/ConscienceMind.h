/**
Conscience's frame of mind Collection.  Object to be populated state of emotion for Conscience.
Data derived from User's actions.  Member of ConscienceView.
 
@class ConscienceMind
@see ConscienceView
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/20/2010
@file
 */

@interface ConscienceMind : NSObject

@property (nonatomic, retain) NSMutableDictionary *enthusiasmMemories;	/**< past enthusiasm states and timestamps */
@property (nonatomic, retain) NSMutableDictionary *moodMemories;		/**< past mood states and timestamps */
@property (nonatomic, assign) CGFloat enthusiasm;	/**< current Conscience enthusiasm */
@property (nonatomic, assign) CGFloat mood;		/**< current Conscience mood */

/**
Determine prior state of mind for mood
@return CGFloat Conscience's current Mood
*/
- (CGFloat) priorMood;

/**
Determine prior state of mind for enthusiasm
@return CGFloat Conscience's current Enthusiasm
*/
- (CGFloat) priorEnthusiasm;

@end