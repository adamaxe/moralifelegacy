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
@property (nonatomic, retain) NSDecimalNumber * sizeCharacter;
@property (nonatomic, retain) NSString * faceCharacter;
@property (nonatomic, retain) NSString * eyeColor;
@property (nonatomic, retain) NSString * accessoryBottomCharacter;
@property (nonatomic, retain) NSString * eyeCharacter;
@property (nonatomic, retain) NSString * browColor;
@property (nonatomic, retain) NSString * mouthCharacter;
@property (nonatomic, retain) NSNumber * ageCharacter;
@property (nonatomic, retain) NSString * accessoryTopCharacter;
@property (nonatomic, retain) NSString * accessoryPrimaryCharacter;
@property (nonatomic, retain) NSString * accessorySecondaryCharacter;
@property (nonatomic, retain) NSString * nameCharacter;
@property (nonatomic, retain) NSString * bubbleColor;
@property (nonatomic, retain) NSNumber * bubbleType;
@property (nonatomic, retain) NSSet* story;

@end
