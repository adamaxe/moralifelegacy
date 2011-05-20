/**
Facial Features Gradient Data.  Object to be populated with the gradient data from XML.
 Member of ConscienceObjectView as NSMutableDictionary element.

@class ConscienceGradient
@see ConscienceObjectView

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/20/2010
@file
 */

@interface ConscienceGradient : NSObject {

}

@property (nonatomic, retain) NSString *gradientID;         /**< id from SVG */
@property (nonatomic, assign) int locationsCount;           /**< unimplemented */
@property (nonatomic, assign) int componentsCount;          /**< unimplemented */
@property (nonatomic, assign) int pointsCount;              /**< unimplemented */
@property (nonatomic, retain) NSMutableArray *gradientPoints;	/**< array of CGPoints */

@end