//
//  ReferenceAsset.h
//  Moralife
//
//  Created by aaxe on 2/23/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Moral;

@interface ReferenceAsset : NSManagedObject {
@private
}
@property (nonatomic, strong) NSString * linkReference;
@property (nonatomic, strong) NSString * nameReference;
@property (nonatomic, strong) NSNumber * originYear;
@property (nonatomic, strong) NSString * longDescriptionReference;
@property (nonatomic, strong) NSString * displayNameReference;
@property (nonatomic, strong) NSString * shortDescriptionReference;
@property (nonatomic, strong) NSString * imageNameReference;
@property (nonatomic, strong) NSString * originLocation;
@property (nonatomic, strong) Moral * relatedMoral;

@end
