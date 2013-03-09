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

extern int const MLDirectionFacingLeft;
extern int const MLDirectionFacingRight;
extern int const MLConscienceLowerLeftX;
extern int const MLConscienceLowerLeftY;
extern int const MLConscienceLowerLeftXIntro;
extern int const MLConscienceLowerLeftYIntro;
extern int const MLConscienceHomeX;
extern int const MLConscienceHomeY;
extern int const MLConscienceIntroX;
extern int const MLConscienceIntroY;
extern int const MLConscienceOffscreenBottomX;
extern int const MLConscienceOffscreenBottomY;
extern int const MLConscienceAntagonistX;
extern int const MLConscienceAntagonistY;
extern int const MLConscienceAntagonistWidth;
extern int const MLConscienceAntagonistHeight;
extern int const MLConscienceViewTag;
extern int const MLConscienceAntagonistViewTag;
extern float const MLConscienceLargeSizeX;
extern float const MLConscienceLargeSizeY;
extern float const MLConscienceLargestSize;

@interface ConscienceView : UIView

@property (nonatomic, assign) int directionFacing;                  /**< Which way the Conscience is currently facing */
@property (nonatomic, assign) BOOL isExpressionForced;				/**< allow for forcing of an expression */
@property (nonatomic, strong) UIView *conscienceBubbleView;			/**< UIView that contains all other Views */
@property (nonatomic, strong) ConscienceBody *currentConscienceBody;			/**< Current Conscience visual configuration */
@property (nonatomic, strong) ConscienceAccessories *currentConscienceAccessories;	/**< Current Conscience visual possessions */
@property (nonatomic, strong) ConscienceMind *currentConscienceMind;			/**< Current Conscience mood/enthusiasm */

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
