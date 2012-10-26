/**
Implementation: An image wrapper is used for accessories as to simplify the setup of each accessory.

@class AccessoryObjectView AccessoryObjectView.h
 */

#import "AccessoryObjectView.h"

NSString* const MLAccessoryFileNameResourceDefault = @"acc-nothing";
int const MLSideAccessoryWidth = 75;
int const MLSideAccessoryHeight = 162;

@implementation AccessoryObjectView

#pragma mark -
#pragma mark View lifecycle

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {

		//Set view to transparent, enable touch
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.clearsContextBeforeDrawing = YES;
		self.multipleTouchEnabled = TRUE;
		self.contentMode = UIViewContentModeCenter;
		
		//Set filename to known blank png at initialization
		[self setAccessoryFilename:MLAccessoryFileNameResourceDefault];
		
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
    
    if ([_accessoryFilename isEqualToString:@""]) {
        [self setAccessoryFilename:MLAccessoryFileNameResourceDefault];
    }
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_accessoryFilename ofType:@"png"]];
    [image drawInRect:rect];
    
}

#pragma mark -
#pragma mark Memory management


@end