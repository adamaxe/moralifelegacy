//
//  ReferenceBelief.h
//  Moralife
//
//  Created by aaxe on 1/18/11.
//  Copyright 2011 Team Axe, LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ReferenceAsset.h"

@class ReferencePerson;
@class ReferenceText;

@interface ReferenceBelief :  ReferenceAsset  
{
}

@property (nonatomic, strong) NSString * typeBelief;
@property (nonatomic, strong) NSSet* texts;
@property (nonatomic, strong) ReferencePerson * figurehead;

@end


@interface ReferenceBelief (CoreDataGeneratedAccessors)
- (void)addTextsObject:(ReferenceText *)value;
- (void)removeTextsObject:(ReferenceText *)value;
- (void)addTexts:(NSSet *)value;
- (void)removeTexts:(NSSet *)value;

@end

