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
@property (nonatomic, retain) NSString * characterAccessoryPrimary;
@property (nonatomic, retain) NSString * characterAccessoryTop;
@property (nonatomic, retain) NSString * characterFace;
@property (nonatomic, retain) NSString * characterName;
@property (nonatomic, retain) NSString * characterEye;
@property (nonatomic, retain) NSString * characterMouth;
@property (nonatomic, retain) NSNumber * characterEnthusiasm;
@property (nonatomic, retain) NSNumber * characterAge;
@property (nonatomic, retain) NSNumber * characterMood;
@property (nonatomic, retain) NSString * characterAccessoryBottom;
@property (nonatomic, retain) NSString * characterEyeColor;
@property (nonatomic, retain) NSString * characterAccessorySecondary;
@property (nonatomic, retain) NSString * characterBrowColor;
@property (nonatomic, retain) NSString * characterBubbleColor;
@property (nonatomic, retain) NSNumber * characterSize;
@property (nonatomic, retain) NSNumber * characterBubbleType;

@end
