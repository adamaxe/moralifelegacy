//
//  ReferencePerson.h
//  Moralife
//
//  Created by aaxe on 2/23/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ReferenceAsset.h"

@class ReferenceBelief, ReferenceText;

@interface ReferencePerson : ReferenceAsset {
@private
}
@property (nonatomic, strong) NSNumber * deathYearPerson;
@property (nonatomic, strong) NSString * quotePerson;
@property (nonatomic, strong) NSSet* oeuvre;
@property (nonatomic, strong) NSSet* belief;

@end
