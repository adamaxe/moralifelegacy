//
//  Dilemma.h
//  mlcoredata
//
//  Created by aaxe on 6/2/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character, Moral;

@interface Dilemma : NSManagedObject {
@private
}
@property (nonatomic, strong) NSString * rewardADilemma;
@property (nonatomic, strong) NSString * choiceB;
@property (nonatomic, strong) NSNumber * moodDilemma;
@property (nonatomic, strong) NSString * displayNameDilemma;
@property (nonatomic, strong) NSString * surrounding;
@property (nonatomic, strong) NSString * nameDilemma;
@property (nonatomic, strong) NSString * rewardBDilemma;
@property (nonatomic, strong) NSString * choiceA;
@property (nonatomic, strong) NSNumber * enthusiasmDilemma;
@property (nonatomic, strong) NSString * dilemmaText;
@property (nonatomic, strong) Moral * moralChoiceA;
@property (nonatomic, strong) Character * antagonist;
@property (nonatomic, strong) Moral * moralChoiceB;

@end
