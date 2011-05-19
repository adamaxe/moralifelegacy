/**
Conscience Accessories Collection.  Object that designates currently adorned Accessories.
 
@class ConscienceAccessories
@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/20/2010
@file
*/

@interface ConscienceAccessories : NSObject {
	
}

@property (nonatomic, retain) NSString *primaryAccessory;		/**< Conscience left-hand image filename */
@property (nonatomic, retain) NSString *secondaryAccessory;		/**< Conscience right-hand image filename */
@property (nonatomic, retain) NSString *topAccessory;			/**< Conscience top image filename */
@property (nonatomic, retain) NSString *bottomAccessory;		/**< Conscience bottom image filename */

@end