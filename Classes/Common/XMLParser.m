/**
XML Parser to gather Path Data.  Implementation

@class XMLParser XMLParser.h
@author Copyright 2010 Team Axe, LLC. All Rights Reserved. http://www.teamaxe.org
@date 07/20/2010
@file
*/

#import "XMLParser.h"
#import "ConsciencePath.h"
#import "ConscienceLayer.h"
#import "ConscienceGradient.h"
#import "ConscienceBody.h"

@implementation XMLParser 

@synthesize currentConscienceBody;

#pragma mark -
#pragma mark View lifecycle

- (XMLParser *) initXMLParser {

    if ((self = [super init])) {

        pool = [[NSAutoreleasePool alloc] init];
    }
    
	return self;
}

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
attributes:(NSDictionary *)attributeDict {

	//Determine element type for opening
	if([elementName isEqualToString:@"g"]) {
		//Layer Group has been found, initialize containers to hold data
		currentConscienceLayer = [[[ConscienceLayer alloc] init] autorelease];
		[currentConscienceLayer setLayerID:[attributeDict objectForKey:@"id"]];

	} else if([elementName isEqualToString:@"path"]) {

		//Path has been found, populate containers
		//Initialize the path.
		currentConsciencePath = [[ConsciencePath alloc] init];
		
		//Transform path/style strings into ConsciencePaths ready for Quartz rendering
		currentConsciencePath.pathID = [attributeDict objectForKey:@"id"];

        /** 
         d = current path data from XML under inspection/tokenization
         Path Data represents drawing instructions (arc, bezier, etc.)  Possesses points and drawing instructions

         style = current style data from XML under inspection/tokenization
         Style Data represents stroke/fill instructions. Possesses color, opacity, style and possible gradientID
         */
        [currentConsciencePath convertToConsciencePath:[attributeDict objectForKey:@"d"] WithStyle:[attributeDict objectForKey:@"style"]];
        
		//Add completed path to layer
		[currentConscienceLayer.consciencePaths addObject:currentConsciencePath];
		[currentConsciencePath release];
		
	} else if([elementName isEqualToString:@"linearGradient"]) {

		//Gradient has been found, populate containers
		//Initialize the path.
		currentConscienceGradient = [[ConscienceGradient alloc] init];

		[currentConscienceGradient setGradientID:(NSString *)[attributeDict objectForKey:@"id"]];

        CGPoint startPoint = CGPointMake([[attributeDict objectForKey:@"x1"] floatValue],[[attributeDict objectForKey:@"y1"] floatValue]);
		CGPoint endPoint = CGPointMake([[attributeDict objectForKey:@"x2"] floatValue],[[attributeDict objectForKey:@"y2"] floatValue]);
		
		[currentConscienceGradient.gradientPoints addObject:[NSValue valueWithCGPoint:startPoint]];
		[currentConscienceGradient.gradientPoints addObject:[NSValue valueWithCGPoint:endPoint]];

		/** @todo process stop points */
	}

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

	//Determine which layer is found
	NSRange subStrRange = [[currentConscienceLayer layerID] rangeOfString:@"Brow"];
	BOOL browFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [[currentConscienceLayer layerID] rangeOfString:@"Lashes"];
	BOOL lashesFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [[currentConscienceLayer layerID] rangeOfString:@"Eye"];
	BOOL eyeFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [[currentConscienceLayer layerID] rangeOfString:@"Lid"];
	BOOL lidFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [[currentConscienceLayer layerID] rangeOfString:@"Socket"];
	BOOL socketFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [[currentConscienceLayer layerID] rangeOfString:@"Bags"];
	BOOL bagsFoundBool =  (subStrRange.location != NSNotFound);

	subStrRange = [[currentConscienceLayer layerID] rangeOfString:@"Dimples"];
	BOOL dimplesFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [[currentConscienceLayer layerID] rangeOfString:@"Lips"];
	BOOL lipsFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [[currentConscienceLayer layerID] rangeOfString:@"Teeth"];
	BOOL teethFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [[currentConscienceLayer layerID] rangeOfString:@"Tongue"];
	BOOL tongueFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [[currentConscienceLayer layerID] rangeOfString:@"Symbol"];
	BOOL symbolFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [[currentConscienceLayer layerID] rangeOfString:@"Position"];
	BOOL positionFoundBool =  (subStrRange.location != NSNotFound);	

	/** @todo convert dictionary key to kExpression enum */
	//Determine if element is a grouping of paths, a path or a gradient
	if([elementName isEqualToString:@"g"]){
		//Determine which ConscienceLayer path belongs
		if (browFoundBool) {
			[currentConscienceBody.browLayers setObject: currentConscienceLayer forKey:[currentConscienceLayer layerID]];
		} else if (bagsFoundBool) {
			[currentConscienceBody.bagsLayers setObject: currentConscienceLayer forKey:[currentConscienceLayer layerID]];
		} else if (eyeFoundBool) {
			[currentConscienceBody.eyeLayers setObject: currentConscienceLayer forKey:[currentConscienceLayer layerID]];
		} else if (lashesFoundBool) {
			[currentConscienceBody.lashesLayers setObject: currentConscienceLayer forKey:[currentConscienceLayer layerID]];
		} else if (lidFoundBool) {
			[currentConscienceBody.lidLayers setObject: currentConscienceLayer forKey:[currentConscienceLayer layerID]];
		} else if (socketFoundBool) {
			[currentConscienceBody.socketLayers setObject: currentConscienceLayer forKey:[currentConscienceLayer layerID]];
		} else if (dimplesFoundBool) {
			[currentConscienceBody.dimplesLayers setObject: currentConscienceLayer forKey:[currentConscienceLayer layerID]];
		} else if (lipsFoundBool) {
			[currentConscienceBody.lipsLayers setObject: currentConscienceLayer forKey:[currentConscienceLayer layerID]];
		} else if (teethFoundBool) {
			[currentConscienceBody.teethLayers setObject: currentConscienceLayer forKey:[currentConscienceLayer layerID]];
		} else if (tongueFoundBool) {
			[currentConscienceBody.tongueLayers setObject: currentConscienceLayer forKey:[currentConscienceLayer layerID]];
		} else if (symbolFoundBool) {
			[currentConscienceBody.symbolLayers setObject: currentConscienceLayer forKey:[currentConscienceLayer layerID]];
		} else if (positionFoundBool) {
			[currentConscienceBody.symbolLayers setObject: currentConscienceLayer forKey:[currentConscienceLayer layerID]];
		}
		
	}
	
	
	if([elementName isEqualToString:@"linearGradient"]) {
			//Gradient has been found
			[currentConscienceBody.gradientLayers setObject: currentConscienceGradient forKey:currentConscienceGradient.gradientID];
			[currentConscienceGradient release];
	}
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {

	NSString *errorString = [NSString stringWithFormat:@"Error %i,Description: %@, Line: %i, Column: %i", [parseError code], [[parser parserError] localizedDescription], [parser lineNumber],[parser columnNumber]];

	NSLog(@"parseerror:%@",errorString);

}

#pragma mark -
#pragma mark Memory management

- (void) dealloc {
    [pool drain];
    [currentConscienceBody release];
	[super dealloc];
}

@end