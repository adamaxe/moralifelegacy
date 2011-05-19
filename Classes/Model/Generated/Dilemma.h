//
//  Dilemma.h
//  Moralife
//
//  Created by aaxe on 4/5/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character, Moral;

@interface Dilemma : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * rewardADilemma;
@property (nonatomic, retain) NSString * choiceB;
@property (nonatomic, retain) NSNumber * moodDilemma;
@property (nonatomic, retain) NSString * surrounding;
@property (nonatomic, retain) NSString * nameDilemma;
@property (nonatomic, retain) NSString * displayNameDilemma;
@property (nonatomic, retain) NSNumber * campaign;
@property (nonatomic, retain) NSString * choiceA;
@property (nonatomic, retain) NSNumber * enthusiasmDilemma;
@property (nonatomic, retain) NSString * dilemmaText;
@property (nonatomic, retain) NSString * rewardBDilemma;
@property (nonatomic, retain) Moral * moralChoiceA;
@property (nonatomic, retain) Character * antagonist;
@property (nonatomic, retain) Moral * moralChoiceB;

@end
