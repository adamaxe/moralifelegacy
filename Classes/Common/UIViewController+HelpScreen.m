/**
 UIViewController HelpScreen Category.  Used for providing custom helpscreen for each screen.
 
 Copyright 2010 Team Axe, LLC. All rights reserved.
 
 @class UIViewController+HelpScreen UIViewController+HelpScreen.h
 @author Team Axe, LLC. http://www.teamaxe.org
 @date 07/20/2010
 */

#import "UIViewController+HelpScreen.h"
#import "ConscienceHelpViewController.h"

@implementation UIViewController (HelpScreen)

-(void) presentHelpScreen:(NSDictionary *) helpTitleTexts withConscienceOnScreen: (BOOL) isOnScreen{
    
    ConscienceHelpViewController *conscienceHelpViewCont = [[ConscienceHelpViewController alloc] initWithNibName:@"ConscienceHelpView" bundle:[NSBundle mainBundle]];

    NSArray *titles = [helpTitleTexts allKeys];
    NSArray *texts = [helpTitleTexts allValues];
    
    [conscienceHelpViewCont setHelpTitles:titles];
    [conscienceHelpViewCont setHelpTexts:texts];
    [conscienceHelpViewCont setIsConscienceOnScreen:isOnScreen];
    
    [self presentModalViewController:conscienceHelpViewCont animated:NO];
    [conscienceHelpViewCont release];
    
}

@end
