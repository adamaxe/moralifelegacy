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
@property (nonatomic, retain) NSDate * entryModificationDate;
@property (nonatomic, retain) NSNumber * choiceInfluence;
@property (nonatomic, retain) NSString * choiceConsequences;
@property (nonatomic, retain) NSString * choiceJustification;
@property (nonatomic, retain) NSString * choiceMoral;
@property (nonatomic, retain) NSNumber * choiceWeight;

@end
