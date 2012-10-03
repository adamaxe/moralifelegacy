//
//  UserEntry.h
//  Moralife
//
//  Created by aaxe on 2/20/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserEntry : NSManagedObject {
@private
}
@property (nonatomic, strong) NSString * entryShortDescription;
@property (nonatomic, strong) NSNumber * entryIsGood;
@property (nonatomic, strong) NSString * entryKey;
@property (nonatomic, strong) NSString * entryLongDescription;
@property (nonatomic, strong) NSNumber * entrySeverity;
@property (nonatomic, strong) NSDate * entryCreationDate;

@end
