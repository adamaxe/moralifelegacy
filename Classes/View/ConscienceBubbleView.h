/**
Conscience Bubble visualization.  The appearance and animation of the User's or Antagonist's bubble.

@class ConscienceBubbleView
@see ConscienceView
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 08/30/2010
@file
 */

extern NSString* const kBubbleColor;
extern int const kBubbleType;
extern float const kBubbleDuration;
extern float const kBubbleWidth;

@interface ConscienceBubbleView : UIView 

@property (nonatomic, assign) int bubbleType;		/**< type of bubble */
@property (nonatomic, assign) CGFloat bubbleGlowWidth;	/**< width of black bubble outline */
@property (nonatomic, assign) CGFloat bubbleGlowDuration;	/**< pulse speed of bubble */
@property (nonatomic, strong) NSString *bubbleColor;		/**< color of bubble */

@end
