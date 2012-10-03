/**
XML Document Parser.  Common object to gather and transform Path Data from SVG.
Limitations: SVG must be unoptimized, only small subset of SVG instructions are supported, only 1 level of grouping is supported currently, Points must be absolute

@class XMLParser
@author Copyright 2010 Team Axe, LLC. All Rights Reserved. http://www.teamaxe.org
@date 07/20/2010
@file
*/

@class ConscienceBody;

#if defined(__IPHONE_4_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0

@interface XMLParser : NSObject <NSXMLParserDelegate> 

#else

@interface XMLParser : NSObject

#endif

@property (nonatomic, strong) ConscienceBody *currentConscienceBody;    /**< current Conscience selected for population */

@end