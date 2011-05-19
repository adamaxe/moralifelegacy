//
//  ConscienceAsset.h
//  Moralife
//
//  Created by aaxe on 2/11/11.
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

@end
