/** Conscience Accessories Collection.  Object that designates currently adorned Accessories.
 Member of ConscienceView.
 
@class ConscienceAccessories
@see ConscienceView

@author Copyright 2010 Team Axe, LLC. All rights reserved. http://www.teamaxe.org
@date 07/20/2010
@file
*/

extern NSString* const kPrimaryAccessoryFileNameResource;
extern NSString* const kSecondaryAccessoryFileNameResource;
extern NSString* const kTopAccessoryFileNameResource;
extern NSString* const kBottomAccessoryFileNameResource;

@interface ConscienceAccessories : NSObject 

@property (nonatomic, strong) NSString *primaryAccessory;		/**< Conscience left-hand image filename */
@property (nonatomic, strong) NSString *secondaryAccessory;		/**< Conscience right-hand image filename */
@property (nonatomic, strong) NSString *topAccessory;			/**< Conscience top image filename */
@property (nonatomic, strong) NSString *bottomAccessory;		/**< Conscience bottom image filename */

@end