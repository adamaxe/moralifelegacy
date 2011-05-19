/**
Implementation: An image wrapper is used for accessories as to simplify the setup of each accessory.

@class AccessoryObjectView AccessoryObjectView.h
 */

#import "AccessoryObjectView.h"

@implementation AccessoryObjectView

@synthesize accessoryFilename;

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
		
		//Set filename to known blank pdf at initialization
		[self setAccessoryFilename:kAccessoryFileNameResource];
		
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
    
    if ([accessoryFilename isEqualToString:@""]) {
        [self setAccessoryFilename:@"acc-nothing"];
    }
    
    NSString *imageName = [[NSString alloc] initWithString:accessoryFilename];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
    [image drawInRect:rect];
    [image release];
    [imageName release];
    
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[accessoryFilename release];
	[super dealloc];
}

@end