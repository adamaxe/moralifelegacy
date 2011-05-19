//
//  UserCollectable.h
//  Moralife
//
//  Created by aaxe on 3/24/11.
//  Copyright (c) 2011 Team Axe, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserCollectable : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * collectableCreationDate;
@property (nonatomic, retain) NSString * collectableName;
@property (nonatomic, retain) NSString * collectableKey;
@property (nonatomic, retain) NSNumber * collectableValue;

@end
