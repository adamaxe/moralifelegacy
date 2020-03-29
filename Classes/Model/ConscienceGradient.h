/**
Facial Features Gradient Data.  Object to be populated with the gradient data from XML.
 Member of ConscienceObjectView as NSMutableDictionary element.

@class ConscienceGradient
@see ConscienceObjectView

@author Copyright 2020 Adam Axe. All rights reserved. http://www.adamaxe.com
@date 07/20/2010
@file
 */

@interface ConscienceGradient : NSObject 

@property (nonatomic, strong) NSString *gradientID;         /**< id from SVG */
@property (nonatomic, assign) int locationsCount;           /**< unimplemented */
@property (nonatomic, assign) int componentsCount;          /**< unimplemented */
@property (nonatomic, assign) int pointsCount;              /**< unimplemented */
@property (nonatomic, strong) NSMutableArray *gradientPoints;	/**< array of CGPoints */

@end
