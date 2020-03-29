/**
Accessory image wrapper.  The image file of the User's or Antagonist's single accessory to be placed onto ConscienceView.

@class AccessoryObjectView
@see ConscienceView
 
@author Copyright 2020 Adam Axe. All rights reserved. http://www.adamaxe.com
@date 08/16/2010
@file
 */

extern NSString* const MLAccessoryFileNameResourceDefault;
extern int const MLSideAccessoryWidth;
extern int const MLSideAccessoryHeight;

@interface AccessoryObjectView : UIView

@property (nonatomic, strong) NSString *accessoryFilename;	/**< file name to be retrieved */

@end
