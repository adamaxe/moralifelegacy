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
@property (nonatomic, strong) NSDate * collectableCreationDate;
@property (nonatomic, strong) NSString * collectableName;
@property (nonatomic, strong) NSString * collectableKey;
@property (nonatomic, strong) NSNumber * collectableValue;

@end
