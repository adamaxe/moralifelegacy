/**
Implementation:  UIViewController Superclass that possesses ModelManager and UserConscience.
 
@class MoraLifeViewController MoraLifeViewController.h
*/

#import "MoraLifeViewController.h"

@interface MoraLifeViewController () {
    @private
    NSArray *protectedInstanceVariables;
}

@end

@implementation MoraLifeViewController

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience {

    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _modelManager = modelManager;
        _userConscience = userConscience;
        _conscienceHelpViewController = [[ConscienceHelpViewController alloc] initWithConscience:_userConscience];
        _conscienceHelpViewController.viewControllerClassName = NSStringFromClass([self class]);

        protectedInstanceVariables = @[@"_modelManager",@"_userConscience", @"_conscienceHelpViewController", @"protectedInstanceVariables"];
	}
    
	return self;

}

-(id)initWithModelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience {
    return [self initWithNibName:nil bundle:nil modelManager:modelManager andConscience:userConscience];
}

- (id)valueForKey:(NSString *)key {
    return [protectedInstanceVariables containsObject:key]? nil : [super valueForKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if (![protectedInstanceVariables containsObject:key]) {
        [super setValue:value forKey:key];
    }
}

- (void)localizeUI {

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