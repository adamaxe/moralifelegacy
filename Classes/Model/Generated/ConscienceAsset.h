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
@property (nonatomic, strong) NSNumber * costAsset;
@property (nonatomic, strong) NSString * orientationAsset;
@property (nonatomic, strong) NSNumber * moralValueAsset;

@end
