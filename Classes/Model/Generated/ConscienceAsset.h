//
//  ConscienceAsset.h
//  MoraLife
//
//  Created by aaxe on 6/5/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ReferenceAsset.h"


@interface ConscienceAsset : ReferenceAsset {
@private
}
@property (nonatomic, retain) NSNumber * costAsset;
@property (nonatomic, retain) NSString * orientationAsset;
@property (nonatomic, retain) NSNumber * moralValueAsset;

@end
