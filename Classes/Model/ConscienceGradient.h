/**
Facial Features Gradient Data.  Object to be populated with the gradient data from XML.  

@class ConscienceGradient
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/20/2010
@file
 */

@interface ConscienceGradient : NSObject {

}

@property (nonatomic, retain) NSString *gradientID;	/**< id from SVG */
@property (nonatomic, assign) int locationsCount;	
@property (nonatomic, assign) int componentsCount;	
@property (nonatomic, assign) int pointsCount;		
@property (nonatomic, retain) NSMutableArray *gradientPoints;	/**< array of CGPoints */

@end