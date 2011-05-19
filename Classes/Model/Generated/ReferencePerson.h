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
@property (nonatomic, retain) NSNumber * deathYearPerson;
@property (nonatomic, retain) NSString * quotePerson;
@property (nonatomic, retain) NSSet* oeuvre;
@property (nonatomic, retain) NSSet* belief;

@end
