/**
Implementation:  Take ConscienceBody and turn it into functioning, visual conscience.
 
@class ConscienceBuilder ConscienceBuilder.h
 */

#import "ConscienceBuilder.h"
#import "XMLParser.h"
#import "ConscienceBody.h"

@implementation ConscienceBuilder

#pragma mark -
#pragma mark API

/**
Implementation: Call various utilities to construct User's Conscience.  Call XMLParser for eyes, symbol and mouth
 */
+ (void)buildConscience:(ConscienceBody *) requestedConscienceBody{
		
    NSString *featurePath = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];     

    NSMutableString *featureFileName = [NSMutableString stringWithFormat:@"%@.svg", requestedConscienceBody.eyeName];
	NSMutableString *dataPath = [NSMutableString stringWithString:[featurePath stringByAppendingPathComponent:featureFileName]];
            
    if ([fileManager fileExistsAtPath:dataPath]){ 
        [self populateConscience:requestedConscienceBody WithFeature:requestedConscienceBody.eyeName];
    } else {
        [self populateConscience:requestedConscienceBody WithFeature:@"con-nothing"];
        
    }
    
	[featureFileName setString:[NSMutableString stringWithFormat:@"%@.svg", requestedConscienceBody.symbolName]];
    [dataPath setString:[NSMutableString stringWithString:[featurePath stringByAppendingPathComponent:featureFileName]]];
    
    if ([fileManager fileExistsAtPath:dataPath]){ 
        [self populateConscience:requestedConscienceBody WithFeature:requestedConscienceBody.symbolName];
    } else {
        [self populateConscience:requestedConscienceBody WithFeature:@"con-nothing"];

    }
        
    [featureFileName setString:[NSMutableString stringWithFormat:@"%@.svg", requestedConscienceBody.mouthName]];
    [dataPath setString:[NSMutableString stringWithString:[featurePath stringByAppendingPathComponent:featureFileName]]];

    
    if ([fileManager fileExistsAtPath:dataPath]){ 
        [self populateConscience:requestedConscienceBody WithFeature:requestedConscienceBody.mouthName];
    } else {
        [self populateConscience:requestedConscienceBody WithFeature:@"con-nothing"];
        
    }
    
    
}

/**
Implementation: Parse the XML document and feed the ConscienceBody based upon requested feature
 */
+ (void) populateConscience:(ConscienceBody *) manipulatedConscience WithFeature:(NSString *) currentFeature{
    
    
	NSString *featureFileName = [NSString stringWithFormat:@"%@.svg", currentFeature];
	NSString *featurePath = [[NSBundle mainBundle] bundlePath];
	NSString *dataPath = [featurePath stringByAppendingPathComponent:featureFileName];	
	NSData *featureData = [[NSData alloc] initWithContentsOfFile:dataPath];
    
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:featureData];
	
	//Initialize the delegate.
	XMLParser *parser = [[XMLParser alloc] init];
	//Assign a conscience to be populated
	[parser setCurrentConscienceBody:manipulatedConscience];
	
	//Set delegate
	[xmlParser setDelegate:parser];
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	[xmlParser setShouldResolveExternalEntities:NO];
	
	//Start parsing the XML file.
	BOOL success = [xmlParser parse];

	if(success)
		NSLog(@"No Errors");
	else
		NSLog(@"Error Error Error!!!");
    
	[xmlParser setDelegate:nil];
    
    	
}


@end
