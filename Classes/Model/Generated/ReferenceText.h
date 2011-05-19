//
//  ReferenceText.h
//  Moralife
//
//  Created by aaxe on 1/18/11.
//  Copyright 2011 Team Axe, LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ReferenceAsset.h"

@class ReferenceBelief;
@class ReferencePerson;

@interface ReferenceText :  ReferenceAsset  
{
}

@property (nonatomic, retain) NSString * quote;
@property (nonatomic, retain) ReferencePerson * author;
@property (nonatomic, retain) NSSet* childrenReference;
@property (nonatomic, retain) NSSet* belief;
@property (nonatomic, retain) ReferenceText * parentReference;

@end


@interface ReferenceText (CoreDataGeneratedAccessors)
- (void)addChildrenReferenceObject:(ReferenceText *)value;
- (void)removeChildrenReferenceObject:(ReferenceText *)value;
- (void)addChildrenReference:(NSSet *)value;
- (void)removeChildrenReference:(NSSet *)value;

- (void)addBeliefObject:(ReferenceBelief *)value;
- (void)removeBeliefObject:(ReferenceBelief *)value;
- (void)addBelief:(NSSet *)value;
- (void)removeBelief:(NSSet *)value;

@end

