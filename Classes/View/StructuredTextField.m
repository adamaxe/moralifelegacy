/**
Implementation: There is no inherent way to prevent User from entering in data to a limit.  Must add a maxLength field to accomplish.

@class StructuredTextField StructuredTextField.h
 */

#import "StructuredTextField.h"

int const kChoiceTextFieldLength = 64;

@implementation StructuredTextField

/**
override text for a field in order to prevent it from being updated
@param textArg NSString User entered text
*/
-(void)setText:(NSString *) textArg{

	NSMutableString *transformString = [[NSMutableString alloc] initWithCapacity:_maxLength];
	
	if ([textArg length] > _maxLength) {
		[transformString setString:[textArg substringToIndex:_maxLength]];
	}else {
		[transformString setString:textArg];
	}
    
	[super setText: (NSString *) transformString];
    
	[transformString release];

}

@end
