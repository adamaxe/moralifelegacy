//
//  UserChoice.h
//  Moralife
//
//  Created by aaxe on 2/20/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UserEntry.h"


@interface UserChoice : UserEntry {
@private
}
@property (nonatomic, strong) NSDate * entryModificationDate;
@property (nonatomic, strong) NSNumber * choiceInfluence;
@property (nonatomic, strong) NSString * choiceConsequences;
@property (nonatomic, strong) NSString * choiceJustification;
@property (nonatomic, strong) NSString * choiceMoral;
@property (nonatomic, strong) NSNumber * choiceWeight;

@end
