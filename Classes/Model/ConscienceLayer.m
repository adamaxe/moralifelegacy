/**
Implementation:  NSMutableArray of ConsciencePaths.

@class ConscienceLayer ConscienceLayer.h
 */

#import "ConscienceLayer.h"

@implementation ConscienceLayer

- (id)init{
    self = [super init];
    if (self) {    
        //In case of first time run, or User does not supply configuration, default gradient
        _consciencePaths = [[NSMutableArray alloc] init];

        _currentFillColor = kPathColor;
        _currentStrokeColor = kPathColor;
        _layerID = @"";
        _offsetX = kDefault0Float;
        _offsetY = kDefault0Float;
    }
    
	return self;
}


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {         
        
		self.consciencePaths = [decoder decodeObjectForKey:@"consciencePaths"];
		self.layerID = [decoder decodeObjectForKey:@"layerID"];
		self.currentFillColor = [decoder decodeObjectForKey:@"currentFillColor"];
		self.currentStrokeColor = [decoder decodeObjectForKey:@"currentStrokeColor"];
		
        self.offsetX = [decoder decodeFloatForKey:@"offsetX"];
        self.offsetY = [decoder decodeFloatForKey:@"offsetX"];

	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
	[encoder encodeObject:_consciencePaths forKey:@"consciencePaths"];
	[encoder encodeObject:_layerID forKey:@"layerID"];
	[encoder encodeObject:_currentFillColor forKey:@"currentFillColor"];
	[encoder encodeObject:_currentStrokeColor forKey:@"currentStrokeColor"];
	[encoder encodeFloat:_offsetX forKey:@"offsetX"];
    [encoder encodeFloat:_offsetY forKey:@"offsetY"];

}

- (void) dealloc {

    [_consciencePaths removeAllObjects];
	[_consciencePaths release];_consciencePaths = nil;
	[_layerID release];
	[_currentFillColor release];
	[_currentStrokeColor release];

    [super dealloc];

}

@end