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
@property (nonatomic, retain) NSString * imageNameMoral;
@property (nonatomic, retain) NSString * colorMoral;
@property (nonatomic, retain) NSString * displayNameMoral;
@property (nonatomic, retain) NSString * longDescriptionMoral;
@property (nonatomic, retain) NSString * component;
@property (nonatomic, retain) NSString * shortDescriptionMoral;
@property (nonatomic, retain) NSString * linkMoral;
@property (nonatomic, retain) NSString * nameMoral;
@property (nonatomic, retain) NSString * definitionMoral;
@property (nonatomic, retain) NSSet* dillemmaB;
@property (nonatomic, retain) NSSet* dillemmaA;
@property (nonatomic, retain) NSSet* relatedReference;

@end
