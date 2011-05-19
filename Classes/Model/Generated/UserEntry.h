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
@property (nonatomic, retain) NSString * entryShortDescription;
@property (nonatomic, retain) NSNumber * entryIsGood;
@property (nonatomic, retain) NSString * entryKey;
@property (nonatomic, retain) NSString * entryLongDescription;
@property (nonatomic, retain) NSNumber * entrySeverity;
@property (nonatomic, retain) NSDate * entryCreationDate;

@end
