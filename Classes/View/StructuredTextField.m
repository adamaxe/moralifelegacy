/**
Implementation: There is no inherent way to prevent User from entering in data to a limit.  Must add a maxLength field to accomplish.

@class StructuredTextField StructuredTextField.h
 */

#import "StructuredTextField.h"

@implementation StructuredTextField

@synthesize maxLength;

/**
override text for a field in order to prevent it from being updated
@param textArg NSString User entered text
*/
-(void)setText:(NSString *) textArg{

//	NSMutableString *transformString = [NSMutableString stringWithCapacity:maxLength];
	NSMutableString *transformString = [[NSMutableString alloc] initWithCapacity:maxLength];

	
	if ([textArg length] > maxLength) {
		[transformString setString:[textArg substringToIndex:maxLength]];
	}else {
		[transformString setString:textArg];
	}
    
	[super setText: (NSString *) transformString];
    
	[transformString release];

}

@end
