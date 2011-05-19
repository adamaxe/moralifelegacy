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
@property (nonatomic, retain) NSString * linkReference;
@property (nonatomic, retain) NSString * nameReference;
@property (nonatomic, retain) NSNumber * originYear;
@property (nonatomic, retain) NSString * longDescriptionReference;
@property (nonatomic, retain) NSString * displayNameReference;
@property (nonatomic, retain) NSString * shortDescriptionReference;
@property (nonatomic, retain) NSString * imageNameReference;
@property (nonatomic, retain) NSString * originLocation;
@property (nonatomic, retain) Moral * relatedMoral;

@end
