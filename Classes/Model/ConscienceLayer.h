/**
Facial Features Layer.  Object to be populated with the Conscience Paths.  May contain >1 paths.
Layer represents an entire feature (lips, eyelid, etc.)  Possesses one or more paths.
Member of ConscienceObjectView.

@class ConscienceLayer
@see ConscienceObjectView
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/20/2010
@file
 */

@interface ConscienceLayer : NSObject <NSCoding> {

}

@property (nonatomic, retain) NSMutableArray *consciencePaths;	/**< array of ConsciencePath defining structure */
@property (nonatomic, retain) NSString *layerID;                /**< id from SVG */
@property (nonatomic, retain) NSString *currentFillColor;		/**< hex representation of fill color */
@property (nonatomic, retain) NSString *currentStrokeColor;		/**< hex representation of stroke color */
@property (nonatomic, assign) CGFloat offsetX; 		/**< X position facial feature within ConscienceBubble */
@property (nonatomic, assign) CGFloat offsetY;		/**< Y position facial feature within ConscienceBubble */

@end