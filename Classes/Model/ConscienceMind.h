/**
Conscience's frame of mind Collection.  Object to be populated state of emotion for Conscience.
Data derived from User's actions.  Member of ConscienceView.
 
@class ConscienceMind
@see ConscienceView
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/20/2010
@file
 */

extern float const MLConscienceEnthusiasmDefault;
extern float const MLConscienceMoodDefault;

typedef enum {
    MLEyePlacementLeft,
    MLEyePlacementRight,
    MLEyePlacementBoth,
    MLEyePlacementRandom

} MLEyePlacement;

typedef enum {
    MLEyeStateClose,
    MLEyeStateOpen

} MLEyeState;

typedef enum {
	MLExpressionLookCenter,
	MLExpressionLookDown,
	MLExpressionLookUp,
	MLExpressionLookLeft,
	MLExpressionLookRight,
	MLExpressionLookCross,
	MLExpressionLookCrazy
} MLExpressionLook;

@protocol ConscienceExpressionDelegate

/**
 Change dimples expression
 Values are happy, normal, sad
 @param expression NSString layerName of dimple ConscienceLayer to be selected
 */
- (void) changeDimplesExpressions:(NSString *) expression;

/**
 Change lips expression
 @param expression NSString layerName of lips ConscienceLayer to be selected
 */
- (void) changeLipsExpressions:(NSString *) expression;

/**
 Change teeth expression
 @param expression NSString layerName of teeth ConscienceLayer to be selected
 */
- (void) changeTeethExpressions:(NSString *) expression;

/**
 Change tongue expression
 @param expression NSString layerName of tongue ConscienceLayer to be selected
 */
- (void) changeTongueExpressions:(NSString *) expression;

/**
 Changes color and speed of the bubble surrounding the Conscience
 */
- (void) changeBubble;

/**
 Changes direction that Conscience is looking
 */
- (void) changeEyeDirection;

/**
 Change eye state to imitate winking/blinking
 Values are open and closed
 @param eyeState int whether eye is open or closed
 @param eyeNumber int eye designation to affect (left, right, both, random)
 */
- (void) changeEyeState:(MLEyeState) eyeState forEye:(MLEyePlacement) eyeNumber;

/**
 Change direction Conscience is looking by moving iris
 Values are center, down, up, left, right, cross, crazy
 @param expressionIndex int direction eye can look
 @param eyeNumber int eye designation to affect (left, right, both, random)
 @see expressionLookEnum
 */
- (void) changeEyeDirection:(MLExpressionLook)expressionIndex forEye:(MLEyePlacement) eyeNumber;

/**
 Change brow expression
 Values are angry, confused, excited, normal
 @param expression NSString layerName of brow ConscienceLayer to be selected
 @param eyeNumber int eye designation to affect (left, right, both, random)
 */
- (void) changeBrowExpressions:(NSString *) expression forEye:(MLEyePlacement) eyeNumber;

/**
 Change lid expression
 Values are angry, normal, sleepy, under
 @param expression NSString layerName of lid ConscienceLayer to be selected
 @param eyeNumber int eye designation to affect (left, right, both, random)
 */
- (void) changeLidExpressions:(NSString *) expression forEye:(MLEyePlacement) eyeNumber;

@end

@interface ConscienceMind : NSObject

@property (nonatomic, assign) BOOL isExpressionForced;				/**< allow for forcing of an expression */
@property (nonatomic, assign) id<ConscienceExpressionDelegate> delegate;  /**< destination for Conscience emoting */
@property (nonatomic, strong) NSMutableDictionary *enthusiasmMemories;	/**< past enthusiasm states and timestamps */
@property (nonatomic, strong) NSMutableDictionary *moodMemories;		/**< past mood states and timestamps */
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

/**
 Determine which emotion to ask for mouth change
 */
- (void) timedMouthExpressionChanges;

/**
 Determine which direction/emotion to ask for eye change
 */
- (void) timedEyeChanges;

/**
Force eyes to open
 */
-(void)reopenEyes;

/**
 Begin timers for eyes/mouth changes
 */
- (void) setTimers;

/**
 Stop timers for eyes/mouth changes
 */
- (void) stopTimers;

@end