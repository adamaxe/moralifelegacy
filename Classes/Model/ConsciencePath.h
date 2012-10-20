/**
Facial Features Path Data.  Object to be populated with the path data from XML.  
Path from XML represents an image portion of a feature (iris, teeth, etc.)  Possesses points, drawing instructions, style and possible gradientID.  Member of ConscienceLayer as a NSMutableArray.
 
@class ConsciencePath
@see ConscienceLayer
 
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/20/2010
@file
 */

extern NSString* const MLPathColorDefault;
extern float const MLDefault0Float;

@interface ConsciencePath : NSObject <NSCoding> 

@property (nonatomic, strong) NSMutableArray *pathInstructions;     /**< array of integer instructions */
@property (nonatomic, strong) NSMutableArray *pathPoints;           /**< array of CGFloat points */
@property (nonatomic, strong) NSString *pathFillColor;              /**< path fill color */
@property (nonatomic, strong) NSString *pathStrokeColor;            /**< path stroke color */
@property (nonatomic, strong) NSString *pathID;                     /**< id of path from svg */
@property (nonatomic, strong) NSString *pathGradient;               /**< gradient of path (optional) */
@property (nonatomic, assign) CGFloat pathStrokeWidth;	/**< width of stroke */
@property (nonatomic, assign) CGFloat pathFillOpacity;	/**< opacity of fill */
@property (nonatomic, assign) CGFloat pathStrokeOpacity;	/**< opacity of stroke */
@property (nonatomic, assign) CGFloat pathStrokeMiterLimit;	/**< stroke miter limit */

/**
Creates arrays of drawing instructions and coordinates.
Source data is direct from xml parsing.
@param pathData NSString in format of single string of instructions/coordinates
@param styleData NSString in format of single string of stroke/fill information
*/
- (void) convertToConsciencePath:(NSString *) pathData WithStyle:(NSString *) styleData;

@end