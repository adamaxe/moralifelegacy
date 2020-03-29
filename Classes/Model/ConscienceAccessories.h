/** Conscience Accessories Collection.  Object that designates currently adorned Accessories.
 Member of ConscienceView.
 
@class ConscienceAccessories
@see ConscienceView

@author Copyright 2020 Adam Axe. All rights reserved. http://www.adamaxe.com
@date 07/20/2010
@file
*/

extern NSString* const MLPrimaryAccessoryFileNameResourceDefault;
extern NSString* const MLSecondaryAccessoryFileNameResourceDefault;
extern NSString* const MLTopAccessoryFileNameResourceDefault;
extern NSString* const MLBottomAccessoryFileNameResourceDefault;

@interface ConscienceAccessories : NSObject 

@property (nonatomic, strong) NSString *primaryAccessory;		/**< Conscience left-hand image filename */
@property (nonatomic, strong) NSString *secondaryAccessory;		/**< Conscience right-hand image filename */
@property (nonatomic, strong) NSString *topAccessory;			/**< Conscience top image filename */
@property (nonatomic, strong) NSString *bottomAccessory;		/**< Conscience bottom image filename */

@end
