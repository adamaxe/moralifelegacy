//
//  UserCharacter.h
//  MoraLife
//
//  Created by aaxe on 5/15/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserCharacter : NSManagedObject {
@private
}
@property (nonatomic, strong) NSString * characterAccessoryPrimary;
@property (nonatomic, strong) NSString * characterAccessoryTop;
@property (nonatomic, strong) NSString * characterFace;
@property (nonatomic, strong) NSString * characterName;
@property (nonatomic, strong) NSString * characterEye;
@property (nonatomic, strong) NSString * characterMouth;
@property (nonatomic, strong) NSNumber * characterEnthusiasm;
@property (nonatomic, strong) NSNumber * characterAge;
@property (nonatomic, strong) NSNumber * characterMood;
@property (nonatomic, strong) NSString * characterAccessoryBottom;
@property (nonatomic, strong) NSString * characterEyeColor;
@property (nonatomic, strong) NSString * characterAccessorySecondary;
@property (nonatomic, strong) NSString * characterBrowColor;
@property (nonatomic, strong) NSString * characterBubbleColor;
@property (nonatomic, strong) NSNumber * characterSize;
@property (nonatomic, strong) NSNumber * characterBubbleType;

@end
