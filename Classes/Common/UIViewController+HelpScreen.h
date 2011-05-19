/**
 UIViewController HelpScreen Category.  Used for providing custom helpscreen for each screen.
 
 Copyright 2010 Team Axe, LLC. All rights reserved.
 
 @class UIViewController+HelpScreen.h
 @author Team Axe, LLC. http://www.teamaxe.org
 @date 07/20/2010
 */

@interface UIViewController (HelpScreen)

-(void) presentHelpScreen:(NSDictionary *) helpTitleTexts withConscienceOnScreen: (BOOL) isOnScreen;

@end
