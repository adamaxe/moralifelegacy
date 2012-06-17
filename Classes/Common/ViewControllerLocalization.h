/**
 UIViewController Localization Protocol.  Used for localizing UI for Accessibility and Integration Testing.
 
 Copyright 2010 Team Axe, LLC. All rights reserved.
 
 @class ViewControllerLocalization.h
 @author Team Axe, LLC. http://www.teamaxe.org
 @date 06/18/2012
 */

@protocol ViewControllerLocalization <NSObject>

/**
 Should provide AccessibiltyHints and Accessibility Labels for all UI
 */
- (void) localizeUI;

@end
