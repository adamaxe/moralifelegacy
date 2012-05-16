/**
Conscience character.  Combination of ConscienceAccessories, ConscienceBody and ConscienceMind

@class ConscienceView ConscienceView.h
@see ConscienceBody
@see ConscienceAccessories
@see ConscienceMind

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 06/23/2010
@file
 */

@class ConscienceBody, ConscienceAccessories, ConscienceMind, CAKeyframeAnimation;

@interface ConscienceView : UIView

@property (nonatomic, assign) int directionFacing;                  /**< Which way the Conscience is currently facing */
@property (nonatomic, assign) BOOL isExpressionForced;				/**< allow for forcing of an expression */
@property (nonatomic, retain) UIView *conscienceBubbleView;			/**< UIView that contains all other Views */
@property (nonatomic, retain) ConscienceBody *currentConscienceBody;			/**< Current Conscience visual configuration */
@property (nonatomic, retain) ConscienceAccessories *currentConscienceAccessories;	/**< Current Conscience visual possessions */
@property (nonatomic, retain) ConscienceMind *currentConscienceMind;			/**< Current Conscience mood/enthusiasm */

/**
Change eye state to imitate winking/blinking
Values are open and closed
@param frame CGRect encompassing entire Conscience
@param argBody ConscienceBody object to display
@param argAccessories ConscienceAccessories currently outfitted
@param argMind ConscienceMind containing Conscience's current state of mind
@return id Self
 */
- (id)initWithFrame:(CGRect)frame withBody:(ConscienceBody *) argBody withAccessories:(ConscienceAccessories *) argAccessories
           withMind:(ConscienceMind *) argMind;
/**
Change eye state to imitate winking/blinking
Values are open and closed
@param eyeState int whether eye is open or closed
@param eyeNumber int eye designation to affect (left, right, both, random)
 */
- (void) changeEyeState:(int) eyeState forEye:(int) eyeNumber;

/**
Change direction Conscience is looking by moving iris
Values are center, down, up, left, right, cross, crazy
@param expressionIndex int direction eye can look
@param eyeNumber int eye designation to affect (left, right, both, random)
@see expressionLookEnum
 */
- (void) changeEyeDirection:(int)expressionIndex forEye:(int) eyeNumber;

/**
Change brow expression 
Values are angry, confused, excited, normal
@param expression NSString layerName of brow ConscienceLayer to be selected
@param eyeNumber int eye designation to affect (left, right, both, random)
 */
- (void) changeBrowExpressions:(NSString *) expression forEye:(int) eyeNumber;

/**
Change lid expression 
Values are angry, normal, sleepy, under
@param expression NSString layerName of lid ConscienceLayer to be selected
@param eyeNumber int eye designation to affect (left, right, both, random)
 */
- (void) changeLidExpressions:(NSString *) expression forEye:(int) eyeNumber;

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
Determine which emotion to ask for mouth change
 */
- (void) timedMouthExpressionChanges;

/**
Make Conscience reappear
 */
- (void)removeConscienceInvisibility;

/**
Determine which direction/emotion to ask for eye change
 */
- (void) timedEyeChanges;

/**
Begin timers for eyes/mouth changes
 */
- (void) setTimers;

/**
Stop timers for eyes/mouth changes
 */
- (void) stopTimers;
	
/**
Make Conscience reappear
 */
- (void)makeConscienceVisible;

/**
Make Conscience reappear
@return CAKeyFrameAnimation animation to implement for shaken
 */
-(CAKeyframeAnimation *) shakeAnimation;

@end
