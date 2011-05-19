//
//  UserLuck.h
//  Moralife
//
//  Created by aaxe on 2/20/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UserEntry.h"


@interface UserLuck : UserEntry {
@private
}
@property (nonatomic, retain) NSDate * entryModificationDate;

@end
