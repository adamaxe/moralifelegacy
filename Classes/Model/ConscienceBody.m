/**
Implementation:  Each NSMutableDictionary holds the CoreGraphics drawing instructions to draw each state of each
 dynamic feature of the Conscience.
 
@class ConscienceBody ConscienceBody.m
*/

#import "ConscienceBody.h"

float const kConscienceSize = 1.0;
int const kConscienceAge = 0;
NSString* const kEyeColor = @"1C943D";
NSString* const kBrowColor = @"7B4027";

NSString* const kEyeFileNameResource = @"body-eye2";
NSString* const kMouthFileNameResource = @"body-mouth1";
NSString* const kSymbolFileNameResource = @"con-nothing";

@implementation ConscienceBody

- (id)init
{
    self = [super init];
    if (self) {
        //In case of first time run, or User does not supply configuration, default gradient
		_browLayers = [[NSMutableDictionary alloc] init];
		_bagsLayers = [[NSMutableDictionary alloc] init];
		_eyeLayers = [[NSMutableDictionary alloc] init];
		_lidLayers = [[NSMutableDictionary alloc] init];
		_lashesLayers = [[NSMutableDictionary alloc] init];
        _socketLayers = [[NSMutableDictionary alloc] init];
		_lipsLayers = [[NSMutableDictionary alloc] init];
		_dimplesLayers = [[NSMutableDictionary alloc] init];
		_teethLayers = [[NSMutableDictionary alloc] init];
		_tongueLayers = [[NSMutableDictionary alloc] init];
		_symbolLayers = [[NSMutableDictionary alloc] init];
		_gradientLayers = [[NSMutableDictionary alloc] init];
		
        //In case of first time run, or User does not supply configuration, default Conscience
        _eyeName = kEyeFileNameResource;
        _mouthName = kMouthFileNameResource;
        _symbolName = kSymbolFileNameResource;
        _eyeColor = kEyeColor;
        _browColor = kBrowColor;
        _bubbleColor = kBubbleColor;
        _age = kConscienceAge;
        _size = kConscienceSize;
        _bubbleType = kBubbleType;
        
    }

    return self;
}

///**@todo figure out copying */
//
//- copyWithZone:(NSZone *)zone {
//	ConscienceBody *bodyCopy = [[ConscienceBody allocWithZone:zone] init];
//	//NSMutableDictionary *deepCopy = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: browLayers]];
//	
//	bodyCopy.browLayers = [browLayers mutableCopy];
//	bodyCopy.bagsLayers = [bagsLayers mutableCopy];
//	bodyCopy.eyeLayers = [eyeLayers mutableCopy];
//	bodyCopy.lidLayers = [lidLayers mutableCopy];
//	bodyCopy.lashesLayers = [lashesLayers mutableCopy];	
//	bodyCopy.socketLayers = [socketLayers mutableCopy];	
//	bodyCopy.lipsLayers = [lipsLayers mutableCopy];
//	bodyCopy.dimplesLayers = [dimplesLayers mutableCopy];
//	bodyCopy.teethLayers = [teethLayers mutableCopy];
//	bodyCopy.tongueLayers = [tongueLayers mutableCopy];
//	bodyCopy.symbolLayers = [symbolLayers mutableCopy];
//	bodyCopy.gradientLayers = [gradientLayers mutableCopy];
//	bodyCopy.eyeName = [eyeName copy];
//	bodyCopy.mouthName = [mouthName copy];
//	bodyCopy.symbolName = [symbolName copy];
//	bodyCopy.eyeColor = [eyeColor copy];
//	bodyCopy.browColor = [browColor copy];
//	bodyCopy.bubbleColor = [bubbleColor copy];
//	
//	return bodyCopy;
//}
//
//- mutableCopyWithZone:(NSZone *)zone {
//	ConscienceBody *bodyCopy = [[ConscienceBody allocWithZone:zone] init];
//
//	bodyCopy.browLayers = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: browLayers]];
//	bodyCopy.bagsLayers = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: bagsLayers]];
//	bodyCopy.eyeLayers = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: eyeLayers]];
//	bodyCopy.lidLayers = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: lidLayers]];
//	bodyCopy.lashesLayers = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: lashesLayers]];
//	bodyCopy.socketLayers = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: socketLayers]];
//	bodyCopy.lipsLayers = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: lipsLayers]];
//	bodyCopy.dimplesLayers = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: dimplesLayers]];
//	bodyCopy.teethLayers = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: teethLayers]];
//	bodyCopy.tongueLayers = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: tongueLayers]];
//	bodyCopy.symbolLayers = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: symbolLayers]];
//	bodyCopy.gradientLayers = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: gradientLayers]];
//	bodyCopy.eyeName = [eyeName copy];
//	bodyCopy.mouthName = [mouthName copy];
//	bodyCopy.symbolName = [symbolName copy];
//	bodyCopy.eyeColor = [eyeColor copy];
//	bodyCopy.browColor = [browColor copy];
//	bodyCopy.bubbleColor = [bubbleColor copy];
//	
//	return bodyCopy;
//}


@end