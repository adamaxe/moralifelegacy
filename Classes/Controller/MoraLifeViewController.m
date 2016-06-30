/**
Implementation:  UIViewController Superclass that possesses ModelManager and UserConscience.
 
@class MoraLifeViewController MoraLifeViewController.h
*/

#import "MoraLifeViewController.h"

@interface MoraLifeViewController () {
    @private
    NSArray *protectedInstanceVariables;
}

@property (nonatomic, unsafe_unretained) CGAffineTransform previousConscienceSize;

@end

@implementation MoraLifeViewController

#pragma mark -
#pragma mark View lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil modelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience {

    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _modelManager = modelManager;
        _userConscience = userConscience;
        _conscienceHelpViewController = [[ConscienceHelpViewController alloc] initWithConscience:_userConscience];
        _conscienceHelpViewController.viewControllerClassName = NSStringFromClass([self class]);
        _conscienceHelpViewController.modalPresentationStyle = UIModalPresentationFullScreen;

        protectedInstanceVariables = @[@"_modelManager",@"_userConscience", @"_conscienceHelpViewController", @"protectedInstanceVariables"];
	}
    
	return self;

}

-(instancetype)initWithModelManager:(ModelManager *)modelManager andConscience:(UserConscience *)userConscience {
    return [self initWithNibName:nil bundle:nil modelManager:modelManager andConscience:userConscience];
}

#pragma mark -
#pragma mark protected KVC implementation

/** Implementation: Protected variables are not implemented in KVC.  Therefore, we most override it.
 */
- (id)valueForKey:(NSString *)key {
    return [protectedInstanceVariables containsObject:key]? nil : [super valueForKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if (![protectedInstanceVariables containsObject:key]) {
        [super setValue:value forKey:key];
    }
}

#pragma mark -
#pragma mark shake handling

/** Implementation: Allow for shaking response
 */
-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {

    if (motion == UIEventSubtypeMotionShake) {
        [_userConscience shakeConscience];
    }
}

#pragma mark -
#pragma mark Protocol placeholders

/** Implementation: Protocols that must be implemented by the subclasses
 */
- (void)localizeUI {
    //No op to suppress localizable protocol warnings.  Must be implemented by subclasses.
}

-(void)userConscienceTouchBegan {
    //No op to suppress localizable protocol warnings.  Must be implemented by subclasses.
}

-(void)userConscienceTouchEnded {
    //No op to suppress localizable protocol warnings.  Must be implemented by subclasses.
}

#pragma mark -
#pragma mark UserConscienceTouchProtocol

/** Implementation: When Users touches the Conscience, depress and then call the UserConscience protocol callback
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSSet *allTouches = [event allTouches];

	switch (allTouches.count) {
		case 1: { //Single touch

			//Get the first touch.
			UITouch *touch = allTouches.allObjects[0];

			CGPoint conscienceCenter = [touch locationInView:self.view];
			UIView* touchedView = [self.view hitTest:conscienceCenter withEvent:event];

			//Shrink the Conscience to emulate that User is pushing Conscience
			//into background.  Only animate this if User is actually touching Conscience.
			if (touchedView.tag==MLConscienceViewTag) {

                /** @todo fix Conscience movement */
				//Depress Conscience slightly to simulate actual contact
				[UIView beginAnimations:@"ResizeConscienceSmall" context:nil];
				[UIView setAnimationDuration:0.2];
				[UIView setAnimationBeginsFromCurrentState:YES];
                self.previousConscienceSize = _userConscience.userConscienceView.conscienceBubbleView.transform;
				_userConscience.userConscienceView.conscienceBubbleView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
				[UIView commitAnimations];

                [self userConscienceTouchBegan];

			}

		} break;
		default:break;
	}


}

/** Implementation: When Users releases the Conscience, restore the view and then call the UserConscience protocol callback
 */
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	//Return the Conscience to regular size in event of touched or zoomed
	[UIView beginAnimations:@"ResizeConscienceBig" context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationBeginsFromCurrentState:YES];

	_userConscience.userConscienceView.conscienceBubbleView.transform = self.previousConscienceSize;

	[UIView commitAnimations];

    NSSet *allTouches = [event allTouches];
    UITouch *touch = allTouches.allObjects[0];

    CGPoint conscienceCenter = [touch locationInView:self.view];

    UIView* touchedView = [self.view hitTest:conscienceCenter withEvent:event];

    if (touchedView.tag==MLConscienceViewTag) {

        [self userConscienceTouchEnded];
    }
    
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
	[self touchesEnded:touches withEvent:event];
    
}

/** Implementation: Hide the Conscience so that a screenshot can be taken
 */
-(UIImage *)prepareScreenForScreenshot {
    float previousAlpha = _userConscience.userConscienceView.alpha;
    _userConscience.userConscienceView.alpha = 0;
    UIImage *screenshot = [self takeScreenshot];
    _userConscience.userConscienceView.alpha = previousAlpha;
    return screenshot;
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
