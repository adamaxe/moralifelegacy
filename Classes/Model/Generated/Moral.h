//
//  Moral.h
//  MoraLife
//
//  Created by aaxe on 5/14/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dilemma, ReferenceAsset;

@interface Moral : NSManagedObject {
@private
}
@property (nonatomic, strong) NSString * imageNameMoral;
@property (nonatomic, strong) NSString * colorMoral;
@property (nonatomic, strong) NSString * displayNameMoral;
@property (nonatomic, strong) NSString * longDescriptionMoral;
@property (nonatomic, strong) NSString * component;
@property (nonatomic, strong) NSString * shortDescriptionMoral;
@property (nonatomic, strong) NSString * linkMoral;
@property (nonatomic, strong) NSString * nameMoral;
@property (nonatomic, strong) NSString * definitionMoral;
@property (nonatomic, strong) NSSet* dillemmaB;
@property (nonatomic, strong) NSSet* dillemmaA;
@property (nonatomic, strong) NSSet* relatedReference;

@end
