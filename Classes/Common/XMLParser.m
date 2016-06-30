/**
Implementation:  We are parsing the svg's of the animatable facial features.  Each feature is put into an NSMutableDictionary for quick retrieval during emote animations.

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

@interface XMLParser () {
        
	ConsciencePath *currentConsciencePath;		/**< current Path selected for population */
	ConscienceGradient *currentConscienceGradient;	/**< current gradient selected for population */
    
}

@property (nonatomic, strong) ConscienceLayer *currentConscienceLayer;   /**< current Layer selected for population */

@end

@implementation XMLParser 

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
attributes:(NSDictionary *)attributeDict {

	//Determine element type for opening
	if([elementName isEqualToString:@"g"]) {
		//Layer Group has been found, initialize containers to hold data
		self.currentConscienceLayer = [[ConscienceLayer alloc] init];
		self.currentConscienceLayer.layerID = attributeDict[@"id"];

	} else if([elementName isEqualToString:@"path"]) {

		//Path has been found, populate containers
		//Initialize the path.
		currentConsciencePath = [[ConsciencePath alloc] init];
		
		//Transform path/style strings into ConsciencePaths ready for Quartz rendering
		currentConsciencePath.pathID = attributeDict[@"id"];

        /** 
         d = current path data from XML under inspection/tokenization
         Path Data represents drawing instructions (arc, bezier, etc.)  Possesses points and drawing instructions

         style = current style data from XML under inspection/tokenization
         Style Data represents stroke/fill instructions. Possesses color, opacity, style and possible gradientID
         */
        [currentConsciencePath convertToConsciencePath:attributeDict[@"d"] WithStyle:attributeDict[@"style"]];
        
		//Add completed path to layer
		[self.currentConscienceLayer.consciencePaths addObject:currentConsciencePath];
		
	} else if([elementName isEqualToString:@"linearGradient"]) {

		//Gradient has been found, populate containers
		//Initialize the path.
		currentConscienceGradient = [[ConscienceGradient alloc] init];

		currentConscienceGradient.gradientID = (NSString *)attributeDict[@"id"];

        CGPoint startPoint = CGPointMake([attributeDict[@"x1"] floatValue],[attributeDict[@"y1"] floatValue]);
		CGPoint endPoint = CGPointMake([attributeDict[@"x2"] floatValue],[attributeDict[@"y2"] floatValue]);
		
		[currentConscienceGradient.gradientPoints addObject:[NSValue valueWithCGPoint:startPoint]];
		[currentConscienceGradient.gradientPoints addObject:[NSValue valueWithCGPoint:endPoint]];

		/** @todo process stop points */
	}

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

	//Determine which layer is found
	NSRange subStrRange = [self.currentConscienceLayer.layerID rangeOfString:@"Brow"];
	BOOL browFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [self.currentConscienceLayer.layerID rangeOfString:@"Lashes"];
	BOOL lashesFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [self.currentConscienceLayer.layerID rangeOfString:@"Eye"];
	BOOL eyeFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [self.currentConscienceLayer.layerID rangeOfString:@"Lid"];
	BOOL lidFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [self.currentConscienceLayer.layerID rangeOfString:@"Socket"];
	BOOL socketFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [self.currentConscienceLayer.layerID rangeOfString:@"Bags"];
	BOOL bagsFoundBool =  (subStrRange.location != NSNotFound);

	subStrRange = [self.currentConscienceLayer.layerID rangeOfString:@"Dimples"];
	BOOL dimplesFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [self.currentConscienceLayer.layerID rangeOfString:@"Lips"];
	BOOL lipsFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [self.currentConscienceLayer.layerID rangeOfString:@"Teeth"];
	BOOL teethFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [self.currentConscienceLayer.layerID rangeOfString:@"Tongue"];
	BOOL tongueFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [self.currentConscienceLayer.layerID rangeOfString:@"Symbol"];
	BOOL symbolFoundBool =  (subStrRange.location != NSNotFound);
	subStrRange = [self.currentConscienceLayer.layerID rangeOfString:@"Position"];
	BOOL positionFoundBool =  (subStrRange.location != NSNotFound);	

	/** @todo convert dictionary key to kExpression enum */
	//Determine if element is a grouping of paths, a path or a gradient
	if([elementName isEqualToString:@"g"]){
		//Determine which ConscienceLayer path belongs
		if (browFoundBool) {
			(self.currentConscienceBody.browLayers)[self.currentConscienceLayer.layerID] = self.currentConscienceLayer;
		} else if (bagsFoundBool) {
			(self.currentConscienceBody.bagsLayers)[self.currentConscienceLayer.layerID] = self.currentConscienceLayer;
		} else if (eyeFoundBool) {
			(self.currentConscienceBody.eyeLayers)[self.currentConscienceLayer.layerID] = self.currentConscienceLayer;
		} else if (lashesFoundBool) {
			(self.currentConscienceBody.lashesLayers)[self.currentConscienceLayer.layerID] = self.currentConscienceLayer;
		} else if (lidFoundBool) {
			(self.currentConscienceBody.lidLayers)[self.currentConscienceLayer.layerID] = self.currentConscienceLayer;
		} else if (socketFoundBool) {
			(self.currentConscienceBody.socketLayers)[self.currentConscienceLayer.layerID] = self.currentConscienceLayer;
		} else if (dimplesFoundBool) {
			(self.currentConscienceBody.dimplesLayers)[self.currentConscienceLayer.layerID] = self.currentConscienceLayer;
		} else if (lipsFoundBool) {
			(self.currentConscienceBody.lipsLayers)[self.currentConscienceLayer.layerID] = self.currentConscienceLayer;
		} else if (teethFoundBool) {
			(self.currentConscienceBody.teethLayers)[self.currentConscienceLayer.layerID] = self.currentConscienceLayer;
		} else if (tongueFoundBool) {
			(self.currentConscienceBody.tongueLayers)[self.currentConscienceLayer.layerID] = self.currentConscienceLayer;
		} else if (symbolFoundBool) {
			(self.currentConscienceBody.symbolLayers)[self.currentConscienceLayer.layerID] = self.currentConscienceLayer;
		} else if (positionFoundBool) {
			(self.currentConscienceBody.symbolLayers)[self.currentConscienceLayer.layerID] = self.currentConscienceLayer;
		}
		
	}
	
	if([elementName isEqualToString:@"linearGradient"]) {
			//Gradient has been found
			(self.currentConscienceBody.gradientLayers)[currentConscienceGradient.gradientID] = currentConscienceGradient;
	}
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {

	NSString *errorString = [NSString stringWithFormat:@"Error %li,Description: %@, Line: %li, Column: %li", (long)parseError.code, parser.parserError.localizedDescription, (long)parser.lineNumber,(long)parser.columnNumber];

	NSLog(@"parseerror:%@",errorString);

}

@end
