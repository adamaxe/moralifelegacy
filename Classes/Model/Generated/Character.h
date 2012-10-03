//
//  Character.h
//  MoraLife
//
//  Created by aaxe on 5/15/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dilemma;

@interface Character : NSManagedObject {
@private
}
@property (nonatomic, strong) NSDecimalNumber * sizeCharacter;
@property (nonatomic, strong) NSString * faceCharacter;
@property (nonatomic, strong) NSString * eyeColor;
@property (nonatomic, strong) NSString * accessoryBottomCharacter;
@property (nonatomic, strong) NSString * eyeCharacter;
@property (nonatomic, strong) NSString * browColor;
@property (nonatomic, strong) NSString * mouthCharacter;
@property (nonatomic, strong) NSNumber * ageCharacter;
@property (nonatomic, strong) NSString * accessoryTopCharacter;
@property (nonatomic, strong) NSString * accessoryPrimaryCharacter;
@property (nonatomic, strong) NSString * accessorySecondaryCharacter;
@property (nonatomic, strong) NSString * nameCharacter;
@property (nonatomic, strong) NSString * bubbleColor;
@property (nonatomic, strong) NSNumber * bubbleType;
@property (nonatomic, strong) NSSet* story;

@end
