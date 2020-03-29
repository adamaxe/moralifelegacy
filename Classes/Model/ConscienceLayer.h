/**
Facial Features Layer.  Object to be populated with the Conscience Paths.  May contain >1 paths.
Layer represents an entire feature (lips, eyelid, etc.)  Possesses one or more paths.
Member of ConscienceObjectView.

@class ConscienceLayer
@see ConscienceObjectView
 
@author Copyright 2020 Adam Axe. All rights reserved. http://www.adamaxe.com
@date 07/20/2010
@file
 */

extern float const MLFeatureOffsetX;
extern float const MLFeatureOffsetY;

@interface ConscienceLayer : NSObject <NSCoding> 

@property (nonatomic, strong) NSMutableArray *consciencePaths;	/**< array of ConsciencePath defining structure */
@property (nonatomic, strong) NSString *layerID;                /**< id from SVG */
@property (nonatomic, strong) NSString *currentFillColor;		/**< hex representation of fill color */
@property (nonatomic, strong) NSString *currentStrokeColor;		/**< hex representation of stroke color */
@property (nonatomic, assign) CGFloat offsetX; 		/**< X position facial feature within ConscienceBubble */
@property (nonatomic, assign) CGFloat offsetY;		/**< Y position facial feature within ConscienceBubble */

@end
