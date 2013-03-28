/**
Implementation:  UIViewController Superclass that possesses ModelManager and UserConscience.
 
@class MoraLifeViewController MoraLifeViewController.h
*/

#import "MoraLifeViewController.h"

@implementation MoraLifeViewController

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience {

    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _modelManager = modelManager;
        _userConscience = userConscience;
        _conscienceHelpViewController = [[ConscienceHelpViewController alloc] initWithConscience:_userConscience];
        _conscienceHelpViewController.viewControllerClassName = NSStringFromClass([self class]);
        NSLog(@"consciencehelpclass:%@", _conscienceHelpViewController.viewControllerClassName);

	}
    
	return self;

}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
-(id)initWithModelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience {
    return [self initWithNibName:nil bundle:nil modelManager:modelManager andConscience:userConscience];
}

-(void)localizeUI {
    
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end