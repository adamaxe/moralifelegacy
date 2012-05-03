/**
Implementation:  Each NSMutableDictionary holds the CoreGraphics drawing instructions to draw each state of each
 dynamic feature of the Conscience.
 
@class ConscienceBody ConscienceBody.m
*/

#import "ConscienceBody.h"

@implementation ConscienceBody

@synthesize browLayers, bagsLayers, eyeLayers, lidLayers, lashesLayers, socketLayers;
@synthesize lipsLayers, teethLayers, dimplesLayers, tongueLayers, gradientLayers;
@synthesize symbolLayers;
@synthesize eyeName, mouthName, symbolName, eyeColor, browColor, bubbleColor;
@synthesize age, bubbleType;
@synthesize size;

- (id)init
{
    self = [super init];
    if (self) {
        //In case of first time run, or User does not supply configuration, default gradient
		browLayers = [[NSMutableDictionary alloc] init];
		bagsLayers = [[NSMutableDictionary alloc] init];
		eyeLayers = [[NSMutableDictionary alloc] init];		
		lidLayers = [[NSMutableDictionary alloc] init];		
		lashesLayers = [[NSMutableDictionary alloc] init];		
		socketLayers = [[NSMutableDictionary alloc] init];		
		lipsLayers = [[NSMutableDictionary alloc] init];
		dimplesLayers = [[NSMutableDictionary alloc] init];
		teethLayers = [[NSMutableDictionary alloc] init];
		tongueLayers = [[NSMutableDictionary alloc] init];
		symbolLayers = [[NSMutableDictionary alloc] init];
		gradientLayers = [[NSMutableDictionary alloc] init];
		
        //In case of first time run, or User does not supply configuration, default Conscience
        [self setEyeName:kEyeFileNameResource];
        [self setMouthName:kMouthFileNameResource];
        [self setSymbolName:kSymbolFileNameResource];
        [self setEyeColor:kEyeColor];
        [self setBrowColor:kBrowColor];
        [self setBubbleColor:kBubbleColor];
        [self setAge:kConscienceAge];
        [self setSize:kConscienceSize];
        
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

- (void) dealloc {

	[browLayers release];
	[bagsLayers release];
	[eyeLayers release];
	[lidLayers release];
	[lashesLayers release];	
	[socketLayers release];	
	[lipsLayers release];
	[dimplesLayers release];
	[teethLayers release];
	[tongueLayers release];
	[symbolLayers release];
	[gradientLayers release];
	[eyeName release];
	[mouthName release];
	[symbolName release];
	[eyeColor release];
	[browColor release];
	[bubbleColor release];
	[super dealloc];
}

@end